import 'package:flutter/material.dart';
import 'package:photos_viewer/screens/photo_detail_screen.dart';
import '../appModel/photos_model.dart';
import '../utils/utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchScreen();

}

class _SearchScreen extends State<SearchScreen> {
  @override
  void initState() {
    PhotosModel.shared.resetSearchingList(false);
    super.initState();
  }

  @override
  void dispose() {
    PhotosModel.shared.resetSearchingList(false);
    super.dispose();
  }

  Future<void> _developerDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Image(image: AssetImage("assets/qrcode/photos_viewer_source.png"), height: 250),
          alignment: Alignment.center,
          content:
              const Text(
                'Thank you very much for taking a look at this app. \nIt was made with Flutter. \nThe source code has been uploaded to my GitHub workspace.',
              ),

          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
              child: const Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = getIt<PhotosModel>().generalDatetimeFormat;
    return FutureBuilder(
      future: getIt.allReady(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SafeArea(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _developerDialogBuilder(context);
                    },
                    child: const ListTile(
                        leading: Icon(Icons.edit_note),
                        title: Text('Developed by Yan Poon in Year 2025.')
                    )
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
                      if (controller.value.text.isEmpty) {
                        PhotosModel.shared.resetSearchingList(true);
                      } else {
                        PhotosModel.shared.searchPhotos(controller.value.text);
                      }
                  return [
                        for (var p in PhotosModel.shared.searchingList)
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
                                        emailString: p.email,
                                        createdBy: p.createdBy,
                                        createdTimeString: dateFormat.format(p.createdAt),
                                        takenAtString: dateFormat.format(p.takenAt),
                                        isFavorite: PhotosModel.shared.favoriteIds.contains(p.id),
                                        onDetailPressedFavorite: (bool isFavorite) async {
                                          await PhotosModel.shared.updateAllFavoriteDataOnChangeIsFavorite(isFavorite, p.id);
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
        }else{
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
      },
    );

  }

}