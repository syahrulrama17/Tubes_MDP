import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class DetailDataSatu extends StatefulWidget {
  final String item;
  DetailDataSatu({
    Key key,
    this.item,
  }) : super(key: key);

  @override
  _DetailDataSatuState createState() => _DetailDataSatuState();
}

class _DetailDataSatuState extends State<DetailDataSatu> {
  Future<List<SatuDetail>> detail;

  @override
  void initState() {
    super.initState();
    detail = fetchDetails(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1F1D2B),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff1F1D2B),
        title: Text(
          'Doa',
          style:
              TextStyle(color: Colors.white, letterSpacing: .5, fontSize: 15),
          overflow: TextOverflow.ellipsis,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: FutureBuilder<List<SatuDetail>>(
            future: detail,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) => Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: Card(
                        borderOnForeground: false,
                        shadowColor: Colors.black,
                        color: Color(0xffF5F5DC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 4,
                              ),
                              Text(snapshot.data[index].doa),
                              SizedBox(
                                height: 4,
                              ),
                              Text("Ayat = " + snapshot.data[index].ayat),
                              SizedBox(
                                height: 4,
                              ),
                              Text("latin = " + snapshot.data[index].latin),
                              SizedBox(
                                height: 4,
                              ),
                              Text("artinya = " + snapshot.data[index].artinya),
                            ],
                          ),
                        )),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.error}"),
                );
              }
              return Center(
                child: const CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SatuDetail {
  String doa;
  String uuid;
  String ayat;
  String latin;
  String artinya;

  SatuDetail({this.uuid, this.doa, this.ayat, this.latin, this.artinya});

  factory SatuDetail.fromJson(Map<String, dynamic> json) {
    return SatuDetail(
      uuid: json['id'],
      doa: json['doa'],
      ayat: json['ayat'],
      latin: json['latin'],
      artinya: json['artinya'],
    );
  }
}

Future<List<SatuDetail>> fetchDetails(uuid) async {
  String api = 'https://doa-doa-api-ahmadramadhan.fly.dev/api/$uuid';
  final response = await http.get(
    Uri.parse(api),
    // headers: headers,
  );

  if (response.statusCode == 200) {
    print(response.body);
    print(response.statusCode);
    var ayatShowsJson = jsonDecode(response.body) as List,
        ayatShows =
            ayatShowsJson.map((top) => SatuDetail.fromJson(top)).toList();

    return ayatShows;
  } else {
    throw Exception('Failed to load drivers');
  }
}
