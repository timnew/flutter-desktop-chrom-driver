import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webdriver/io.dart';
import 'package:webdriver/support/async.dart';
import 'package:matcher/matcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();

  void _searchGoogle() async {
    try {
      final driver = await createDriver(spec: WebDriverSpec.W3c);

      await driver.get('https://google.com');
      final searchBar = await driver.findElement(const By.name('q'));

      await searchBar.sendKeys('Test Driver');

      final searchButton = await driver.findElement(const By.name('btnK'));

      await waitFor(() => searchButton.displayed, matcher: isTrue);

      await searchButton.click();
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "WebDriver not found, try to start chrom drvier again: \nchromedriver --port=4444 --url-base=wd/hub --verbose,'"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Chrome Test"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ConstrainedBox(
                constraints: const BoxConstraints.tightFor(width: 300),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Keywords',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  child: const Text("Search in Chrome"),
                  onPressed: _searchGoogle,
                ),
              )
            ],
          ),
        ),
      );
}
