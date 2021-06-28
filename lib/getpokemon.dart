import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetPokemon extends StatefulWidget {
  @override
  _GetPokemonState createState() => _GetPokemonState();
}

class _GetPokemonState extends State<GetPokemon> {
  String nextPage = "https://pokeapi.co/api/v2/pokemon/?limit=25";
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  List pokemons = [];
  List<String> favourites = [];
  final dio = Dio();


  getlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if(prefs.getStringList("favourite_list") == null)
        {
          favourites = [];
        }
      else
        {
          favourites = prefs.getStringList("favourite_list")!;
        }

    });
  }


  void _getpokemondata() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      final response = await dio.get(nextPage);
      List tempList = [];
      nextPage = response.data['next'];
      for (int i = 0; i < response.data['results'].length; i++) {
        tempList.add(response.data['results'][i]);
      }

      setState(() {
        isLoading = false;
        pokemons.addAll(tempList);
      });
    }
  }

  @override
  void initState() {
    getlist();
    _getpokemondata();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getpokemondata();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      //+1 for progressbar
      itemCount: pokemons.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == pokemons.length) {
          return _buildProgressIndicator();
        } else {
          return ListTile(
            title: Text((pokemons[index]['name'])),
            trailing:
            Consumer<Modifier>(
              builder: (context, modify, child) {
                return IconButton(
                  icon: favourites.contains(pokemons[index]["name"])
                      ? const Icon(Icons.favorite, color: Colors.red)
                      : const Icon(Icons.favorite,
                      color: Colors.grey),
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    modify.changeIcon();
                    if(!favourites.contains(pokemons[index]["name"]))
                      {
                        favourites.add(pokemons[index]["name"]);
                      }
                    prefs.setStringList("favourite_list", favourites);
                  },
                );
              },
            ),
          );
        }
      },
      controller: _scrollController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Modifier>(
      create: (context) => Modifier(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Pokemons"),
          centerTitle: true,
        ),
        body: Container(
          child: _buildList(),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}

class Modifier with ChangeNotifier {
  Modifier();

  Icon icon = const Icon(
    Icons.favorite,
    color: Colors.grey,
  );

  changeIcon() {
    print('icon updated');
    icon = const Icon(Icons.favorite, color: Colors.red);
    notifyListeners();
  }

  Icon get getIcons => icon;
}
