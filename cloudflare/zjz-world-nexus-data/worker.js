var __defProp = Object.defineProperty;
var __name = (target, value) => __defProp(target, "name", { value, configurable: true });

// ../../src/app/site-icon-utils.js
var WEBSITE_PROTOCOL_RE = /^[a-z][a-z0-9+.-]*:\/\//i;
function normalizeWebsiteHost(website) {
  const normalizedUrl = normalizeWebsiteUrl(website);
  if (!normalizedUrl) {
    return "";
  }
  return normalizedUrl.hostname.replace(/^www\./, "").toLowerCase();
}
__name(normalizeWebsiteHost, "normalizeWebsiteHost");
function normalizeWebsiteUrl(website) {
  const trimmedWebsite = String(website ?? "").trim();
  if (!trimmedWebsite) {
    return null;
  }
  const candidate = WEBSITE_PROTOCOL_RE.test(trimmedWebsite) ? trimmedWebsite : `https://${trimmedWebsite}`;
  try {
    const parsedUrl = new URL(candidate);
    if (parsedUrl.protocol !== "http:" && parsedUrl.protocol !== "https:") {
      return null;
    }
    return parsedUrl;
  } catch (_error) {
    return null;
  }
}
__name(normalizeWebsiteUrl, "normalizeWebsiteUrl");
function getPasswordMatchType(requestHost, website) {
  const credentialHost = normalizeWebsiteHost(website);
  if (!requestHost || !credentialHost) {
    return "";
  }
  if (requestHost === credentialHost) {
    return "exact";
  }
  if (requestHost.endsWith(`.${credentialHost}`)) {
    return "subdomain";
  }
  return "";
}
__name(getPasswordMatchType, "getPasswordMatchType");
function comparePasswordMatches(left, right) {
  const leftRank = left.matchType === "exact" ? 0 : 1;
  const rightRank = right.matchType === "exact" ? 0 : 1;
  if (leftRank !== rightRank) {
    return leftRank - rightRank;
  }
  const leftService = String(left.service ?? "").toLowerCase();
  const rightService = String(right.service ?? "").toLowerCase();
  if (leftService !== rightService) {
    return leftService.localeCompare(rightService);
  }
  return String(left.username ?? "").toLowerCase().localeCompare(String(right.username ?? "").toLowerCase());
}
__name(comparePasswordMatches, "comparePasswordMatches");

