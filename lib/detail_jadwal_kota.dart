import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class DetailDataDua extends StatefulWidget {
  final String item;
  DetailDataDua({
    Key key,
    this.item,
  }) : super(key: key);

  @override
  _DetailDataDuaState createState() => _DetailDataDuaState();
}

class _DetailDataDuaState extends State<DetailDataDua> {
  Future<DuaDetail> detail;

  @override
  void initState() {
    super.initState();
    detail = fetchDetails(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff1F1D2B),
        title: Text(
          'Jadwal Solat',
          style:
              TextStyle(color: Colors.white, letterSpacing: .5, fontSize: 15),
          overflow: TextOverflow.ellipsis,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
            child: FutureBuilder<DuaDetail>(
          future: detail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  SizedBox(
                    height: 4,
                  ),
                  Text(snapshot.data.tanggal),
                  SizedBox(
                    height: 4,
                  ),
                  Text("ashar = " + snapshot.data.ashar),
                  SizedBox(
                    height: 4,
                  ),
                  Text("dhuha = " + snapshot.data.dhuha),
                  SizedBox(
                    height: 4,
                  ),
                  Text("dzuhur = " + snapshot.data.dzuhur),
                  SizedBox(
                    height: 4,
                  ),
                  Text("imsak = " + snapshot.data.imsak),
                  SizedBox(
                    height: 4,
                  ),
                  Text("isya = " + snapshot.data.isya),
                  SizedBox(
                    height: 4,
                  ),
                  Text("maghrib = " + snapshot.data.maghrib),
                  SizedBox(
                    height: 4,
                  ),
                  Text("subuh = " + snapshot.data.subuh),
                  SizedBox(
                    height: 4,
                  ),
                  Text("terbit = " + snapshot.data.terbit),
                ],
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
        )),
      ),
    );
  }
}

class DuaDetail {
  String ashar;
  String dhuha;
  String dzuhur;
  String imsak;
  String isya;
  String maghrib;
  String subuh;
  String tanggal;
  String terbit;

  DuaDetail({
    this.ashar,
    this.dhuha,
    this.dzuhur,
    this.imsak,
    this.isya,
    this.maghrib,
    this.subuh,
    this.tanggal,
    this.terbit,
  });

  factory DuaDetail.fromJson(Map<String, dynamic> json) {
    return DuaDetail(
      ashar: json['ashar'],
      dhuha: json['dhuha'],
      dzuhur: json['dzuhur'],
      imsak: json['imsak'],
      isya: json['isya'],
      maghrib: json['maghrib'],
      subuh: json['subuh'],
      tanggal: json['tanggal'],
      terbit: json['terbit'],
    );
  }
}

Future<DuaDetail> fetchDetails(uuid) async {
  String api =
      'https://api.banghasan.com/sholat/format/json/jadwal/kota/$uuid/tanggal/2021-11-20';
  final response = await http.get(
    Uri.parse(api),
    // headers: headers,
  );

  if (response.statusCode == 200) {
    print(response.body);
    print(response.statusCode);
    return DuaDetail.fromJson(jsonDecode(response.body)['jadwal']['data']);
  } else {
    throw Exception('Failed to load drivers');
  }
}
