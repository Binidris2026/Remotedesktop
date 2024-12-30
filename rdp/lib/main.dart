import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

void main()=> runApp(RemoteDesktopApp());


class RemoteDesktopApp extends StatelessWidget {
  final WebSocketChannel channel  = IOWebSocketChannel.connect(
      'wss://fa73-154-74-127-172.ngrok-free.app:4000');
  RemoteDesktopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RemoteDesktopScreen(channel: channel)
    );
  }
}

class RemoteDesktopScreen extends StatefulWidget {
  final WebSocketChannel channel;

  const RemoteDesktopScreen({super.key, required this.channel});

  @override
  State createState() => _RemoteDesktopScreenState();
}

class _RemoteDesktopScreenState extends State<RemoteDesktopScreen> {
  String output = '';
  String? imagePath;

  void _requestScreen() async{
  
  }

  @override
  void initState() {
    super.initState();
    widget.channel.stream.listen((data) {
      setState(() {
        if (data.endsWith('.png')) {
          imagePath = data;
        } else {
          output = data;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Remote Desktop App"),),
      body: Column(
        children: [
          ElevatedButton(onPressed:() async{
            _requestScreen();
          }, child: Text('Request Screen'),),
          if (imagePath != null) Image.network('https://fa73-154-74-127-172.ngrok-free.app/$imagePath'),
          Text(output),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.channel.sink.close(status.goingAway);
    super.dispose();
  }
}
