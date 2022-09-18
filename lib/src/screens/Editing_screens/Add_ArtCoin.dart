import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_artisto/src/models/ImArtistooUser_data_model.dart';
import 'package:flutter_artisto/src/providers/user_provider.dart';
import 'package:flutter_artisto/src/screens/Editing_screens/counter_class.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyArtCoin extends StatefulWidget {
  @override
  State<MyArtCoin> createState() => _HomePageState();
}

int count = 0;
final CounterClass counterClass = Get.put(CounterClass());
String auid = "";

class _HomePageState extends State<MyArtCoin> {
  @override
  void initState() {
    super.initState();
    log('init called');
    counterClass.streamCount();
    log('init end');
  }

  @override
  Widget build(BuildContext context) {
    ArtistooUser Artistoo_User = context.watch<UserProvider>().Artistoo_User!;
    // a = "count";
    auid = Artistoo_User.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Get Art Coin',
          style: TextStyle(
              color: Color.fromARGB(255, 238, 234, 234),
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: counterClass.streamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    count = snapshot.data as int;
                    return Column(
                      children: [
                        Text('${Artistoo_User.email}',
                            style: TextStyle(fontSize: 20)),
                        SizedBox(
                          height: 33,
                        ),
                        Text('${count}', style: TextStyle(fontSize: 60)),
                      ],
                    );
                    // Artistoo_User.email
                  } else {
                    return Text('No data ');
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              counterClass.updateCount(count);
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              counterClass.minusCount(count);
            },
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
