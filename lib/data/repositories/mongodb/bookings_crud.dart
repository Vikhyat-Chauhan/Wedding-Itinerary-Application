part of 'mongodb_crud.dart';

class BookingsCrud extends MongoDatabase {
  static var bookingsCollection;

  static Future<List<Bookings>> getDocuments() async {
    bookingsCollection = MongoDatabase.db.collection(Strings.BOOKINGS_COLLECTION);
    try {
      final List<Bookings> bookingslist = [];
      List<dynamic> bookings = await bookingsCollection.find().toList();
      final bookingsdata = List<Map<String, dynamic>>.from(bookings);
      for (var bookingS in bookingsdata) {
        bookingslist.add(bookingsFromMap(bookingS));
      }
      return bookingslist;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static Future<Bookings> get(String id) async {
    bookingsCollection = MongoDatabase.db.collection(Strings.BOOKINGS_COLLECTION);
    try {
      bookingsCollection = MongoDatabase.db.collection(Strings.BOOKINGS_COLLECTION);
      var u = await bookingsCollection.findOne({"_id": id});
      Bookings bookings = Bookings.fromMap(u);
      return bookings;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static Future<Bookings> getbykey(Map<String, dynamic> key) async {
    bookingsCollection = MongoDatabase.db.collection(Strings.BOOKINGS_COLLECTION);
    try {
      bookingsCollection = MongoDatabase.db.collection(Strings.BOOKINGS_COLLECTION);
      var u = await bookingsCollection.findOne(key);
      Bookings bookings = Bookings.fromMap(u);
      return bookings;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static Future<List<Bookings>> getmanybykey(Map<String, dynamic> key) async {
    bookingsCollection = MongoDatabase.db.collection(Strings.BOOKINGS_COLLECTION);
    try {
      final List<Bookings> bookingslist = [];
      List<dynamic> bookings = await bookingsCollection.find(key).toList();
      final bookingsdata = List<Map<String, dynamic>>.from(bookings);
      for (var bookingS in bookingsdata) {
        bookingslist.add(bookingsFromMap(bookingS));
      }
      return bookingslist;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static insert(Bookings bookings) async {
    bookingsCollection = MongoDatabase.db.collection(Strings.BOOKINGS_COLLECTION);
    List<Map<String,dynamic>> bookingsarray = [bookings.toMap()];
    await bookingsCollection.insertAll(bookingsarray);
  }

  static update(Bookings bookings) async {
    bookingsCollection = MongoDatabase.db.collection(Strings.BOOKINGS_COLLECTION);
    var u = await bookingsCollection.findOne({"_id": bookings.id});
    /*
    u["name"] = user.name;
    u["email"] = user.email;*/
    u = bookings.toMap();
    await bookingsCollection.save(u);
  }

  static delete(String id) async {
    bookingsCollection = MongoDatabase.db.collection(Strings.BOOKINGS_COLLECTION);
    await bookingsCollection.remove(where.eq("_id", id));
  }
}
