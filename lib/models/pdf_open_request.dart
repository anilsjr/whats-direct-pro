class PdfOpenRequest {
  final String? path;
  final String? displayName;
  final String? sourceUri;
  final String? error;

  const PdfOpenRequest({
    this.path,
    this.displayName,
    this.sourceUri,
    this.error,
  });

  bool get hasError => error != null && error!.isNotEmpty;
  bool get hasPath => path != null && path!.isNotEmpty;

  factory PdfOpenRequest.fromMap(Map<dynamic, dynamic> map) {
    return PdfOpenRequest(
      path: map['path'] as String?,
      displayName: map['displayName'] as String?,
      sourceUri: map['sourceUri'] as String?,
      error: map['error'] as String?,
    );
  }
}
