import {
  login,
  logout,
  readPasswordMatches,
  readResourceItems,
  readSession,
  register,
} from "../shared/api-client.js";
import {
  executeContentScript,
  getExtensionApi,
  queryActiveTab,
  readLocalStorage,
  sendTabMessage,
  writeLocalStorage,
} from "../shared/extension-api.js";
import {
  DEFAULT_API_BASE_URL,
  RUNTIME_MESSAGES,
  STORAGE_KEYS,
} from "../shared/constants.js";
import {
  clearSession,
  readExtensionSettings,
  writeSession,
} from "../shared/storage.js";
import { isHttpLikeUrl, normalizeLookupOrigin, normalizeWebsiteHost } from "../shared/url-utils.js";

const extensionApi = getExtensionApi();
const RESOURCE_IDS = Object.freeze(["passwords", "apiKeys", "cards", "subscriptions"]);
const SESSION_CACHE_TTL_MS = 5 * 60 * 1000;
const MATCHES_CACHE_TTL_MS = 45 * 1000;
const ITEMS_CACHE_TTL_MS = 60 * 1000;
const FILL_TARGET_CACHE_TTL_MS = 15 * 1000;
const POPUP_STATE_CACHE_TTL_MS = 15 * 1000;

let sessionCache = {
  authenticated: false,
  email: "",
  fetchedAt: 0,
  token: "",
};

let popupStateCache = {
  cacheKey: "",
  fetchedAt: 0,
  popupState: null,
};

const matchesCache = new Map();
const itemsCache = new Map();
const fillTargetCache = new Map();
const inFlightRequests = new Map();

function buildEmptyInitialResourceItems() {
  return {
    passwords: [],
    apiKeys: [],
    cards: [],
    subscriptions: [],
  };
}

function withInFlight(key, load) {
  if (inFlightRequests.has(key)) {
    return inFlightRequests.get(key);
  }
  const promise = Promise.resolve()
    .then(load)
    .finally(() => {
      inFlightRequests.delete(key);
    });
  inFlightRequests.set(key, promise);
  return promise;
}

function clearPopupStateCache() {
  popupStateCache = {
    cacheKey: "",
    fetchedAt: 0,
    popupState: null,
  };
}

function clearMatchesCache() {
  matchesCache.clear();
  clearPopupStateCache();
}

function clearItemsCache() {
  itemsCache.clear();
  clearPopupStateCache();
}

function clearFillTargetCache() {
  fillTargetCache.clear();
  clearPopupStateCache();
}

function clearSessionCache() {
  sessionCache = {
    authenticated: false,
    email: "",
    fetchedAt: 0,
    token: "",
  };
  clearMatchesCache();
  clearItemsCache();
  clearFillTargetCache();
}

function updateSessionCache(session) {
  sessionCache = {
    authenticated: Boolean(session?.authenticated),
    email: String(session?.email ?? "").trim(),
    fetchedAt: Date.now(),
    token: String(session?.token ?? "").trim(),
  };
  clearPopupStateCache();
}

function readCachedSession(settings) {
  if (!settings.sessionToken) {
    return null;
  }
  if (sessionCache.token !== settings.sessionToken) {
    return null;
  }
  if (Date.now() - sessionCache.fetchedAt > SESSION_CACHE_TTL_MS) {
    return null;
  }
  return {
    authenticated: sessionCache.authenticated,
    email: sessionCache.email,
    token: sessionCache.token,
  };
}

function readCachedMatches(origin, token) {
  const cacheEntry = matchesCache.get(origin);
  if (!cacheEntry) {
    return null;
  }
  if (cacheEntry.token !== token) {
    return null;
  }
  if (Date.now() - cacheEntry.fetchedAt > MATCHES_CACHE_TTL_MS) {
    return null;
  }
  return cacheEntry.matches;
}

function writeMatchesCache(origin, token, matches) {
  matchesCache.set(origin, {
    fetchedAt: Date.now(),
    matches,
    token,
  });
  clearPopupStateCache();
}

function buildItemsCacheKey(resourceId, token) {
  return `${String(resourceId ?? "").trim()}::${String(token ?? "").trim()}`;
}

