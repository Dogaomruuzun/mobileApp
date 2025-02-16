
import 'package:mobile/JSON/sharedgallery.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelperGallery{
  final databaseName = "sharedgallery.db";

  String sharedgallery = '''
  CREATE TABLE sharedgallery (
   rowId INTEGER PRIMARY KEY AUTOINCREMENT,
   usrId INTEGER,
   score INTEGER
   )
   ''';

  //Our connection is ready
  Future<Database> initDB ()async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path,version: 1 , onCreate: (db,version)async{
      await db.execute(sharedgallery);
    });
  }

  //Get All from Shared Gallery
Future<List<Sharedgallery>> getSharedGallery() async {
  final Database db = await initDB();
  
  // Query all rows from the table `sharedgallery`
  final List<Map<String, dynamic>> res = await db.query("sharedgallery");

  // Convert the result to a list of Sharedgallery objects
  return res.isNotEmpty
      ? res.map((item) => Sharedgallery.fromMap(item)).toList()
      : [];
}


    //Create item in shared gallery
  Future<int> createSharedGallery(Sharedgallery galleryInfo)async{
    final Database db = await initDB();
    return db.insert("sharedgallery", galleryInfo.toMap());
  }

  //Delete item in shared gallery
  Future<int> deleteSharedGallery(int rowid) async {
  final Database db = await initDB();
  return await db.delete(
    'sharedgallery',
    where: 'rowid = ?',
    whereArgs: [rowid],
  );
}

}