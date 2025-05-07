import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:js' as js;
import 'dart:html' as html;
import 'dart:ui' as ui;

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
      appBar: _isFullScreen ? null : AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('画面解像度'),
      ),
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${width.toInt()} x ${height.toInt()}',
                style: const TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'ピクセル比: $pixelRatio',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                '物理ピクセル: ${(width * pixelRatio).toInt()} x ${(height * pixelRatio).toInt()}',
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _toggleFullScreen,
                icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                label: Text(_isFullScreen ? '全画面解除' : '全画面表示'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
