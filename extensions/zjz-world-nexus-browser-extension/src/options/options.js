import { readExtensionSettings, writeApiBaseUrl } from "../shared/storage.js";

const formElement = document.getElementById("settings-form");
const apiBaseUrlInput = document.getElementById("api-base-url");
const statusLineElement = document.getElementById("status-line");

async function loadSettings() {
  try {
    const settings = await readExtensionSettings();
    apiBaseUrlInput.value = settings.apiBaseUrl;
  } catch (error) {
    statusLineElement.textContent =
      error instanceof Error ? error.message : "Unable to load settings.";
  }
}

async function saveSettings(event) {
  event.preventDefault();
  statusLineElement.textContent = "";
  try {
    const normalizedApiBaseUrl = await writeApiBaseUrl(apiBaseUrlInput.value);
    apiBaseUrlInput.value = normalizedApiBaseUrl;
    statusLineElement.textContent = "Saved";
  } catch (error) {
    statusLineElement.textContent =
      error instanceof Error ? error.message : "Unable to save settings.";
  }
}

formElement.addEventListener("submit", (event) => {
  void saveSettings(event);
});

document.addEventListener("DOMContentLoaded", () => {
  void loadSettings();
});
