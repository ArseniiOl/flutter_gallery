import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List data;

  @override
  void initState() {
    super.initState();
    getimages();
  }

  Future<String> getimages() async {
    try {
      var getdata = await http.get(
          "https://api.unsplash.com/search/photos?per_page=30&client_id=n65Hs51kCNXYDaf6XTO8N6otsrl0bVjcH9TnUdlkYrg&query='nature'");
      setState(() {
        var jsondata = json.decode(getdata.body);
        data = jsondata['results'];
      });
    } catch (e) {
      print("error");
    }
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(title: Text("Test app")),
            body: new ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new Card(
                          child: new Container(
                            padding: EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  data[index]['id'],
                                  style: new TextStyle(fontSize: 10.0),
                                ),
                                new Text(
                                  data[index]['user']['username'],
                                  style: new TextStyle(fontSize: 20.0),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (_) {
                                        return DetailScreen(
                                            num: index, data: data);
                                      }));
                                    },
                                    child: Image.network(
                                      data[index]['urls']['thumb'],
                                      width: MediaQuery.of(context).size.width,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )));
  }
}

class DetailScreen extends StatelessWidget {
  final int num;
  final List data;

  DetailScreen({Key key, @required this.num, @required this.data})
      : assert(num != null),
        assert(data != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.network(
                  data[num]['urls']['full'],
                  width: MediaQuery.of(context).size.width,
                )
              ]),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
