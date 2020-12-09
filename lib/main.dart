import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ml_test_app/infopage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
  var movielist;

  void moviesList() async {
    var url = "http://10.0.2.2:12345/get_movies";

    http.Response movieData = await http.get(url);
    if (movieData.statusCode != 200) {
      print("Error ocurred");
    } else {
      setState(() {
        movielist = json.decode(movieData.body)['movies'];
      });
    }
  }

  @override
  void initState() {
    moviesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 26),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/assets/bg.jpg'), fit: BoxFit.fill),
        ),
        child: Card(
          color: Colors.transparent.withOpacity(0.1),
          child: Column(
            children: <Widget>[
              SizedBox(
                      height: 20,
                    ),
              Card(
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  padding: EdgeInsets.only(left: 20),
                  child: Center(
                      child: Text('CHECKOUT YOUR FAVOURITE MOVIES!!',
                          style: GoogleFonts.rye(
                              textStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 30,
                                  wordSpacing: 2,
                                  fontWeight: FontWeight.w500)))),
                ),
              ),
              movielist == null
                  ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    )
                  :
              Expanded(
                child: ListView.builder(
                    itemCount: movielist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
                        child: Stack(
                          overflow: Overflow.clip,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Card(
                                color: Colors.white,
                                elevation: 20,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Image.asset(
                                  'lib/assets/app_bg.jpg',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 20,
                              top: 10,
                              right: 50,
                              bottom: 20,
                              child: Card(
                                  color: Colors.transparent.withOpacity(0.6),
                                  child: Center(
                                      child: Text(movielist[index],
                                          style: GoogleFonts.exo(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  wordSpacing: 2,
                                                  fontWeight:
                                                      FontWeight.w600))))),
                            ),
                            Positioned(
                              top: 120,
                              right: 10,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => InfoPage(
                                              moviename: movielist[index])));
                                },
                                child: Card(
                                  elevation: 25,
                                  color: Colors.transparent,
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                        child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                      size: 30,
                                    )),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
