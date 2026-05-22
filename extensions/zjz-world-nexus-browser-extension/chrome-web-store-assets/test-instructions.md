# Nexus Chrome Web Store Test Instructions

## Test account

Use a valid Nexus account with at least:

- one password item that matches a test website
- one API key item
- one payment card item
- one recurring billing item

## Core test flow

1. Install the extension and pin it to the Chrome toolbar.
2. Open the popup.
3. Sign in with the Nexus account.
4. Confirm the popup loads the four resource sections:
   - Passwords
   - API Keys
   - Cards
   - Recurrings

## Password flow

1. Open a website that has a saved password match in the test account.
2. Open the popup.
3. Confirm the matching password appears in the Passwords section.
4. Click the username value and confirm it copies.
5. Click the password row and confirm autofill runs on the page.

## API key flow

1. Open the API Keys section.
2. Confirm the key value is visible.
3. Click the key value and confirm it copies.

## Card flow

1. Open a payment form with standard card fields.
2. Open the Cards section.
3. Click the card row.
4. Confirm supported card fields are autofilled on the page.
5. Click the card number, expiry, and CVV values individually and confirm each copies.

## Recurrings flow

1. Open the Recurrings section.
2. Confirm recurring items load and show active status.

## Sign-out flow

1. Click the sign-out button in the left rail.
2. Confirm the popup returns to the sign-in screen.
