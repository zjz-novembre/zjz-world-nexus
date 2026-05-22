export const EXTENSION_NAME = "Nexus";
export const DEFAULT_API_BASE_URL = "https://zjz.world/nexus";

export const STORAGE_KEYS = Object.freeze({
  apiBaseUrl: "nexus-api-base-url",
  sessionEmail: "nexus-session-email",
  sessionToken: "nexus-session-token",
});

export const RUNTIME_MESSAGES = Object.freeze({
  detectFillTarget: "nexus:detect-fill-target",
  fillCredential: "nexus:fill-credential",
  getPopupState: "nexus:get-popup-state",
  login: "nexus:login",
  logout: "nexus:logout",
  readResourceItems: "nexus:read-resource-items",
  readAutoFillCredential: "nexus:read-auto-fill-credential",
  register: "nexus:register",
});

export const MATCH_TYPES = Object.freeze({
  exact: "exact",
  subdomain: "subdomain",
});
