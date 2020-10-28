import 'package:flutter/material.dart';

class SubMenusDetail extends StatelessWidget {
  var dizi;
  var title;
  SubMenusDetail({@required this.dizi, @required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title + " Sub Menu"),
      ),
      body: ListView.builder(
          itemCount: dizi.length,
          itemBuilder: (context, position) {
            return Center(
              child: Column(
                children: [
                  FlatButton(
                    onPressed: () => {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Fiyat Bilgisi'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(dizi[position]["price"] != null
                                        ? dizi[position]["price"].toString() +
                                            " TL"
                                        : "Fiyat Bilgisi yok."),
                                  ],
                                ),
                              ),
                            );
                          })
                    },
                    child: Text(
                        dizi[position]["name"] != null
                            ? dizi[position]["name"]
                            : "İsimsiz Yemek",
                        style: TextStyle(
                            color: Colors.black,
                            backgroundColor: Colors.lightBlue,
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic)),
                  ),
                  Image.asset("assets/" + dizi[position]["image"]),
                ],
              ),
            );
          }),
    );
  }
}
