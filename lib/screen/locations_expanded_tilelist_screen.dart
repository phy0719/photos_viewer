import 'package:flutter/material.dart';
import 'package:photos_viewer/screen/photos_list_screen.dart';
import '../model/photo.dart';

class LocationsExpandedTileListScreen extends StatefulWidget {
  final String screenTitle;
  final List<String> locations;
  final Map<String, List<Photo>> photosByLocation; // to store the photos by different location

  const LocationsExpandedTileListScreen({super.key, required this.screenTitle, required this.locations, required this.photosByLocation});

  @override
  State<StatefulWidget> createState() => _LocationsExpandedTileListScreen();

}

class _LocationsExpandedTileListScreen extends State<LocationsExpandedTileListScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.screenTitle),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //display the location name as the section title
                for (var l in widget.locations)
                  ExpansionTile(
                    title: Text(l, style: const TextStyle(fontWeight: FontWeight.bold)),
                    //display the location section index and number of photos in each section with the handle of plural
                    subtitle: Text('This location contains ${widget.photosByLocation[l]?.length} photo${(widget.photosByLocation[l] != null && widget.photosByLocation[l]!.length > 1)? 's.':'.' }'),
                    children: [
                      PhotosListScreen(photos: widget.photosByLocation[l]??[])
                    ],
                  )
              ],
            ),
          ),
        )
    );
  }

}