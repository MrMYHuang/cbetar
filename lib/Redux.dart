import 'package:cbetar/Boormark.dart';
import 'package:redux/redux.dart';

Store store;

enum ActionTypes {
  CHANGE_FONT_SIZE,
  ADD_BOOKMARK,
  DEL_BOOKMARK
}

AppState reducer(AppState state, dynamic action) {
  switch(action.type) {
    case ActionTypes.CHANGE_FONT_SIZE:
      return AppState(fontSize: action.value, bookmarks: state.bookmarks);
    case ActionTypes.ADD_BOOKMARK:
      var bookmarksNew = new List<Bookmark>.from(state.bookmarks);
      bookmarksNew.add(action.value);
      return AppState(fontSize: state.fontSize, bookmarks: bookmarksNew);
    case ActionTypes.DEL_BOOKMARK:
      var bookmarksNew = new List<Bookmark>.from(state.bookmarks);
      bookmarksNew.removeWhere((element) => element.uuid == action.value);
      return AppState(fontSize: state.fontSize, bookmarks: bookmarksNew);
    default:
      return state;
  }
}

class AppState {
  final double fontSize;
  final List<Bookmark> bookmarks;

  AppState({this.fontSize = 32, this.bookmarks = const []});

  AppState copyWith({double fontSize}) =>
      AppState(fontSize: fontSize ?? this.fontSize);

  static AppState fromJson(dynamic json) {
    if (json != null) {
      final bookmarksNew = (json['bookmarks'] as List<dynamic>).map((e) => Bookmark.fromJson(e)).toList();
      return AppState(fontSize: json['fontSize'], bookmarks: bookmarksNew);
    } else {
      return AppState();
    }
  }

  dynamic toJson() => {'fontSize': fontSize, 'bookmarks': bookmarks};
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
