import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayService {
  static Future<bool> requestPermission() async {
    final status = await FlutterOverlayWindow.requestPermission();
    return status ?? false;
  }

  static Future<void> showOverlay({
    required String title,
    required String message,
    Duration delay = const Duration(seconds: 2),
  }) async {
    await Future.delayed(delay);
    if (await FlutterOverlayWindow.isActive()) return;

    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      overlayTitle: "WhatsDirectPro",
      overlayContent: 'Overlay Notification',
      flag: OverlayFlag.defaultFlag,
      alignment: OverlayAlignment.centerLeft,
      visibility: NotificationVisibility.visibilityPublic,
      positionGravity: PositionGravity.auto,
      height: 200,
      width: WindowSize.matchParent,
    );
  }

  static Future<void> closeOverlay() async {
    if (await FlutterOverlayWindow.isActive()) {
      await FlutterOverlayWindow.closeOverlay();
    }
  }
}