// ../../src/app/resource-data.js
var numberFormatter = new Intl.NumberFormat("en-US", {
  style: "currency",
  currency: "USD",
  minimumFractionDigits: 2,
  maximumFractionDigits: 2
});
var shortNumberFormatter = new Intl.NumberFormat("en-US", {
  style: "currency",
  currency: "USD",
  minimumFractionDigits: 0,
  maximumFractionDigits: 0
});
var cardCurrencyFormatterMap = {
  USD: new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: "USD",
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
  }),
  CAD: new Intl.NumberFormat("en-CA", {
    style: "currency",
    currency: "CAD",
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
  }),
  CNY: new Intl.NumberFormat("zh-CN", {
    style: "currency",
    currency: "CNY",
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
  })
};
var monthDayFormatter = new Intl.DateTimeFormat("en-US", {
  month: "short",
  day: "2-digit"
});
var storageCategoryByResourceId = {
  passwords: "passwords",
  apiKeys: "api_keys",
  cards: "cards",
  subscriptions: "subscriptions"
};
var resourceIdByStorageCategory = Object.fromEntries(
  Object.entries(storageCategoryByResourceId).map(([resourceId, category]) => [category, resourceId])
);
function buildRowFromForm(resourceId, formValues, existingRow = null) {
  const id = existingRow?.id ?? (globalThis.crypto?.randomUUID?.() ?? `${resourceId}-${Date.now()}`);
  const normalizedWebsite = normalizeWebsiteUrl(formValues.website)?.toString() || String(formValues.website ?? "").trim();
  switch (resourceId) {
    case "passwords": {
      const nextKinds = getPasswordKinds(formValues.credentialMode);
      const isOneTimeCode = formValues.credentialMode === "ONE-TIME-CODE";
      return {
        id,
        icon: existingRow?.icon ?? "key",
        iconKey: formValues.iconKey?.trim() || "",
        iconSource: formValues.iconSource?.trim() || "",
        service: formValues.serviceName.trim(),
        username: formValues.userName.trim(),
        kinds: nextKinds,
        rawSecret: isOneTimeCode ? "" : formValues.secretValue.trim(),
        passwordMask: isOneTimeCode ? "-" : formValues.secretValue.trim() ? maskPasswordValue(formValues.secretValue) : existingRow?.passwordMask ?? "-",
        website: normalizedWebsite,
        note: formValues.note.trim()
      };
    }
    case "apiKeys": {
      const rawValue = formValues.keyValue.trim() || existingRow?.rawValue || "";
      return {
        id,
        keyName: formValues.keyName.trim(),
        rawValue,
        maskedValue: maskSecret(rawValue),
        note: formValues.note.trim(),
        environment: existingRow?.environment ?? "LIVE"
      };
    }
    case "cards": {
      const isNoCreditType = isCardWithoutCreditType(formValues.network);
      return {
        id,
        iconKey: formValues.iconKey?.trim() || "",
        iconSource: formValues.iconSource?.trim() || "",
        cardName: formValues.cardName.trim(),
        network: formValues.network,
        creditCurrency: normalizeCurrencyCode(formValues.creditCurrency ?? existingRow?.creditCurrency),
        rawCardNumber: formValues.cardNumber.trim() || existingRow?.rawCardNumber || "",
        maskedNumber: formValues.cardNumber.trim() ? maskCardNumber(formValues.cardNumber) : existingRow?.maskedNumber ?? "**** **** **** 0000",
        creditLimit: isNoCreditType ? 0 : parseCurrencyInput(formValues.creditLimit),
        expiry: formValues.expiry.trim().toUpperCase(),
        rawCvv: formValues.cvv.trim() || existingRow?.rawCvv || "",
        cvvMask: formValues.cvv.trim() ? maskCvv(formValues.cvv) : existingRow?.cvvMask ?? "***",
        billingAnchorDate: isNoCreditType ? "" : formValues.nextBillingDate,
        note: formValues.note.trim()
      };
    }
    case "subscriptions":
      return {
        id,
        icon: existingRow?.icon ?? "inventory_2",
        iconKey: formValues.iconKey?.trim() || "",
        iconSource: formValues.iconSource?.trim() || "",
        service: formValues.service.trim(),
        tier: formValues.tier.trim().toUpperCase(),
        cadence: normalizeCadence(formValues.cadence),
        amountCurrency: normalizeCurrencyCode(formValues.amountCurrency ?? existingRow?.amountCurrency),
        amount: parseCurrencyInput(formValues.amount),
        billingAnchorDate: formValues.nextBillingDate,
        status: formValues.status,
        note: formValues.note.trim()
      };
    default:
      return null;
  }
}
__name(buildRowFromForm, "buildRowFromForm");
function normalizeCurrencyCode(value) {
  const normalized = String(value ?? "USD").trim().toUpperCase();
  return normalized === "JPY" || normalized === "CNY" ? "CNY" : normalized === "CAD" ? "CAD" : "USD";
}
__name(normalizeCurrencyCode, "normalizeCurrencyCode");
function normalizeCadence(value) {
  const normalized = String(value ?? "MONTHLY").trim().toUpperCase();
  if (normalized === "YEARLY" || normalized === "ANNUAL" || normalized === "ANNUALLY") {
    return "YEARLY";
  }
  if (normalized === "QUARTERLY" || normalized === "QUARTER") {
    return "QUARTERLY";
  }
  return "MONTHLY";
}
__name(normalizeCadence, "normalizeCadence");
function isCardWithoutCreditType(value) {
  return value === "DEBIT" || value === "VIRTUAL";
}
__name(isCardWithoutCreditType, "isCardWithoutCreditType");
function getPasswordKinds(mode) {
  switch (mode) {
    case "ONE-TIME-CODE":
      return ["OTP"];
    default:
      return ["PASSWORD"];
  }
}
__name(getPasswordKinds, "getPasswordKinds");
function parseCurrencyInput(value) {
  const cleaned = String(value).replace(/[^0-9.]/g, "");
  const parsed = Number.parseFloat(cleaned);
  return Number.isFinite(parsed) ? parsed : 0;
}
__name(parseCurrencyInput, "parseCurrencyInput");
function maskSecret(value) {
  const cleanValue = String(value).trim();
  if (!cleanValue) {
    return "";
  }
  if (cleanValue.length <= 8) {
    return `${cleanValue.slice(0, 2)}\u2022\u2022\u2022\u2022`;
  }
  return `${cleanValue.slice(0, 10)}\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022${cleanValue.slice(-4)}`;
}
__name(maskSecret, "maskSecret");
function maskCardNumber(value) {
  const digits = String(value).replace(/\D/g, "");
  if (!digits) {
    return "**** **** **** 0000";
  }
  const tail = digits.slice(-4).padStart(4, "0");
  return `**** **** **** ${tail}`;
}
__name(maskCardNumber, "maskCardNumber");
function maskCvv(value) {
  const digits = String(value).replace(/\D/g, "");
  return digits ? digits : "***";
}
__name(maskCvv, "maskCvv");
function maskPasswordValue(value) {
  const cleanValue = String(value).trim();
  return cleanValue ? "********" : "-";
}
__name(maskPasswordValue, "maskPasswordValue");

