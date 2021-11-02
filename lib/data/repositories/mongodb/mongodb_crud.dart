import 'package:mongo_dart/mongo_dart.dart';
import 'package:weddingitinerary/core/constants/strings.dart';
import 'package:weddingitinerary/data/models/user/user.dart';
import 'package:weddingitinerary/data/models/event/event.dart';
import 'package:weddingitinerary/data/models/bookings/bookings.dart';
import 'package:weddingitinerary/data/models/locations/locations.dart';

part 'user_crud.dart';
part 'event_crud.dart';
part 'bookings_crud.dart';
part 'locations_crud.dart';

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
