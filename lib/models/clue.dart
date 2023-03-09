import 'dart:convert';

class Clue {
  String id;
  int xCoord;
  int yCoord;
  String clueEasy;
  String clueHard;
  String hint;

  Clue({
    this.id = 'default-id',
    required this.xCoord,
    required this.yCoord,
    required this.clueEasy,
    required this.clueHard,
    required this.hint,
  });

  bool checkCoordinates(int xCoord, int yCoord) =>
      this.xCoord == xCoord && this.yCoord == yCoord;

  Clue copyWith({
    String? id,
    int? xCoord,
    int? yCoord,
    String? clueEasy,
    String? clueHard,
    String? hint,
  }) {
    return Clue(
      id: id ?? this.id,
      xCoord: xCoord ?? this.xCoord,
      yCoord: yCoord ?? this.yCoord,
      clueEasy: clueEasy ?? this.clueEasy,
      clueHard: clueHard ?? this.clueHard,
      hint: hint ?? this.hint,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'xCoord': xCoord,
      'yCoord': yCoord,
      'clueEasy': clueEasy,
      'clueHard': clueHard,
      'hint': hint,
    };
  }

  factory Clue.fromMap(Map<String, dynamic> map) {
    return Clue(
      id: map['id'] ?? '',
      xCoord: map['xCoord']?.toInt() ?? 0,
      yCoord: map['yCoord']?.toInt() ?? 0,
      clueEasy: map['clueEasy'] ?? '',
      clueHard: map['clueHard'] ?? '',
      hint: map['hint'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Clue.fromJson(String source) => Clue.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Clue(id: $id, xCoord: $xCoord, yCoord: $yCoord, clueEasy: $clueEasy, clueHard: $clueHard, hint: $hint)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Clue &&
        other.id == id &&
        other.xCoord == xCoord &&
        other.yCoord == yCoord &&
        other.clueEasy == clueEasy &&
        other.clueHard == clueHard &&
        other.hint == hint;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        xCoord.hashCode ^
        yCoord.hashCode ^
        clueEasy.hashCode ^
        clueHard.hashCode ^
        hint.hashCode;
  }
}