function readCachedItems(resourceId, token) {
  const cacheEntry = itemsCache.get(buildItemsCacheKey(resourceId, token));
  if (!cacheEntry) {
    return null;
  }
  if (Date.now() - cacheEntry.fetchedAt > ITEMS_CACHE_TTL_MS) {
    return null;
  }
  return cacheEntry.items;
}

function writeItemsCache(resourceId, token, items) {
  itemsCache.set(buildItemsCacheKey(resourceId, token), {
    fetchedAt: Date.now(),
    items,
  });
  clearPopupStateCache();
}

function buildFillTargetCacheKey(tab) {
  return `${tab?.id ?? "none"}::${String(tab?.url ?? "").trim()}`;
}

function readCachedFillTarget(tab) {
  const cacheEntry = fillTargetCache.get(buildFillTargetCacheKey(tab));
  if (!cacheEntry) {
    return null;
  }
  if (Date.now() - cacheEntry.fetchedAt > FILL_TARGET_CACHE_TTL_MS) {
    return null;
  }
  return cacheEntry.detection;
}

function writeFillTargetCache(tab, detection) {
  fillTargetCache.set(buildFillTargetCacheKey(tab), {
    detection,
    fetchedAt: Date.now(),
  });
  clearPopupStateCache();
}

function buildPopupStateCacheKey(settings, tab) {
  return [
    String(settings?.apiBaseUrl ?? "").trim(),
    String(settings?.sessionToken ?? "").trim(),
    tab?.id ?? "none",
    String(tab?.url ?? "").trim(),
  ].join("::");
}

function readCachedPopupState(cacheKey) {
  if (!popupStateCache.popupState) {
    return null;
  }
  if (popupStateCache.cacheKey !== cacheKey) {
    return null;
  }
  if (Date.now() - popupStateCache.fetchedAt > POPUP_STATE_CACHE_TTL_MS) {
    return null;
  }
  return popupStateCache.popupState;
}

function writePopupStateCache(cacheKey, popupState) {
  popupStateCache = {
    cacheKey,
    fetchedAt: Date.now(),
    popupState,
  };
  return popupState;
}

function selectAutoFillCredential(matches) {
  const exactMatches = matches.filter((match) => match.matchType === "exact");
  const candidates = exactMatches.length > 0 ? exactMatches : matches;
  return candidates.length === 1 ? candidates[0] : null;
}

async function ensureStoredConfiguration() {
  const storedValues = await readLocalStorage([STORAGE_KEYS.apiBaseUrl]);
  if (storedValues[STORAGE_KEYS.apiBaseUrl]) {
    return;
  }
  await writeLocalStorage({
    [STORAGE_KEYS.apiBaseUrl]: DEFAULT_API_BASE_URL,
  });
}

async function ensureContentScriptAvailable(tab) {
  if (!tab?.id || !isHttpLikeUrl(tab.url)) {
    return null;
  }
  const readDetection = async () => {
    const response = await sendTabMessage(tab.id, { type: RUNTIME_MESSAGES.detectFillTarget });
    if (!response?.ok) {
      throw new Error(response?.error ?? "Content script request failed.");
    }
    return response;
  };
  try {
    return await readDetection();
  } catch (_error) {
    await executeContentScript(tab.id, ["content/content-script.js"]);
    return readDetection();
  }
}

async function readFillTargetDetection(tab, { preferCached = false } = {}) {
  if (!tab?.id || !isHttpLikeUrl(tab.url)) {
    return {
      cardFillTargetAvailable: false,
      fillTargetAvailable: false,
      pageHost: normalizeWebsiteHost(tab?.url ?? ""),
      passwordFillTargetAvailable: false,
      source: "",
    };
  }
  if (preferCached) {
    const cachedDetection = readCachedFillTarget(tab);
    if (cachedDetection) {
      return cachedDetection;
    }
  }
  return withInFlight(`fill-target::${buildFillTargetCacheKey(tab)}`, async () => {
    const detection = await ensureContentScriptAvailable(tab).catch(() => ({
      cardFillTargetAvailable: false,
      fillTargetAvailable: false,
      pageHost: normalizeWebsiteHost(tab?.url ?? ""),
      passwordFillTargetAvailable: false,
      source: "",
    }));
    writeFillTargetCache(tab, detection);
    return detection;
  });
}

