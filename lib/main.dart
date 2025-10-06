import 'package:flutter/material.dart';
import 'package:flutter_api_helper/flutter_api_helper.dart';
import 'package:photos_viewer/model/photo.dart';
import 'package:photos_viewer/screens/home_screen.dart';
import 'package:photos_viewer/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  favoriteIds = prefs.getStringList('savedIds')?? [];
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return ApiBuilder<List<Photo>>(
      future: fetchPhotos(),
      builder: (photos) => MaterialApp(
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
        home: HomeScreen(screenTitle: 'Photos Viewer', photosList: photos) ,
      ),
      loading: const Center(child: CircularProgressIndicator()),
      error: (error) => ErrorWidget('Failed to load photos from api: ${error.message}'),
      empty: const Center(child: Text('No photos found')),
    );
  }
}

