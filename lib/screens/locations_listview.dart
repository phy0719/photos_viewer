import 'package:flutter/material.dart';
import 'package:photos_viewer/appModel/photos_model.dart';
import 'package:photos_viewer/utils/logger.dart';
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
  Map<String, List<Photo>> _photosByLocations = {};

  updateUI() {
    // logger.i('_LocationsExpandedTileListScreen:updateUI');
    if (mounted) {
      setState(() {
        _locations = PhotosModel.shared.locations;
        _photosByLocations = PhotosModel.shared.photosLocationMappingList;
      });
    }
  }

  @override
  void initState() {
    _locations = PhotosModel.shared.locations;
    _photosByLocations = PhotosModel.shared.photosLocationMappingList;
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  //display the location name as the section title
                  for (var l in _locations)
                    ExpansionTile(
                      title: Text(l, style: const TextStyle(fontWeight: FontWeight.bold)),
                      //display the location section index and number of photos in each section with the handle of plural
                      subtitle: Text('This location contains ${_photosByLocations[l]?.length} photo${(_photosByLocations[l] != null && _photosByLocations[l]!.length > 1)? 's.':'.' }'),
                      children: [
                        PhotosListComponents(photos: _photosByLocations[l]??[])
                      ],
                    )
                ],
              ),
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