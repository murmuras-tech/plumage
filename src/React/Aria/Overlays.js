const overlays = require("@react-aria/overlays");

exports.useModalImpl = overlays.useModal;
// exports.useModalProviderImpl = overlays.useModalProvider;
exports.useOverlayImpl = overlays.useOverlay;
exports.useOverlayPositionImpl = overlays.useOverlayPosition;
exports.useOverlayTriggerImpl = overlays.useOverlayTrigger;
exports.usePreventScrollImpl = overlays.usePreventScroll;
// exports.ariaHideOutsideImpl = overlays.ariaHideOutside;

exports.overlayProvider = overlays.OverlayProvider;
exports.overlayContainer = overlays.OverlayContainer;
exports.dismissButton = overlays.DismissButton;
exports.modalProvider = overlays.ModalProvider;

exports.toPSAria = (obj) => {
  let result = {};
  Object.keys(obj).forEach((k) => {
    if (k.startsWith("aria-")) {
      const v = obj[k];
      if (v !== undefined && v !== null) {
        const newKey = k.substring(5);
        result[newKey] = v;
      }
    } else {
      console.error(`${k} is not an aria attribute`);
    }
  });
  return result;
};
