import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multiple API Requests Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> responses = [];
  List<String> urls = [];

  TextEditingController _urlController = TextEditingController();

  Future<void> fetchAPIs(List<String> urls) async {
    List<Future<http.Response>> futures = [];
    for (String url in urls) {
      futures.add(http.get(Uri.parse(url)));
    }
    List<http.Response> results = await Future.wait(futures);
    for (http.Response response in results) {
      if (response.statusCode == 200) {
        setState(() {
          responses.add(response.body);
        });
      } else {
        throw Exception('Failed to load data');
      }
    }
  }

  Future<void> fetchData() async {
    await fetchAPIs(urls);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multiple API Requests Example'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: InputDecoration(labelText: 'Enter API URL'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      urls.add(_urlController.text);
                      _urlController.clear();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: responses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Response ${index + 1}'),
                  subtitle: Text(responses[index]),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: fetchData,
            child: Text('Fetch Data'),
          ),
        ],
      ),
    );
  }
}
