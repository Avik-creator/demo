import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> leadList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final apiUrl = Uri.parse("https://api.thenotary.app/lead/getLeads");

    try {
      final response = await http.post(
        apiUrl,
        body: json.encode({"notaryId": "643074200605c500112e0902"}),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> leads = data['leads'];

        setState(() {
          leadList = leads.map((lead) => lead as Map<String, dynamic>).toList();
          isLoading = false;
        });
      } else {
        // Handle the error
        print("Error: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle network or other errors
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lead List'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: leadList.length,
              itemBuilder: (context, index) {
                final lead = leadList[index];
                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title:
                        Text("Name: ${lead['firstName']} ${lead['lastName']}"),
                    subtitle: Text("Email: ${lead['email']}"),
                  ),
                );
              },
            ),
    );
  }
}
