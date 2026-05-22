import { normalizeApiBaseUrl } from "./url-utils.js";

function buildApiUrl(pathname, apiBaseUrl) {
  const normalizedApiBaseUrl = normalizeApiBaseUrl(apiBaseUrl);
  const normalizedPathname = String(pathname ?? "").startsWith("/")
    ? String(pathname)
    : `/${String(pathname ?? "")}`;
  return `${normalizedApiBaseUrl}${normalizedPathname}`;
}

async function requestJson(pathname, { apiBaseUrl, body, method = "GET", token = "" } = {}) {
  const headers = new Headers();
  headers.set("accept", "application/json");
  if (body !== undefined) {
    headers.set("content-type", "application/json");
  }
  if (token) {
    headers.set("x-session-token", String(token).trim());
  }
  const response = await fetch(buildApiUrl(pathname, apiBaseUrl), {
    body: body === undefined ? undefined : JSON.stringify(body),
    credentials: "omit",
    headers,
    method,
  });
  const payload = await response.json().catch(() => null);
  if (!response.ok || payload?.ok === false) {
    throw new Error(payload?.error ?? "Request failed.");
  }
  return payload?.data ?? payload;
}

export async function login({ apiBaseUrl, email, password }) {
  return requestJson("/api/auth/login", {
    apiBaseUrl,
    body: {
      email: String(email ?? "").trim(),
      password: String(password ?? ""),
    },
    method: "POST",
  });
}

export async function register({ apiBaseUrl, email, password }) {
  return requestJson("/api/auth/register", {
    apiBaseUrl,
    body: {
      email: String(email ?? "").trim(),
      password: String(password ?? ""),
    },
    method: "POST",
  });
}

export async function logout({ apiBaseUrl, token }) {
  return requestJson("/api/auth/logout", {
    apiBaseUrl,
    method: "POST",
    token,
  });
}

export async function readSession({ apiBaseUrl, token }) {
  return requestJson("/api/session", {
    apiBaseUrl,
    method: "GET",
    token,
  });
}

export async function readPasswordMatches({ apiBaseUrl, origin, token }) {
  const query = new URLSearchParams({
    origin: String(origin ?? "").trim(),
  });
  return requestJson(`/api/nexus/password-matches?${query.toString()}`, {
    apiBaseUrl,
    method: "GET",
    token,
  });
}

export async function readResourceItems({ apiBaseUrl, resourceId, token }) {
  const query = new URLSearchParams({
    resource: String(resourceId ?? "").trim(),
  });
  return requestJson(`/api/nexus/items?${query.toString()}`, {
    apiBaseUrl,
    method: "GET",
    token,
  });
}
