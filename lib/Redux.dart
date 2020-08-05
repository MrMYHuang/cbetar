import 'package:cbetar/Bookmark.dart';
import 'package:redux/redux.dart';

import 'Utilities.dart';

Store store;

enum ActionTypes {
  CHANGE_FONT_SIZE,
  CHANGE_DARK_MODE,
  ADD_BOOKMARK,
  DEL_BOOKMARK,
  DEL_BOOKMARKS, // Delete bookmarks of one file.
}

AppState reducer(AppState state, dynamic action) {
  var newState = AppState.copyWith(state);
  switch(action.type) {
    case ActionTypes.CHANGE_FONT_SIZE:
      newState.fontSize = action.value; break;
    case ActionTypes.CHANGE_DARK_MODE:
      newState.darkMode = action.value; break;
    case ActionTypes.ADD_BOOKMARK:
      saveFile(action.value['fileName'], action.value['htmlStr']);
      var bookmarksNew = new List<Bookmark>.from(state.bookmarks);
      bookmarksNew.add(action.value['bookmark']);
      newState.bookmarks = bookmarksNew; break;
    case ActionTypes.DEL_BOOKMARK:
      var bookmarksNew = new List<Bookmark>.from(state.bookmarks);
      bookmarksNew.removeWhere((element) => element.uuid == action.value['uuid']);

      try {
        bookmarksNew.firstWhere((element) => element.fileName == action.value['fileName']);
      } catch (e) {
        // Delete the file if no bookmark anymore.
        delFile(action.value['fileName']);
      }
      newState.bookmarks = bookmarksNew; break;
    case ActionTypes.DEL_BOOKMARKS:
      var bookmarksNew = new List<Bookmark>.from(state.bookmarks);
      bookmarksNew.removeWhere((element) => element.fileName == action.value['fileName']);
      newState.bookmarks = bookmarksNew; break;
  }
  return newState;
}

class AppState {
  double fontSize;
  bool darkMode;
  List<Bookmark> bookmarks;

  AppState({this.fontSize = 32, this.darkMode = true, this.bookmarks = const []});

  static AppState copyWith(AppState orig) =>
      AppState(fontSize: orig.fontSize, darkMode: orig.darkMode, bookmarks: List.from(orig.bookmarks));

  static AppState fromJson(dynamic json) {
    if (json != null) {
      final bookmarksNew = (json['bookmarks'] as List<dynamic>).map((e) => Bookmark.fromJson(e)).toList();
      return AppState(fontSize: json['fontSize'], darkMode: json['darkMode'] ?? true, bookmarks: bookmarksNew);
    } else {
      return AppState();
    }
  }

  dynamic toJson() => {'fontSize': fontSize, 'darkMode': darkMode, 'bookmarks': bookmarks};
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