// src/index.js
var AUTH_COOKIE_NAME = "zjz_world_session";
var NEXUS_SERVICE_KEY = "zjz-world-nexus";
var aesKeyCache = /* @__PURE__ */ new Map();
var ICON_KEY_PATTERN = /^[a-z0-9._:-]{1,160}$/i;
var LEGACY_SCOPED_ICON_KEY_PATTERN = /^u:[a-f0-9]{16}:(.+)$/i;
function getCookieValue(request, name) {
  const cookieHeader = request.headers.get("cookie") || "";
  const segments = cookieHeader.split(";");
  for (const segment of segments) {
    const trimmed = segment.trim();
    if (trimmed.startsWith(`${name}=`)) {
      return decodeURIComponent(trimmed.slice(name.length + 1));
    }
  }
  return null;
}
__name(getCookieValue, "getCookieValue");
function readSessionToken(request, cookieName = AUTH_COOKIE_NAME) {
  const headerToken = request.headers.get("x-session-token")?.trim();
  if (headerToken) {
    return headerToken;
  }
  const authorization = request.headers.get("authorization")?.trim() || "";
  if (authorization.toLowerCase().startsWith("bearer ")) {
    const bearer = authorization.slice(7).trim();
    if (bearer) {
      return bearer;
    }
  }
  return getCookieValue(request, cookieName) || void 0;
}
__name(readSessionToken, "readSessionToken");
function normalizeEmail(value) {
  return String(value ?? "").trim().toLowerCase();
}
__name(normalizeEmail, "normalizeEmail");
function readAccessEmail(request) {
  return normalizeEmail(request.headers.get("cf-access-authenticated-user-email"));
}
__name(readAccessEmail, "readAccessEmail");
function createLogger(service) {
  return {
    info(event, fields = {}) {
      console.log(JSON.stringify({ ts: (/* @__PURE__ */ new Date()).toISOString(), level: "info", event, service, ...fields }));
    },
    error(event, fields = {}) {
      console.error(JSON.stringify({ ts: (/* @__PURE__ */ new Date()).toISOString(), level: "error", event, service, ...fields }));
    }
  };
}
__name(createLogger, "createLogger");
async function withRequestLogging(logger2, request, handler) {
  const startedAt = Date.now();
  const requestId = request.headers.get("cf-ray")?.trim() || crypto.randomUUID();
  try {
    const response = await handler();
    logger2.info("request", {
      duration_ms: Date.now() - startedAt,
      method: request.method,
      path: new URL(request.url).pathname,
      request_id: requestId,
      status: response.status
    });
    return response;
  } catch (error) {
    logger2.error("request_error", {
      duration_ms: Date.now() - startedAt,
      error: error instanceof Error ? { message: error.message, stack: error.stack } : error,
      method: request.method,
      path: new URL(request.url).pathname,
      request_id: requestId
    });
    throw error;
  }
}
__name(withRequestLogging, "withRequestLogging");
function jsonResponse(payload, status = 200, headersInit = {}) {
  return new Response(JSON.stringify(payload), {
    headers: {
      "Cache-Control": "no-store",
      "Content-Type": "application/json; charset=utf-8",
      ...headersInit
    },
    status
  });
}
__name(jsonResponse, "jsonResponse");
function ok(data, status = 200) {
  return jsonResponse({ ok: true, data }, status);
}
__name(ok, "ok");
function fail(error, status = 400) {
  return jsonResponse({ ok: false, error: String(error || "Request failed.") }, status);
}
__name(fail, "fail");
function getUniversalAuthBinding(env) {
  const binding = env?.UNIVERSAL_AUTH;
  if (!binding || typeof binding.fetch !== "function") {
    throw new Error("UNIVERSAL_AUTH binding is not configured.");
  }
  return binding;
}
__name(getUniversalAuthBinding, "getUniversalAuthBinding");
function cloneUniversalAuthHeaders(request, serviceKey = NEXUS_SERVICE_KEY) {
  const headers = new Headers();
  const cookie = request.headers.get("cookie");
  const accessEmail = request.headers.get("cf-access-authenticated-user-email");
  const sessionToken = readSessionToken(request);
  const authorization = request.headers.get("authorization");
  const contentType = request.headers.get("content-type");
  if (cookie) {
    headers.set("cookie", cookie);
  }
  if (accessEmail) {
    headers.set("cf-access-authenticated-user-email", accessEmail);
  }
  if (sessionToken) {
    headers.set("x-session-token", sessionToken);
  }
  if (authorization) {
    headers.set("authorization", authorization);
  }
  if (contentType) {
    headers.set("content-type", contentType);
  }
  if (serviceKey) {
    headers.set("x-universal-service-key", serviceKey);
  }
  return headers;
}
__name(cloneUniversalAuthHeaders, "cloneUniversalAuthHeaders");
async function callUniversalAuth(request, env, pathname, init = {}) {
  const headers = cloneUniversalAuthHeaders(request);
  for (const [name, value] of new Headers(init.headers || {}).entries()) {
    headers.set(name, value);
  }
  const response = await getUniversalAuthBinding(env).fetch(
    new Request(`https://universal-auth${pathname}`, {
      method: init.method || request.method,
      headers,
      body: init.body
    })
  );
  const payload = await response.json().catch(() => null);
  return { payload, response };
}
__name(callUniversalAuth, "callUniversalAuth");
async function requireAuthenticated(request, env) {
  const accessEmail = readAccessEmail(request);
  if (accessEmail) {
    return accessEmail;
  }
  const { payload, response } = await callUniversalAuth(request, env, "/api/session", { method: "GET" });
  if (!response.ok || payload?.ok === false || !(payload?.authenticated || payload?.session?.authenticated)) {
    throw new Error("Authentication required.");
  }
  return normalizeEmail(payload?.session?.email);
}
__name(requireAuthenticated, "requireAuthenticated");
async function callServiceDataApi(request, env, pathname, init = {}) {
  const { payload, response } = await callUniversalAuth(request, env, pathname, init);
  if (!response.ok || payload?.ok === false) {
    throw new Error(payload?.error ?? "Service data request failed.");
  }
  return payload;
}
__name(callServiceDataApi, "callServiceDataApi");
function readEnvValue(env, key) {
  return typeof env?.[key] === "string" ? env[key].trim() : "";
}
__name(readEnvValue, "readEnvValue");
function bytesToBase64(bytes) {
  let binary = "";
  bytes.forEach((byte) => {
    binary += String.fromCharCode(byte);
  });
  return btoa(binary);
}
__name(bytesToBase64, "bytesToBase64");
function base64ToBytes(base64) {
  const binary = atob(base64);
  const bytes = new Uint8Array(binary.length);
  for (let index = 0; index < binary.length; index += 1) {
    bytes[index] = binary.charCodeAt(index);
  }
  return bytes;
}
__name(base64ToBytes, "base64ToBytes");
async function getAesKey(secret) {
  const cached = aesKeyCache.get(secret);
  if (cached) {
    return cached;
  }
  const digest = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(secret));
  const key = await crypto.subtle.importKey("raw", digest, "AES-GCM", false, ["encrypt", "decrypt"]);
  aesKeyCache.set(secret, key);
  return key;
}
__name(getAesKey, "getAesKey");
function getNexusDataSecret(env) {
  const secret = readEnvValue(env, "NEXUS_DATA_SECRET");
  if (!secret) {
    throw new Error("NEXUS_DATA_SECRET is not configured.");
  }
  return secret;
}
__name(getNexusDataSecret, "getNexusDataSecret");
async function encryptPayload(env, payload) {
  const key = await getAesKey(getNexusDataSecret(env));
  const iv = crypto.getRandomValues(new Uint8Array(12));
  const encoded = new TextEncoder().encode(JSON.stringify(payload));
  const encrypted = await crypto.subtle.encrypt({ name: "AES-GCM", iv }, key, encoded);
  return JSON.stringify({
    data: bytesToBase64(new Uint8Array(encrypted)),
    iv: bytesToBase64(iv),
    version: 1
  });
}
__name(encryptPayload, "encryptPayload");
async function decryptPayload(env, payloadJson) {
  const payload = JSON.parse(String(payloadJson || "{}"));
  if (Number(payload.version || 0) !== 1 || typeof payload.iv !== "string" || typeof payload.data !== "string") {
    throw new Error("Invalid encrypted payload.");
  }
  const key = await getAesKey(getNexusDataSecret(env));
  const decrypted = await crypto.subtle.decrypt(
    { name: "AES-GCM", iv: base64ToBytes(payload.iv) },
    key,
    base64ToBytes(payload.data)
  );
  return JSON.parse(new TextDecoder().decode(decrypted));
}
__name(decryptPayload, "decryptPayload");
function normalizeResourceId(value) {
  return Object.hasOwn(storageCategoryByResourceId, value) ? value : "";
}
__name(normalizeResourceId, "normalizeResourceId");
function normalizeStorageCategory(value) {
  return Object.hasOwn(resourceIdByStorageCategory, value) ? value : "";
}
__name(normalizeStorageCategory, "normalizeStorageCategory");
async function deserializeServiceItem(env, item) {
  const category = normalizeStorageCategory(item?.category);
  const resourceId = resourceIdByStorageCategory[category];
  if (!resourceId) {
    throw new Error("Unsupported resource category.");
  }
  const row = await decryptPayload(env, item.payload_json);
  const iconResolution = await resolveIconReference(env, {
    iconKey: row?.iconKey,
    website: row?.website
  });
  return {
    ...row,
    id: String(item.id),
    ...iconResolution
  };
}
__name(deserializeServiceItem, "deserializeServiceItem");
function normalizeIconKey(value) {
  const normalized = String(value ?? "").trim().toLowerCase();
  return ICON_KEY_PATTERN.test(normalized) ? normalized : "";
}
__name(normalizeIconKey, "normalizeIconKey");
function readSharedIconOwnerEmail(env) {
  return normalizeEmail(env?.NEXUS_SHARED_ICON_OWNER_EMAIL);
}
__name(readSharedIconOwnerEmail, "readSharedIconOwnerEmail");
async function isSharedIconOwner(email, env) {
  const ownerEmail = readSharedIconOwnerEmail(env);
  return Boolean(ownerEmail && normalizeEmail(email) === ownerEmail);
}
__name(isSharedIconOwner, "isSharedIconOwner");
function iconObjectKey(iconKey) {
  return `icons/${encodeURIComponent(iconKey)}`;
}
__name(iconObjectKey, "iconObjectKey");
function buildResolvedIconUrl(iconKey) {
  const normalizedIconKey = normalizeIconKey(iconKey);
  return normalizedIconKey ? `/api/site-icons/${encodeURIComponent(normalizedIconKey)}` : "";
}
__name(buildResolvedIconUrl, "buildResolvedIconUrl");
function buildFallbackSvg(label) {
  const safeLabel = escapeXml(String(label ?? "").trim().charAt(0).toUpperCase() || "?");
  return `
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 36 36" fill="none">
      <text
        x="18"
        y="18"
        fill="#0a0a0a"
        font-family="'OpenAI Sans', sans-serif"
        font-size="16"
        font-weight="600"
        text-anchor="middle"
        dominant-baseline="central"
      >
        ${safeLabel}
      </text>
    </svg>
  `.trim();
}
__name(buildFallbackSvg, "buildFallbackSvg");
function escapeXml(value) {
  return value.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll('"', "&quot;").replaceAll("'", "&apos;");
}
__name(escapeXml, "escapeXml");
function applyCorsHeaders(headers) {
  headers.set("Access-Control-Allow-Origin", "*");
  headers.set("Access-Control-Allow-Methods", "GET, POST, PATCH, DELETE, OPTIONS");
  headers.set("Access-Control-Allow-Headers", "Content-Type, Authorization, X-Session-Token");
}
__name(applyCorsHeaders, "applyCorsHeaders");
function parseIconUrlFallbackLabel(requestUrl) {
  return requestUrl.searchParams.get("fallback") ?? "";
}
__name(parseIconUrlFallbackLabel, "parseIconUrlFallbackLabel");
async function resolveIconReference(env, { iconKey = "", website = "" } = {}) {
  const normalizedIconKey = normalizeIconKey(iconKey);
  const hostIconKey = normalizeIconKey(normalizeWebsiteHost(website));
  const legacyScopedMatch = String(iconKey ?? "").trim().match(LEGACY_SCOPED_ICON_KEY_PATTERN);
  const legacyScopedBaseKey = normalizeIconKey(legacyScopedMatch?.[1] ?? "");
  const iconCandidates = [normalizedIconKey, legacyScopedBaseKey, hostIconKey].filter(
    (candidate, index, values) => candidate && values.indexOf(candidate) === index
  );
  if (!iconCandidates.length) {
    return {
      resolvedIconKey: "",
      resolvedIconScope: "",
      resolvedIconSourceType: "",
      resolvedIconUrl: ""
    };
  }
  for (const candidate of iconCandidates) {
    const iconHead = await env.NEXUS_ICONS.head(iconObjectKey(candidate));
    if (iconHead) {
      return {
        resolvedIconKey: candidate,
        resolvedIconScope: String(iconHead.customMetadata?.scope ?? "").trim().toLowerCase(),
        resolvedIconSourceType: String(iconHead.customMetadata?.sourceType ?? "").trim().toLowerCase(),
        resolvedIconUrl: buildResolvedIconUrl(candidate)
      };
    }
  }
  return {
    resolvedIconKey: "",
    resolvedIconScope: "",
    resolvedIconSourceType: "",
    resolvedIconUrl: ""
  };
}
__name(resolveIconReference, "resolveIconReference");
async function readIcon(request, requestUrl, env) {
  const iconKey = normalizeIconKey(decodeURIComponent(requestUrl.pathname.replace("/api/site-icons/", "")));
  const fallbackLabel = parseIconUrlFallbackLabel(requestUrl);
  if (!iconKey) {
    const headers2 = new Headers({
      "Cache-Control": "public, max-age=300",
      "Content-Type": "image/svg+xml"
    });
    applyCorsHeaders(headers2);
    return new Response(request.method === "HEAD" ? null : buildFallbackSvg(fallbackLabel), { headers: headers2, status: 200 });
  }
  const resolvedIconObject = await env.NEXUS_ICONS.get(iconObjectKey(iconKey));
  if (!resolvedIconObject) {
    const headers2 = new Headers({
      "Cache-Control": "no-store",
      "Content-Type": "image/svg+xml"
    });
    applyCorsHeaders(headers2);
    return new Response(request.method === "HEAD" ? null : buildFallbackSvg(fallbackLabel), { headers: headers2, status: 200 });
  }
  const headers = new Headers();
  resolvedIconObject.writeHttpMetadata(headers);
  headers.set("Cache-Control", "no-store");
  applyCorsHeaders(headers);
  return new Response(request.method === "HEAD" ? null : resolvedIconObject.body, {
    headers,
    status: 200
  });
}
__name(readIcon, "readIcon");
async function uploadIcon(request, env) {
  const requesterEmail = await requireAuthenticated(request, env);
  const body = await request.json().catch(() => null);
  const host = normalizeWebsiteHost(body?.website);
  const baseIconKey = normalizeIconKey(host || body?.iconKey);
  if (!baseIconKey || !body?.data || !String(body?.contentType || "").startsWith("image/")) {
    return fail("Icon file is required.", 400);
  }
  if (host && !await isSharedIconOwner(requesterEmail, env)) {
    return fail("Only the owner can overwrite website icons.", 403);
  }
  const bytes = Uint8Array.from(atob(body.data), (character) => character.charCodeAt(0));
  const resolvedIconKey = baseIconKey;
  if (!resolvedIconKey) {
    return fail("Could not save the icon.", 400);
  }
  await env.NEXUS_ICONS.put(iconObjectKey(resolvedIconKey), bytes, {
    customMetadata: {
      sourceType: "custom",
      sourceUrl: body.fileName ?? "upload",
      ownerEmail: requesterEmail,
      scope: host ? "shared" : "record",
      baseIconKey
    },
    httpMetadata: {
      contentType: body.contentType
    }
  });
  const iconResolution = await resolveIconReference(env, {
    iconKey: resolvedIconKey,
    website: body?.website
  });
  return ok({
    host,
    iconKey: resolvedIconKey,
    iconUrl: buildResolvedIconUrl(resolvedIconKey),
    resolvedIconKey: iconResolution.resolvedIconKey || resolvedIconKey,
    resolvedIconUrl: iconResolution.resolvedIconUrl || buildResolvedIconUrl(resolvedIconKey),
    scope: host ? "shared" : "record"
  });
}
__name(uploadIcon, "uploadIcon");
function extractIconUrl(html, websiteUrl) {
  const linkTags = html.match(/<link\b[^>]*>/gi) ?? [];
  for (const tag of linkTags) {
    const relValue = readHtmlAttribute(tag, "rel");
    const hrefValue = readHtmlAttribute(tag, "href");
    if (!relValue || !hrefValue || !relValue.toLowerCase().includes("icon")) {
      continue;
    }
    return new URL(hrefValue, websiteUrl).toString();
  }
  return null;
}
__name(extractIconUrl, "extractIconUrl");
function readHtmlAttribute(tag, attributeName) {
  const attributePattern = new RegExp(`${attributeName}\\s*=\\s*("([^"]+)"|'([^']+)'|([^\\s>]+))`, "i");
  const match = tag.match(attributePattern);
  if (!match) {
    return "";
  }
  return match[2] ?? match[3] ?? match[4] ?? "";
}
__name(readHtmlAttribute, "readHtmlAttribute");
async function fetchIcon(request, env) {
  const requesterEmail = await requireAuthenticated(request, env);
  const body = await request.json().catch(() => null);
  const websiteUrl = normalizeWebsiteUrl(body?.website);
  const host = normalizeWebsiteHost(body?.website);
  const iconKey = normalizeIconKey(host);
  if (!websiteUrl || !iconKey) {
    return fail("Please add a valid website first.", 400);
  }
  const existingIcon = await env.NEXUS_ICONS.head(iconObjectKey(iconKey));
  if (existingIcon) {
    const resolution2 = await resolveIconReference(env, {
      iconKey,
      website: websiteUrl
    });
    return ok({
      host: iconKey,
      iconKey,
      iconUrl: buildResolvedIconUrl(iconKey),
      resolvedIconKey: resolution2.resolvedIconKey || iconKey,
      resolvedIconUrl: resolution2.resolvedIconUrl || buildResolvedIconUrl(iconKey),
      scope: "shared"
    });
  }
  const htmlResponse = await fetch(websiteUrl, {
    headers: {
      "user-agent": "Nexus Icon Bot/1.0"
    }
  });
  if (!htmlResponse.ok) {
    return fail("Could not open that website.", 422);
  }
  const html = await htmlResponse.text();
  const iconUrl = extractIconUrl(html, websiteUrl) ?? new URL("/favicon.ico", websiteUrl).toString();
  const iconResponse = await fetch(iconUrl, {
    headers: {
      "user-agent": "Nexus Icon Bot/1.0"
    }
  });
  if (!iconResponse.ok) {
    return fail("Could not fetch the website icon.", 422);
  }
  await env.NEXUS_ICONS.put(iconObjectKey(iconKey), await iconResponse.arrayBuffer(), {
    customMetadata: {
      sourceType: "website",
      sourceUrl: iconUrl,
      ownerEmail: requesterEmail,
      scope: "shared",
      baseIconKey: iconKey
    },
    httpMetadata: {
      contentType: iconResponse.headers.get("content-type")?.split(";")[0] ?? "image/x-icon"
    }
  });
  const resolution = await resolveIconReference(env, {
    iconKey,
    website: websiteUrl
  });
  return ok({
    host: iconKey,
    iconKey,
    iconUrl: buildResolvedIconUrl(iconKey),
    resolvedIconKey: resolution.resolvedIconKey || iconKey,
    resolvedIconUrl: resolution.resolvedIconUrl || buildResolvedIconUrl(iconKey),
    scope: "shared"
  });
}
__name(fetchIcon, "fetchIcon");
async function handleNexusItems(request, env, pathname) {
  if (pathname === "/api/nexus/items") {
    if (request.method === "GET") {
      const requestUrl = new URL(request.url);
      const resourceId = normalizeResourceId(requestUrl.searchParams.get("resource"));
      if (!resourceId) {
        return fail("resource is required.", 400);
      }
      try {
        await requireAuthenticated(request, env);
        const category = storageCategoryByResourceId[resourceId];
        const payload = await callServiceDataApi(
          request,
          env,
          `/api/service-data/items?category=${encodeURIComponent(category)}`,
          { method: "GET" }
        );
        const items = await Promise.all((payload.items ?? []).map((item) => deserializeServiceItem(env, item)));
        return ok({ items });
      } catch (error) {
        return fail(error instanceof Error ? error.message : "Unable to load items.", 502);
      }
    }
    if (request.method === "POST") {
      const payload = await request.json().catch(() => null);
      const resourceId = normalizeResourceId(payload?.resourceId);
      if (!resourceId) {
        return fail("resourceId is required.", 400);
      }
      try {
        await requireAuthenticated(request, env);
        const category = storageCategoryByResourceId[resourceId];
        const row = buildRowFromForm(resourceId, payload?.formValues ?? {}, null);
        const encryptedPayload = await encryptPayload(env, row);
        const upstream = await callServiceDataApi(request, env, "/api/service-data/items", {
          method: "POST",
          headers: {
            "content-type": "application/json"
          },
          body: JSON.stringify({
            category,
            payload_json: encryptedPayload
          })
        });
        return ok({ item: await deserializeServiceItem(env, upstream.item) }, 201);
      } catch (error) {
        return fail(error instanceof Error ? error.message : "Unable to save item.", 400);
      }
    }
    return fail("Method not allowed.", 405);
  }
  const match = pathname.match(/^\/api\/nexus\/items\/([^/]+)$/);
  if (!match) {
    return fail("Not found.", 404);
  }
  const id = decodeURIComponent(match[1]);
  if (request.method === "PATCH" || request.method === "PUT") {
    const payload = await request.json().catch(() => null);
    const resourceId = normalizeResourceId(payload?.resourceId);
    if (!resourceId) {
      return fail("resourceId is required.", 400);
    }
    try {
      await requireAuthenticated(request, env);
      const upstreamCurrent = await callServiceDataApi(request, env, `/api/service-data/items/${encodeURIComponent(id)}`, {
        method: "GET"
      });
      const existingRow = await deserializeServiceItem(env, upstreamCurrent.item);
      const nextRow = buildRowFromForm(resourceId, payload?.formValues ?? {}, existingRow);
      const encryptedPayload = await encryptPayload(env, nextRow);
      const upstreamNext = await callServiceDataApi(request, env, `/api/service-data/items/${encodeURIComponent(id)}`, {
        method: "PATCH",
        headers: {
          "content-type": "application/json"
        },
        body: JSON.stringify({
          category: storageCategoryByResourceId[resourceId],
          payload_json: encryptedPayload
        })
      });
      return ok({ item: await deserializeServiceItem(env, upstreamNext.item) });
    } catch (error) {
      return fail(error instanceof Error ? error.message : "Unable to update item.", 400);
    }
  }
  if (request.method === "DELETE") {
    const requestUrl = new URL(request.url);
    const resourceId = normalizeResourceId(requestUrl.searchParams.get("resource"));
    if (!resourceId) {
      return fail("resource is required.", 400);
    }
    try {
      await requireAuthenticated(request, env);
      await callServiceDataApi(request, env, `/api/service-data/items/${encodeURIComponent(id)}`, {
        method: "DELETE"
      });
      return ok({ deleted: true });
    } catch (error) {
      return fail(error instanceof Error ? error.message : "Unable to delete item.", 400);
    }
  }
  if (request.method === "GET") {
    try {
      await requireAuthenticated(request, env);
      const upstream = await callServiceDataApi(request, env, `/api/service-data/items/${encodeURIComponent(id)}`, {
        method: "GET"
      });
      return ok({ item: await deserializeServiceItem(env, upstream.item) });
    } catch (error) {
      return fail(error instanceof Error ? error.message : "Unable to load item.", 404);
    }
  }
  return fail("Method not allowed.", 405);
}
__name(handleNexusItems, "handleNexusItems");
async function handlePasswordMatches(request, env) {
  if (request.method !== "GET") {
    return fail("Method not allowed.", 405);
  }
  const requestUrl = new URL(request.url);
  const requestHost = normalizeWebsiteHost(requestUrl.searchParams.get("origin"));
  if (!requestHost) {
    return fail("origin is required.", 400);
  }
  try {
    await requireAuthenticated(request, env);
    const payload = await callServiceDataApi(
      request,
      env,
      `/api/service-data/items?category=${encodeURIComponent(storageCategoryByResourceId.passwords)}`,
      { method: "GET" }
    );
    const items = await Promise.all((payload.items ?? []).map((item) => deserializeServiceItem(env, item)));
    const matches = items.map((item) => {
      const matchType = getPasswordMatchType(requestHost, item.website);
      if (!matchType) {
        return null;
      }
      if (!Array.isArray(item.kinds) || !item.kinds.includes("PASSWORD")) {
        return null;
      }
      if (!String(item.rawSecret ?? "").trim()) {
        return null;
      }
      return {
        id: String(item.id),
        matchType,
        passwordMask: item.passwordMask ?? "",
        rawSecret: item.rawSecret ?? "",
        resolvedIconKey: item.resolvedIconKey ?? "",
        resolvedIconUrl: item.resolvedIconUrl ?? "",
        service: item.service ?? "",
        username: item.username ?? "",
        website: item.website ?? ""
      };
    }).filter(Boolean).sort(comparePasswordMatches);
    return ok({
      host: requestHost,
      matches
    });
  } catch (error) {
    return fail(error instanceof Error ? error.message : "Unable to load password matches.", 502);
  }
}
__name(handlePasswordMatches, "handlePasswordMatches");
var logger = createLogger("nexus-data");
var index_default = {
  async fetch(request, env) {
    return withRequestLogging(logger, request, async () => {
      const requestUrl = new URL(request.url);
      const pathname = requestUrl.pathname;
      if (request.method === "OPTIONS") {
        const headers = new Headers();
        applyCorsHeaders(headers);
        return new Response(null, { headers, status: 204 });
      }
      if (pathname === "/health") {
        return ok({ service: "nexus-data" });
      }
      if ((request.method === "GET" || request.method === "HEAD") && pathname.startsWith("/api/site-icons/")) {
        return readIcon(request, requestUrl, env);
      }
      if (request.method === "POST" && pathname === "/api/site-icons/upload") {
        return uploadIcon(request, env);
      }
      if (request.method === "POST" && pathname === "/api/site-icons/fetch") {
        return fetchIcon(request, env);
      }
      if (pathname === "/api/nexus/password-matches") {
        return handlePasswordMatches(request, env);
      }
      if (pathname === "/api/nexus/items" || pathname.startsWith("/api/nexus/items/")) {
        return handleNexusItems(request, env, pathname);
      }
      return fail("Not found.", 404);
    });
  }
};
export {
  index_default as default
};
//# sourceMappingURL=index.js.map
