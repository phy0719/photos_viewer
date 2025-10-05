import 'package:flutter/material.dart';
import 'package:flutter_api_helper/flutter_api_helper.dart';
import 'package:photos_viewer/model/photo.dart';
import 'package:photos_viewer/screen/locations_expanded_tilelist_screen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // 🔧 Configure once, use everywhere
  ApiHelper.configure(
    const ApiConfig(
      baseUrl: 'https://qchkdevhiring.blob.core.windows.net/mobile/api',
      enableLogging: true,
      timeout: Duration(seconds: 30),
      // 🧠 Smart caching out of the box
      cacheConfig: CacheConfig(duration: Duration(minutes: 5)),
      // 🔄 Auto-retry with exponential backoff
      retryConfig: RetryConfig(maxRetries: 3),
    ),
  );
  final List<Photo> photosList = await fetchPhotos();
  runApp(MyApp(photos: photosList));
}

Future<List<Photo>> fetchPhotos() async{
  List<Photo> photos = [];
  final data = await ApiHelper.get('/photos');
  for (var item in data) {
    photos.add(Photo.fromJson(item));
  }
  photos.sort((a, b) => a.location.compareTo(b.location));
  return photos;
}

class MyApp extends StatelessWidget {
  final List<Photo> photos;
  const MyApp({super.key, required this.photos});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){
    List<String> locationsList = [];
    for (var item in photos) {
      if (locationsList.where((l) => item.location == l).isEmpty) locationsList.add(item.location);
    }
    //To assign the photos according to location
    Map<String, List<Photo>> photosList = {};//initial with empty map
    for (var l in locationsList) {
      photosList[l] = [];
      for (var p in photos) {
        if (p.location == l) photosList[l]?.add(p);
      }
    }
    return MaterialApp(
      title: 'Flutter Photos Viewer',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LocationsExpandedTileListScreen(screenTitle: 'Photos Viewer', locations: locationsList, photosByLocation: photosList) ,
    );
  }
}

