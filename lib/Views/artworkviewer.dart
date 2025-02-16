import 'package:flutter/material.dart';
import 'package:mobile/JSON/sharedgallery.dart';
import 'package:mobile/SQLite/database_helper_galery.dart';
import 'package:mobile/Views/gallery.dart';
import 'package:mobile/JSON/users.dart';
import 'package:mobile/SQLite/database_helper.dart';

class ImageViewScreen extends StatelessWidget {
  final int bodyTemp;
  final String imageName;
  final Users? profile;
  const ImageViewScreen({super.key, required this.imageName, required this.bodyTemp, required this.profile });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood Artwork"),
      ),
      body: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Dear ${profile?.fullName}"),
                    const Text("Your mood visual is :"),
                    Image.asset(imageName),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                         final dbHelperGallery = DatabaseHelperGallery();

                        Sharedgallery galleryInfo = Sharedgallery(
                          usrId: profile?.usrId,
                          score: bodyTemp
                        );
                        int res = await dbHelperGallery.createSharedGallery(galleryInfo);
                        if (res > 0) {
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => GalleryScreen(usrId: profile!.usrId)),
                            );
                          } 
                          }
                        },
                      child: const Text("Share on Gallery"), 
                    ),
                  ],
                ),
                  ),
    );
  }
}