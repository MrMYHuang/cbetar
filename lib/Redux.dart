import 'package:cbetar/Bookmark.dart';
import 'package:redux/redux.dart';

import 'Utilities.dart';

late Store<AppState> store;

enum ActionTypes {
  CHANGE_FONT_SIZE,
  CHANGE_LIST_FONT_SIZE,
  CHANGE_DARK_MODE,
  CHANGE_COMMENT_MODE,
  ADD_BOOKMARK,
  DEL_BOOKMARK,
  DEL_BOOKMARKS, // Delete bookmarks of one file.
}

AppState reducer(AppState state, dynamic action) {
  var newState = AppState.copyWith(state);
  switch (action.type) {
    case ActionTypes.CHANGE_FONT_SIZE:
      newState.fontSize = action.value;
      break;
    case ActionTypes.CHANGE_LIST_FONT_SIZE:
      newState.listFontSize = action.value;
      break;
    case ActionTypes.CHANGE_DARK_MODE:
      newState.darkMode = action.value;
      break;
    case ActionTypes.CHANGE_COMMENT_MODE:
      newState.showComments = action.value;
      break;
    case ActionTypes.ADD_BOOKMARK:
      final bookmarkNew = action.value['bookmark'] as Bookmark;
      switch (bookmarkNew.type) {
        case BookmarkType.CATALOG:
          break;
        case BookmarkType.WORK:
          break;
        case BookmarkType.JUAN:
          saveFile(action.value['fileName'], action.value['htmlStr']);
          break;
      }
      var bookmarksNew = new List<Bookmark>.from(state.bookmarks);
      bookmarksNew.add(bookmarkNew);
      newState.bookmarks = bookmarksNew;
      break;
    case ActionTypes.DEL_BOOKMARK:
      var bookmarksNew = new List<Bookmark>.from(state.bookmarks);
      switch (action.value['type']) {
        case BookmarkType.CATALOG:
          bookmarksNew.removeWhere((e) =>
              e.type == BookmarkType.CATALOG &&
              e.fileName == action.value['fileName']);
          break;
        case BookmarkType.WORK:
          bookmarksNew.removeWhere((e) =>
              e.type == BookmarkType.WORK &&
              e.work?.work == action.value['work']);
          break;
        case BookmarkType.JUAN:
          bookmarksNew.removeWhere((e) =>
              e.type == BookmarkType.JUAN && e.uuid == action.value['uuid']);

          try {
            bookmarksNew.firstWhere(
                (element) => element.fileName == action.value['fileName']);
          } catch (e) {
            // Delete the file if no bookmark anymore.
            delFile(action.value['fileName']);
          }
          break;
      }
      newState.bookmarks = bookmarksNew;
      break;
    case ActionTypes.DEL_BOOKMARKS:
      var bookmarksNew = new List<Bookmark>.from(state.bookmarks);
      bookmarksNew.removeWhere(
          (element) => element.fileName == action.value['fileName']);
      newState.bookmarks = bookmarksNew;
      break;
  }
  return newState;
}

class AppState {
  double fontSize;
  double listFontSize;
  bool darkMode;
  bool showComments;
  List<Bookmark> bookmarks;

  AppState(
      {this.fontSize = 32,
      this.listFontSize = 32,
      this.darkMode = true,
      this.showComments = false,
      this.bookmarks = const []});

  static AppState copyWith(AppState orig) => AppState(
      fontSize: orig.fontSize,
      listFontSize: orig.listFontSize,
      darkMode: orig.darkMode,
      showComments: orig.showComments,
      bookmarks: List.from(orig.bookmarks));

  static AppState fromJson(dynamic json) {
    if (json != null) {
      final bookmarksNew = (json['bookmarks'] as List<dynamic>)
          .map((e) => Bookmark.fromJson(e))
          .toList();
      return AppState(
          fontSize: json['fontSize'],
          listFontSize: json['listFontSize'] ?? 32,
          darkMode: json['darkMode'] ?? true,
          showComments: json['showComments'] ?? false,
          bookmarks: bookmarksNew);
    } else {
      return AppState();
    }
  }

  dynamic toJson() => {
        'fontSize': fontSize,
        'listFontSize': listFontSize,
        'darkMode': darkMode,
        'showComments': showComments,
        'bookmarks': bookmarks
      };
}

class MyViewModel {
  final Map<String, dynamic> state;
  final void Function(double value) onChanged;

  MyViewModel(this.state, this.onChanged);
}

class MyActions {
  final ActionTypes type;
  final dynamic value;

  MyActions({required this.type, required this.value});
}
