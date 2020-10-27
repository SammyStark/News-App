import 'dart:convert';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './details.dart';

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
    fetchDataFromApi();
  }

  Future<String> fetchDataFromApi() async {
    var jsondata = await http.get(
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=5d57a156bdf142fb996a4ba38cacf491");
    var fetchdata = jsonDecode(jsondata.body);
    setState(
      () {
        data = fetchdata["articles"];
      },
    );
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "News App",
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.cyan[100],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "News",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
              Text(
                "Update",
                style: TextStyle(
                  color: Colors.deepPurpleAccent[700],
                  fontSize: 25,
                ),
              )
            ],
          ),
        ),
        body: Container(
          color: Colors.cyan[50],
          child: Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(
                          author: data[index]["author"],
                          title: data[index]["title"],
                          description: data[index]["description"],
                          urlToImage: data[index]["urlToImage"],
                          publishedAt: data[index]["publishedAt"],
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35.0),
                            topRight: Radius.circular(35.0),
                          ),
                          child: Image.network(
                            data[index]["urlToImage"],
                            fit: BoxFit.cover,
                            height: 400.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 350.0, 0.0, 0.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.9,
                          width: MediaQuery.of(context).size.width,
                          child: Material(
                            borderRadius: BorderRadius.circular(35.0),
                            elevation: 10.0,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      20.0, 20.0, 10.0, 20.0),
                                  child: Text(
                                    data[index]["title"],
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
              itemCount: data == null ? 0 : data.length,
              autoplay: true,
              viewportFraction: 0.8,
              scale: 0.9,
            ),
          ),
        ),
      ),
    );
  }
}
