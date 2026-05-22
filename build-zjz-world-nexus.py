#!/usr/bin/env python3
from __future__ import annotations

import base64
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
SRC_ROOT = ROOT / "src"
PUBLIC_ROOT = ROOT / "public"
OUTPUT_PATH = ROOT / "cloudflare" / "zjz-world-nexus-web" / "worker.js"
BASE_PATH = "/nexus"
WORKER_NAME = "zjz-world-nexus-web"

STATIC_ASSET_PATHS = {
    "/index.html": SRC_ROOT / "index.html",
    "/assets/nexus-web.css": SRC_ROOT / "assets" / "nexus-web.css",
    "/assets/nexus-web.js": SRC_ROOT / "assets" / "nexus-web.js",
}

WORKER_TEMPLATE = """const BASE_PATH = "__BASE_PATH__";
const WORKER_NAME = "__WORKER_NAME__";
const ASSETS = __ASSETS__;
const AUTH_COOKIE_NAME = "zjz_world_session";

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
  return getCookieValue(request, cookieName) || undefined;
}

function normalizeEmail(value) {
  return String(value ?? "").trim().toLowerCase();
}

function readAccessEmail(request) {
  return normalizeEmail(request.headers.get("cf-access-authenticated-user-email"));
}

function createLogger(service) {
  return {
    info(event, fields = {}) {
      console.log(
        JSON.stringify({
          ts: new Date().toISOString(),
          level: "info",
          event,
          service,
          ...fields,
        }),
      );
    },
    error(event, fields = {}) {
      console.error(
        JSON.stringify({
          ts: new Date().toISOString(),
          level: "error",
          event,
          service,
          ...fields,
        }),
      );
    },
  };
}

async function withRequestLogging(logger, request, handler) {
  const startedAt = Date.now();
  const requestId = request.headers.get("cf-ray")?.trim() || crypto.randomUUID();
  try {
    const response = await handler();
    logger.info("request", {
      duration_ms: Date.now() - startedAt,
      method: request.method,
      path: new URL(request.url).pathname,
      request_id: requestId,
      status: response.status,
    });
    return response;
  } catch (error) {
    logger.error("request_error", {
      duration_ms: Date.now() - startedAt,
      error: error instanceof Error ? { message: error.message, stack: error.stack } : error,
      method: request.method,
      path: new URL(request.url).pathname,
      request_id: requestId,
    });
    throw error;
  }
}

function buildJsonHeaders(headersInit = {}) {
  const headers = new Headers(headersInit);
  headers.set("content-type", "application/json; charset=utf-8");
  headers.set("cache-control", "no-store");
  return headers;
}

function json(payload, init = {}) {
  return new Response(JSON.stringify(payload), {
    ...init,
    headers: buildJsonHeaders(init.headers),
  });
}

function ok(data = null, init = {}) {
  return json({ ok: true, data }, init);
}

function associatedAppIds(env) {
  const explicit = String(env?.NEXUS_APPLE_ASSOCIATED_APP_IDS || "")
    .split(",")
    .map((value) => value.trim())
    .filter(Boolean);
  if (explicit.length > 0) {
    return explicit;
  }
  const teamId = String(env?.NEXUS_APPLE_TEAM_ID || "").trim();
  if (!teamId) {
    return [];
  }
  const bundleIds = String(
    env?.NEXUS_APPLE_BUNDLE_IDS || "one.zjz.nexus.ios,one.zjz.nexus.macos",
  )
    .split(",")
    .map((value) => value.trim())
    .filter(Boolean);
  return bundleIds.map((bundleId) => `${teamId}.${bundleId}`);
}

function handleAppleAppSiteAssociation(request, env) {
  if (request.method !== "GET" && request.method !== "HEAD") {
    return methodNotAllowed();
  }
  const apps = associatedAppIds(env);
  const payload = {
    webcredentials: { apps },
    applinks: {
      details: apps.map((appID) => ({
        appIDs: [appID],
        components: [{ "/": "/*" }],
      })),
    },
  };
  const headers = new Headers();
  headers.set("content-type", "application/json; charset=utf-8");
  headers.set("cache-control", "no-store");
  headers.set("x-nexus-worker", WORKER_NAME);
  return new Response(request.method === "HEAD" ? null : JSON.stringify(payload), {
    headers,
  });
}

function fail(error, status = 400, init = {}) {
  return json(
    { ok: false, error: String(error || "Request failed.") },
    {
      ...init,
      status,
    },
  );
}

function methodNotAllowed(message = "Method not allowed.") {
  return fail(message, 405);
}

function notFound(message = "Not found.") {
  return fail(message, 404);
}

function getBinding(env, bindingName) {
  const binding = env?.[bindingName];
  if (!binding || typeof binding.fetch !== "function") {
    throw new Error(`${bindingName} binding is not configured.`);
  }
  return binding;
}

function stripBasePath(pathname, basePath) {
  if (pathname === basePath) {
    return "/";
  }
  if (pathname.startsWith(`${basePath}/`)) {
    const stripped = pathname.slice(basePath.length);
    return stripped === "" ? "/" : stripped;
  }
  return null;
}

function redirectToBasePath(requestUrl, basePath) {
  const nextUrl = new URL(requestUrl.toString());
  nextUrl.pathname = `${basePath}/`;
  return Response.redirect(nextUrl.toString(), 308);
}

function decodeBase64(base64) {
  const binary = atob(base64);
  const bytes = new Uint8Array(binary.length);
  for (let index = 0; index < binary.length; index += 1) {
    bytes[index] = binary.charCodeAt(index);
  }
  return bytes;
}

function buildAssetResponse(asset, method) {
  const headers = new Headers();
  headers.set("content-type", asset.contentType);
  headers.set("cache-control", "no-store");
  headers.set("x-nexus-worker", WORKER_NAME);
  if (method === "HEAD") {
    return new Response(null, { status: 200, headers });
  }
  const body = asset.bodyBase64 ? decodeBase64(asset.bodyBase64) : asset.body;
  return new Response(body, { status: 200, headers });
}

function serveAsset(pathname, method, fallbackPath = "/index.html") {
  const assetPath = pathname === "/" ? fallbackPath : pathname;
  const asset = ASSETS[assetPath] || (!assetPath.includes(".") ? ASSETS[fallbackPath] : null);
  if (!asset) {
    return new Response("Not found", { status: 404 });
  }
  return buildAssetResponse(asset, method);
}

function cloneUpstreamHeaders(request) {
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
  return headers;
}

function withSetCookie(headersInit, upstreamResponse) {
  const headers = new Headers(headersInit || {});
  const setCookie = upstreamResponse.headers.get("set-cookie");
  if (setCookie) {
    headers.set("set-cookie", setCookie);
  }
  return headers;
}

async function callBindingFetch(binding, request, pathname, init = {}) {
  const headers = cloneUpstreamHeaders(request);
  for (const [name, value] of new Headers(init.headers || {}).entries()) {
    headers.set(name, value);
  }
  const response = await binding.fetch(
    new Request(`https://internal${pathname}`, {
      method: init.method || request.method,
      headers,
      body: init.body,
    }),
  );
  const contentType = response.headers.get("content-type") || "";
  if (contentType.includes("application/json")) {
    const payload = await response.clone().json().catch(() => null);
    return { payload, response };
  }
  return { payload: null, response };
}

async function callUniversalAuth(request, env, pathname, init = {}) {
  return callBindingFetch(getBinding(env, "UNIVERSAL_AUTH"), request, pathname, init);
}

async function proxyBindingResponse(binding, request, pathname, init = {}) {
  const headers = cloneUpstreamHeaders(request);
  for (const [name, value] of new Headers(init.headers || {}).entries()) {
    headers.set(name, value);
  }
  return binding.fetch(
    new Request(`https://internal${pathname}`, {
      method: init.method || request.method,
      headers,
      body: init.body,
    }),
  );
}

function normalizeSessionPayload(payload) {
  const session =
    payload?.session && typeof payload.session === "object"
      ? payload.session
      : { authenticated: false };
  const authenticated = Boolean(payload?.authenticated || session?.authenticated);
  return {
    authenticated,
    email: session?.email || "",
    session,
    token: payload?.token || null,
    unlocked: authenticated,
  };
}

async function handleSessionApi(request, env) {
  if (request.method.toUpperCase() !== "GET") {
    return methodNotAllowed();
  }
  const accessEmail = normalizeEmail(readAccessEmail(request));
  if (accessEmail) {
    return ok({
      authenticated: true,
      email: accessEmail,
      session: {
        authenticated: true,
        email: accessEmail,
        source: "cloudflare-access",
        verified_at: null,
      },
      token: null,
      unlocked: true,
    });
  }
  const { payload, response } = await callUniversalAuth(request, env, "/api/session", {
    method: "GET",
  });
  const headers = withSetCookie(null, response);
  if (!response.ok || payload?.ok === false) {
    return ok(
      {
        authenticated: false,
        email: "",
        session: { authenticated: false },
        token: null,
        unlocked: false,
      },
      { headers },
    );
  }
  return ok(normalizeSessionPayload(payload), { headers });
}

async function handleAuthApi(request, env, pathname) {
  const method = request.method.toUpperCase();
  if (pathname === "/api/auth/login" || pathname === "/api/auth/register") {
    if (method !== "POST") {
      return methodNotAllowed();
    }
    const upstreamPath = pathname === "/api/auth/register" ? "/api/register" : "/api/login";
    const { payload, response } = await callUniversalAuth(request, env, upstreamPath, {
      method: "POST",
      body: await request.text(),
    });
    const headers = withSetCookie(null, response);
    if (!response.ok || payload?.ok === false) {
      return fail(payload?.error || "Authentication failed.", response.status || 502, {
        headers,
      });
    }
    return ok(normalizeSessionPayload(payload), {
      headers,
      status: response.status,
    });
  }
  if (pathname === "/api/auth/logout") {
    if (method !== "POST") {
      return methodNotAllowed();
    }
    const { payload, response } = await callUniversalAuth(request, env, "/api/logout", {
      method: "POST",
    });
    const headers = withSetCookie(null, response);
    if (!response.ok || payload?.ok === false) {
      return fail(payload?.error || "Logout failed.", response.status || 502, {
        headers,
      });
    }
    return ok(normalizeSessionPayload(payload), { headers });
  }
  if (pathname === "/api/auth/session") {
    return handleSessionApi(request, env);
  }
  return null;
}

async function handleProfileApi(request, env) {
  const method = request.method.toUpperCase();
  if (method !== "GET" && method !== "PATCH" && method !== "PUT" && method !== "DELETE") {
    return methodNotAllowed();
  }
  const { payload, response } = await callUniversalAuth(request, env, "/api/profile", {
    method,
    body: method === "GET" || method === "DELETE" ? undefined : await request.text(),
  });
  const headers = withSetCookie(null, response);
  if (!response.ok || payload?.ok === false) {
    return fail(payload?.error || "Profile request failed.", response.status || 502, {
      headers,
    });
  }
  if (method === "DELETE") {
    return ok(
      {
        authenticated: false,
        deleted: true,
        email: payload?.email ?? "",
        session: { authenticated: false },
        token: null,
        unlocked: false,
      },
      { headers },
    );
  }
  return ok(payload?.profile ?? {}, { headers });
}

function passthroughResponse(upstreamResponse) {
  const headers = new Headers(upstreamResponse.headers);
  return new Response(upstreamResponse.body, {
    headers,
    status: upstreamResponse.status,
    statusText: upstreamResponse.statusText,
  });
}

async function handleDataApi(request, env, requestPath) {
  const response = await proxyBindingResponse(getBinding(env, "NEXUS_DATA"), request, requestPath, {
    method: request.method,
    body: request.method === "GET" || request.method === "HEAD" ? undefined : await request.text(),
  });
  return passthroughResponse(response);
}

const logger = createLogger("nexus-web");

export default {
  async fetch(request, env) {
    return withRequestLogging(logger, request, async () => {
      const url = new URL(request.url);
      if (
        url.pathname === "/.well-known/apple-app-site-association" ||
        url.pathname === "/apple-app-site-association"
      ) {
        return handleAppleAppSiteAssociation(request, env);
      }
      const pathname = stripBasePath(url.pathname, BASE_PATH);
      if (!pathname) {
        return notFound();
      }
      if (pathname === "/" && !url.pathname.endsWith("/")) {
        return redirectToBasePath(url, BASE_PATH);
      }
      if (pathname === "/index.html") {
        return redirectToBasePath(url, BASE_PATH);
      }
      if (pathname.startsWith("/api/")) {
        if (pathname === "/api/session") {
          return handleSessionApi(request, env);
        }
        if (pathname.startsWith("/api/auth/")) {
          const authResponse = await handleAuthApi(request, env, pathname);
          return authResponse || notFound();
        }
        if (pathname === "/api/profile") {
          return handleProfileApi(request, env);
        }
        if (pathname.startsWith("/api/nexus/") || pathname.startsWith("/api/site-icons/")) {
          const requestPath = `${pathname}${url.search || ""}`;
          return handleDataApi(request, env, requestPath);
        }
        return notFound();
      }
      if (request.method !== "GET" && request.method !== "HEAD") {
        return methodNotAllowed();
      }
      return serveAsset(pathname, request.method);
    });
  },
};
"""


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def read_base64(path: Path) -> str:
    return base64.b64encode(path.read_bytes()).decode("ascii")


