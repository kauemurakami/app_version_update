/// Type displays modal.
enum ShowModalType { page, bottomSheet, alertDialog }

typedef VersionChecker = bool Function({
  required String? localVersion,
  required String? storeVersion,
});
