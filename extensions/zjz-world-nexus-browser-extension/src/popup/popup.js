import { sendRuntimeMessage } from "../shared/extension-api.js";
import { RUNTIME_MESSAGES } from "../shared/constants.js";

const rootElement = document.getElementById("app");
const POPUP_VIEW_STORAGE_KEY = "nexus-popup-view";
const monthDayFormatter = new Intl.DateTimeFormat("en-US", {
  month: "short",
  day: "2-digit",
});

const RESOURCE_NAV_ITEMS = Object.freeze([
  {
    id: "passwords",
    iconPath: "../assets/shared-icons/passwords.png",
    label: "Passwords",
  },
  {
    id: "apiKeys",
    iconPath: "../assets/shared-icons/keys.png",
    label: "API Keys",
  },
  {
    id: "cards",
    iconPath: "../assets/shared-icons/cards.png",
    label: "Cards",
  },
  {
    id: "subscriptions",
    iconPath: "../assets/shared-icons/recurrings.png",
    label: "Recurrings",
  },
]);

const RESOURCE_IDS = RESOURCE_NAV_ITEMS.map((item) => item.id);

function buildEmptyResourceItems() {
  return {
    passwords: [],
    apiKeys: [],
    cards: [],
    subscriptions: [],
  };
}

function buildEmptyResourceFlags(value = false) {
  return {
    passwords: value,
    apiKeys: value,
    cards: value,
    subscriptions: value,
  };
}

const state = {
  activeView: "loading",
  errorMessage: "",
  activeResourceId: "passwords",
  popupState: null,
  resourceItems: buildEmptyResourceItems(),
  resourceItemsLoaded: buildEmptyResourceFlags(false),
  resourceItemsLoading: buildEmptyResourceFlags(false),
  submitting: false,
};

function setBodyViewClass(viewId) {
  const hintedView =
    viewId === "loading"
      ? document.documentElement.dataset.popupView === "signed-in" ||
        document.documentElement.dataset.popupView === "signed-out"
        ? document.documentElement.dataset.popupView
        : "loading"
      : viewId;
  document.documentElement.dataset.popupView = hintedView;
  if (viewId === "signed-in" || viewId === "signed-out") {
    try {
      window.localStorage.setItem(POPUP_VIEW_STORAGE_KEY, viewId);
    } catch {
      // Ignore storage failures; popup rendering still proceeds with the live view.
    }
  }
  document.body.className = `popup-view popup-view--${viewId}`;
}

function escapeHtml(value) {
  return String(value ?? "")
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
}

