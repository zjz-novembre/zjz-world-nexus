# Nexus Chrome Web Store Release Readiness

Prepared on 2026-04-19.

## Ready in code

- Manifest V3 package builds successfully.
- Extension icons are generated from `public/shared/icons/zjz.svg` into the required PNG sizes.
- Chrome Web Store upload zip is built at:
  `/Users/zjz/Documents/zjz-world-nexus/dist/zjz-world-nexus-browser-extension/chrome-web-store/zjz-world-nexus-browser-extension.zip`
- Extension version is `0.1.1`.
- Background, popup, options, content script, and shared modules pass JavaScript syntax checks.

## Still required before first public submission

- Chrome Web Store developer account with 2-step verification enabled
- Store listing fields completed
- Privacy fields completed
- Public privacy policy URL
- Review test instructions entered in the dashboard
- Publisher credentials if publishing through the API

## Official references

- Chrome Web Store first-time publish:
  https://developer.chrome.com/docs/webstore/publish/
- Chrome Web Store API:
  https://developer.chrome.com/docs/webstore/using-api
- Extension icons:
  https://developer.chrome.com/docs/extensions/develop/ui/configure-icons
- User data policy:
  https://developer.chrome.com/docs/webstore/program-policies/user-data-faq
- Program policies:
  https://developer.chrome.com/docs/webstore/program-policies/policies
