import 'package:flutter/material.dart';
import 'package:photos_viewer/screens/photo_detail_screen.dart';
import '../model/photo.dart';
import '../utils/utils.dart';

class SearchScreen extends StatefulWidget {
  final List<Photo> photos;

  const SearchScreen({super.key, required this.photos});

  @override
  State<StatefulWidget> createState() => _SearchScreen();

}

class _SearchScreen extends State<SearchScreen> {
  List<Photo> _photosList = [];
  @override
  void initState() {
    super.initState();
    _photosList = widget.photos;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: [
            const ListTile(
                leading: Icon(Icons.edit_note),
                title: Text('Developed by Yan Poon in Year 2025.')
            ),
            SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (String s) {
                    controller.openView();
                  },
                  leading: const Icon(Icons.search),
                );
              },
              suggestionsBuilder: (BuildContext context, SearchController controller) {

                return [
                  for (var p in _photosList)
                    if (controller.value.text.isEmpty || p.location.toUpperCase().contains(controller.value.text.toUpperCase()) || p.createdBy.toUpperCase().contains(controller.value.text.toUpperCase()))
                    ListTile(
                      title: Text('Location: ${p.location}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Created by ${p.createdBy}\nCreated at ${dateFormat.format(p.createdAt)}'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return PhotoDetailScreen(
                                screenTitle: 'Detail',
                                  imageUrl: p.url,
                                  location: p.location,
                                  description: p.description?? "",
                                  createdBy: p.createdBy,
                                  createdTimeString: dateFormat.format(p.createdAt),
                                  takenAtString: dateFormat.format(p.takenAt),
                                  isFavorite: favoriteIds.contains(p.id),
                                  onDetailPressedFavorite: (bool pressed) {

                                  }
                                );
                            },
                          ),
                        );
                      },
                    )
                ];
              },
            ),
          ],
        ));
  }

}