async function readAuthenticatedSession(settings, { preferCached = false } = {}) {
  if (!settings.sessionToken) {
    clearSessionCache();
    return {
      authenticated: false,
      email: settings.sessionEmail,
      token: "",
    };
  }
  if (preferCached) {
    const cachedSession = readCachedSession(settings);
    if (cachedSession) {
      return cachedSession;
    }
  }
  return withInFlight(`session::${settings.apiBaseUrl}::${settings.sessionToken}`, async () => {
    const session = await readSession({
      apiBaseUrl: settings.apiBaseUrl,
      token: settings.sessionToken,
    });
    if (!session?.authenticated) {
      await clearSession();
      clearSessionCache();
      return {
        authenticated: false,
        email: "",
        token: "",
      };
    }
    const rotatedToken = String(session.token ?? settings.sessionToken).trim();
    await writeSession({
      email: session.email,
      token: rotatedToken,
    });
    const nextSession = {
      ...session,
      token: rotatedToken,
    };
    updateSessionCache(nextSession);
    return nextSession;
  });
}

async function readMatchesForOrigin(settings, session, origin, { preferCached = false } = {}) {
  if (!session.authenticated || !session.token || !origin) {
    return [];
  }
  if (preferCached) {
    const cachedMatches = readCachedMatches(origin, session.token);
    if (cachedMatches) {
      return cachedMatches;
    }
  }
  return withInFlight(`matches::${session.token}::${origin}`, async () => {
    const response = await readPasswordMatches({
      apiBaseUrl: settings.apiBaseUrl,
      origin,
      token: session.token,
    });
    const matches = Array.isArray(response?.matches) ? response.matches : [];
    writeMatchesCache(origin, session.token, matches);
    return matches;
  });
}

async function readItemsForResource(settings, session, resourceId, { preferCached = false } = {}) {
  if (!session.authenticated || !session.token || !resourceId) {
    return [];
  }
  if (preferCached) {
    const cachedItems = readCachedItems(resourceId, session.token);
    if (cachedItems) {
      return cachedItems;
    }
  }
  return withInFlight(`items::${session.token}::${resourceId}`, async () => {
    const response = await readResourceItems({
      apiBaseUrl: settings.apiBaseUrl,
      resourceId,
      token: session.token,
    });
    const items = Array.isArray(response?.items) ? response.items : [];
    writeItemsCache(resourceId, session.token, items);
    return items;
  });
}

async function buildInitialResourceState(settings, session) {
  const initialResourceItems = buildEmptyInitialResourceItems();
  const loadedResourceIds = [];
  if (!session.authenticated || !session.token) {
    return {
      initialResourceItems,
      loadedResourceIds,
    };
  }
  RESOURCE_IDS.forEach((resourceId) => {
    const cachedItems = readCachedItems(resourceId, session.token);
    if (cachedItems === null) {
      return;
    }
    initialResourceItems[resourceId] = cachedItems;
    loadedResourceIds.push(resourceId);
  });
  if (!loadedResourceIds.includes("passwords")) {
    try {
      initialResourceItems.passwords = await readItemsForResource(settings, session, "passwords", {
        preferCached: true,
      });
      loadedResourceIds.push("passwords");
    } catch (_error) {
    }
  }
  return {
    initialResourceItems,
    loadedResourceIds,
  };
}

async function prewarmSignedInState(settings, session, { activeTab = null, origin = "" } = {}) {
  if (!session.authenticated || !session.token) {
    return;
  }
  const tasks = RESOURCE_IDS.map((resourceId) =>
    readItemsForResource(settings, session, resourceId, { preferCached: true }),
  );
  if (origin) {
    tasks.push(readMatchesForOrigin(settings, session, origin, { preferCached: true }));
  }
  if (activeTab?.id && isHttpLikeUrl(activeTab.url)) {
    tasks.push(readFillTargetDetection(activeTab, { preferCached: true }));
  }
  await Promise.all(tasks);
}

