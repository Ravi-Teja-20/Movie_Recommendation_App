import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class InfoPage extends StatefulWidget {
  String moviename;
  InfoPage({@required this.moviename});
  @override
  _InfoPageState createState() => _InfoPageState(moviename);
}

class _InfoPageState extends State<InfoPage> {
  String moviename;
  var predictedlist;

  @override
  void initState() {
    super.initState();
    predictor();
  }
  void predictor() async {
    var url = "http://10.0.2.2:12345/get_recommendations";

    var predictedData = await http.post(url, headers: {
      'content-type' : 'application/json',
      'accept' : 'application.json',
    },body: jsonEncode({"movie" : "$moviename"}));
    setState(() {
      predictedlist = json.decode(predictedData.body)['predicted'];
    });
  }

  _InfoPageState(this.moviename);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/assets/bg.jpg'), fit: BoxFit.fill),
          ),
          child: Card(
            color: Colors.transparent.withOpacity(0.7),
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    child: Card(
                      elevation: 20,
                      shadowColor: Colors.black87,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          image: DecorationImage(image: AssetImage('lib/assets/app_bg.jpg',),fit: BoxFit.fill),
                        ),
                        padding: const EdgeInsets.fromLTRB(30, 30, 5, 5),
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: Card(
                          color: Colors.transparent.withOpacity(0.7),
                          child: Text('$moviename', style: GoogleFonts.audiowide(textStyle: TextStyle(color: Colors.green, fontSize: 30, wordSpacing: 3, fontWeight: FontWeight.w600),),))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:15.0,top: 30),
                  child: SizedBox(height: 50,
                  child: Text('You may also Like :', style: GoogleFonts.kellySlab(textStyle: TextStyle(color: Colors.white70, fontSize: 30, wordSpacing: 2, fontWeight: FontWeight.w600),),),
                  ),
                ),
                predictedlist == null ? Expanded(child: Center(child: CircularProgressIndicator(backgroundColor: Colors.red,),),) :
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: predictedlist.length,
                    itemBuilder: (BuildContext context, int index){
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => InfoPage(
                                              moviename: predictedlist[index] )));
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(10),
                              width: 300,
                              height: 300,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white,width: 1),
                              ),
                              child: Card(
                                color: Colors.white,
                                elevation: 20,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Image.asset('lib/assets/app_bg.jpg', fit: BoxFit.fill,),
                              ),
                            ),
                            Positioned(
                              left: 10,
                              top: 10,
                              right: 10,
                              bottom: 30,
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                color: Colors.transparent.withOpacity(0.6),
                                child: Container(
                                  width: 300,
                                  height: 300,
                                  padding: EdgeInsets.only(left: 20),
                                  child: Center(child: Text(predictedlist[index],style: GoogleFonts.exo(textStyle: TextStyle(color: Colors.white, fontSize: 30, wordSpacing: 2, fontWeight: FontWeight.w600)))))),
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}