import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/place.dart';
import '../helpers/db_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(
    String pickedTitle,
    File pickedImage,
  ) {
    final newPlace = Place(
      id: DateTime.now().toIso8601String(),
      image: pickedImage,
      title: pickedTitle,
      locaion: null,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map((map) => Place(
              id: map['id'],
              title: map['title'],
              image: File(map['image']),
              locaion: null,
            ))
        .toList();
    notifyListeners();
  }
}
