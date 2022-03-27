import 'package:flutter/material.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/states/states.dart';
import 'package:provider/provider.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LayoutPageState();
}

class LayoutPageState extends RoutePage<LayoutPage> {
  int _currentIndex = 3;
  late Widget _body;
  final _items = [
    const BottomNavigationBarItem(icon: Icon(Icons.set_meal), label: '首页'),
    const BottomNavigationBarItem(icon: Icon(Icons.padding), label: '云社区'),
    const BottomNavigationBarItem(icon: Icon(Icons.cabin), label: '云视频'),
    const BottomNavigationBarItem(icon: Icon(Icons.dangerous), label: '创作中心'),
    const BottomNavigationBarItem(icon: Icon(Icons.baby_changing_station), label: '个人中心')
  ];
  final paths = [RoutePath.index, RoutePath.community, RoutePath.videos, RoutePath.creation, RoutePath.personal];

  LayoutPageState() {
    _body = NestedRouter.nestedRouteMap[RoutePath.creation] as Widget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          items: _items,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          unselectedLabelStyle: const TextStyle(color: Colors.black),
          backgroundColor: Colors.blue,
          fixedColor: Colors.blue,
          currentIndex: _currentIndex,
          onTap: (index) {
            UserState userState = Provider.of(context, listen: false);
            if (!userState.login) {
              // Navigator.pushNamed(context, '/login');
              // return;
            }
            NestedRouter.push(context, paths[index]);
          }),
      // appBar: AppBar(
      //   title: const Text('bar'),
      // ),
      body: _body,
      drawer: Drawer(
        child: ListView(
          children: const [
            ListTile(title: Text('title')),
            ListTile(title: Text('title')),
            ListTile(title: Text('title')),
          ],
        ),
      ),
    );
  }

  @override
  void setRoute(Widget page, String path, [Object? arguments]) {
    setState(() {
      _body = page;
      _currentIndex = paths.indexOf(path);
    });
  }
}
