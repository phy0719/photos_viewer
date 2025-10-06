import 'package:flutter/material.dart';
import 'package:photos_viewer/screens/photo_detail_screen.dart';
import 'package:photos_viewer/utils/utils.dart';

import '../model/photo.dart';
import '../utils/logger.dart';
import '../widgets/photos_list_cell.dart';

class FavoriteListScreen extends StatefulWidget {
  final List<Photo> photos;

  const FavoriteListScreen({super.key, required this.photos});

  @override
  State<StatefulWidget> createState() => _FavoriteListScreen();

}

class _FavoriteListScreen extends State<FavoriteListScreen> {
  List<Photo> favoriteList = [];
  List<Photo> getFavoritePhotosList() {
    List<Photo> pl = [];
    for (var p in widget.photos) {
      if (favoriteIds.contains(p.id)) pl.add(p);
    }
    return pl;
  }
  @override
  void initState() {
    favoriteList = getFavoritePhotosList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: favoriteList.length,
      itemBuilder: (context, index) {
        return PhotosListCell(
            isFavorite: null,
            imageUrl: favoriteList[index].url,
            subtitleString: 'Created by ${favoriteList[index].createdBy}\nCreated at ${dateFormat.format(favoriteList[index].createdAt)}',
            titleString: 'Location: ${favoriteList[index].location}',
            onTapEvent: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return PhotoDetailScreen(
                    screenTitle: 'Detail',
                    imageUrl: favoriteList[index].url,
                    location: favoriteList[index].location,
                    description: favoriteList[index].description?? "",
                    createdBy: favoriteList[index].createdBy,
                    createdTimeString: dateFormat.format(favoriteList[index].createdAt),
                    takenAtString: dateFormat.format(favoriteList[index].takenAt),
                    isFavorite: favoriteIds.contains(favoriteList[index].id),
                    onDetailPressedFavorite: (bool isFavorite) async{
                      logger.i('FavoriteListScreen: onDetailPressedFavorite? $isFavorite');
                      await updateFavoriteIds(isFavorite, favoriteList[index].id);
                      if (mounted) {
                        setState(() {
                          favoriteList = getFavoritePhotosList();
                        });
                      }
                    },
                  );
                },
              ),
            );
          },
            onPhotosListCellPressedFavorite: (bool isFavorite) async {
              logger.i('FavoriteListScreen: onPhotosListCellPressedFavorite: isFavorite? $isFavorite');
              await updateFavoriteIds(isFavorite, favoriteList[index].id);
              if (mounted) {
                setState(() {
                  favoriteList = getFavoritePhotosList();
                });
              }
          },
          onPressedDeleteButton: () async {
            await updateFavoriteIds(false, favoriteList[index].id);
            if (mounted) {
              setState(() {
                favoriteList = getFavoritePhotosList();
              });
            }
          },
        );
      },
    );
  }

}