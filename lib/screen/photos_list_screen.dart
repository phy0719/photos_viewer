import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photos_viewer/screen/photo_detail_screen.dart';

import '../model/photo.dart';
import '../widgets/photos_list_cell.dart';

class PhotosListScreen extends StatefulWidget {
  final List<Photo> photos;

  const PhotosListScreen({super.key, required this.photos});

  @override
  State<StatefulWidget> createState() => _PhotosListScreen();
}

class _PhotosListScreen extends State<PhotosListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat.yMMMMEEEEd().add_jms();
    return Column(
      children: [
        for (var p in widget.photos)
          PhotosListCell(
              imageUrl: p.url,
              subtitleString: 'Created at ${dateFormat.format(p.createdAt)}',
              titleString: 'Created by ${p.createdBy}',
              onTapEvent: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return PhotoDetailScreen(screenTitle: 'Detail', imageUrl: p.url, location: p.location, description: p.description?? "", createdBy: p.createdBy, createdTimeString: dateFormat.format(p.createdAt), takenAtString: dateFormat.format(p.takenAt));
                    },
                  ),
                );
              }
          )
      ],
    );
  }
  
}