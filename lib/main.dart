import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String futureStatus = 'loading...';

  @override
  void initState() {
    super.initState();

    // Flutter version: master (cacf1d298f)
    // Expected outcome: `then` is entered synchronously,
    // _dangerousOperation throws, the `onError` callback
    // is invoked, and the UI shows a message telling
    // us that the operation completed with an error.
    // Actual outcome: `then` is entered synchronously,
    // _dangerousOperation throws, but the `onError` callback
    // is never invoked, and the UI is stuck in a "loading" state.
    _safeSyncOrAsyncOperation().then((value) async {
      await _dangerousOperation();
      futureStatus = 'operation completed without error';
    }, onError: (err, stack) {
      futureStatus = 'operation completed with an error';
    });
  }

  // Imagine this is an operation that's normally sync,
  // but could sometimes be async (e.g. cache got invalidated).
  Future<String> _safeSyncOrAsyncOperation() {
    return SynchronousFuture<String>('value');
  }

  Future<String> _dangerousOperation() {
    throw 'how could this happen?!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget title :)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('futureStatus: $futureStatus'),
          ],
        ),
      ),
    );
  }
}
