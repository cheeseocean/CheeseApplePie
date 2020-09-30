import 'package:cheese_flutter/widgets/custom_dialog.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final initialColor = Colors.amber;

class ClassEditDialog extends StatefulWidget {
  @override
  State createState() {
    return _ClassEditDialogState();
  }
}

class _ClassEditDialogState extends State<ClassEditDialog> {
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _teacherController = TextEditingController();
  final TextEditingController _classAddressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Color _selectedColor;

  Widget get frontComponent => Builder(builder: (context) {
        return CustomDialog(
          leftButtonLabel: "取消",
          rightButtonLabel: "完成",
          title: Row(children: [
            Expanded(
              flex: 8,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Text(
                    "添加课程",
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: IconButton(
                icon: Icon(
                  Icons.color_lens_outlined,
                  color: _selectedColor,
                ),
                onPressed: () {
                  _cardKey.currentState.toggleCard();
                },
              ),
            )
          ]),
          content: Container(
            // height: 160.0,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _classNameController,
                    decoration: InputDecoration(hintText: "课程名"),
                    validator: (text) {
                      return text.trim().length > 0 ? null : "课程名不能为空";
                    },
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                    controller: _teacherController,
                    decoration: InputDecoration(
                      hintText: "老师",
                    ),
                    validator: (text) {
                      return text.trim().length > 0 ? null : "老师不能为空";
                    },
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                    controller: _classAddressController,
                    decoration: InputDecoration(hintText: "教室"),
                    validator: (text) {
                      return text.trim().length > 0 ? null : "教室不能为空";
                    },
                  ),
                  // SizedBox(
                  //   height: 5.0,
                  // ),
                  // ColorPicker(),
                ],
              ),
            ),
          ),
          // scrollable: true,
          onLeftPressed: () {
            Navigator.of(context).pop(Response(hasResult: false));
          },
          onRightPressed: () {
            if (_formKey.currentState.validate()) {
              Navigator.of(context).pop(Response(
                  hasResult: true,
                  details: ClassDetails(
                      color: _selectedColor.value,
                      className: _classNameController.text.trim(),
                      classAddress: _classAddressController.text.trim(),
                      teacherName: _teacherController.text.trim())));
            }
          },
        );
      });

  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();

  @override
  void initState() {
    super.initState();
    _selectedColor = initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
        key: _cardKey,
        flipOnTouch: false,
        front: frontComponent,
        back: ColorPicker(
          initialColor: initialColor,
          onCancel: () {
            _cardKey.currentState.toggleCard();
          },
          onSelected: (selectedColor) {
            _cardKey.currentState.toggleCard();
            setState(() {
              _selectedColor = selectedColor;
            });
          },
        ));
  }
}

typedef onColorSelected = void Function(Color color);

class ColorPicker extends StatefulWidget {
  final Color initialColor;

  final VoidCallback onCancel;
  final onColorSelected onSelected;

  ColorPicker({this.initialColor, this.onCancel, this.onSelected});

  @override
  State createState() {
    return _ColorPickerState();
  }
}

class _ColorPickerState extends State<ColorPicker> {
  int _value = 0;
  final _colors = <MaterialColor>[
    Colors.grey,
    Colors.yellow,
    Colors.amber,
    Colors.purple,
    Colors.lime,
    Colors.pink,
    Colors.blue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.red,
    Colors.indigo
  ];
  Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: Center(child: Text("选择颜色")),
      leftButtonLabel: "取消",
      rightButtonLabel: "完成",
      content: Container(
        width: 200.0,
        height: 180.0,
        child: GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            // childAspectRatio: 1.0,
            children: _colors
                .map(
                  (color) => Padding(
                    padding: EdgeInsets.all(2.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      child: ClipOval(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              color: color,
                            ),
                            Opacity(
                                opacity: _selectedColor == color ? 1.0 : 0.0,
                                child: Icon(Icons.done_rounded))
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList()),
      ),
      onLeftPressed: widget.onCancel,
      onRightPressed: () {
        if (mounted) {
          widget.onSelected(_selectedColor);
        }
      },
    );
  }
}

class Response {
  bool hasResult;
  ClassDetails details;

  Response({this.hasResult, this.details});
}

class ClassDetails {
  final int color;
  final String className;
  final String teacherName;
  final String classAddress;

  ClassDetails(
      {this.color, this.className, this.teacherName, this.classAddress});
}
