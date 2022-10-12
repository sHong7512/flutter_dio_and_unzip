import 'package:flutter/material.dart';
import 'package:flutter_animator/animation/animation_preferences.dart';
import 'package:flutter_animator/animation/animator_play_states.dart';
import 'package:flutter_animator/widgets/attention_seekers/bounce.dart';

class DownloadIcon extends StatelessWidget {
  final EdgeInsetsGeometry edgeInsetsGeometry;
  final double size;
  final Color? color;

  const DownloadIcon({
    Key? key,
    required this.edgeInsetsGeometry,
    required this.size,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: edgeInsetsGeometry,
      child: Bounce(
          preferences: const AnimationPreferences(
            duration: Duration(milliseconds: 1000),
            autoPlay: AnimationPlayStates.Loop,
            magnitude: 0.1,
          ),
          child: Icon(
            Icons.download_sharp,
            size: size,
            color: color,
          )),
    );
  }
}
