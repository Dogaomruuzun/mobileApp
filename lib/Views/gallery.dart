import 'package:flutter/material.dart';
import 'package:mobile/JSON/sharedgallery.dart';
import 'package:mobile/SQLite/database_helper_galery.dart';
import 'package:mobile/SQLite/database_helper.dart';

class GalleryScreen extends StatelessWidget {
  final int? usrId; // User ID to fetch images for

  const GalleryScreen({super.key, required this.usrId});

  Future<List<Sharedgallery>> fetchImages() async {
    final dbHelperGallery = DatabaseHelperGallery();    
    return await dbHelperGallery.getSharedGallery();
  }
  Future<List<Map<String, dynamic>>> fetchImagesWithUsers() async {
  final dbHelperGallery = DatabaseHelperGallery();
  final dbHelper = DatabaseHelper();
  // Fetch all shared gallery records
  final images = await dbHelperGallery.getSharedGallery();

  // Fetch user details for each record
  final List<Map<String, dynamic>> imagesWithUsers = [];
  for (var image in images) {
    final user = await dbHelper.getUserById(image.usrId!);
    imagesWithUsers.add({
      'image': image,
      'userName': user?.fullName ?? 'Unknown User',
    });
  }
  return imagesWithUsers;
  }
Future<void> deleteRecord(int? id, BuildContext context) async {
  try {
    final dbHelperGallery = DatabaseHelperGallery();

    // Delete the record
    await dbHelperGallery.deleteSharedGallery(id!);

    // Ensure the widget is still mounted before accessing BuildContext
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Record deleted successfully")),
      );

      // Refresh the gallery
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GalleryScreen(usrId: usrId)),
      );
    }
  } catch (e) {
    // Ensure the widget is still mounted before showing the error message
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete record")),
      );
    }
  }
}


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Gallery")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchImagesWithUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No images found"));
          } else {
            final imagesWithUsers = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              padding: const EdgeInsets.all(8.0),
              itemCount: imagesWithUsers.length,
              itemBuilder: (context, index) {
                final imageInfo = imagesWithUsers[index];
                final Sharedgallery image = imageInfo['image'];
                final String userName = imageInfo['userName'];

                return Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        image.score == null
                            ? 'assets/artworks/hr0.jpg'
                            : 'assets/artworks/hr${image.score}.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (usrId == image.usrId) // Show delete button for the current user's records
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await deleteRecord(image.rowId, context);
                        },
                      ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}