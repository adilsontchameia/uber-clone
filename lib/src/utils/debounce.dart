import 'dart:async';

import 'package:flutter/cupertino.dart';

class Debounce {
  final Duration duration;
  Timer? _timer;

  Debounce([this.duration = const Duration(milliseconds: 500)]);

  create(VoidCallback cb) {
    cancel();
    _timer = Timer(duration, cb);
  }

  cancel() {
    if (_timer != null) {
      _timer?.cancel();
    }
  }
}
