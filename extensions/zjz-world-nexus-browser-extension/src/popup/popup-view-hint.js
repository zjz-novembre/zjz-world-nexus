(function initializePopupViewHint() {
  try {
    const storedView = window.localStorage.getItem("nexus-popup-view");
    document.documentElement.dataset.popupView =
      storedView === "signed-in" || storedView === "signed-out" ? storedView : "loading";
  } catch {
    document.documentElement.dataset.popupView = "loading";
  }
})();
