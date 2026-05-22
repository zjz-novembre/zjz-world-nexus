# zjz-world-nexus-browser-extension

## Build
```bash
python3 /Users/zjz/Documents/zjz-world-nexus/build-zjz-world-nexus-browser-extension.py
```

## Output
- Chrome extension root: `/Users/zjz/Documents/zjz-world-nexus/dist/zjz-world-nexus-browser-extension/chrome`
- Chrome Web Store zip: `/Users/zjz/Documents/zjz-world-nexus/dist/zjz-world-nexus-browser-extension/chrome-web-store/zjz-world-nexus-browser-extension.zip`
- Safari web extension source: `/Users/zjz/Documents/zjz-world-nexus/dist/zjz-world-nexus-browser-extension/web-extension`
- Safari web extension zip: `/Users/zjz/Documents/zjz-world-nexus/dist/zjz-world-nexus-browser-extension/safari-web-extension/zjz-world-nexus-safari-web-extension.zip`

## Chrome Web Store
1. Build the extension zip.
2. Open the Chrome Developer Dashboard.
3. Upload `/Users/zjz/Documents/zjz-world-nexus/dist/zjz-world-nexus-browser-extension/chrome-web-store/zjz-world-nexus-browser-extension.zip`.
4. Complete listing, privacy, and review details.
5. Submit for review.

Chrome Web Store assets:
- `/Users/zjz/Documents/zjz-world-nexus/extensions/zjz-world-nexus-browser-extension/chrome-web-store-assets/listing-copy.md`
- `/Users/zjz/Documents/zjz-world-nexus/extensions/zjz-world-nexus-browser-extension/chrome-web-store-assets/privacy-policy.md`
- `/Users/zjz/Documents/zjz-world-nexus/extensions/zjz-world-nexus-browser-extension/chrome-web-store-assets/test-instructions.md`
- `/Users/zjz/Documents/zjz-world-nexus/extensions/zjz-world-nexus-browser-extension/chrome-web-store-assets/release-readiness.md`

Programmatic publish for an existing item:
```bash
CWS_CLIENT_ID=... \
CWS_CLIENT_SECRET=... \
CWS_REFRESH_TOKEN=... \
CWS_PUBLISHER_ID=... \
CWS_EXTENSION_ID=... \
python3 /Users/zjz/Documents/zjz-world-nexus/extensions/zjz-world-nexus-browser-extension/publish-chrome-web-store-item.py
```

Reference:
- https://developer.chrome.com/docs/webstore/publish/
- https://developer.chrome.com/docs/extensions/develop/migrate/publish-mv3

## Safari App Store
1. Build the web extension source.
2. Run `/Users/zjz/Documents/zjz-world-nexus/extensions/zjz-world-nexus-browser-extension/package-safari-web-extension.sh`.
3. Open the generated Xcode project.
4. Archive the containing app and upload it to App Store Connect.
5. Submit in App Store Connect.

Reference:
- https://developer.apple.com/documentation/safariservices/packaging-a-web-extension-for-safari
- https://developer.apple.com/documentation/safariservices/distributing-your-safari-web-extension
- https://developer.apple.com/documentation/safariservices/packaging-and-distributing-safari-web-extensions-with-app-store-connect
