(function bootstrapNexusContentScript() {
  const runtimeApi = globalThis.browser ?? globalThis.chrome;
  const DETECT_FILL_TARGET = "nexus:detect-fill-target";
  const FILL_CREDENTIAL = "nexus:fill-credential";
  const READ_AUTO_FILL_CREDENTIAL = "nexus:read-auto-fill-credential";
  const AUTO_FILL_DELAY_MS = 80;
  const HIGHLIGHT_STYLE_ID = "nexus-autofill-highlight-style";
  const HIGHLIGHT_CLASS_NAME = "nexus-autofilled-field";

  let autoFillTimeoutId = 0;

  function ensureHighlightStyles() {
    if (document.getElementById(HIGHLIGHT_STYLE_ID)) {
      return;
    }
    const styleElement = document.createElement("style");
    styleElement.id = HIGHLIGHT_STYLE_ID;
    styleElement.textContent = `
      .${HIGHLIGHT_CLASS_NAME} {
        background-color: rgba(255, 232, 115, 0.26) !important;
        border-color: rgba(216, 176, 0, 0.9) !important;
        box-shadow: inset 0 0 0 999px rgba(255, 232, 115, 0.18) !important;
        transition:
          background-color 180ms ease,
          box-shadow 180ms ease,
          border-color 180ms ease !important;
      }
    `;
    document.head.append(styleElement);
  }

  function isVisible(element) {
    if (!(element instanceof HTMLElement)) {
      return false;
    }
    const style = window.getComputedStyle(element);
    if (style.display === "none" || style.visibility === "hidden") {
      return false;
    }
    const rect = element.getBoundingClientRect();
    return rect.width > 0 && rect.height > 0;
  }

  function isEditableInput(element) {
    return (
      element instanceof HTMLInputElement &&
      !element.disabled &&
      !element.readOnly &&
      isVisible(element)
    );
  }

  function isEditableSelect(element) {
    return element instanceof HTMLSelectElement && !element.disabled && isVisible(element);
  }

  function isEditableField(element) {
    return isEditableInput(element) || isEditableSelect(element);
  }

  function getAutocompleteTokens(element) {
    return String(element?.getAttribute("autocomplete") ?? "")
      .toLowerCase()
      .trim()
      .split(/\s+/)
      .filter(Boolean);
  }

  function hasAutocompleteToken(element, token) {
    return getAutocompleteTokens(element).includes(String(token ?? "").toLowerCase());
  }

  function isPasswordInput(element) {
    return isEditableInput(element) && element.type === "password";
  }

  function isBefore(referenceElement, candidateElement) {
    const position = referenceElement.compareDocumentPosition(candidateElement);
    return Boolean(position & Node.DOCUMENT_POSITION_PRECEDING);
  }

  function isExplicitUsernameInput(element) {
    if (!isEditableInput(element)) {
      return false;
    }
    return hasAutocompleteToken(element, "username") || hasAutocompleteToken(element, "email");
  }

  function isCompatibleUsernameInput(element) {
    if (!isEditableInput(element)) {
      return false;
    }
    const inputType = String(element.type ?? "").toLowerCase();
    if (inputType === "hidden" || inputType === "password") {
      return false;
    }
    return inputType === "email" || inputType === "text" || inputType === "search";
  }

  function pickPasswordField(scopeRoot) {
    const passwordFields = Array.from(scopeRoot.querySelectorAll('input[type="password"]')).filter(
      isPasswordInput,
    );
    return passwordFields[0] ?? null;
  }

  function resolvePasswordFillScopeFromElement(activeElement) {
    if (activeElement instanceof HTMLElement) {
      const activeForm = activeElement.closest("form");
      if (activeForm) {
        const activeFormPasswordField = pickPasswordField(activeForm);
        if (activeFormPasswordField) {
          return {
            passwordField: activeFormPasswordField,
            scopeRoot: activeForm,
            source: "active-password-form",
          };
        }
      }
      if (isPasswordInput(activeElement)) {
        return {
          passwordField: activeElement,
          scopeRoot: document,
          source: "active-password-field",
        };
      }
    }
    const visiblePasswordFields = Array.from(document.querySelectorAll('input[type="password"]')).filter(
      isPasswordInput,
    );
    if (visiblePasswordFields.length === 1) {
      const passwordField = visiblePasswordFields[0];
      return {
        passwordField,
        scopeRoot: passwordField.form ?? document,
        source: "single-password-field",
      };
    }
    return null;
  }

  function resolvePasswordFillScope() {
    return resolvePasswordFillScopeFromElement(document.activeElement);
  }

  function pickUsernameField(scopeRoot, passwordField) {
    const explicitCandidates = Array.from(scopeRoot.querySelectorAll("input")).filter(
      isExplicitUsernameInput,
    );
    const explicitBeforePassword = explicitCandidates.filter((candidate) =>
      isBefore(passwordField, candidate),
    );
    if (explicitBeforePassword.length === 1) {
      return explicitBeforePassword[0];
    }
    if (explicitCandidates.length === 1) {
      return explicitCandidates[0];
    }
    const compatibleCandidates = Array.from(scopeRoot.querySelectorAll("input")).filter(
      isCompatibleUsernameInput,
    );
    const compatibleBeforePassword = compatibleCandidates.filter((candidate) =>
      isBefore(passwordField, candidate),
    );
    if (compatibleBeforePassword.length === 1) {
      return compatibleBeforePassword[0];
    }
    return null;
  }

  function resolveCardFields(scopeRoot) {
    const editableFields = Array.from(scopeRoot.querySelectorAll("input, select")).filter(isEditableField);
    return {
      cardNumberField: editableFields.find((field) => hasAutocompleteToken(field, "cc-number")) ?? null,
      expiryField: editableFields.find((field) => hasAutocompleteToken(field, "cc-exp")) ?? null,
      expiryMonthField: editableFields.find((field) => hasAutocompleteToken(field, "cc-exp-month")) ?? null,
      expiryYearField: editableFields.find((field) => hasAutocompleteToken(field, "cc-exp-year")) ?? null,
      securityCodeField: editableFields.find((field) => hasAutocompleteToken(field, "cc-csc")) ?? null,
    };
  }

  function hasCardFillTarget(fields) {
    return Boolean(
      fields?.cardNumberField ||
        fields?.expiryField ||
        fields?.expiryMonthField ||
        fields?.expiryYearField ||
        fields?.securityCodeField,
    );
  }

  function resolveCardFillScopeFromElement(activeElement) {
    if (activeElement instanceof HTMLElement) {
      const activeForm = activeElement.closest("form");
      if (activeForm) {
        const activeFormFields = resolveCardFields(activeForm);
        if (hasCardFillTarget(activeFormFields)) {
          return {
            fields: activeFormFields,
            scopeRoot: activeForm,
            source: "active-card-form",
          };
        }
      }
      if (isEditableField(activeElement) && getAutocompleteTokens(activeElement).some((token) => token.startsWith("cc-"))) {
        const documentFields = resolveCardFields(document);
        if (hasCardFillTarget(documentFields)) {
          return {
            fields: documentFields,
            scopeRoot: document,
            source: "active-card-field",
          };
        }
      }
    }
    const documentFields = resolveCardFields(document);
    if (hasCardFillTarget(documentFields)) {
      return {
        fields: documentFields,
        scopeRoot: document,
        source: "document-card-fields",
      };
    }
    return null;
  }

  function resolveCardFillScope() {
    return resolveCardFillScopeFromElement(document.activeElement);
  }

  function markAutofilled(field) {
    if (!(field instanceof HTMLElement)) {
      return;
    }
    ensureHighlightStyles();
    field.classList.add(HIGHLIGHT_CLASS_NAME);
  }

  function assignInputValue(input, value) {
    const nativeSetter = Object.getOwnPropertyDescriptor(
      window.HTMLInputElement.prototype,
      "value",
    )?.set;
    nativeSetter?.call(input, value);
    input.dispatchEvent(new Event("input", { bubbles: true, composed: true }));
    input.dispatchEvent(new Event("change", { bubbles: true, composed: true }));
    markAutofilled(input);
  }

  function assignSelectValue(select, candidates) {
    const normalizedCandidates = candidates
      .map((candidate) => String(candidate ?? "").trim())
      .filter(Boolean);
    if (normalizedCandidates.length === 0) {
      return false;
    }
    const optionValues = Array.from(select.options).map((option) => ({
      normalizedValue: String(option.value ?? "").trim().toLowerCase(),
      normalizedText: String(option.textContent ?? "").trim().toLowerCase(),
      value: option.value,
    }));
    const matchingOption = normalizedCandidates
      .map((candidate) => candidate.toLowerCase())
      .flatMap((candidate) => optionValues.filter((option) => option.normalizedValue === candidate || option.normalizedText === candidate))
      [0];
    if (!matchingOption) {
      return false;
    }
    select.value = matchingOption.value;
    select.dispatchEvent(new Event("input", { bubbles: true, composed: true }));
    select.dispatchEvent(new Event("change", { bubbles: true, composed: true }));
    markAutofilled(select);
    return true;
  }

  function assignFieldValue(field, candidates) {
    const normalizedCandidates = Array.isArray(candidates)
      ? candidates.map((candidate) => String(candidate ?? "").trim()).filter(Boolean)
      : [String(candidates ?? "").trim()].filter(Boolean);
    if (normalizedCandidates.length === 0 || !field) {
      return false;
    }
    if (field instanceof HTMLSelectElement) {
      return assignSelectValue(field, normalizedCandidates);
    }
    if (field instanceof HTMLInputElement) {
      assignInputValue(field, normalizedCandidates[0]);
      return true;
    }
    return false;
  }

  function isAutoFillTriggerElement(element) {
    if (!isEditableInput(element)) {
      return false;
    }
    if (String(element.type ?? "").toLowerCase() === "password") {
      return true;
    }
    const containingForm = element.closest("form");
    return Boolean(containingForm && pickPasswordField(containingForm));
  }

  function buildAutoFillScopeKey(scope) {
    const formAction = scope.passwordField.form?.getAttribute("action") ?? "";
    return [
      window.location.origin,
      window.location.pathname,
      formAction,
      scope.passwordField.name || scope.passwordField.id || "password",
    ].join("|");
  }

  function requestRuntimeMessage(message) {
    return new Promise((resolve, reject) => {
      runtimeApi.runtime.sendMessage(message, (response) => {
        const errorMessage = runtimeApi.runtime.lastError?.message ?? "";
        if (errorMessage) {
          reject(new Error(errorMessage));
          return;
        }
        if (!response?.ok) {
          reject(new Error(response?.error ?? "Runtime request failed."));
          return;
        }
        resolve(response.result);
      });
    });
  }

  function detectFillTarget() {
    const passwordScope = resolvePasswordFillScope();
    const cardScope = resolveCardFillScope();
    return {
      cardFillTargetAvailable: hasCardFillTarget(cardScope?.fields),
      fillTargetAvailable: Boolean(passwordScope?.passwordField || hasCardFillTarget(cardScope?.fields)),
      pageHost: window.location.hostname.replace(/^www\./, "").toLowerCase(),
      passwordFillTargetAvailable: Boolean(passwordScope?.passwordField),
      source: [passwordScope?.source, cardScope?.source].filter(Boolean).join("|"),
    };
  }

  function fillPasswordCredential(credential, scope = resolvePasswordFillScope()) {
    if (!scope?.passwordField) {
      throw new Error("No password field is active.");
    }
    if (!credential || typeof credential !== "object") {
      throw new Error("Credential payload is missing.");
    }
    const passwordValue = String(credential.rawSecret ?? "").trim();
    if (!passwordValue) {
      throw new Error("Password is unavailable.");
    }
    const usernameField = pickUsernameField(scope.scopeRoot, scope.passwordField);
    const usernameValue = String(credential.username ?? "").trim();
    if (usernameField && usernameValue) {
      assignInputValue(usernameField, usernameValue);
    }
    assignInputValue(scope.passwordField, passwordValue);
    scope.passwordField.dataset.nexusAutofilled = "true";
    scope.passwordField.focus();
    return {
      filled: true,
      fillKind: "password",
      usernameFilled: Boolean(usernameField && usernameValue),
    };
  }

  function parseExpiryParts(value) {
    const rawValue = String(value ?? "").trim();
    if (!rawValue) {
      return null;
    }
    const normalizedValue = rawValue.replace(/\s+/g, "");
    const slashMatch = normalizedValue.match(/^(\d{2})\/(\d{2}|\d{4})$/);
    if (slashMatch) {
      const month = slashMatch[1];
      const year = slashMatch[2].length === 2 ? `20${slashMatch[2]}` : slashMatch[2];
      return {
        monthNumeric: String(Number(month)),
        monthTwoDigit: month,
        yearFourDigit: year,
        yearTwoDigit: year.slice(-2),
      };
    }
    const digitValue = normalizedValue.replace(/\D/g, "");
    if (digitValue.length === 4) {
      return {
        monthNumeric: String(Number(digitValue.slice(0, 2))),
        monthTwoDigit: digitValue.slice(0, 2),
        yearFourDigit: `20${digitValue.slice(2)}`,
        yearTwoDigit: digitValue.slice(2),
      };
    }
    if (digitValue.length === 6) {
      return {
        monthNumeric: String(Number(digitValue.slice(0, 2))),
        monthTwoDigit: digitValue.slice(0, 2),
        yearFourDigit: digitValue.slice(2),
        yearTwoDigit: digitValue.slice(-2),
      };
    }
    return null;
  }

  function fillCardCredential(credential, scope = resolveCardFillScope()) {
    if (!hasCardFillTarget(scope?.fields)) {
      throw new Error("No payment field is active.");
    }
    if (!credential || typeof credential !== "object") {
      throw new Error("Card payload is missing.");
    }
    const cardNumberValue = String(credential.rawCardNumber ?? "").trim();
    const expiryValue = String(credential.expiry ?? "").trim();
    const securityCodeValue = String(credential.rawCvv ?? "").trim();
    const expiryParts = parseExpiryParts(expiryValue);
    let filledCount = 0;
    if (cardNumberValue && assignFieldValue(scope.fields.cardNumberField, cardNumberValue)) {
      filledCount += 1;
    }
    if (expiryValue && assignFieldValue(scope.fields.expiryField, expiryValue)) {
      filledCount += 1;
    }
    if (expiryParts) {
      if (
        assignFieldValue(scope.fields.expiryMonthField, [expiryParts.monthTwoDigit, expiryParts.monthNumeric])
      ) {
        filledCount += 1;
      }
      if (
        assignFieldValue(scope.fields.expiryYearField, [expiryParts.yearFourDigit, expiryParts.yearTwoDigit])
      ) {
        filledCount += 1;
      }
    }
    if (securityCodeValue && assignFieldValue(scope.fields.securityCodeField, securityCodeValue)) {
      filledCount += 1;
    }
    if (filledCount === 0) {
      throw new Error("No card values were available to fill.");
    }
    const focusTarget =
      scope.fields.cardNumberField ??
      scope.fields.expiryField ??
      scope.fields.expiryMonthField ??
      scope.fields.securityCodeField ??
      null;
    focusTarget?.focus?.();
    return {
      filled: true,
      fillKind: "card",
      filledFieldCount: filledCount,
    };
  }

  function fillCredential(credential) {
    if (credential && typeof credential === "object" && "rawSecret" in credential) {
      return fillPasswordCredential(credential);
    }
    if (
      credential &&
      typeof credential === "object" &&
      ("rawCardNumber" in credential || "expiry" in credential || "rawCvv" in credential)
    ) {
      return fillCardCredential(credential);
    }
    throw new Error("Fill payload is unsupported.");
  }

  async function maybeAutoFillFocusedScope() {
    const scope = resolvePasswordFillScope();
    if (!scope?.passwordField) {
      return;
    }
    if (scope.passwordField.dataset.nexusAutofilled === "true") {
      return;
    }
    const scopeKey = buildAutoFillScopeKey(scope);
    if (scope.passwordField.dataset.nexusAutofillKey === scopeKey) {
      return;
    }
    const response = await requestRuntimeMessage({
      origin: window.location.origin,
      type: READ_AUTO_FILL_CREDENTIAL,
    }).catch(() => null);
    const credential = response?.credential ?? null;
    if (!credential) {
      return;
    }
    fillPasswordCredential(credential, scope);
    scope.passwordField.dataset.nexusAutofillKey = scopeKey;
  }

  function scheduleAutoFill() {
    if (autoFillTimeoutId) {
      window.clearTimeout(autoFillTimeoutId);
    }
    autoFillTimeoutId = window.setTimeout(() => {
      void maybeAutoFillFocusedScope();
    }, AUTO_FILL_DELAY_MS);
  }

  document.addEventListener("focusin", (event) => {
    const target = event.target;
    if (!(target instanceof HTMLInputElement)) {
      return;
    }
    if (!isAutoFillTriggerElement(target)) {
      return;
    }
    scheduleAutoFill();
  });

  if (document.readyState === "interactive" || document.readyState === "complete") {
    scheduleAutoFill();
  } else {
    document.addEventListener("DOMContentLoaded", () => {
      scheduleAutoFill();
    });
  }

  runtimeApi.runtime.onMessage.addListener((message, _sender, sendResponse) => {
    try {
      switch (message?.type) {
        case DETECT_FILL_TARGET:
          sendResponse({ ok: true, ...detectFillTarget() });
          return true;
        case FILL_CREDENTIAL:
          sendResponse({ ok: true, ...fillCredential(message.credential) });
          return true;
        default:
          return false;
      }
    } catch (error) {
      sendResponse({
        ok: false,
        error: error instanceof Error ? error.message : "Unable to complete request.",
      });
      return true;
    }
  });
})();
