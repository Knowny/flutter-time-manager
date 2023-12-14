import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

class DurationAdapter extends TypeAdapter<Duration> {
  @override
  final int typeId = 1;

  @override
  Duration read(BinaryReader reader) {
    final seconds = reader.readInt();
    return Duration(seconds: seconds);
  }

  @override
  void write(BinaryWriter writer, Duration duration) {
    writer.writeInt(duration.inSeconds);
  }
}

class MaterialColorAdapter extends TypeAdapter<MaterialColor> {
  @override
  final int typeId = 0;

  @override
  MaterialColor read(BinaryReader reader) {
    final value = reader.readInt();
    return Colors.primaries[value];
  }

  @override
  void write(BinaryWriter writer, MaterialColor color) {
    writer.writeInt(Colors.primaries.indexOf(color));
  }
}
