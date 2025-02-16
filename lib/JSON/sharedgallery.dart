
import 'dart:convert';

Sharedgallery sharedgalleryfromMap(String str) => Sharedgallery.fromMap(json.decode(str));

String sharedgallerytoMap(Sharedgallery data) => json.encode(data.toMap());

class Sharedgallery {
  final int? rowId;
  final int? usrId;
  final int? score;

  Sharedgallery({
    this.rowId,
    this.usrId,
    this.score,
  });

  //These json value must be same as your column name in database that we have already defined
  //one column didn't match
  factory Sharedgallery.fromMap(Map<String, dynamic> json) => Sharedgallery(
    rowId: json["rowId"],
    usrId: json["usrId"],
    score: json["score"]
  );

  Map<String, dynamic> toMap() => {
    "rowId": rowId,
    "usrId": usrId,
    "score": score
  };
}
