import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

/// Thin wrapper over pdfrx for rendering PDFs (network URL or local file),
/// used both for inline previews and full-screen viewing. Replaces SfPdfViewer.
class PdfRender extends StatelessWidget {
  const PdfRender({
    super.key,
    this.url,
    this.file,
    this.onReady,
  }) : assert(url != null || file != null, 'Provide a url or a file');

  final String? url;
  final File? file;
  final VoidCallback? onReady;

  @override
  Widget build(BuildContext context) {
    final params = PdfViewerParams(
      maxScale: 5,
      onViewerReady: onReady == null ? null : (_, __) => onReady!(),
    );
    return file != null
        ? PdfViewer.file(file!.path, params: params)
        : PdfViewer.uri(Uri.parse(url ?? ''), params: params);
  }
}
