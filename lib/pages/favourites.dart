import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  List<String> favourite_list = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getfavouritelist();
  }

  Widget _buildList() {
    return ListView.builder(
      //+1 for progressbar
      itemCount: favourite_list.length,
      itemBuilder: (BuildContext context, int index) {
        if (favourite_list.isEmpty) {
          return const Center(child: Text("No Favourite Found"));
        } else {
          return ListTile(
            title: Text((favourite_list[index])),
            trailing: GestureDetector(
                onTap: () {
                  setState(() async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    setState(() {
                      favourite_list.remove(favourite_list[index]);
                      prefs.setStringList("favourite_list", favourite_list);
                    });
                  });
                },
                child: Icon(Icons.cancel)),
          );
        }
      },
    );
  }

  getfavouritelist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if(prefs.getStringList("favourite_list") == null)
        {
          favourite_list = [];
        }
      else
        {
          favourite_list = prefs.getStringList("favourite_list")!;
        }

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourite"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Container(child: _buildList()),
      resizeToAvoidBottomInset: false,
    );
  }
}
