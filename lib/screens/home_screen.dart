import 'package:flutter/material.dart';
import 'package:photos_viewer/screens/favorite_list_screen.dart';
import 'package:photos_viewer/screens/search_screen.dart';
import '../model/photo.dart';
import '../utils/utils.dart';
import 'locations_listview.dart';

class HomeScreen extends StatefulWidget {
  final String screenTitle;
  final List<Photo> photosList;

  const HomeScreen({super.key, required this.screenTitle, required this.photosList}) ;

  @override
  State<StatefulWidget> createState()  => _HomeScreen();


}
class _HomeScreen extends State<HomeScreen> {
  int _currentPageIndex = 0;
  final NavigationDestinationLabelBehavior _labelBehavior = NavigationDestinationLabelBehavior.onlyShowSelected;
  List<Photo> _photosList = [];
  List<String> _locationsList = [];
  Map<String, List<Photo>> _photosMappingList = {};

  @override
  void initState() {
    _photosList = widget.photosList;
    _locationsList = getLocation(_photosList);
    _photosMappingList = getPhotosByLocation(photos: _photosList, locationsList: _locationsList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.screenTitle),
        ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        labelBehavior: _labelBehavior,
        indicatorColor: Theme.of(context).colorScheme.inversePrimary,
        selectedIndex: _currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.photo, color: Colors.grey),
            icon: Icon(Icons.photo, color: Colors.purple),
            label: 'Photos',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.search, color: Colors.grey),
            icon: Icon(Icons.search, color: Colors.purple),
            label: 'Search',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmark_added, color: Colors.grey),
            icon: Icon(Icons.bookmark_added, color: Colors.purple),
            label: 'Favourite',
          ),
        ],
      ),
      body: <Widget>[
        /// Photo page
        LocationsListView(locations: _locationsList, photosByLocation: _photosMappingList),

        /// Search page
        SearchScreen(photos: _photosList),

        /// Favourite page
        FavoriteListScreen(photos: _photosList),
      ][_currentPageIndex],
    );
  }

}