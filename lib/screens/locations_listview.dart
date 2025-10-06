import 'package:flutter/material.dart';
import 'package:photos_viewer/widgets/photos_list_component.dart';
import '../model/photo.dart';

class LocationsListView extends StatefulWidget {
  final List<String> locations;
  final Map<String, List<Photo>> photosByLocation; // to store the photos by different location

  const LocationsListView({super.key, required this.locations, required this.photosByLocation});

  @override
  State<StatefulWidget> createState() => _LocationsExpandedTileListScreen();

}

class _LocationsExpandedTileListScreen extends State<LocationsListView> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
            child: Column(
              children: [
                //display the location name as the section title
                for (var l in widget.locations)
                  ExpansionTile(
                    title: Text(l, style: const TextStyle(fontWeight: FontWeight.bold)),
                    //display the location section index and number of photos in each section with the handle of plural
                    subtitle: Text('This location contains ${widget.photosByLocation[l]?.length} photo${(widget.photosByLocation[l] != null && widget.photosByLocation[l]!.length > 1)? 's.':'.' }'),
                    children: [
                      PhotosListComponents(photos: widget.photosByLocation[l]??[])
                    ],
                  )
              ],
            ),
          );
  }

}