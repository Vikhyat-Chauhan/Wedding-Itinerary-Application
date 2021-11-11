part of 'mongodb_crud.dart';

class LivelinkCrud extends MongoDatabase {
  static var livelinksCollection;

  static Future<List<Livelink>> getDocuments() async {
    livelinksCollection = MongoDatabase.db.collection(Strings.LIVELINK_COLLECTION);
    try {
      final List<Livelink> livelinkslist = [];
      List<dynamic> livelinks = await livelinksCollection.find().toList();
      final livelinksdata = List<Map<String, dynamic>>.from(livelinks);
      for (var livelinkS in livelinksdata) {
        livelinkslist.add(livelinkFromMap(livelinkS));
      }
      return livelinkslist;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static Future<Livelink> get(String id) async {
    livelinksCollection = MongoDatabase.db.collection(Strings.LIVELINK_COLLECTION);
    try {
      livelinksCollection = MongoDatabase.db.collection(Strings.LIVELINK_COLLECTION);
      var u = await livelinksCollection.findOne({"_id": id});
      Livelink livelinks = Livelink.fromMap(u);
      return livelinks;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static Future<Livelink> getbykey(Map<String, dynamic> key) async {
    livelinksCollection = MongoDatabase.db.collection(Strings.LIVELINK_COLLECTION);
    try {
      livelinksCollection = MongoDatabase.db.collection(Strings.LIVELINK_COLLECTION);
      var u = await livelinksCollection.findOne(key);
      Livelink livelinks = Livelink.fromMap(u);
      return livelinks;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static Future<List<Livelink>> getmanybykey(Map<String, dynamic> key) async {
    livelinksCollection = MongoDatabase.db.collection(Strings.LIVELINK_COLLECTION);
    try {
      final List<Livelink> livelinkslist = [];
      List<dynamic> livelinks = await livelinksCollection.find(key).toList();
      final livelinksdata = List<Map<String, dynamic>>.from(livelinks);
      for (var livelinkS in livelinksdata) {
        livelinkslist.add(livelinkFromMap(livelinkS));
      }
      return livelinkslist;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static insert(Livelink livelinks) async {
    livelinksCollection = MongoDatabase.db.collection(Strings.LIVELINK_COLLECTION);
    List<Map<String,dynamic>> livelinksarray = [livelinks.toMap()];
    await livelinksCollection.insertAll(livelinksarray);
  }

  static update(Livelink livelinks) async {
    livelinksCollection = MongoDatabase.db.collection(Strings.LIVELINK_COLLECTION);
    var u = await livelinksCollection.findOne({"_id": livelinks.id});
    /*
    u["name"] = user.name;
    u["email"] = user.email;*/
    u = livelinks.toMap();
    await livelinksCollection.save(u);
  }

  static delete(String id) async {
    livelinksCollection = MongoDatabase.db.collection(Strings.LIVELINK_COLLECTION);
    await livelinksCollection.remove(where.eq("_id", id));
  }
}
