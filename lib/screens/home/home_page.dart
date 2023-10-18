import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:photo_albums/models/photo_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  List<PhotoItem>? _itemList;
  String? _error;

  void getPhotos() async {
    try {
      setState(() {
        _error = null;
      });

      await Future.delayed(Duration(seconds: 1), () {});

      final response =
          await _dio.get('https://jsonplaceholder.typicode.com/albums');
      debugPrint(response.data.toString());

      List list = jsonDecode(response.data.toString());
      setState(() {
        _itemList = list.map((item) => PhotoItem.fromJson(item)).toList();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      debugPrint('เกิดข้อผิดพลาด: ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    getPhotos();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_error != null) {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_error!),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              getPhotos();
            },
            child: Text('RETRY'),
          )
        ],
      );
    } else if (_itemList == null) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = ListView.builder(
        itemCount: _itemList!.length,
        itemBuilder: (context, index) {
          var photoItem = _itemList![index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(photoItem.title),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.pink[100],
                              shape: BoxShape.rectangle,
                              // border: Border.all(),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              'Album ID: ${photoItem.id}',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.cyanAccent[100],
                              shape: BoxShape.rectangle,
                              // border: Border.all(),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              'User ID: ${photoItem.userId}',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Photo Albums')),
      ),
      body: body,
    );
  }
}
