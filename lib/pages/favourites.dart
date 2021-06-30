import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 12,
          itemCount: favourite_list.length,
          itemBuilder: (context, index) {
            if (favourite_list.isEmpty) {
              return const Center(child: Text("No Favourite Found"));
            } else {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/pikachu.png",
                          width: 160,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                (favourite_list[index]),
                                style: TextStyle(color: Colors.white),
                              ),
                              GestureDetector(
                                  onTap: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    setState(() {
                                      favourite_list
                                          .remove(favourite_list[index]);
                                      prefs.setStringList(
                                          "favourite_list", favourite_list);
                                    });
                                  },
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        )
                      ],
                    )),
              );
            }
          },
          staggeredTileBuilder: (index) {
            return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8);
          }),
    );
  }

  getfavouritelist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getStringList("favourite_list") == null) {
        favourite_list = [];
      } else {
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
