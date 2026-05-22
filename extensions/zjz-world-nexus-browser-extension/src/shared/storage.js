import { DEFAULT_API_BASE_URL, STORAGE_KEYS } from "./constants.js";
import {
  readLocalStorage,
  removeLocalStorage,
  writeLocalStorage,
} from "./extension-api.js";
import { normalizeApiBaseUrl } from "./url-utils.js";

export async function readExtensionSettings() {
  const storedValues = await readLocalStorage([
    STORAGE_KEYS.apiBaseUrl,
    STORAGE_KEYS.sessionEmail,
    STORAGE_KEYS.sessionToken,
  ]);
  return {
    apiBaseUrl: normalizeApiBaseUrl(storedValues[STORAGE_KEYS.apiBaseUrl] ?? DEFAULT_API_BASE_URL),
    sessionEmail: String(storedValues[STORAGE_KEYS.sessionEmail] ?? "").trim(),
    sessionToken: String(storedValues[STORAGE_KEYS.sessionToken] ?? "").trim(),
  };
}

export async function writeApiBaseUrl(apiBaseUrl) {
  const normalizedApiBaseUrl = normalizeApiBaseUrl(apiBaseUrl);
  await writeLocalStorage({
    [STORAGE_KEYS.apiBaseUrl]: normalizedApiBaseUrl,
  });
  return normalizedApiBaseUrl;
}

export async function writeSession({ email, token }) {
  await writeLocalStorage({
    [STORAGE_KEYS.sessionEmail]: String(email ?? "").trim(),
    [STORAGE_KEYS.sessionToken]: String(token ?? "").trim(),
  });
}

export async function clearSession() {
  await removeLocalStorage([
    STORAGE_KEYS.sessionEmail,
    STORAGE_KEYS.sessionToken,
  ]);
}
