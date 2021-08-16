import 'package:cheese_flutter/provider/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemePage extends StatefulWidget {
  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {

  final List<String> _list = ['跟随系统', '开启', '关闭'];

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = Provider.of<ThemeModel>(context, listen: false).getThemeMode();
    String currentMode;
    switch(themeMode.value){
      case"Dark":
        currentMode = _list[1];
        break;
      case "Light":
        currentMode = _list[2];
        break;
      default:
        currentMode = _list[0];
        break;
    }

    return Scaffold(appBar: AppBar(title: Text("深夜模式"),),body: ListView.separated(itemBuilder: (_, index){
      return InkWell(
        onTap: (){
          ThemeMode themeMode = index == 0 ? ThemeMode.system : (index == 1 ? ThemeMode.dark : ThemeMode.light);
          context.read<ThemeModel>().setTheme(themeMode);
        },
        child:Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            height: 50.0,
            child:Row(
              children: [
                Expanded(
                  child: Text(_list[index]),
                ),
                Opacity(
                  opacity: currentMode == _list[index] ? 1 : 0,
                  child: Icon(Icons.done, color: Colors.amber),
                )
              ],
            )
        )
      );
    }, separatorBuilder: (_, index){
      return Divider();
    }, itemCount: _list.length),);
  }
}