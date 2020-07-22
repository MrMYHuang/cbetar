enum ActionTypes {
  CHANGE_FONT_SIZE
}

class MyState {
  final Map<String, dynamic> state;

  MyState({this.state});
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
