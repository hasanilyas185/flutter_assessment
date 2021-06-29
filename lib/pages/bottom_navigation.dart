import 'package:flutter/material.dart';

import 'favourites.dart';
import 'getpokemon.dart';

class bottomNavigation extends StatefulWidget {
  int? currentIndex;

  bottomNavigation(this.currentIndex);

  @override
  _bottomNavigationState createState() => _bottomNavigationState();
}

class _bottomNavigationState extends State<bottomNavigation> {
  int? currentIndex = 0;

  @override
  void initState() {
    currentIndex = widget.currentIndex;
  }

  /// Set a type current number a layout class
  Widget callPage(int? current) {
    switch (current) {
      case 0:
        return GetPokemon();
      case 1:
        return Favourites();
        break;
      default:
        return Text('Home');
    }
  }

  Widget _widget() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double scalefactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
        body: callPage(currentIndex),
        bottomNavigationBar: Container(
          height: 70,
          child: BottomAppBar(
              shape: CircularNotchedRectangle(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          currentIndex = 0;
                        });
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.home,
                            color: currentIndex == 0
                                ? Colors.red
                                : Colors.grey,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Home',
                            style: TextStyle(
                                fontSize: 11 * scalefactor,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                color: currentIndex == 0
                                    ? Colors.red
                                    : Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          currentIndex = 1;
                        });
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: currentIndex == 1
                                ? Colors.red
                                : Colors.grey,
                          ),
                          Text(
                            'Favourites',
                            style: TextStyle(
                                fontSize: 11 * scalefactor,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                color: currentIndex == 1
                                    ? Colors.red
                                    : Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
        );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final md = MediaQuery.of(context);
    if (md.orientation == Orientation.landscape) {
      return _widget();
    }
    return _widget();
  }
}