async function buildPopupState({ activeTab = null, preferCached = true } = {}) {
  await ensureStoredConfiguration();
  const settings = await readExtensionSettings();
  const resolvedActiveTab = activeTab ?? (await queryActiveTab());
  const popupStateCacheKey = buildPopupStateCacheKey(settings, resolvedActiveTab);
  if (preferCached) {
    const cachedPopupState = readCachedPopupState(popupStateCacheKey);
    if (cachedPopupState) {
      return cachedPopupState;
    }
  }
  return withInFlight(`popup-state::${popupStateCacheKey}`, async () => {
    const pageOrigin = normalizeLookupOrigin(resolvedActiveTab?.url ?? "");
    const pageHost = normalizeWebsiteHost(resolvedActiveTab?.url ?? "");
    const page = {
      fillTargetAvailable: false,
      fillTargets: {
        cards: false,
        passwords: false,
      },
      host: pageHost,
      origin: pageOrigin,
      supported: Boolean(pageOrigin),
      tabId: resolvedActiveTab?.id ?? null,
      title: resolvedActiveTab?.title ?? "",
      url: resolvedActiveTab?.url ?? "",
    };
    const detectionPromise =
      page.supported && resolvedActiveTab?.id
      ? readFillTargetDetection(resolvedActiveTab, { preferCached: true }).catch(() => ({
            cardFillTargetAvailable: false,
            fillTargetAvailable: false,
            pageHost,
            passwordFillTargetAvailable: false,
            source: "",
          }))
        : Promise.resolve({
            cardFillTargetAvailable: false,
            fillTargetAvailable: false,
            pageHost,
            passwordFillTargetAvailable: false,
            source: "",
          });
    try {
      const [session, detection] = await Promise.all([
        readAuthenticatedSession(settings, { preferCached: true }),
        detectionPromise,
      ]);
      page.fillTargets = {
        cards: Boolean(detection?.cardFillTargetAvailable),
        passwords: Boolean(detection?.passwordFillTargetAvailable),
      };
      page.fillTargetAvailable = Boolean(page.fillTargets.cards || page.fillTargets.passwords);
      const { initialResourceItems, loadedResourceIds } = await buildInitialResourceState(settings, session);
      let matches = [];
      let matchesError = "";
      if (session.authenticated && page.origin) {
        try {
          matches = await readMatchesForOrigin(settings, session, page.origin, { preferCached: true });
        } catch (error) {
          matchesError = error instanceof Error ? error.message : "Unable to read matches.";
        }
      }
      if (session.authenticated) {
        void prewarmSignedInState(settings, session, {
          activeTab: resolvedActiveTab,
          origin: page.origin,
        }).catch(() => {});
      }
      return writePopupStateCache(popupStateCacheKey, {
        apiBaseUrl: settings.apiBaseUrl,
        initialResourceItems,
        loadedResourceIds,
        matches,
        matchesError,
        page,
        session: {
          authenticated: Boolean(session.authenticated),
          email: session.email ?? settings.sessionEmail,
        },
      });
    } catch (error) {
      return writePopupStateCache(popupStateCacheKey, {
        apiBaseUrl: settings.apiBaseUrl,
        initialResourceItems: buildEmptyInitialResourceItems(),
        loadedResourceIds: [],
        matches: [],
        matchesError: "",
        page,
        session: {
          authenticated: false,
          email: "",
        },
        sessionError: error instanceof Error ? error.message : "Unable to read session.",
      });
    }
  });
}

async function warmTabState(tab) {
  try {
    await buildPopupState({
      activeTab: tab,
      preferCached: true,
    });
  } catch (_error) {
  }
}

async function handleLogin(message) {
  await ensureStoredConfiguration();
  const settings = await readExtensionSettings();
  const session = await login({
    apiBaseUrl: settings.apiBaseUrl,
    email: message?.email,
    password: message?.password,
  });
  return writeAuthenticatedSession(session, message?.email);
}

async function handleRegister(message) {
  await ensureStoredConfiguration();
  const settings = await readExtensionSettings();
  const session = await register({
    apiBaseUrl: settings.apiBaseUrl,
    email: message?.email,
    password: message?.password,
  });
  return writeAuthenticatedSession(session, message?.email);
}

