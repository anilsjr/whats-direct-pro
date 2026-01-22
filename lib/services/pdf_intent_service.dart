import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import '../models/pdf_open_request.dart';

class PdfIntentService {
  PdfIntentService._();

  static final PdfIntentService instance = PdfIntentService._();

  static const MethodChannel _methodChannel =
      MethodChannel('pdf_intent_channel');
  static const EventChannel _eventChannel =
      EventChannel('pdf_intent_events');

  Stream<PdfOpenRequest> get intentStream {
    if (!Platform.isAndroid) {
      return Stream<PdfOpenRequest>.empty();
    }
    return _eventChannel
        .receiveBroadcastStream()
        .map((event) {
          if (event is Map) {
            return PdfOpenRequest.fromMap(
              Map<dynamic, dynamic>.from(event),
            );
          }
          return const PdfOpenRequest(
            error: 'Unsupported PDF intent payload.',
          );
        })
        .where((event) => event.hasPath || event.hasError);
  }

  Future<PdfOpenRequest?> getInitialPdfIntent() async {
    if (!Platform.isAndroid) {
      return null;
    }
    try {
      final result = await _methodChannel.invokeMethod('getInitialPdfIntent');
      if (result == null) {
        return null;
      }
      if (result is! Map) {
        return null;
      }
      final request = PdfOpenRequest.fromMap(
        Map<dynamic, dynamic>.from(result),
      );
      if (request.hasPath || request.hasError) {
        return request;
      }
      return null;
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return const PdfOpenRequest(
        error: 'Unable to read incoming PDF.',
      );
    }
  }
}
