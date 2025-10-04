import 'package:flutter/material.dart';
import 'package:flutter_api_helper/flutter_api_helper.dart';
import 'package:intl/intl.dart';
import 'package:photos_viewer/model/photo.dart';
import 'package:photos_viewer/screen/photo_detail_screen.dart';
import 'package:photos_viewer/utils/logger.dart';
import 'package:photos_viewer/widgets/photoslist_cell.dart';

void main() {
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
      home: const MyHomePage(title: 'Flutter Photos Viewer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<Photo>> fetchPhotos() async{
    List<Photo> photos = [];
    final data = await ApiHelper.get('/photos');
    for (var item in data) {
      photos.add(Photo.fromJson(item));
    }
    photos.sort((a, b) => a.location.compareTo(b.location));
    return photos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ApiBuilder<List<Photo>>(
        future: fetchPhotos(),
        builder: (photos) => ListView.builder(
          itemCount: photos.length,
          itemBuilder: (context, index) {
            final p = photos[index];
            final DateFormat dateFormat = DateFormat.yMMMMEEEEd().add_jms();
            logger.i("List item: ${p.id}, location is ${p.location}, created at ${p.createdAt.toString()}");
            return PhotosListCell(
              imageUrl: p.url,
              createTimeString: dateFormat.format(p.createdAt),
              author: p.createdBy,
              onTapEvent: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return PhotoDetailScreen(screenTitle: 'Detail', imageUrl: p.url, location: p.location, description: p.description?? "", createdBy: p.createdBy, createdTimeString: dateFormat.format(p.createdAt), takenAtString: dateFormat.format(p.takenAt));
                    },
                  ),
                );
              }
            );
          },
        ),
        loading: const Center(child: CircularProgressIndicator()),
        error: (error) => ErrorWidget('Failed to load photos: ${error.message}'),
        empty: const Center(child: Text('No Photo found')),
      ),

    );

  }
}
