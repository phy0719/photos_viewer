import 'package:flutter/material.dart';
import 'package:photos_viewer/appModel/photos_model.dart';
import 'package:photos_viewer/screens/photo_detail_screen.dart';
import '../model/photo.dart';
import '../utils/utils.dart';
import 'photos_list_cell.dart';

class PhotosListComponents extends StatefulWidget {
  final List<Photo> photos;

  const PhotosListComponents({super.key, required this.photos});

  @override
  State<StatefulWidget> createState() => _PhotosListScreen();
}

class _PhotosListScreen extends State<PhotosListComponents> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = PhotosModel.shared.dateFormat;
    return FutureBuilder(
        future: getIt.allReady(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                for (var p in widget.photos)
                  PhotosListCell(
                    id: p.id,
                    imageUrl: p.url,
                    subtitleString: 'Created at ${dateFormat.format(p.createdAt)}',
                    titleString: 'Created by ${p.createdBy}',
                    onTapEvent: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return PhotoDetailScreen(
                              screenTitle: 'Detail',
                              imageUrl: p.url,
                              location: p.location,
                              description: p.description?? "",
                              createdBy: p.createdBy,
                              emailString: p.email,
                              createdTimeString: dateFormat.format(p.createdAt),
                              takenAtString: dateFormat.format(p.takenAt),
                              isFavorite: PhotosModel.shared.favoriteIds.contains(p.id),
                              onDetailPressedFavorite: (bool isFavorite) async{
                                // logger.i('PhotoDetailScreen: onPressedFavorite? $isFavorite');

                                await PhotosModel.shared.updateAllFavoriteDataOnChangeIsFavorite(isFavorite, p.id);
                              },
                            );
                          },
                        ),
                      );
                    },
                    onPhotosListCellPressedFavorite: (bool isFavorite) async {
                      // logger.i('onPhotosListCellPressedFavorite: isFavorite? $isFavorite');
                      await PhotosModel.shared.updateAllFavoriteDataOnChangeIsFavorite(isFavorite, p.id);
                    },
                  )
              ],
            );
          } else {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('PhotosListComponents: Waiting for initialisation'),
                SizedBox(height: 16),
                CircularProgressIndicator(),
              ],
            );
      }
    });

  }

}