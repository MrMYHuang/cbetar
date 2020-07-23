enum ActionTypes {
  CHANGE_FONT_SIZE
}

class AppState {
  final double fontSize;

  AppState({this.fontSize = 32});

  AppState copyWith({double fontSize}) =>
      AppState(fontSize: fontSize ?? this.fontSize);

  static AppState fromJson(dynamic json) {
    if (json != null) {
      return AppState(fontSize: json["fontSize"]);
    } else {
      return AppState();
    }
  }

  dynamic toJson() => {'fontSize': fontSize};
}


class MyViewModel {
  final Map<String, dynamic> state;
  final void Function(double value) onChanged;

  MyViewModel({this.state, this.onChanged});
}


class MyActions {
  final ActionTypes type;
  final dynamic value;

  MyActions({this.type, this.value});
}
