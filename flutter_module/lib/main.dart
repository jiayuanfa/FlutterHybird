import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/services.dart';

void main() => runApp(const MyApp(initParams: ''));

/// Flutter与iOS、Android混编的通信实现
class MyApp extends StatelessWidget {
  final String? initParams;

  const MyApp({super.key, this.initParams});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 混合开发',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter 混合开发'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title = ''});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool _isMethodChannelPlugin = false;

  /// 初始化三种信息传递的Channel
  static const EventChannel _eventChannelPlugin =
      EventChannel('EventChannelPlugin');
  static const MethodChannel _methodChannelPlugin =
      MethodChannel('MethodChannelPlugin');
  static const BasicMessageChannel _basicMessageChannel =
      BasicMessageChannel('BasicMessageChannelPlugin', StringCodec());

  String showMessage = '';
  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    /// 添加EventChannel消息监听，接收从Native发来的消息
    _streamSubscription = _eventChannelPlugin
        .receiveBroadcastStream('123')
        .listen(_onToDart, onError: _onToDartError);

    /// 给BasicMessageChannel设置MessageHandler接受来自Native的消息，并向Native回复消息
    _basicMessageChannel.setMessageHandler((message) => Future<String?>(() {
          setState(() {
            showMessage = 'BasicMessageChannel:$message';
          });
          return '收到Native的消息:$message';
        }));
    super.initState();
  }

  @override
  void dispose() {
    /// 取消监听
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontSize: 20);
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.topLeft,
        decoration: const BoxDecoration(color: Colors.lightBlueAccent),
        margin: const EdgeInsets.only(top: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
              SwitchListTile(
                  value: _isMethodChannelPlugin,
                  onChanged: _onChanelChanged,
                title: Text(_isMethodChannelPlugin?"MethodChannelPlugin":"BasicMessageChannelPlugin"),
              ),
              TextField(
                onChanged: _onTextChange,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                ),
              ),
            Text(
              'Native 传来的数据:$showMessage',
              style: textStyle,
            )
          ],
        ),
      ),
    );
  }

  /// EventChannel从Native接收到的消息
  void _onToDart(message) {
    setState(() {
      showMessage = message;
    });
  }

  void _onChanelChanged(bool value) =>
      setState(() => _isMethodChannelPlugin = value);

  _onToDartError(error) {
    if (kDebugMode) {
      print(error);
    }
  }

  /// 监听文字输入框内容发生了改变
  /// 使用对应的ChannelPlugin插件发送输入框内的文字给Native
  void _onTextChange(value) async {
    String? response;
    try {
      if (_isMethodChannelPlugin) {
        //使用BasicMessageChannel向Native发送消息，并接受Native的回复
        response = await _methodChannelPlugin.invokeMethod('send', value);
      } else {
        response = await _basicMessageChannel.send(value);
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    /// 最后把Native回调回来的消息赋值给变量接收
    setState(() {
      showMessage = response ?? "";
    });
  }
}
