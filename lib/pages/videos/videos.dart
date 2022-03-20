import 'package:flutter/material.dart';
import 'package:flutter_application/common/utils.dart';


import '../../http/http.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            // Expanded(
            //   child: Container(
            //     child: quill.QuillEditor.basic(
            //       controller: _quillShowCtr!,
            //       readOnly: true,
            //     ),
            //   ),
            // ),
            ElevatedButton(
              onPressed: () {

              },
              child: Text('提交'),
            )
          ],
        ),
      ),
    );
  }
}
