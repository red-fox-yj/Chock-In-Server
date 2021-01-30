import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'pages/modify.dart';
import 'one_for_all.dart';
import 'dart:convert' as convert;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Clock in';

    return MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, @required this.title}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var temp = Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Container(
              child: Text(
                "已签到",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.blue,
                  fontWeight: FontWeight.w800,
                ),
              ),
              width: 300,
            ),
            SizedBox(height: 10),
            Form(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: "在这里输入已签到人员名单",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: Text(
                "未签到",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.blue,
                  fontWeight: FontWeight.w800,
                ),
              ),
              width: 300,
            ),
            SizedBox(height: 10),
            Form(
              child: TextFormField(
                controller: controller_,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "这里显示未签到人员名单"),
                maxLines: 3,
              ),
            ),
            SizedBox(height: 10),
            StreamBuilder(
              stream: wschannel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData && temp_snapshot != snapshot.data) {
                  temp_snapshot = snapshot.data;
                  _resolve_results(convert.jsonDecode(snapshot.data));
                  return new Text(
                    '当前状态：发送成功',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.red,
                      fontWeight: FontWeight.w800,
                    ),
                  );
                } else {
                  return new Text(
                    "当前状态：无发送",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.red,
                      fontWeight: FontWeight.w800,
                    ),
                  );
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 50,
                    child: RaisedButton(
                      child: Text('查询'),
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: () {
                        sendMessage_search();
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 50,
                    child: RaisedButton(
                      child: Text('修改名单'),
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: () {
                        sendMessage_read();
                        //路由跳转
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ModifyPage()));
                      },
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: Image.network(
                  "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1764738094,803920278&fm=26&gp=0.jpg",
                  fit: BoxFit.fill),
              width: 600,
              height: 300,
              decoration: BoxDecoration(color: Colors.yellow),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _copy_names,
        child: new Icon(Icons.copy),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
    //_monitor(widget.channel.stream);
    return temp;
  }

  // 向服务器发送查询请求
  void sendMessage_search() {
    if (controller.text.isNotEmpty) {
      wschannel.sink
          .add({'"type"': '"search"', '"data"': '"' + controller.text + '"'});
    }
  }

  // 向服务器读发送读取名单请求
  void sendMessage_read() {
    wschannel.sink.add({'"type"': '"read"', '"data"': '"read"'});
  }

  // ignore: non_constant_identifier_names
  void _resolve_results(Map m) {
    //分发后端的数据
    Future.delayed(Duration(milliseconds: 100)).then((e) {
      setState(() {
        if (m["type"] == "search") {
          controller_.text = m["data"];
        } else if (m["type"] == "read") modify_controller.text = m["data"];
      });
    });
  }

  void _copy_names() {
    Clipboard.setData(ClipboardData(text: controller_.text));
    Fluttertoast.showToast(
      msg: "复制成功",
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  void dispose() {
    wschannel.sink.close();
    super.dispose();
  }
}
