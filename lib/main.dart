import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return WebViewPage();
              },
            ),
          );
        },
        child: Text('open web view'),
      )),
    );
  }
}

const String webUrl =
    'https://daryllparulan.github.io/sample_web_app_for_ios_scroll_bug/';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  var loadingPercentage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StatefulBuilder(
        builder: (context, setState) => Stack(
          children: [
            WebView(
              javascriptMode: JavascriptMode.unrestricted,
              gestureNavigationEnabled: false,
              initialUrl: webUrl,
              navigationDelegate: (request) {
                final String url = request.url;

                if (url.startsWith('${webUrl}sent')) {
                  Navigator.of(context).pop();
                } else if (url.startsWith(webUrl)) {
                  return NavigationDecision.navigate;
                }

                return NavigationDecision.prevent;
              },
              onPageStarted: (url) {
                setState(() {
                  loadingPercentage = 0;
                });
              },
              onProgress: (progress) {
                setState(() {
                  loadingPercentage = progress;
                });
              },
              onPageFinished: (url) async {
                setState(() {
                  loadingPercentage = 100;
                });
              },
            ),
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
              ),
          ],
        ),
      ),
    );
  }
}
