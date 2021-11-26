import 'dart:convert';

import 'package:doa_harian/detail_jadwal_kota.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KotaList extends StatefulWidget {
  KotaList({Key key}) : super(key: key);

  @override
  _KotaListState createState() => _KotaListState();
}

class _KotaListState extends State<KotaList> {
  Future<List<DataDua>> data2;
  @override
  void initState() {
    super.initState();
    data2 = fetchDataSatuList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Doa Harian',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                    // height: 200.0,
                    child: FutureBuilder<List<DataDua>>(
                        future: data2,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Card(
                                  borderOnForeground: false,
                                  shadowColor: Colors.white,
                                  color: Color(0xff22b07D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    title: Text(
                                      snapshot.data[index].nama,
                                      style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: .5,
                                          fontSize: 15),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailDataDua(
                                            item: snapshot.data[index].uuid,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
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

class DataDua {
  String nama;
  String uuid;

  DataDua({
    this.uuid,
    this.nama,
  });

  factory DataDua.fromJson(Map<String, dynamic> json) {
    return DataDua(
      uuid: json['id'],
      nama: json['nama'],
    );
  }
}

// function untuk fetch api
Future<List<DataDua>> fetchDataSatuList() async {
  String api = 'https://api.banghasan.com/sholat/format/json/kota';
  final response = await http.get(
    Uri.parse(api),
  );

  if (response.statusCode == 200) {
    print(response.body);
    var doaShowsJson = jsonDecode(response.body)['kota'] as List,
        doaShows = doaShowsJson.map((top) => DataDua.fromJson(top)).toList();

    return doaShows;
  } else {
    throw Exception('Failed to load doa');
  }
}
