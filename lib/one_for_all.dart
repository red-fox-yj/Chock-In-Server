import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/html.dart';

StreamBuilder md;
TextEditingController controller = TextEditingController();
TextEditingController controller_ = TextEditingController();
TextEditingController modify_controller = TextEditingController();
WebSocketChannel wschannel =
    HtmlWebSocketChannel.connect('ws://81.69.7.50:8000/ws');
var temp_snapshot = null;

class one_for_all extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
