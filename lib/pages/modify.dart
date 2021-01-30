import 'package:flutter/material.dart';
import 'package:flutter_web_client/one_for_all.dart';

class ModifyPage extends StatelessWidget {
  const ModifyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text("修改名单")),
        body: new Padding(
          padding: const EdgeInsets.all(20.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Form(
                child: TextFormField(
                  controller: modify_controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "在这里输入要修改的名单"),
                  maxLines: 3,
                ),
              ),
              Text(
                "注:名字之间用中文逗号隔开，修改之后保存才可生效",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.red,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 50,
                      child: RaisedButton(
                        child: Text('保存'),
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {
                          print("修改名单");
                          sendMessage_modify();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendMessage_modify() {
    wschannel.sink.add(
        {'"type"': '"modify"', '"data"': '"' + modify_controller.text + '"'});
  }
}