def detect_content_type(path: Path) -> str:
    suffix = path.suffix.lower()

    if suffix == ".html":
        return "text/html; charset=utf-8"
    if suffix == ".css":
        return "text/css; charset=utf-8"
    if suffix == ".js":
        return "application/javascript; charset=utf-8"
    if suffix == ".svg":
        return "image/svg+xml; charset=utf-8"
    if suffix == ".png":
        return "image/png"
    if suffix == ".woff2":
        return "font/woff2"

    raise ValueError(f"Unsupported asset type: {path}")


def build_asset_payload(path: Path) -> dict[str, str]:
    content_type = detect_content_type(path)

    if path.suffix.lower() in {".woff2", ".png"}:
        return {
            "contentType": content_type,
            "bodyBase64": read_base64(path),
        }

    return {
        "contentType": content_type,
        "body": read_text(path),
    }


def collect_assets() -> dict[str, dict[str, str]]:
    assets: dict[str, dict[str, str]] = {}

    for asset_path, source_path in STATIC_ASSET_PATHS.items():
        assets[asset_path] = build_asset_payload(source_path)

    for path in sorted(PUBLIC_ROOT.rglob("*")):
        if not path.is_file():
            continue
        if any(part.startswith(".") for part in path.relative_to(PUBLIC_ROOT).parts):
            continue

        asset_path = "/" + path.relative_to(PUBLIC_ROOT).as_posix()
        assets[asset_path] = build_asset_payload(path)

    return assets


def build_worker_source(assets: dict[str, dict[str, str]]) -> str:
    return (
        WORKER_TEMPLATE.replace("__BASE_PATH__", BASE_PATH)
        .replace("__WORKER_NAME__", WORKER_NAME)
        .replace("__ASSETS__", json.dumps(assets, ensure_ascii=False))
    )


def main() -> None:
    assets = collect_assets()
    OUTPUT_PATH.write_text(build_worker_source(assets), encoding="utf-8")
    print(f"built {OUTPUT_PATH}")


if __name__ == "__main__":
    main()
