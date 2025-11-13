import 'package:flutter/material.dart';
import 'package:photos_viewer/appModel/photos_model.dart';
import 'package:photos_viewer/screens/favorite_list_screen.dart';
import 'package:photos_viewer/screens/photo_list_by_month_screen.dart';
import 'package:photos_viewer/screens/search_screen.dart';
import 'locations_listview.dart';

class HomeScreen extends StatefulWidget {
  final String screenTitle;

  const HomeScreen({super.key, required this.screenTitle}) ;

  @override
  State<StatefulWidget> createState()  => _HomeScreen();


}
class _HomeScreen extends State<HomeScreen> {
  int _currentPageIndex = 0;
  final NavigationDestinationLabelBehavior _labelBehavior = NavigationDestinationLabelBehavior.onlyShowSelected;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.screenTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
                onPressed: () async {
                  await PhotosModel.shared.refreshFetchPhotos();
                })
          ],
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
            selectedIcon: Icon(Icons.photo_outlined, color: Colors.grey),
            icon: Icon(Icons.photo, color: Colors.purple),
            label: 'All Photos',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.map_outlined, color: Colors.grey),
            icon: Icon(Icons.map, color: Colors.purple),
            label: 'By Location',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.search, color: Colors.grey),
            icon: Icon(Icons.search, color: Colors.purple),
            label: 'By Search',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmark_added, color: Colors.grey),
            icon: Icon(Icons.bookmark_added, color: Colors.purple),
            label: 'My Favourite',
          ),
        ],
      ),
      body: <Widget>[
        /// Photo by Location page
        const PhotoListByMonthScreen(),

        /// Photo by Location page
        const LocationsListView(),

        /// Search page
        const SearchScreen(),

        /// Favourite page
        const FavoriteListScreen(),
      ][_currentPageIndex],
    );
  }

}