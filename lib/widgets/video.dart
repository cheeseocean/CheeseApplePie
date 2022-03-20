import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// 缩略的视频
class SmallPlayer extends StatefulWidget {
  final String path;
  final bool showIcon;

  const SmallPlayer(this.path, {Key? key, this.showIcon = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SmallPlayerState();
}

class _SmallPlayerState extends State<SmallPlayer> {
  final FijkPlayer player = FijkPlayer();

  @override
  void initState() {
    super.initState();
    player.setDataSource(widget.path, showCover: true);
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
    print('--------------------------------------------------------------------------------------------------------dispose'); // todo
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        player.enterFullScreen();
        player.start();
      },
      child: IgnorePointer(
        // 阻止点击事件防止视频溢出
        child: Stack(
          alignment: Alignment.center,
          children: [
            FijkView(
              fit: FijkFit.cover,
              player: player,
            ),
            widget.showIcon
                ? const Icon(
                    Icons.play_circle_outlined,
                    color: Colors.white,
                    size: 40,
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}

// 正常大小的视频
class NormalPlayer extends StatefulWidget {
  final String path;

  const NormalPlayer(this.path, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NormalPlayerState();
}

class NormalPlayerState extends State<NormalPlayer> {
  final FijkPlayer player = FijkPlayer();

  void pause() {
    player.pause();
  }

  @override
  void initState() {
    super.initState();
    player.setDataSource(widget.path, showCover: true);
  }

  @override
  void deactivate() {
    super.deactivate();
    player.release();
  }
  // @override
  // void dispose() {
  //   // super.dispose();
  //   player.release();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FijkView(
        fit: FijkFit.cover,
        player: player,
      ),
    );
  }
}
