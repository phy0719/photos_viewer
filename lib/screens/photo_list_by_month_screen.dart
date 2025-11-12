import 'package:flutter/material.dart';
import 'package:photos_viewer/model/photo.dart';
import 'package:photos_viewer/screens/photo_detail_screen.dart';

import '../appModel/photos_model.dart';
import '../utils/utils.dart';
import '../widgets/photos_list_cell.dart';

class PhotoListByMonthScreen extends StatefulWidget {
  const PhotoListByMonthScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PhotoListByMonthScreen();

}

class _PhotoListByMonthScreen extends State<PhotoListByMonthScreen> {
  List<Photo> _photos = [];
  updatePhotosList() {
    if (mounted){
      setState(() {
        _photos = PhotosModel.shared.photos;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    updatePhotosList();
    PhotosModel.shared.addListener(updatePhotosList);
  }

  @override
  void dispose() {
    super.dispose();
    PhotosModel.shared.removeListener(updatePhotosList);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = PhotosModel.shared.dateFormat;
    return FutureBuilder(
        future: getIt.allReady(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: _photos.length,
              itemBuilder: (context, index) {
                return  PhotosListCell(
                  id: _photos[index].id,
                  imageUrl: _photos[index].url,
                  subtitleString: 'Created at ${dateFormat.format(_photos[index].createdAt)}',
                  titleString: 'Created by ${_photos[index].createdBy}',
                  onTapEvent: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return PhotoDetailScreen(
                            screenTitle: 'Detail',
                            imageUrl: _photos[index].url,
                            location: _photos[index].location,
                            description: _photos[index].description?? "",
                            createdBy: _photos[index].createdBy,
                            emailString: _photos[index].email,
                            createdTimeString: dateFormat.format(_photos[index].createdAt),
                            takenAtString: dateFormat.format(_photos[index].takenAt),
                            isFavorite: PhotosModel.shared.favoriteIds.contains(_photos[index].id),
                            onDetailPressedFavorite: (bool isFavorite) async{
                              // logger.i('PhotoDetailScreen: onPressedFavorite? $isFavorite');

                              await PhotosModel.shared.updateAllFavoriteDataOnChangeIsFavorite(isFavorite, _photos[index].id);
                            },
                          );
                        },
                      ),
                    );
                  },
                  onPhotosListCellPressedFavorite: (bool isFavorite) async {
                    // logger.i('onPhotosListCellPressedFavorite: isFavorite? $isFavorite');
                    await PhotosModel.shared.updateAllFavoriteDataOnChangeIsFavorite(isFavorite, _photos[index].id);
                  },
                );
              },
            );
          } else {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('PhotoListByMonthScreen: Waiting for initialisation'),
                SizedBox(height: 16),
                CircularProgressIndicator(),
              ],
            );
          }
        });

  }

}