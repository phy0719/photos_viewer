import 'package:flutter/cupertino.dart';
import 'package:flutter_api_helper/flutter_api_helper.dart';
import 'package:intl/intl.dart';
import 'package:photos_viewer/utils/logger.dart';
import 'package:photos_viewer/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/photo.dart';

class PhotosModel extends ChangeNotifier{
  static PhotosModel get shared => getIt.get<PhotosModel>();

  SharedPreferences? _sharedPreferences;
  final String _baseUrl = 'https://api.json-generator.com/templates';
  final String _photosUrlPath = '/IKlaYT4D44DX/data';
  final String _refreshPhotosUrlPath = '/TxtWlKQr4IQe/data';
  String _refreshingPath = '';

  DateFormat get dateFormat => DateFormat.yMMMMEEEEd().add_jms();
  String get prefKeyFavoriteIds => 'savedIds';

  late List<Photo> _photos = [];
  List<Photo> get photos => _photos;

  late List<Photo> _searchingList = [];
  List<Photo> get searchingList => _searchingList;

  late List<String> _locations = [];
  List<String> get locations => _locations;

  late List<String> _favoriteIds = [];
  List<String> get favoriteIds => _favoriteIds;

  late List<Photo> _favoriteList = [];
  List<Photo> get favoriteList => _favoriteList;

  init() async {
    // 🔧 Configure once, use everywhere
    ApiHelper.configure(
       ApiConfig(
        baseUrl: _baseUrl,
        enableLogging: true,
        getToken: () async {
          return 'ee7lnsi9j3p135tq7bwntvzwx71ikuhys81lnrgp';
        },
        timeout: const Duration(seconds: 30),
        // 🧠 Smart caching out of the box
        cacheConfig: const CacheConfig(duration: Duration(minutes: 5)),
        // 🔄 Auto-retry with exponential backoff
        retryConfig: const RetryConfig(maxRetries: 3),
      ),
    );

    _sharedPreferences ??= await getSharedPreferences();

    await fetchPhotos(_photosUrlPath);

    getFavoriteListData();
  }

  Future<SharedPreferences> getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  // get Photos Result from API call
  fetchPhotos(String apiUrl) async{
    final data = await ApiHelper.get(apiUrl);
    _photos = [];
    for (var item in data) {
      _photos.add(Photo.fromJson(item));
    }
    _photos.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });

    // construct useful data list
    updateLocationAndPhotosMappingData();
    resetSearchingList(false);
  }

  refreshFetchPhotos() async {
    _refreshingPath = _refreshingPath == _refreshPhotosUrlPath? _photosUrlPath : _refreshPhotosUrlPath;
    await fetchPhotos(_refreshingPath);
  }

  updateLocations(){
    // Get different locations from photos
    _locations = []; //initial with empty map
    for (var item in _photos) {
      if (_locations.where((l) => item.location == l).isEmpty) _locations.add(item.location);
    }
  }

  updateLocationAndPhotosMappingData() {
    updateLocations();
    notifyListeners();
  }

  resetSearchingList(bool shouldNotify) {
    _searchingList = _photos; //initial it contains all of the photos as the result set
    if (shouldNotify) notifyListeners();
  }

  searchPhotos(String keywords) {
    List<Photo> result = [];
    for (var p in _photos) {
      if (keywords.isEmpty || p.location.toUpperCase().contains(keywords.toUpperCase()) || p.createdBy.toUpperCase().contains(keywords.toUpperCase())){
        result.add(p);
      }
    }
    _searchingList = result;
    notifyListeners();
  }

  Future<List<String>> getFavoriteIds() async {
    _sharedPreferences ??= await getSharedPreferences();
    return _sharedPreferences!.getStringList(prefKeyFavoriteIds)?? [];
  }

  updateFavoriteIds(bool isFavorite, String id) async {
    // logger.i('PhotosModel:updateFavoriteIds isFavorite? $isFavorite');
    List<String> saved = await getFavoriteIds();
    if (isFavorite) {
      if (!saved.contains(id)) saved.add(id);
    } else {
      saved.remove(id);
    }

    // Save an list of strings to 'items' key.
    _sharedPreferences ??= await getSharedPreferences();
    _sharedPreferences!.setStringList(prefKeyFavoriteIds, saved);
  }

  getFavoriteListData() async {
    _favoriteList = [];
    _favoriteIds = await getFavoriteIds();
    for (var p in _photos) {
      if (_favoriteIds.contains(p.id)) _favoriteList.add(p);
    }
  }

  updateAllFavoriteDataOnChangeIsFavorite(bool isFavorite, String pId) async {
    await updateFavoriteIds(isFavorite, pId);
    await getFavoriteListData();
    notifyListeners();
  }

}