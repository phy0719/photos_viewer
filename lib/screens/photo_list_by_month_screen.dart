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

  bool shouldAddMonthTitle(int index) {
    //always add title when it is first row
    if (index == 0) return true;
    return !Utils.areDatesInSameMonth(_photos[index].createdAt, _photos[index-1].createdAt);
  }

  @override
  Widget build(BuildContext context) {
    final generalDateFormat = PhotosModel.shared.generalDatetimeFormat;
    final titleDateFormat = PhotosModel.shared.monthYearFormat;
    return FutureBuilder(
        future: getIt.allReady(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: _photos.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    // add the month title to show the photos in the same month
                    (shouldAddMonthTitle(index))?
                    ListTile(title: Text(titleDateFormat.format(_photos[index].createdAt),
                        style: const TextStyle(fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.purple,
                            color: Colors.purple)))
                        :Container(),
                    PhotosListCell(
                      id: _photos[index].id,
                      imageUrl: _photos[index].url,
                      subtitleString: 'Created by ${_photos[index].createdBy}\nCreated at ${generalDateFormat.format(_photos[index].createdAt)}',
                      titleString: 'Location: ${_photos[index].location}',
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
                                createdTimeString: generalDateFormat.format(_photos[index].createdAt),
                                takenAtString: generalDateFormat.format(_photos[index].takenAt),
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
                    )
                  ],
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