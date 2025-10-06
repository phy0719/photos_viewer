import 'package:flutter_api_helper/flutter_api_helper.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/photo.dart';
import 'logger.dart';

final DateFormat dateFormat = DateFormat.yMMMMEEEEd().add_jms();
List<String> favoriteIds = [];
// get Photos Result from API call
Future<List<Photo>> fetchPhotos() async{
  List<Photo> photos = [];
  final data = await ApiHelper.get('/photos');
  for (var item in data) {
    photos.add(Photo.fromJson(item));
  }
  photos.sort((a, b) {
    int cmp = a.location.compareTo(b.location);
    if (cmp != 0) return cmp;
    return b.createdAt.compareTo(a.createdAt);
  });
  return photos;
}

List<String> getLocation(List<Photo> photos){
  // Get different locations from photos
  List<String> locationsList = []; //initial with empty map
  for (var item in photos) {
    if (locationsList.where((l) => item.location == l).isEmpty) locationsList.add(item.location);
  }
  return locationsList;
}

Map<String, List<Photo>> getPhotosByLocation({required List<Photo> photos, required List<String> locationsList}) {
  //To assign the photos according to location
  Map<String, List<Photo>> photosList = {}; //initial with empty map
  for (var l in locationsList) {
    photosList[l] = [];
    for (var p in photos) {
      if (p.location == l) photosList[l]?.add(p);
    }
  }
  return photosList;
}

updateFavoriteIds(bool isFavorite, String id) async {
  logger.i('updateFavoriteIds: isFavorite? $isFavorite');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> saved = prefs.getStringList('savedIds')??[];
  if (isFavorite) {
    if (!favoriteIds.contains(id)) saved.add(id);
  } else {
    saved.remove(id);
  }
  // Save an list of strings to 'items' key.
  await prefs.setStringList('savedIds', saved);
  favoriteIds = saved;
}