function compactUrl(value) {
  return String(value ?? "")
    .trim()
    .replace(/^https?:\/\//i, "")
    .replace(/\/+$/g, "");
}

function extractHost(value) {
  const compactValue = compactUrl(value);
  if (!compactValue) {
    return "";
  }
  return compactValue.split("/")[0] ?? compactValue;
}

function buildMonogram(...values) {
  const source = values
    .map((value) => String(value ?? "").trim())
    .find((value) => value.length > 0);
  if (!source) {
    return "N";
  }
  const candidate = source.replace(/^https?:\/\//i, "").match(/[A-Za-z0-9]/)?.[0] ?? source[0];
  return String(candidate).toUpperCase();
}

function buildApiUrl(pathname, apiBaseUrl) {
  const normalizedApiBaseUrl = String(apiBaseUrl ?? "").trim().replace(/\/$/, "");
  if (!normalizedApiBaseUrl) {
    return "";
  }
  const normalizedPathname = String(pathname ?? "").startsWith("/")
    ? String(pathname)
    : `/${String(pathname ?? "")}`;
  return `${normalizedApiBaseUrl}${normalizedPathname}`;
}

function buildIconUrl(item, popupState, fallbackLabel) {
  const apiBaseUrl = popupState?.apiBaseUrl ?? "";
  const resolvedIconKey = String(
    item?.resolvedIconKey ?? item?.iconKey ?? extractHost(item?.website ?? item?.url ?? ""),
  ).trim();
  if (!apiBaseUrl || !resolvedIconKey) {
    return "";
  }
  const params = new URLSearchParams();
  const resolvedIconVersion = Number(item?.resolvedIconVersion ?? item?.iconVersion ?? 0);
  if (Number.isFinite(resolvedIconVersion) && resolvedIconVersion > 0) {
    params.set("v", String(resolvedIconVersion));
  }
  if (fallbackLabel) {
    params.set("fallback", fallbackLabel);
  }
  return buildApiUrl(`/api/site-icons/${encodeURIComponent(resolvedIconKey)}${params.size ? `?${params.toString()}` : ""}`, apiBaseUrl);
}

function formatMonthDay(value) {
  if (!value) {
    return "";
  }
  const parsed = parseDateOnly(value) ?? new Date(value);
  return Number.isNaN(parsed.getTime()) ? "" : monthDayFormatter.format(parsed).toUpperCase();
}

function formatCurrency(value, currency = "USD", fractionDigits = null) {
  const numericValue = Number(value ?? 0);
  if (!Number.isFinite(numericValue)) {
    return currency;
  }
  const normalizedCurrency = currency === "CAD" ? "CAD" : currency === "JPY" ? "JPY" : "USD";
  const resolvedFractionDigits =
    Number.isInteger(fractionDigits)
      ? Number(fractionDigits)
      : normalizedCurrency === "JPY"
        ? 0
        : numericValue % 1 === 0
          ? 0
          : 2;
  const formattedValue = new Intl.NumberFormat(
    normalizedCurrency === "CAD" ? "en-CA" : normalizedCurrency === "JPY" ? "ja-JP" : "en-US",
    {
      style: "currency",
      currency: normalizedCurrency,
      minimumFractionDigits: resolvedFractionDigits,
      maximumFractionDigits: resolvedFractionDigits,
    },
  ).format(numericValue);
  return normalizedCurrency === "CAD" ? `CA$${formattedValue.replace(/^\$+/, "")}` : formattedValue;
}

function formatMetricCount(value) {
  return String(Math.max(0, Number.parseInt(String(value ?? "0"), 10) || 0)).padStart(2, "0");
}

function parseDateOnly(value) {
  const match = String(value ?? "").trim().match(/^(\d{4})-(\d{2})-(\d{2})$/);
  if (!match) {
    return null;
  }
  const year = Number.parseInt(match[1], 10);
  const month = Number.parseInt(match[2], 10);
  const day = Number.parseInt(match[3], 10);
  const parsed = new Date(year, month - 1, day);
  if (
    parsed.getFullYear() !== year
    || parsed.getMonth() !== month - 1
    || parsed.getDate() !== day
  ) {
    return null;
  }
  parsed.setHours(0, 0, 0, 0);
  return parsed;
}

function normalizeDateOnly(value) {
  const parsed = new Date(value);
  parsed.setHours(0, 0, 0, 0);
  return parsed;
}

function buildAnchoredDate(year, monthIndex, anchorDay) {
  const lastDay = new Date(year, monthIndex + 1, 0).getDate();
  const dateValue = new Date(year, monthIndex, Math.min(anchorDay, lastDay));
  dateValue.setHours(0, 0, 0, 0);
  return dateValue;
}

function advanceBillingDate(anchorDate, cadenceMonths, now = new Date()) {
  if (!(anchorDate instanceof Date) || !Number.isFinite(anchorDate.getTime()) || cadenceMonths <= 0) {
    return null;
  }
  const today = normalizeDateOnly(now);
  const anchorDay = anchorDate.getDate();
  let current = new Date(anchorDate);
  current.setHours(0, 0, 0, 0);
  while (current.getTime() < today.getTime()) {
    current = buildAnchoredDate(current.getFullYear(), current.getMonth() + cadenceMonths, anchorDay);
  }
  return current;
}

function getCadenceMonths(cadence) {
  switch (String(cadence ?? "").trim().toUpperCase()) {
    case "QUARTERLY":
      return 3;
    case "YEARLY":
      return 12;
    case "MONTHLY":
      return 1;
    default:
      return 0;
  }
}

function isNoCreditNetwork(network) {
  const normalizedNetwork = String(network ?? "").trim().toUpperCase();
  return normalizedNetwork === "DEBIT" || normalizedNetwork === "VIRTUAL";
}

function readCardNextBillingDate(item, now = new Date()) {
  if (isNoCreditNetwork(item?.network)) {
    return "";
  }
  const anchorDate = parseDateOnly(item?.billingAnchorDate);
  if (!anchorDate) {
    return "";
  }
  const nextDate = advanceBillingDate(anchorDate, 1, now);
  if (!nextDate) {
    return "";
  }
  return `${nextDate.getFullYear()}-${String(nextDate.getMonth() + 1).padStart(2, "0")}-${String(nextDate.getDate()).padStart(2, "0")}`;
}

function readSubscriptionNextBillingDate(item, now = new Date()) {
  if (String(item?.status ?? "").trim().toUpperCase() === "INACTIVE") {
    return "";
  }
  const anchorDate = parseDateOnly(item?.billingAnchorDate);
  const cadenceMonths = getCadenceMonths(item?.cadence);
  if (!anchorDate || cadenceMonths <= 0) {
    return "";
  }
  const nextDate = advanceBillingDate(anchorDate, cadenceMonths, now);
  if (!nextDate) {
    return "";
  }
  return `${nextDate.getFullYear()}-${String(nextDate.getMonth() + 1).padStart(2, "0")}-${String(nextDate.getDate()).padStart(2, "0")}`;
}

function isBillableSubscription(item, now = new Date()) {
  if (String(item?.status ?? "").trim().toUpperCase() !== "ACTIVE") {
    return false;
  }
  if (String(item?.tier ?? "").trim().toUpperCase() !== "FREE TRIAL") {
    return true;
  }
  const anchorDate = parseDateOnly(item?.billingAnchorDate);
  if (!anchorDate) {
    return false;
  }
  return anchorDate.getTime() <= normalizeDateOnly(now).getTime();
}

function normalizeRecurringAmount(amount, cadence) {
  const numericAmount = Number(amount ?? 0);
  if (!Number.isFinite(numericAmount)) {
    return 0;
  }
  switch (String(cadence ?? "").trim().toUpperCase()) {
    case "YEARLY":
      return numericAmount / 12;
    case "QUARTERLY":
      return numericAmount / 3;
    default:
      return numericAmount;
  }
}

function getMetricCurrencyPriority(currency) {
  switch (String(currency ?? "").trim().toUpperCase()) {
    case "USD":
      return 0;
    case "CAD":
      return 1;
    case "JPY":
      return 2;
    default:
      return 9;
  }
}

function sumByCurrency(items, valueResolver, currencyResolver) {
  return items.reduce((totals, item) => {
    const numericValue = Number(valueResolver(item) ?? 0);
    if (!Number.isFinite(numericValue) || numericValue === 0) {
      return totals;
    }
    const currencyCode = String(currencyResolver(item) ?? "USD").trim().toUpperCase() || "USD";
    totals[currencyCode] = (totals[currencyCode] ?? 0) + numericValue;
    return totals;
  }, {});
}

function formatMetricCurrencyLines(totals, fractionDigits) {
  const lines = Object.entries(totals)
    .filter(([, value]) => Math.abs(value) > 0)
    .sort(([leftCurrency], [rightCurrency]) => {
      const priorityDelta = getMetricCurrencyPriority(leftCurrency) - getMetricCurrencyPriority(rightCurrency);
      return priorityDelta !== 0 ? priorityDelta : leftCurrency.localeCompare(rightCurrency);
    })
    .map(([currencyCode, value]) => formatCurrency(value, currencyCode, fractionDigits));
  return lines.length > 0 ? lines.join("\n") : formatCurrency(0, "USD", fractionDigits);
}

function findNearestBillingDate(items, valueResolver) {
  const nextBilling = items
    .map((item) => {
      const dateValue = valueResolver(item);
      const parsedDate = parseDateOnly(dateValue);
      if (!parsedDate) {
        return null;
      }
      return {
        dateValue,
        stamp: parsedDate.getTime(),
      };
    })
    .filter(Boolean)
    .sort((left, right) => left.stamp - right.stamp)[0];
  return nextBilling?.dateValue ?? "";
}

function buildHeaderMetric(resourceId, items) {
  switch (resourceId) {
    case "passwords":
      return { label: "TOTAL ACCOUNTS", value: formatMetricCount(items.length), valueClassName: "" };
    case "apiKeys":
      return { label: "TOTAL", value: formatMetricCount(items.length), valueClassName: "" };
    case "cards": {
      const nextBillingDate = findNearestBillingDate(items, (item) => readCardNextBillingDate(item));
      return { label: "NEXT BILLING", value: formatMonthDay(nextBillingDate) || "N/A", valueClassName: "resource-toolbar-count--date" };
    }
    case "subscriptions": {
      const nextBillingDate = findNearestBillingDate(items, (item) => readSubscriptionNextBillingDate(item));
      return { label: "NEXT BILLING", value: formatMonthDay(nextBillingDate) || "N/A", valueClassName: "resource-toolbar-count--date" };
    }
    default:
      return null;
  }
}

function buildMetricStripMarkup(resourceId, items, loaded) {
  if (!loaded) {
    return "";
  }
  const metric = buildHeaderMetric(resourceId, items);
  if (!metric) {
    return "";
  }
  return `
    <section class="resource-metric-bar" aria-label="Metrics">
      <div class="resource-toolbar-metric">
        <div class="resource-toolbar-head">
          <span class="resource-marker-block" aria-hidden="true"></span>
          <span class="resource-toolbar-tag">${escapeHtml(metric.label)}</span>
        </div>
        <span class="resource-toolbar-count ${escapeHtml(metric.valueClassName ?? "")}">${escapeHtml(metric.value)}</span>
      </div>
    </section>
  `;
}

function isOneTimeCodeItem(item) {
  const kinds = Array.isArray(item?.kinds) ? item.kinds : [];
  return kinds.includes("OTP") || kinds.includes("2FA");
}

function applyPopupState(popupState) {
  state.popupState = popupState;
  state.activeView = popupState?.session?.authenticated ? "signed-in" : "signed-out";
  if (!popupState?.session?.authenticated) {
    state.activeResourceId = "passwords";
    state.resourceItems = buildEmptyResourceItems();
    state.resourceItemsLoaded = buildEmptyResourceFlags(false);
    state.resourceItemsLoading = buildEmptyResourceFlags(false);
    return;
  }
  const loadedResourceIds = new Set(
    Array.isArray(popupState?.loadedResourceIds)
      ? popupState.loadedResourceIds.filter((resourceId) => RESOURCE_IDS.includes(resourceId))
      : [],
  );
  const nextResourceItems = buildEmptyResourceItems();
  const nextResourceItemsLoaded = buildEmptyResourceFlags(false);
  RESOURCE_IDS.forEach((resourceId) => {
    if (!loadedResourceIds.has(resourceId)) {
      return;
    }
    const providedItems = popupState?.initialResourceItems?.[resourceId];
    nextResourceItems[resourceId] = Array.isArray(providedItems) ? providedItems : [];
    nextResourceItemsLoaded[resourceId] = true;
  });
  state.resourceItems = nextResourceItems;
  state.resourceItemsLoaded = nextResourceItemsLoaded;
  state.resourceItemsLoading = buildEmptyResourceFlags(false);
}

function sortItems(resourceId, items, matches = []) {
  const rows = [...items];
  const sortNow = new Date();
  const compareLabels = (leftLabel, rightLabel) =>
    String(leftLabel ?? "").localeCompare(String(rightLabel ?? ""), undefined, {
      numeric: true,
      sensitivity: "base",
    });
  const readBillingSortStamp = (item) => {
    const dateValue =
      resourceId === "cards"
        ? readCardNextBillingDate(item, sortNow)
        : resourceId === "subscriptions"
          ? readSubscriptionNextBillingDate(item, sortNow)
          : "";
    const parsedDate = parseDateOnly(dateValue);
    return parsedDate ? parsedDate.getTime() : Number.POSITIVE_INFINITY;
  };
  if (resourceId === "passwords") {
    const matchOrder = new Map(matches.map((match, index) => [String(match.id), index]));
    rows.sort((left, right) => {
      const leftMatchOrder = matchOrder.has(String(left.id)) ? matchOrder.get(String(left.id)) : Number.POSITIVE_INFINITY;
      const rightMatchOrder = matchOrder.has(String(right.id)) ? matchOrder.get(String(right.id)) : Number.POSITIVE_INFINITY;
      if (leftMatchOrder !== rightMatchOrder) {
        return leftMatchOrder - rightMatchOrder;
      }
      const leftLabel = `${left.service ?? ""} ${left.username ?? ""}`.trim().toLowerCase();
      const rightLabel = `${right.service ?? ""} ${right.username ?? ""}`.trim().toLowerCase();
      return compareLabels(leftLabel, rightLabel);
    });
    return rows;
  }
  rows.sort((left, right) => {
    if (resourceId === "cards" || resourceId === "subscriptions") {
      const billingDelta = readBillingSortStamp(left) - readBillingSortStamp(right);
      if (billingDelta !== 0) {
        return billingDelta;
      }
    }
    const leftLabel =
      resourceId === "apiKeys"
        ? String(left.keyName ?? "").toLowerCase()
        : resourceId === "cards"
          ? String(left.cardName ?? "").toLowerCase()
          : String(left.service ?? "").toLowerCase();
    const rightLabel =
      resourceId === "apiKeys"
        ? String(right.keyName ?? "").toLowerCase()
        : resourceId === "cards"
          ? String(right.cardName ?? "").toLowerCase()
          : String(right.service ?? "").toLowerCase();
    return compareLabels(leftLabel, rightLabel);
  });
  return rows;
}

function isFillReady(resourceId, popupState) {
  if (resourceId === "passwords") {
    return Boolean(popupState?.page?.fillTargets?.passwords);
  }
  if (resourceId === "cards") {
    return Boolean(popupState?.page?.fillTargets?.cards);
  }
  return false;
}

function buildIconMarkup(item, popupState, fallbackLabel) {
  const iconUrl = buildIconUrl(item, popupState, fallbackLabel);
  return `
    <div class="resource-icon ${iconUrl ? "resource-icon--has-image" : ""}">
      ${iconUrl ? `<img alt="" aria-hidden="true" class="resource-icon__image" src="${escapeHtml(iconUrl)}" />` : ""}
      <span class="resource-icon__fallback" aria-hidden="true">${escapeHtml(fallbackLabel)}</span>
    </div>
  `;
}

function buildPasswordRowMarkup(item, popupState) {
  const fillReady = isFillReady("passwords", popupState) && !isOneTimeCodeItem(item) && Boolean(String(item?.rawSecret ?? "").trim());
  const fallbackLabel = buildMonogram(item.service, item.website, item.username);
  const metaValue = item.service || extractHost(item.website) || "PASSWORD";
  const supportValue = compactUrl(item.website);
  const passwordMask = String(item.passwordMask ?? "").trim() || "••••••••";
  const websiteMarkup = supportValue
    ? `
          <span class="resource-row__separator" aria-hidden="true">&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;</span>
          <a
            class="resource-row__link"
            data-resource-link
            href="${escapeHtml(item.website || "")}"
            rel="noreferrer noopener"
            target="_blank"
          >
            ${escapeHtml(supportValue)}
          </a>
        `
    : "";
  const secretMarkup = String(item?.rawSecret ?? "").trim()
    ? `
          <button class="resource-value resource-value--primary resource-value--secret" data-copy-secret-id="${escapeHtml(item.id)}" type="button">
            ${escapeHtml(passwordMask)}
          </button>
        `
    : "";
  return `
    <article class="resource-row resource-row--password ${fillReady ? "is-fillable" : ""}" ${fillReady ? `data-fill-password-row-id="${escapeHtml(item.id)}"` : ""}>
      <div class="resource-row__icon-wrap">
        ${buildIconMarkup(item, popupState, fallbackLabel)}
      </div>
      <div class="resource-row__body">
        <div class="resource-row__meta">
          <span class="resource-row__name">${escapeHtml(metaValue)}</span>
          ${websiteMarkup}
        </div>
        <div class="resource-inline-values resource-inline-values--password">
          <button class="resource-value resource-value--secondary" data-copy-username-id="${escapeHtml(item.id)}" type="button">
            ${escapeHtml(item.username || "NO USERNAME")}
          </button>
          ${secretMarkup}
        </div>
      </div>
    </article>
  `;
}

function buildApiKeyRowMarkup(item, popupState) {
  const primaryValue = String(item.rawValue ?? item.maskedValue ?? "").trim();
  const displayValue = String(item.maskedValue ?? primaryValue ?? "").trim() || "NO VALUE";
  return `
    <article class="resource-row resource-row--api-key resource-row--no-icon">
      <div class="resource-row__body">
        <div class="resource-row__meta">
          <span class="resource-row__name">${escapeHtml(item.keyName || "API KEY")}</span>
        </div>
        <button class="resource-value resource-value--api-key resource-value--mono" data-copy-key-id="${escapeHtml(item.id)}" type="button">
          ${escapeHtml(displayValue)}
        </button>
      </div>
    </article>
  `;
}

function buildCardRowMarkup(item, popupState) {
  const fillReady = isFillReady("cards", popupState);
  const fallbackLabel = buildMonogram(item.cardName, item.network);
  return `
    <article class="resource-row resource-row--card ${fillReady ? "is-fillable" : ""}" ${fillReady ? `data-fill-card-row-id="${escapeHtml(item.id)}"` : ""}>
      <div class="resource-row__icon-wrap">
        ${buildIconMarkup(item, popupState, fallbackLabel)}
      </div>
      <div class="resource-row__body">
        <div class="resource-row__meta">
          <span class="resource-row__name">${escapeHtml(item.cardName || "CARD")}</span>
          ${item.network ? `<span class="resource-row__support">${escapeHtml(item.network)}</span>` : ""}
        </div>
        <div class="resource-inline-values resource-inline-values--card">
          <button class="resource-value resource-value--card-number resource-value--mono" data-copy-card-number-id="${escapeHtml(item.id)}" type="button">
            ${escapeHtml(item.maskedNumber || "NO NUMBER")}
          </button>
          <button class="resource-value resource-value--mini resource-value--card-expiry resource-value--mono" data-copy-card-expiry-id="${escapeHtml(item.id)}" type="button">
            ${escapeHtml(item.expiry || "MM/YY")}
          </button>
          <button class="resource-value resource-value--mini resource-value--card-cvv resource-value--secret resource-value--mono" data-copy-card-cvv-id="${escapeHtml(item.id)}" type="button">
            ${escapeHtml(item.cvvMask || "•••")}
          </button>
        </div>
      </div>
    </article>
  `;
}

function buildSubscriptionRowMarkup(item, popupState) {
  const fallbackLabel = buildMonogram(item.service, item.tier);
  const amountLabel = formatCurrency(item.amount, item.amountCurrency);
  const statusLabel = String(item.status ?? "").trim().toUpperCase() || "ACTIVE";
  return `
    <article class="resource-row resource-row--subscription">
      <div class="resource-row__icon-wrap">
        ${buildIconMarkup(item, popupState, fallbackLabel)}
      </div>
      <div class="resource-row__body">
        <div class="resource-row__meta">
          <span class="resource-row__name">${escapeHtml(item.service || "RECURRING")}</span>
          <span class="resource-chip ${statusLabel === "ACTIVE" ? "resource-chip--success" : "resource-chip--muted"}">${escapeHtml(statusLabel)}</span>
        </div>
        <span class="resource-value resource-value--subscription">
          ${escapeHtml(amountLabel)}
        </span>
      </div>
    </article>
  `;
}

function buildResourceListMarkup(resourceId, items, popupState) {
  const matches = Array.isArray(popupState?.matches) ? popupState.matches : [];
  const sortedItems = sortItems(resourceId, items, matches);
  if (sortedItems.length === 0) {
    return `
      <section class="resource-list">
        <div class="resource-empty">EMPTY</div>
      </section>
    `;
  }
  return `
    <section class="resource-list">
      ${sortedItems
        .map((item) => {
          switch (resourceId) {
            case "passwords":
              return buildPasswordRowMarkup(item, popupState);
            case "apiKeys":
              return buildApiKeyRowMarkup(item, popupState);
            case "cards":
              return buildCardRowMarkup(item, popupState);
            case "subscriptions":
              return buildSubscriptionRowMarkup(item, popupState);
            default:
              return "";
          }
        })
        .join("")}
    </section>
  `;
}

function getHeaderSubline(resourceId, popupState, items) {
  if (resourceId === "passwords") {
    return popupState?.page?.host ?? "";
  }
  return "";
}

function getSignedInStatusMessage(popupState) {
  if (state.errorMessage) {
    return state.errorMessage;
  }
  if (popupState?.sessionError) {
    return popupState.sessionError;
  }
  if (state.resourceItemsLoading[state.activeResourceId]) {
    return "SYNC";
  }
  return "";
}

function buildSignedInHeaderMarkup(activeResource, activeItems, popupState, loaded) {
  const accountLabel = String(popupState?.session?.email ?? "").trim();
  const headerSubline = getHeaderSubline(activeResource.id, popupState, activeItems);
  return `
    <header class="resource-header">
      <div class="resource-header__top">
        <div class="resource-header__lead">
          <span class="resource-header__label">${escapeHtml(activeResource.label)}</span>
          ${headerSubline ? `<span class="resource-header__subline">${escapeHtml(headerSubline)}</span>` : ""}
        </div>
        <div class="resource-header__account">${escapeHtml(accountLabel)}</div>
      </div>
      ${buildMetricStripMarkup(activeResource.id, activeItems, loaded)}
      <a
        aria-label="Open Nexus"
        class="resource-header__shortcut resource-rail__button resource-rail__button--exit"
        data-open-dashboard
        href="https://zjz.world/nexus"
        rel="noreferrer noopener"
        target="_blank"
        title="Open Nexus"
      >
        <img alt="" aria-hidden="true" class="resource-rail__image resource-rail__image--exit" src="../assets/redirect.svg" />
      </a>
    </header>
  `;
}

function bindCopyButtons(selector, resolver) {
  rootElement.querySelectorAll(selector).forEach((buttonElement) => {
    buttonElement.addEventListener("click", (event) => {
      event.stopPropagation();
      const payload = resolver(event.currentTarget);
      void copyToClipboard(payload);
    });
  });
}

function bindIconFallbacks() {
  rootElement.querySelectorAll(".resource-icon__image").forEach((imageElement) => {
    const iconElement = imageElement.closest(".resource-icon");
    if (imageElement.complete && imageElement.naturalWidth === 0) {
      iconElement?.classList.remove("resource-icon--has-image");
      imageElement.remove();
      return;
    }
    imageElement.addEventListener("error", () => {
      iconElement?.classList.remove("resource-icon--has-image");
      imageElement.remove();
    });
  });
}

function bindSignedInEventHandlers() {
  bindIconFallbacks();
  rootElement.querySelectorAll("[data-resource-id]").forEach((buttonElement) => {
    buttonElement.addEventListener("click", (event) => {
      const resourceId = event.currentTarget?.getAttribute("data-resource-id") ?? "passwords";
      state.activeResourceId = resourceId;
      render();
      void ensureResourceItems(resourceId);
    });
  });
  rootElement.querySelector("[data-sign-out]")?.addEventListener("click", () => {
    void signOut();
  });
  rootElement.querySelectorAll("[data-open-dashboard]").forEach((linkElement) => {
    linkElement.addEventListener("click", (event) => {
      event.stopPropagation();
    });
  });
  rootElement.querySelectorAll("[data-resource-link]").forEach((linkElement) => {
    linkElement.addEventListener("click", (event) => {
      event.stopPropagation();
    });
  });
  bindCopyButtons("[data-copy-username-id]", (buttonElement) => {
    const itemId = buttonElement.getAttribute("data-copy-username-id") ?? "";
    const item = state.resourceItems.passwords.find((entry) => String(entry.id) === itemId);
    return item?.username ?? "";
  });
  bindCopyButtons("[data-copy-secret-id]", (buttonElement) => {
    const itemId = buttonElement.getAttribute("data-copy-secret-id") ?? "";
    const item = state.resourceItems.passwords.find((entry) => String(entry.id) === itemId);
    return item?.rawSecret ?? "";
  });
  bindCopyButtons("[data-copy-key-id]", (buttonElement) => {
    const itemId = buttonElement.getAttribute("data-copy-key-id") ?? "";
    const item = state.resourceItems.apiKeys.find((entry) => String(entry.id) === itemId);
    return item?.rawValue ?? item?.maskedValue ?? "";
  });
  bindCopyButtons("[data-copy-card-number-id]", (buttonElement) => {
    const itemId = buttonElement.getAttribute("data-copy-card-number-id") ?? "";
    const item = state.resourceItems.cards.find((entry) => String(entry.id) === itemId);
    return item?.rawCardNumber ?? item?.maskedNumber ?? "";
  });
  bindCopyButtons("[data-copy-card-expiry-id]", (buttonElement) => {
    const itemId = buttonElement.getAttribute("data-copy-card-expiry-id") ?? "";
    const item = state.resourceItems.cards.find((entry) => String(entry.id) === itemId);
    return item?.expiry ?? "";
  });
  bindCopyButtons("[data-copy-card-cvv-id]", (buttonElement) => {
    const itemId = buttonElement.getAttribute("data-copy-card-cvv-id") ?? "";
    const item = state.resourceItems.cards.find((entry) => String(entry.id) === itemId);
    return item?.rawCvv ?? item?.cvvMask ?? "";
  });
  rootElement.querySelectorAll("[data-fill-password-row-id]").forEach((rowElement) => {
    rowElement.addEventListener("click", (event) => {
      if (event.defaultPrevented) {
        return;
      }
      const itemId = event.currentTarget?.getAttribute("data-fill-password-row-id") ?? "";
      const item = state.resourceItems.passwords.find((entry) => String(entry.id) === itemId);
      void fillEntry(item);
    });
  });
  rootElement.querySelectorAll("[data-fill-card-row-id]").forEach((rowElement) => {
    rowElement.addEventListener("click", (event) => {
      if (event.defaultPrevented) {
        return;
      }
      const itemId = event.currentTarget?.getAttribute("data-fill-card-row-id") ?? "";
      const item = state.resourceItems.cards.find((entry) => String(entry.id) === itemId);
      void fillEntry(item);
    });
  });
}

function renderLoading() {
  setBodyViewClass("loading");
  rootElement.className = "shell shell--popup";
  rootElement.innerHTML = `
    <section class="popup-app popup-app--loading">
      <div class="popup-loading">
        <div class="popup-loading__line"></div>
        <div class="popup-loading__line"></div>
      </div>
    </section>
  `;
}

function renderSignedOut() {
  setBodyViewClass("signed-out");
  rootElement.className = "shell shell--popup shell--popup--logged-out";
  const statusMarkup = state.errorMessage
    ? `<div class="status-line logged-out-screen__status">${escapeHtml(state.errorMessage)}</div>`
    : "";
  rootElement.innerHTML = `
    <section class="logged-out-screen">
      <form class="logged-out-screen__content" id="sign-in-form">
        <p class="logged-out-screen__brand">Nexus</p>
        <label class="logged-out-screen__field">
          <span class="logged-out-screen__label">Username</span>
          <input class="logged-out-screen__input" id="email" name="email" type="text" autocomplete="username" required />
        </label>
        <label class="logged-out-screen__field">
          <span class="logged-out-screen__label">Password</span>
          <input class="logged-out-screen__input" id="password" name="password" type="password" autocomplete="current-password" required />
        </label>
        <div class="logged-out-screen__actions">
          <button class="button button--primary logged-out-screen__button" type="submit">SIGN IN</button>
          <button class="button button--secondary logged-out-screen__button" id="create-account" type="button">CREATE</button>
        </div>
        ${statusMarkup}
      </form>
    </section>
  `;
  document.getElementById("sign-in-form")?.addEventListener("submit", (event) => {
    event.preventDefault();
    const formData = new FormData(event.currentTarget);
    void signIn({
      email: formData.get("email"),
      password: formData.get("password"),
    });
  });
  document.getElementById("create-account")?.addEventListener("click", () => {
    const formElement = document.getElementById("sign-in-form");
    const formData = formElement ? new FormData(formElement) : new FormData();
    void createAccount({
      email: formData.get("email"),
      password: formData.get("password"),
    });
  });
}

function renderSignedIn() {
  setBodyViewClass("signed-in");
  rootElement.className = "shell shell--popup";
  const popupState = state.popupState ?? {};
  const activeResource = RESOURCE_NAV_ITEMS.find((item) => item.id === state.activeResourceId) ?? RESOURCE_NAV_ITEMS[0];
  const activeItems = Array.isArray(state.resourceItems[activeResource.id]) ? state.resourceItems[activeResource.id] : [];
  const navMarkup = RESOURCE_NAV_ITEMS.map(
    (item) => `
      <button
        aria-label="${escapeHtml(item.label)}"
        class="resource-rail__button ${item.id === activeResource.id ? "is-active" : ""}"
        data-resource-id="${escapeHtml(item.id)}"
        title="${escapeHtml(item.label)}"
        type="button"
      >
        <img alt="" aria-hidden="true" class="resource-rail__image" src="${escapeHtml(item.iconPath)}" />
      </button>
    `,
  ).join("");
  const statusMessage = getSignedInStatusMessage(popupState);
  rootElement.innerHTML = `
    <section class="popup-app popup-app--signed-in">
      <nav class="resource-rail" aria-label="Resources">
        ${navMarkup}
        <div class="resource-rail__spacer"></div>
        <button aria-label="Sign out" class="resource-rail__button resource-rail__button--exit" data-sign-out title="Sign out" type="button">
          <img alt="" aria-hidden="true" class="resource-rail__image resource-rail__image--exit" src="../assets/exit.svg" />
        </button>
      </nav>
      <section class="resource-stage">
        ${buildSignedInHeaderMarkup(activeResource, activeItems, popupState, state.resourceItemsLoaded[activeResource.id])}
        ${buildResourceListMarkup(activeResource.id, activeItems, popupState)}
        ${statusMessage ? `<div class="resource-status">${escapeHtml(statusMessage)}</div>` : ""}
      </section>
    </section>
  `;
  bindSignedInEventHandlers();
}

function render() {
  switch (state.activeView) {
    case "loading":
      renderLoading();
      break;
    case "signed-out":
      renderSignedOut();
      break;
    case "signed-in":
      renderSignedIn();
      break;
    default:
      renderLoading();
      break;
  }
}

async function readPopupState() {
  return sendRuntimeMessage({ type: RUNTIME_MESSAGES.getPopupState });
}

async function readResourceItems(resourceId) {
  const response = await sendRuntimeMessage({
    type: RUNTIME_MESSAGES.readResourceItems,
    resourceId,
  });
  return Array.isArray(response?.items) ? response.items : [];
}

async function ensureResourceItems(resourceId, { force = false } = {}) {
  if (!resourceId) {
    return;
  }
  if (!force && (state.resourceItemsLoaded[resourceId] || state.resourceItemsLoading[resourceId])) {
    return;
  }
  state.errorMessage = "";
  state.resourceItemsLoading = {
    ...state.resourceItemsLoading,
    [resourceId]: true,
  };
  render();
  try {
    const items = await readResourceItems(resourceId);
    state.resourceItems = {
      ...state.resourceItems,
      [resourceId]: items,
    };
    state.resourceItemsLoaded = {
      ...state.resourceItemsLoaded,
      [resourceId]: true,
    };
  } catch (error) {
    state.errorMessage = error instanceof Error ? error.message : "Unable to read items.";
  } finally {
    state.resourceItemsLoading = {
      ...state.resourceItemsLoading,
      [resourceId]: false,
    };
  }
  render();
}

async function copyToClipboard(value) {
  if (!value) {
    return;
  }
  await navigator.clipboard.writeText(String(value));
}

async function refreshState() {
  state.activeView = "loading";
  state.errorMessage = "";
  state.activeResourceId = "passwords";
  state.resourceItems = buildEmptyResourceItems();
  state.resourceItemsLoaded = buildEmptyResourceFlags(false);
  state.resourceItemsLoading = buildEmptyResourceFlags(false);
  render();
  try {
    applyPopupState(await readPopupState());
  } catch (error) {
    state.popupState = null;
    state.activeView = "signed-out";
    state.errorMessage = error instanceof Error ? error.message : "Unable to load state.";
  }
  render();
  if (state.activeView === "signed-in" && !state.resourceItemsLoaded[state.activeResourceId]) {
    await ensureResourceItems(state.activeResourceId);
  }
}

async function signIn({ email, password }) {
  state.submitting = true;
  state.errorMessage = "";
  render();
  try {
    applyPopupState(
      await sendRuntimeMessage({
        type: RUNTIME_MESSAGES.login,
        email,
        password,
      }),
    );
  } catch (error) {
    state.errorMessage = error instanceof Error ? error.message : "Unable to sign in.";
    state.activeView = "signed-out";
  } finally {
    state.submitting = false;
  }
  render();
  if (state.activeView === "signed-in" && !state.resourceItemsLoaded[state.activeResourceId]) {
    await ensureResourceItems(state.activeResourceId);
  }
}

async function signOut() {
  state.errorMessage = "";
  render();
  try {
    applyPopupState(await sendRuntimeMessage({ type: RUNTIME_MESSAGES.logout }));
  } catch (error) {
    state.errorMessage = error instanceof Error ? error.message : "Unable to sign out.";
  }
  render();
}

async function createAccount({ email, password }) {
  state.submitting = true;
  state.errorMessage = "";
  render();
  try {
    applyPopupState(
      await sendRuntimeMessage({
        type: RUNTIME_MESSAGES.register,
        email,
        password,
      }),
    );
  } catch (error) {
    state.errorMessage = error instanceof Error ? error.message : "Unable to create account.";
    state.activeView = "signed-out";
  } finally {
    state.submitting = false;
  }
  render();
  if (state.activeView === "signed-in" && !state.resourceItemsLoaded[state.activeResourceId]) {
    await ensureResourceItems(state.activeResourceId);
  }
}

async function fillEntry(item) {
  state.errorMessage = "";
  render();
  try {
    await sendRuntimeMessage({
      type: RUNTIME_MESSAGES.fillCredential,
      credential: item,
    });
    await window.close();
  } catch (error) {
    state.errorMessage = error instanceof Error ? error.message : "Unable to autofill.";
    render();
  }
}

document.addEventListener("DOMContentLoaded", () => {
  void refreshState();
});
