import 'package:mongo_dart/mongo_dart.dart';
import 'package:weddingitinerary/core/constants/strings.dart';
import 'package:weddingitinerary/data/models/model.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:weddingitinerary/data/models/user/user.dart';

part 'user_crud.dart';

abstract class MongoDatabase {
  static var db;

  static connect() async {
    db = await Db.create(Strings.MONGO_CONN_URL);
    await db.open();
  }

  static disconnect() async {
    await db.close();
  }
}