async function writeAuthenticatedSession(session, fallbackEmail) {
  const token = String(session?.token ?? "").trim();
  if (!token) {
    throw new Error("Session token was not returned.");
  }
  await writeSession({
    email: session?.email ?? fallbackEmail,
    token,
  });
  clearMatchesCache();
  clearItemsCache();
  updateSessionCache({
    authenticated: true,
    email: session?.email ?? fallbackEmail,
    token,
  });
  return buildPopupState({ preferCached: false });
}

async function handleLogout() {
  const settings = await readExtensionSettings();
  if (settings.sessionToken) {
    try {
      await logout({
        apiBaseUrl: settings.apiBaseUrl,
        token: settings.sessionToken,
      });
    } catch (_error) {
    }
  }
  await clearSession();
  clearSessionCache();
  return buildPopupState({ preferCached: false });
}

async function handleFillCredential(message) {
  const activeTab = await queryActiveTab();
  if (!activeTab?.id) {
    throw new Error("Active tab is unavailable.");
  }
  await ensureContentScriptAvailable(activeTab);
  const response = await sendTabMessage(activeTab.id, {
    credential: message?.credential ?? null,
    type: RUNTIME_MESSAGES.fillCredential,
  });
  if (!response?.ok) {
    throw new Error(response?.error ?? "Unable to fill credential.");
  }
  return response;
}

async function handleReadAutoFillCredential(message, sender) {
  await ensureStoredConfiguration();
  const settings = await readExtensionSettings();
  const session = await readAuthenticatedSession(settings, { preferCached: true });
  if (!session.authenticated) {
    return { credential: null };
  }
  const origin = normalizeLookupOrigin(message?.origin ?? sender?.tab?.url ?? "");
  if (!origin) {
    return { credential: null };
  }
  const matches = await readMatchesForOrigin(settings, session, origin, { preferCached: true });
  return {
    credential: selectAutoFillCredential(matches),
  };
}

async function handleReadResourceItems(message) {
  await ensureStoredConfiguration();
  const settings = await readExtensionSettings();
  const session = await readAuthenticatedSession(settings, { preferCached: true });
  if (!session.authenticated) {
    return { items: [] };
  }
  clearPopupStateCache();
  return {
    items: await readItemsForResource(settings, session, message?.resourceId, {
      preferCached: true,
    }),
  };
}

async function handleRuntimeMessage(message, sender) {
  switch (message?.type) {
    case RUNTIME_MESSAGES.getPopupState:
      return buildPopupState({ preferCached: true });
    case RUNTIME_MESSAGES.login:
      return handleLogin(message);
    case RUNTIME_MESSAGES.register:
      return handleRegister(message);
    case RUNTIME_MESSAGES.logout:
      return handleLogout();
    case RUNTIME_MESSAGES.fillCredential:
      return handleFillCredential(message);
    case RUNTIME_MESSAGES.readAutoFillCredential:
      return handleReadAutoFillCredential(message, sender);
    case RUNTIME_MESSAGES.readResourceItems:
      return handleReadResourceItems(message);
    default:
      throw new Error("Unsupported runtime message.");
  }
}

function initializeExtension() {
  ensureStoredConfiguration()
    .then(() => queryActiveTab())
    .then((tab) => warmTabState(tab))
    .catch(() => {});
}

extensionApi.runtime.onInstalled.addListener(() => {
  initializeExtension();
});

extensionApi.runtime.onStartup?.addListener(() => {
  initializeExtension();
});

extensionApi.tabs.onActivated?.addListener(() => {
  queryActiveTab()
    .then((tab) => warmTabState(tab))
    .catch(() => {});
});

extensionApi.tabs.onUpdated?.addListener((_tabId, changeInfo, tab) => {
  if (changeInfo.status !== "complete") {
    return;
  }
  warmTabState(tab).catch(() => {});
});

extensionApi.runtime.onMessage.addListener((message, sender, sendResponse) => {
  handleRuntimeMessage(message, sender)
    .then((result) => {
      sendResponse({ ok: true, result });
    })
    .catch((error) => {
      sendResponse({
        ok: false,
        error: error instanceof Error ? error.message : "Request failed.",
      });
    });
  return true;
});
