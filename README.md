# FlutterHybird

# Flutter与Android项目混编
- Android工程中加载Flutter项目的方式
- Flutter与iOS混编
- Flutter与Android工程通信的三种方式 
## 初始化三种信息传递的Channel
-   static const EventChannel _eventChannelPlugin =
      EventChannel('EventChannelPlugin');
-   static const MethodChannel _methodChannelPlugin =
      MethodChannel('MethodChannelPlugin');
-   static const BasicMessageChannel _basicMessageChannel =
      BasicMessageChannel('BasicMessageChannelPlugin', StringCodec()); 
- iOS 项目基础：PCH文件、布局、懒加载
- Flutter项目与iOS项目通信
- Flutter与iOS端与Android端通信效果：
flutterAndAndroid.gif![image](https://user-images.githubusercontent.com/9419485/199454799-31d1f173-fa2e-47cc-9981-00300b9ea06b.png)
222.gif![image](https://user-images.githubusercontent.com/9419485/199454841-84debea0-d9ec-469f-9f71-1f3c478124fb.png)

