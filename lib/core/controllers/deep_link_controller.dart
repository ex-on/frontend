import 'dart:async';
import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

bool _initialLinkIsHandled = false;

class DeepLinkController extends GetxController {
  String? _initialLink = '/';
  String? _latestLink;
  Object? _err;

  StreamSubscription? _sub;

  @override
  void onInit() {
    _handleIncomingLinks();
    _handleInitialLink();
    super.onInit();
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  void _updateInitialLink(String? link) {
    _initialLink = link;
    update();
  }

  void _updateLatestLink(String? link) {
    _latestLink = link;
    update();
  }

  void _updateErr(Object? err) {
    _err = err;
    update();
  }

  /// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.
  void _handleIncomingLinks() {
    // It will handle app links while the app is already started - be it in
    // the foreground or in the background.
    _sub = linkStream.listen(
      (String? link) {
        int index = link!.indexOf('?');
        String parsedLink = '/' + link.substring("exon://".length, index);
        print('got link: $parsedLink');
        _updateLatestLink(parsedLink);
        _updateErr(null);
        Get.offAllNamed(parsedLink);
      },
      onError: (Object err) {
        print('got err: $err');
        _updateInitialLink(null);
        _updateLatestLink(null);
        if (err is FormatException) {
          _updateErr(err);
        } else {
          _updateErr(null);
        }
      },
    );
  }

  /// Handle the initial Uri - the one the app was started with
  ///
  /// **ATTENTION**: `getInitialLink`/`getInitialUri` should be handled
  /// ONLY ONCE in your app's lifetime, since it is not meant to change
  /// throughout your app's life.
  ///
  /// We handle all exceptions, since it is called from initState.
  Future<void> _handleInitialLink() async {
    // In this example app this is an almost useless guard, but it is here to
    // show we are not going to call getInitialUri multiple times, even if this
    // was a weidget that will be disposed of (ex. a navigation route change).
    if (!_initialLinkIsHandled) {
      _initialLinkIsHandled = true;
      print('_handleInitialLink called');
      try {
        final link = await getInitialLink();
        int? index;
        String? parsedLink;
        if (link == null) {
          print('no initial link');
        } else {
          index = link.indexOf('?');
          parsedLink = '/' + link.substring("exon://".length, index);
          print('got initial link: $parsedLink');
        }
        _updateInitialLink(parsedLink);
        print(_initialLink ?? _latestLink ?? '/');
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        print('falied to get initial link');
      } on FormatException catch (err) {
        print('malformed initial link');
        _updateErr(err);
      }
    }
  }
}