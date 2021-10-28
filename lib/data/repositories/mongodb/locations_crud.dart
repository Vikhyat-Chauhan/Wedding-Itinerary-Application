part of 'mongodb_crud.dart';

class LocationsCrud extends MongoDatabase {
  static var locationsCollection;

  static Future<List<Locations>> getDocuments() async {
    locationsCollection =
        MongoDatabase.db.collection(Strings.LOCATIONS_COLLECTION);
    try {
      final List<Locations> locationslist = [];
      List<dynamic> locations = await locationsCollection.find().toList();
      final locationsdata = List<Map<String, dynamic>>.from(locations);
      for (var locationS in locationsdata) {
        locationslist.add(locationsFromMap(locationS));
      }
      return locationslist;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static Future<Locations> get(String id) async {
    locationsCollection =
        MongoDatabase.db.collection(Strings.LOCATIONS_COLLECTION);
    try {
      locationsCollection =
          MongoDatabase.db.collection(Strings.LOCATIONS_COLLECTION);
      var u = await locationsCollection.findOne({"_id": id});
      Locations locations = Locations.fromMap(u);
      return locations;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static Future<Locations> getbykey(Map<String, dynamic> key) async {
    locationsCollection =
        MongoDatabase.db.collection(Strings.LOCATIONS_COLLECTION);
    try {
      locationsCollection =
          MongoDatabase.db.collection(Strings.LOCATIONS_COLLECTION);
      var u = await locationsCollection.findOne(key);
      Locations locations = Locations.fromMap(u);
      return locations;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static Future<List<Locations>> getmanybykey(Map<String, dynamic> key) async {
    locationsCollection =
        MongoDatabase.db.collection(Strings.LOCATIONS_COLLECTION);
    try {
      final List<Locations> locationslist = [];
      List<dynamic> locations = await locationsCollection.find(key).toList();
      final locationsdata = List<Map<String, dynamic>>.from(locations);
      for (var locationS in locationsdata) {
        locationslist.add(locationsFromMap(locationS));
      }
      return locationslist;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static insert(Locations locations) async {
    locationsCollection =
        MongoDatabase.db.collection(Strings.LOCATIONS_COLLECTION);
    List<Map<String, dynamic>> locationsarray = [locations.toMap()];
    await locationsCollection.insertAll(locationsarray);
  }

  static update(Locations locations) async {
    locationsCollection =
        MongoDatabase.db.collection(Strings.LOCATIONS_COLLECTION);
    var u = await locationsCollection.findOne({"_id": locations.id});
    /*
    u["name"] = user.name;
    u["email"] = user.email;*/
    u = locations.toMap();
    await locationsCollection.save(u);
  }

  static delete(String id) async {
    locationsCollection =
        MongoDatabase.db.collection(Strings.LOCATIONS_COLLECTION);
    await locationsCollection.remove(where.eq("_id", id));
  }
}
