#!/usr/bin/env python3
from __future__ import annotations

import json
import os
import pathlib
import sys
import urllib.error
import urllib.parse
import urllib.request


ROOT = pathlib.Path(__file__).resolve().parents[2]
DEFAULT_ZIP_PATH = (
    ROOT
    / "dist"
    / "zjz-world-nexus-browser-extension"
    / "chrome-web-store"
    / "zjz-world-nexus-browser-extension.zip"
)

REQUIRED_ENVIRONMENT_KEYS = (
    "CWS_CLIENT_ID",
    "CWS_CLIENT_SECRET",
    "CWS_REFRESH_TOKEN",
    "CWS_PUBLISHER_ID",
    "CWS_EXTENSION_ID",
)


def read_environment() -> dict[str, str]:
    values = {key: os.environ.get(key, "").strip() for key in REQUIRED_ENVIRONMENT_KEYS}
    missing_keys = [key for key, value in values.items() if not value]
    if missing_keys:
        raise SystemExit(
            "Missing required environment variables: "
            + ", ".join(missing_keys)
            + ".\n"
            + "Required for Chrome Web Store API upload and publish."
        )
    zip_path = pathlib.Path(os.environ.get("CWS_ZIP_PATH", "")).expanduser() if os.environ.get("CWS_ZIP_PATH") else DEFAULT_ZIP_PATH
    if not zip_path.exists():
        raise SystemExit(f"Extension zip not found: {zip_path}")
    values["CWS_ZIP_PATH"] = str(zip_path)
    return values


def request_json(url: str, *, data: bytes | None = None, headers: dict[str, str] | None = None, method: str = "GET") -> dict:
    request = urllib.request.Request(url=url, data=data, headers=headers or {}, method=method)
    try:
        with urllib.request.urlopen(request) as response:
            raw_body = response.read().decode("utf-8")
    except urllib.error.HTTPError as error:
        error_body = error.read().decode("utf-8", errors="replace")
        raise SystemExit(f"HTTP {error.code} for {url}\n{error_body}") from error
    return json.loads(raw_body) if raw_body else {}


def request_bytes(url: str, *, data: bytes, headers: dict[str, str], method: str = "POST") -> dict:
    request = urllib.request.Request(url=url, data=data, headers=headers, method=method)
    try:
        with urllib.request.urlopen(request) as response:
            raw_body = response.read().decode("utf-8")
    except urllib.error.HTTPError as error:
        error_body = error.read().decode("utf-8", errors="replace")
        raise SystemExit(f"HTTP {error.code} for {url}\n{error_body}") from error
    return json.loads(raw_body) if raw_body else {}


def refresh_access_token(client_id: str, client_secret: str, refresh_token: str) -> str:
    payload = urllib.parse.urlencode(
        {
            "client_id": client_id,
            "client_secret": client_secret,
            "refresh_token": refresh_token,
            "grant_type": "refresh_token",
        }
    ).encode("utf-8")
    response = request_json(
        "https://oauth2.googleapis.com/token",
        data=payload,
        headers={"Content-Type": "application/x-www-form-urlencoded"},
        method="POST",
    )
    access_token = str(response.get("access_token", "")).strip()
    if not access_token:
        raise SystemExit(f"Unable to refresh access token.\n{json.dumps(response, indent=2)}")
    return access_token


def upload_package(access_token: str, publisher_id: str, extension_id: str, zip_path: pathlib.Path) -> dict:
    upload_url = (
        "https://chromewebstore.googleapis.com/upload/v2/publishers/"
        f"{publisher_id}/items/{extension_id}:upload"
    )
    return request_bytes(
        upload_url,
        data=zip_path.read_bytes(),
        headers={
            "Authorization": f"Bearer {access_token}",
            "Content-Type": "application/zip",
        },
        method="POST",
    )


def publish_item(access_token: str, publisher_id: str, extension_id: str) -> dict:
    publish_url = (
        "https://chromewebstore.googleapis.com/v2/publishers/"
        f"{publisher_id}/items/{extension_id}:publish"
    )
    return request_json(
        publish_url,
        data=b"",
        headers={"Authorization": f"Bearer {access_token}"},
        method="POST",
    )


def main() -> None:
    environment = read_environment()
    zip_path = pathlib.Path(environment["CWS_ZIP_PATH"])
    access_token = refresh_access_token(
        environment["CWS_CLIENT_ID"],
        environment["CWS_CLIENT_SECRET"],
        environment["CWS_REFRESH_TOKEN"],
    )
    upload_response = upload_package(
        access_token,
        environment["CWS_PUBLISHER_ID"],
        environment["CWS_EXTENSION_ID"],
        zip_path,
    )
    print("Upload response:")
    print(json.dumps(upload_response, indent=2))
    upload_state = str(upload_response.get("uploadState", "")).strip()
    if upload_state not in {"SUCCEEDED", "IN_PROGRESS"}:
        raise SystemExit("Upload did not succeed. Aborting before publish.")

    publish_response = publish_item(
        access_token,
        environment["CWS_PUBLISHER_ID"],
        environment["CWS_EXTENSION_ID"],
    )
    print("Publish response:")
    print(json.dumps(publish_response, indent=2))


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(130)
