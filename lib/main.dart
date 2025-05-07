import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:js' as js;
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:marquee/marquee.dart';

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
  final List<int> _columnRatios = [5, 3, 9, 16]; // 時刻、路線番号、行先、経由の比率
  int _textIndex = 0; // テキスト切り替え用インデックス

  // セルテキスト用の共通スタイルを定義
  final TextStyle cellTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 105,
    fontWeight: FontWeight.normal,
    shadows: [
      Shadow(blurRadius: 2.0, color: Colors.black, offset: Offset(1.0, 1.0)),
    ],
    height: 1,
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
    
    // テキスト切り替えタイマーを設定
    Future.delayed(Duration.zero, () {
      _startTextSwitchTimer();
    });
  }
  
  void _startTextSwitchTimer() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _textIndex = (_textIndex + 1) % 2;
        });
        _startTextSwitchTimer();
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
        color: Colors.black,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: _columnRatios[0],
                          child: Container(
                            child: Center(
                              child: Padding(
                                // padding: EdgeInsets.only(left: 60),
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  '11:56',
                                  style: cellTextStyle,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: _columnRatios[1],
                          child: Container(
                            padding: EdgeInsets.all(5),
                            // color: Colors.green.shade900,
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.yellow,
                                    width: 10,
                                  ),
                                ),
                                margin: EdgeInsets.zero,
                                // padding: EdgeInsets.all(5),
                                width: double.infinity,
                                height: double.infinity,
                                child: Center(
                                  child: Stack(
                                    children: [
                                      Container(
                                        // color: Colors.red,
                                        child: Center(
                                          child: Text(
                                            '94',
                                            // style: cellTextStyle,
                                            style: cellTextStyle.copyWith(
                                              color: Colors.black,
                                              // fontWeight: FontWeight.bold,
                                              // 縁取り
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: _columnRatios[2],
                          child: Container(
                            // color: Colors.blue.shade900,
                            child: Center(
                              child: Text('金沢駅', style: cellTextStyle),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: _columnRatios[3],
                          child: Container(
                            // color: Colors.yellow.shade900,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  "旭町経由",
                                  style: cellTextStyle.copyWith(
                                    color: Colors.lightBlueAccent,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: _columnRatios[0],
                          child: Container(
                            // color: Colors.yellow.shade700,
                            child: Center(
                              child: Marquee(
                                text: "若松からの停車停留所:若松西 若松橋 旭町 旭町口 田井町 桜町から 兼六園下 香林坊 武蔵ヶ辻 経由 金沢駅東口まで                                                ",
                                style: cellTextStyle,
                                scrollAxis: Axis.horizontal,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                blankSpace: 50.0,
                                velocity: 200.0,
                                pauseAfterRound: Duration.zero,
                                showFadingOnlyWhenScrolling: true,
                                fadingEdgeStartFraction: 0.1,
                                fadingEdgeEndFraction: 0.1,
                                startPadding: 10.0,
                                accelerationDuration: Duration(seconds: 1),
                                accelerationCurve: Curves.linear,
                                decelerationDuration: Duration(milliseconds: 500),
                                decelerationCurve: Curves.easeOut,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: _columnRatios[0],
                          child: Container(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(right: 0),
                                child: Text(
                                  '12:13',
                                  style: cellTextStyle,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: _columnRatios[1],
                          child: Container(
                            // color: Colors.green.shade500,
                            child: Center(
                              child: Text('', style: cellTextStyle),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: _columnRatios[2],
                          child: Container(
                            // color: Colors.blue.shade500,
                            child: Center(
                              child: Text('田井町', style: cellTextStyle),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: _columnRatios[3],
                          child: Container(
                            // color: Colors.yellow.shade500,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 0),
                                  child: _textIndex == 0 
                                    ? Text(
                                        '旭町経由',
                                        key: const ValueKey('text1'),
                                        style: cellTextStyle.copyWith(
                                          color: Colors.lightBlueAccent,
                                        ),
                                        textAlign: TextAlign.left,
                                      )
                                    : Marquee(
                                        key: const ValueKey('scrolling_text'),
                                        text: '旭町で金沢駅方面のりつぎ',
                                        style: cellTextStyle.copyWith(
                                          color: Colors.white,
                                        ),
                                        scrollAxis: Axis.horizontal,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        blankSpace: 50.0,
                                        velocity: 200.0,
                                        pauseAfterRound: Duration.zero,
                                        showFadingOnlyWhenScrolling: true,
                                        fadingEdgeStartFraction: 0.1,
                                        fadingEdgeEndFraction: 0.1,
                                        startPadding: 10.0,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: _columnRatios[0],
                          child: Container(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(right: 0),
                                child: Text(
                                  '12:16',
                                  style: cellTextStyle,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: _columnRatios[1],
                          child: Container(
                            padding: EdgeInsets.all(5),
                            // color: Colors.green.shade900,
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  // color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.yellow,
                                    width: 10,
                                  ),
                                ),
                                margin: EdgeInsets.zero,
                                // padding: EdgeInsets.all(5),
                                width: double.infinity,
                                height: double.infinity,
                                child: Center(
                                  child: Stack(
                                    children: [
                                      Container(
                                        // color: Colors.red,
                                        child: Center(
                                          child: Text(
                                            '93',
                                            // style: cellTextStyle,
                                            style: cellTextStyle.copyWith(
                                              color: Colors.yellow,
                                              // fontWeight: FontWeight.bold,
                                              // 縁取り
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: _columnRatios[2],
                          child: Container(
                            // color: Colors.blue.shade300,
                            child: Center(
                              child: Text('金沢駅', style: cellTextStyle),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: _columnRatios[3],
                          child: Container(
                            // color: Colors.yellow.shade300,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  '鈴見経由',
                                  style: cellTextStyle.copyWith(
                                    color: Colors.lightGreenAccent,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ), // 二層目のレ
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
          ],
        ),
      ),
    );
  }
}
