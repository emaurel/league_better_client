import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

void minimizeLeagueClient() {
  // Allocate a UTF-16 pointer from a Dart string
  final windowName = 'League of Legends'.toNativeUtf16();

  // Find the window handle
  final hwnd = FindWindow(nullptr, windowName);

  // Always free allocated memory
  calloc.free(windowName);

  if (hwnd != 0) {
    ShowWindow(hwnd, SW_SHOW);
  } else {
    print('League client window not found');
  }
}
