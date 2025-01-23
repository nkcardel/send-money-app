import 'package:flutter/material.dart';

extension FlutterKeysExtension on ValueKey? {
  Key? nullableKey(String? valueExt) {
    if (this != null) {
      return Key('${this!.value}-$valueExt');
    }
    return null;
  }
}
