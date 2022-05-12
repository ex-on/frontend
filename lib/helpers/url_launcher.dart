import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  static Future<void> launchInBrowser(String url,
      {String nativeUrl = ''}) async {
    if (await canLaunch(nativeUrl)) {
      await launch(nativeUrl);
    } else if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      print('Could not launch $url');
    }
  }

  static Future<void> launchInApp(String url, {String nativeUrl = ''}) async {
    try {
      if (await canLaunch(nativeUrl)) {
        await launch(nativeUrl);
      } else if (await canLaunch(url)) {
        var webView = ChromeSafariBrowser();
        await webView.open(
          url: Uri.parse(url),
        );
        // await launch(
        //   url,
        //   // forceSafariVC: true,
        //   forceWebView: true,
        //   enableJavaScript: true,
        // );
      } else {
        print('Could not launch $url');
      }
    } catch (e) {
      print(e);
    }
  }
}
