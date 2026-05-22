# Nexus Chrome Web Store Listing Copy

## Name
Nexus

## Summary
Compact access to passwords, API keys, cards, and recurring billing details from your Nexus vault.

## Description
Nexus brings your vault into a fast Chrome popup and inline autofill flow.

Use Nexus to:

- sign in to your Nexus account
- view passwords, API keys, cards, and recurring records
- copy values directly from the popup
- autofill supported sign-in and card forms on matching sites
- jump from the extension to Nexus on the web

Nexus is designed for a compact workflow:

- a lightweight popup optimized for quick lookup
- low-latency background caching for active-tab matches
- direct copy interactions without extra copy buttons
- focused autofill for passwords and payment fields

## Category
Productivity

## Single Purpose
Nexus helps users securely access, copy, and autofill credentials and payment details stored in their Nexus vault.

## Permission Notes
- `storage`: stores the API base URL, session email, and session token locally in the extension
- `tabs`: reads the active tab URL so Nexus can match the current site with saved vault entries
- `scripting`: ensures the content script is available on the active page for autofill
- `clipboardWrite`: copies selected vault values when the user clicks them
- `http://*/*`, `https://*/*`: allows Nexus to detect and autofill supported fields on sites the user visits
