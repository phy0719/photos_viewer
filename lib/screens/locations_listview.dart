import 'package:flutter/material.dart';
import 'package:photos_viewer/appModel/photos_model.dart';
import 'package:photos_viewer/widgets/photos_list_component.dart';

import '../model/photo.dart';
import '../utils/utils.dart';

class LocationsListView extends StatefulWidget {
  const LocationsListView({super.key});

  @override
  State<StatefulWidget> createState() => _LocationsExpandedTileListScreen();

}

class _LocationsExpandedTileListScreen extends State<LocationsListView> {
  List<String> _locations = [];

  updateUI() {
    // logger.i('_LocationsExpandedTileListScreen:updateUI');
    if (mounted) {
      setState(() {
        _locations = PhotosModel.shared.locations;
      });
    }
  }

  @override
  void initState() {
    _locations = PhotosModel.shared.locations;
    PhotosModel.shared.addListener(updateUI);
    super.initState();
  }

  @override
  void dispose() {
    PhotosModel.shared.removeListener(updateUI);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getIt.allReady(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: _locations.length,
                itemBuilder: (BuildContext context, int index) {
                  List<Photo> photosInLocation = PhotosModel.shared.photos.where((element) => element.location == _locations[index]).toList();
                  return ExpansionTile(
                    title: Text(_locations[index], style: const TextStyle(fontWeight: FontWeight.bold)),
                    //display the location section index and number of photos in each section with the handle of plural
                    subtitle: Text('This location contains ${photosInLocation.length} photo${(photosInLocation.length > 1)? 's.':'.' }'),
                      children: [
                        PhotosListComponents(photos: photosInLocation)
                      ],
                  );
                },
              );
          } else {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Waiting for initialisation'),
                SizedBox(height: 16),
                CircularProgressIndicator(),
              ],
            );
          }
        });

  }

}