part of 'mongodb_crud.dart';

class UserCrud extends MongoDatabase {
  static var userCollection;

  static Future<List<User>> getDocuments() async {
    userCollection = MongoDatabase.db.collection(Strings.USER_COLLECTION);
    try {
      final List<User> userlist = [];
      List<dynamic> users = await userCollection.find().toList();
      final userdata = List<Map<String, dynamic>>.from(users);
      for (var useR in userdata) {
        userlist.add(userFromMap(useR));
      }
      return userlist;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static Future<User> get(String id) async {
    userCollection = MongoDatabase.db.collection(Strings.USER_COLLECTION);
    try {
      userCollection = MongoDatabase.db.collection(Strings.USER_COLLECTION);
      var u = await userCollection.findOne({"_id": id});
      User user = User.fromMap(u);
      return user;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static insert(User user) async {
    userCollection = MongoDatabase.db.collection(Strings.USER_COLLECTION);
    List<Map<String,dynamic>> userarray = [user.toMap()];
    await userCollection.insertAll(userarray);
  }

  static update(User user) async {
    userCollection = MongoDatabase.db.collection(Strings.USER_COLLECTION);
    var u = await userCollection.findOne({"_id": user.id});
    /*
    u["name"] = user.name;
    u["email"] = user.email;*/
    u = user.toMap();
    await userCollection.save(u);
  }

  static delete(String id) async {
    userCollection = MongoDatabase.db.collection(Strings.USER_COLLECTION);
    await userCollection.remove(where.eq("_id", id));
  }
}
