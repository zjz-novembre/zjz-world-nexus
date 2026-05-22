import { DEFAULT_API_BASE_URL } from "./constants.js";

const WEBSITE_PROTOCOL_RE = /^[a-z][a-z0-9+.-]*:\/\//i;

export function normalizeApiBaseUrl(value) {
  const trimmedValue = String(value ?? "").trim();
  const candidate = trimmedValue || DEFAULT_API_BASE_URL;
  const normalizedCandidate = candidate.endsWith("/") ? candidate.slice(0, -1) : candidate;
  const parsedUrl = new URL(normalizedCandidate);
  if (parsedUrl.protocol !== "http:" && parsedUrl.protocol !== "https:") {
    throw new Error("Server must use HTTP or HTTPS.");
  }
  return parsedUrl.toString().replace(/\/$/, "");
}

export function normalizeWebsiteUrl(value) {
  const trimmedValue = String(value ?? "").trim();
  if (!trimmedValue) {
    return null;
  }
  const candidate = WEBSITE_PROTOCOL_RE.test(trimmedValue) ? trimmedValue : `https://${trimmedValue}`;
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

export function normalizeWebsiteHost(value) {
  const normalizedUrl = normalizeWebsiteUrl(value);
  if (!normalizedUrl) {
    return "";
  }
  return normalizedUrl.hostname.replace(/^www\./, "").toLowerCase();
}

export function normalizeLookupOrigin(value) {
  const normalizedUrl = normalizeWebsiteUrl(value);
  return normalizedUrl ? normalizedUrl.origin : "";
}

export function isHttpLikeUrl(value) {
  return Boolean(normalizeWebsiteUrl(value));
}
