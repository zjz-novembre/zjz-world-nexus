const extensionApi = globalThis.browser ?? globalThis.chrome;

function lastErrorMessage() {
  return extensionApi?.runtime?.lastError?.message ?? "";
}

export function getExtensionApi() {
  if (!extensionApi) {
    throw new Error("Browser extension API is unavailable.");
  }
  return extensionApi;
}

export function callExtensionApi(context, methodName, ...args) {
  const method = context?.[methodName];
  if (typeof method !== "function") {
    return Promise.reject(new Error(`Extension API method is unavailable: ${methodName}`));
  }
  return new Promise((resolve, reject) => {
    const callback = (value) => {
      const errorMessage = lastErrorMessage();
      if (errorMessage) {
        reject(new Error(errorMessage));
        return;
      }
      resolve(value);
    };
    try {
      const maybePromise = method.call(context, ...args, callback);
      if (maybePromise && typeof maybePromise.then === "function") {
        maybePromise.then(resolve, reject);
      }
    } catch (error) {
      reject(error);
    }
  });
}

export async function queryActiveTab() {
  const api = getExtensionApi();
  const tabs = await callExtensionApi(api.tabs, "query", {
    active: true,
    currentWindow: true,
  });
  return Array.isArray(tabs) ? tabs[0] ?? null : null;
}

export async function sendRuntimeMessage(message) {
  const api = getExtensionApi();
  const response = await callExtensionApi(api.runtime, "sendMessage", message);
  if (!response?.ok) {
    throw new Error(response?.error ?? "Runtime request failed.");
  }
  return response.result;
}

export async function sendTabMessage(tabId, message) {
  const api = getExtensionApi();
  return callExtensionApi(api.tabs, "sendMessage", tabId, message);
}

export async function executeContentScript(tabId, files) {
  const api = getExtensionApi();
  return callExtensionApi(api.scripting, "executeScript", {
    files,
    target: { tabId },
  });
}

export async function readLocalStorage(keys) {
  const api = getExtensionApi();
  return callExtensionApi(api.storage.local, "get", keys);
}

export async function writeLocalStorage(values) {
  const api = getExtensionApi();
  return callExtensionApi(api.storage.local, "set", values);
}

export async function removeLocalStorage(keys) {
  const api = getExtensionApi();
  return callExtensionApi(api.storage.local, "remove", keys);
}

export async function openOptionsPage() {
  const api = getExtensionApi();
  return callExtensionApi(api.runtime, "openOptionsPage");
}

export async function openTab(url) {
  const api = getExtensionApi();
  return callExtensionApi(api.tabs, "create", { url });
}
