import 'package:flutter/material.dart';
import 'package:photos_viewer/appModel/photos_model.dart';
import 'package:photos_viewer/screens/photo_detail_screen.dart';
import 'package:photos_viewer/utils/utils.dart';
import '../model/photo.dart';
import '../widgets/photos_list_cell.dart';

class FavoriteListScreen extends StatefulWidget {
  const FavoriteListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FavoriteListScreen();

}

class _FavoriteListScreen extends State<FavoriteListScreen> {
  List<Photo> _favoritePhotos = [];

  updateFavoritePhotosUI() {
    if (mounted){
      setState(() {
        _favoritePhotos = PhotosModel.shared.photos.where((element) => PhotosModel.shared.favoriteIds.contains(element.id)).toList();
      });
    }
  }

  @override
  void initState() {
    _favoritePhotos = PhotosModel.shared.photos.where((element) => PhotosModel.shared.favoriteIds.contains(element.id)).toList();
    PhotosModel.shared.addListener(updateFavoritePhotosUI);
    super.initState();
  }

  @override
  void dispose() {
    PhotosModel.shared.removeListener(updateFavoritePhotosUI);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = PhotosModel.shared.dateFormat;
    return FutureBuilder(
        future: getIt.allReady(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: _favoritePhotos.length,
              itemBuilder: (context, index) {
                return PhotosListCell(
                  id: _favoritePhotos[index].id,
                  imageUrl: _favoritePhotos[index].url,
                  subtitleString: 'Created by ${_favoritePhotos[index].createdBy}\nCreated at ${dateFormat.format(_favoritePhotos[index].createdAt)}',
                  titleString: 'Location: ${_favoritePhotos[index].location}',
                  onTapEvent: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return PhotoDetailScreen(
                            screenTitle: 'Detail',
                            imageUrl: _favoritePhotos[index].url,
                            location: _favoritePhotos[index].location,
                            description: _favoritePhotos[index].description?? "",
                            emailString: _favoritePhotos[index].email,
                            createdBy: _favoritePhotos[index].createdBy,
                            createdTimeString: dateFormat.format(_favoritePhotos[index].createdAt),
                            takenAtString: dateFormat.format(_favoritePhotos[index].takenAt),
                            isFavorite: true,
                            onDetailPressedFavorite: (bool isFavorite) async{
                              // logger.i('FavoriteListScreen: onDetailPressedFavorite? $isFavorite');
                              await PhotosModel.shared.updateAllFavoriteDataOnChangeIsFavorite(isFavorite, _favoritePhotos[index].id);

                            },
                          );
                        },
                      ),
                    );
                  },
                  onPhotosListCellPressedFavorite: null,
                  onPressedDeleteButton: () async {
                    await PhotosModel.shared.updateAllFavoriteDataOnChangeIsFavorite(false, _favoritePhotos[index].id);
                  },
                );
              },
            );
          } else {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('FavoriteListScreen: Waiting for initialisation'),
                SizedBox(height: 16),
                CircularProgressIndicator(),
              ],
            );
          }
        });
  }

}