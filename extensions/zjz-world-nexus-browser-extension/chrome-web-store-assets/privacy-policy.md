# Nexus Browser Extension Privacy Policy

Effective date: 2026-04-19

Nexus is a browser extension that lets you access, copy, and autofill credentials and payment details stored in your Nexus account.

## What Nexus collects and uses

Nexus processes the following data in order to provide its core functionality:

- account email address
- session token issued after sign-in
- the active tab origin and host needed to match saved credentials with the current site
- vault data requested from your Nexus account, including passwords, API keys, cards, and recurring billing records

Nexus uses this data only to:

- authenticate you with your Nexus account
- retrieve your vault records from the Nexus service
- match saved credentials against the current site
- autofill supported sign-in and payment forms when you trigger autofill
- copy selected values to your clipboard when you click them

## What Nexus stores locally

Nexus stores the following values in browser extension storage:

- API base URL
- session email
- session token

Nexus also uses short-lived in-memory caches inside the extension background service worker to reduce popup latency and repeated network requests.

## What Nexus sends to the Nexus service

Nexus sends data to `https://zjz.world/nexus` over HTTPS, including:

- sign-in and registration requests
- session validation requests
- vault item requests
- active site origin requests used for password matching
- site icon requests used to display brand icons in the popup

Nexus does not send full browsing history. It uses the current active site origin and host only as needed to match saved items with the page you are on.

## Clipboard and autofill

When you click a copyable value in the popup, Nexus writes that selected value to your clipboard.

When you trigger autofill, Nexus fills supported form fields on the current page locally in your browser. Form field detection and filling happen in the extension content script on the page.

## Sharing

Nexus does not sell your data.

Nexus does not use your data for advertising.

Nexus does not transfer your data to third parties except when required to operate the Nexus service, comply with law, or protect the security and integrity of the service.

## Security

Nexus transmits service requests over HTTPS.

You are responsible for protecting access to your browser profile and device. If you sign out, Nexus removes the stored session email and session token from extension storage.

## Contact

Support: https://zjz.world/nexus
