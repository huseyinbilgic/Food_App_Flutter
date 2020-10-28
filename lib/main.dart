import 'dart:convert';

import 'package:flutter/material.dart';
import "package:yaml/yaml.dart";

import "package:flutter/services.dart" as s;
import 'package:yemek_project1/subMenus/subMenusDetail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  //var doc = loadYaml("/assets/ymlfiles/menu.yaml");
  var mapData = {"menus": []};
  var gecici = [];
  var visiblesData = [];
  var main;
  getir() async {
    final data = await s.rootBundle.loadString('assets/ymlfiles/menu.yaml');

    setState(() {
      mapData["menus"] = loadYaml(data)["menus"];
    });
    for (var i = 0; i < mapData["menus"].length; i++) {
      gecici.add(false);
      if (mapData["menus"][i]["key"] == "main") {
        setState(() {
          main = mapData["menus"][i];
        });
      }
    }
    setState(() {
      visiblesData = gecici;
    });
    print(main);
  }

  aktif(index) {
    setState(() {
      visiblesData[index] = !visiblesData[index];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Yemek Listesi"),
        ),
        body: ListView.builder(
            itemCount: main != null ? main["items"].length : 0,
            itemBuilder: (context, position) {
              return Center(
                  child: Column(
                children: [
                  FlatButton(
                    onPressed: () => {aktif(position)},
                    child: Text(main["items"][position]["name"],
                        style: TextStyle(
                            color: Colors.black,
                            backgroundColor: Colors.lightBlue,
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic)),
                  ),
                  Image.asset("assets/" + main["items"][position]["image"]),
                  Visibility(
                    visible: visiblesData[position],
                    child: SubMenus(
                      menuler: mapData["menus"],
                      dizi: main["items"][position]["items"],
                      
                    ),
                  )
                ],
              ));
            }));
  }
}

class SubMenus extends StatelessWidget {

  var dizi;
  var menuler;
  SubMenus({@required this.dizi, @required this.menuler});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < dizi.length; i++)
          FlatButton(
            onPressed: () => {
              if (dizi[i]["subMenus"] != null)
                {allSubMenus(context, dizi[i]["subMenus"],dizi[i]["name"])}
              else
                {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Fiyat Bilgisi'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(dizi[i]["price"]!=null?dizi[i]["price"].toString() + " TL":"Fiyat bilgisi yok."),
                              ],
                            ),
                          ),
                        );
                      })
                }
            },
            child: Text(dizi[i]["name"],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontStyle: FontStyle.italic)),
          ),
      ],
    );
  }

  allSubMenus(BuildContext context, var subMenus,title) {
    List<dynamic> anaMenuler = [];
    for (var i = 0; i < subMenus.length; i++) {
      var iterable;
      for (var j = 0; j < menuler.length; j++) {
        if (menuler[j]["key"] == subMenus[i]) {
          iterable = menuler[j]["items"];
        }
      }
      for (var i = 0; i < iterable.length; i++) {
        anaMenuler.add(iterable[i]);
      }
    }

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SubMenusDetail(
              dizi: anaMenuler,
              title: title,
            )));
  }
}
