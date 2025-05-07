import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:js' as js;
import 'dart:html' as html;
import 'dart:ui' as ui;

// 1920x540

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '画面解像度表示',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ResolutionDisplayPage(),
    );
  }
}

class ResolutionDisplayPage extends StatefulWidget {
  const ResolutionDisplayPage({super.key});

  @override
  State<ResolutionDisplayPage> createState() => _ResolutionDisplayPageState();
}

class _ResolutionDisplayPageState extends State<ResolutionDisplayPage> {
  bool _isFullScreen = false;
  bool _buttonVisible = true; // ボタンの表示状態を管理
  // 横分割の比率を設定するリスト
  final List<int> _columnRatios = [5, 3, 7, 18]; // 時刻、路線番号、行先、経由の比率

  // セルテキスト用の共通スタイルを定義
  final TextStyle cellTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 105,
    fontWeight: FontWeight.normal,
    shadows: [
      Shadow(
        blurRadius: 2.0,
        color: Colors.black,
        offset: Offset(1.0, 1.0),
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    // フルスクリーン状態の変化を検知するリスナーを追加
    html.document.onFullscreenChange.listen((_) {
      final isCurrentlyFullScreen = html.document.fullscreenElement != null;
      if (_isFullScreen != isCurrentlyFullScreen) {
        setState(() {
          _isFullScreen = isCurrentlyFullScreen;
        });
      }
    });
  }

  void _toggleFullScreen() {
    if (!_isFullScreen) {
      _requestFullscreen();
    } else {
      _exitFullscreen();
    }
    // ボタンを押したら非表示にする
    setState(() {
      _buttonVisible = false;
    });
  }

  void _requestFullscreen() {
    final element = html.document.documentElement;
    if (element != null) {
      // 各ブラウザに対応したFullscreen API呼び出し
      if (element.requestFullscreen != null) {
        element.requestFullscreen();
      }
    }
  }

  void _exitFullscreen() {
    if (html.document.exitFullscreen != null) {
      html.document.exitFullscreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (_buttonVisible)
                    ElevatedButton.icon(
                      onPressed: _toggleFullScreen,
                      icon: const Icon(Icons.fullscreen),
                      label: const Text('全画面表示'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              // 横三分割から縦三分割に変更
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(flex: _columnRatios[0], child: Container(
                          color: Colors.red.shade900,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Text('9:05', style: cellTextStyle),
                            ),
                          ),
                        )),
                        Expanded(flex: _columnRatios[1], child: Container(
                          color: Colors.green.shade900,
                          child: Center(child: Text('94', style: cellTextStyle)),
                        )),
                        Expanded(flex: _columnRatios[2], child: Container(
                          color: Colors.blue.shade900,
                          child: Center(child: Text('金沢駅', style: cellTextStyle)),
                        )),
                        Expanded(flex: _columnRatios[3], child: Container(
                          color: Colors.yellow.shade900,
                          child: Center(child: Text("<旭町経由>", style: cellTextStyle)),
                        )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(flex: _columnRatios[0], child: Container(
                          color: Colors.yellow.shade700,
                          child: Center(
                            child: Text(
                              "若松からの停車停留所:若松西 若松橋 旭町 旭町口 田井町 桜町から 兼六園下 香林坊 武蔵ヶ辻 経由 金沢駅東口まで", 
                              style: cellTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(flex: _columnRatios[0], child: Container(
                          color: Colors.red.shade500,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Text('11:00', style: cellTextStyle),
                            ),
                          ),
                        )),
                        Expanded(flex: _columnRatios[1], child: Container(
                          color: Colors.green.shade500,
                          child: Center(child: Text('', style: cellTextStyle)),
                        )),
                        Expanded(flex: _columnRatios[2], child: Container(
                          color: Colors.blue.shade500,
                          child: Center(child: Text('田井町', style: cellTextStyle)),
                        )),
                        Expanded(flex: _columnRatios[3], child: Container(
                          color: Colors.yellow.shade500,
                          child: Center(child: Text('<旭町経由>', style: cellTextStyle)),
                        )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(flex: _columnRatios[0], child: Container(
                          color: Colors.red.shade300,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Text('18:32', style: cellTextStyle),
                            ),
                          ),
                        )),
                        Expanded(flex: _columnRatios[1], child: Container(
                          color: Colors.green.shade300,
                          child: Center(child: Text('93', style: cellTextStyle)),
                        )),
                        Expanded(flex: _columnRatios[2], child: Container(
                          color: Colors.blue.shade300,
                          child: Center(child: Text('金沢駅', style: cellTextStyle)),
                        )),
                        Expanded(flex: _columnRatios[3], child: Container(
                          color: Colors.yellow.shade300,
                          child: Center(child: Text('[鈴見経由]', style: cellTextStyle)),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ), // 二層目のレイヤー（必要に応じて内容を追加可能）
          ],
        ),
      ),
    );
  }
}
