import 'package:flutter/material.dart';

import '../models/clue.dart';
import '../services/beacon_service.dart';
import '../services/time_service.dart';

class HomeProvider extends ChangeNotifier {
  List<Clue> _cluesCollected = [];
  Clue _selectedClue = Clue(
    clueEasy: 'Scan your first clue to have it appear here.',
    clueHard: 'Scan your first clue to have it appear here.',
    xCoord: 0,
    yCoord: 0,
    hint: 'Tap the \'Scan QR\' button below to scan your first clue.',
  );
  String _latestClue = '', _hint = "";

  DateTime _startTime = DateTime.parse("2022-03-25 12:00:00"),
      _endTime = DateTime.parse("2022-03-25 16:00:00");

  int _hintsLeft = 3, _scansLeft = 3;

  refreshHomeScreen() {
    BeaconService.getCurrentBeacons().then(
      (data) {
        if (data.isNotEmpty) {
          _latestClue = data['beacon']['currentBeacon']['clue'];
          _cluesCollected = data['beacon']['capturedBeacons']
              .map<Clue>(
                (beaconMap) => Clue.fromMap(
                  beaconMap['beacon'],
                ),
              )
              .toList();
          _hintsLeft = data['hintsLeft'] ?? 0;
          _hint = data["hint"] ?? "";
          _scansLeft = data["scansLeft"] ?? 0;
          jumpToLatest();
        } else {
          _selectedClue = Clue(
            clueEasy: 'Error fetching your clues.',
            clueHard: 'Error fetching your clues.',
            xCoord: 0,
            yCoord: 0,
            hint: 'Error fetching your clues.',
          );
        }
      },
    );

    TimeService.getTime().then(
      (value) {
        if (value['start'] != null && value['end'] != null) {
          setTime(value['start'], value['end']);
        }
      },
    );
  }

  selectClue(Clue toSelect) {
    _selectedClue = toSelect;
    notifyListeners();
  }

  jumpToLatest() {
    _selectedClue = _selectedClue.copyWith(
      clueEasy: _latestClue,
      clueHard: _latestClue,
      hint: _hint,
    );
    notifyListeners();
  }

  setTime(int startTime, int endTime) {
    _startTime = DateTime.fromMillisecondsSinceEpoch(startTime);
    _endTime = DateTime.fromMillisecondsSinceEpoch(endTime);
  }

  Clue get selectedClue => _selectedClue;

  List<Clue> get cluesCollected => _cluesCollected;

  String get latestClue => _latestClue;

  String get clueToDisplay => _cluesCollected.indexOf(_selectedClue) > 5
      ? _selectedClue.clueHard
      : _selectedClue.clueEasy;

  DateTime get startTime => _startTime;

  DateTime get endTime => _endTime;

  int get hintsLeft => _hintsLeft;

  int get scansLeft => _scansLeft;
}
