part of 'mongodb_crud.dart';

class EventCrud extends MongoDatabase {
  static var eventCollection;

  static Future<List<Event>> getDocuments() async {
    eventCollection = MongoDatabase.db.collection(Strings.EVENT_COLLECTION);
    try {
      final List<Event> eventlist = [];
      List<dynamic> events = await eventCollection.find().toList();
      final eventdata = List<Map<String, dynamic>>.from(events);
      for (var evenT in eventdata) {
        eventlist.add(eventFromMap(evenT));
      }
      return eventlist;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static Future<Event> get(String id) async {
      eventCollection = MongoDatabase.db.collection(Strings.EVENT_COLLECTION);
    try {
      eventCollection = MongoDatabase.db.collection(Strings.EVENT_COLLECTION);
      var u = await eventCollection.findOne({"_id": id});
      Event event = Event.fromMap(u);
      return event;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static Future<Event> getbykey(Map<String, dynamic> key) async {
    eventCollection = MongoDatabase.db.collection(Strings.EVENT_COLLECTION);
    try {
      eventCollection = MongoDatabase.db.collection(Strings.EVENT_COLLECTION);
      var u = await eventCollection.findOne(key);
      Event event = Event.fromMap(u);
      return event;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static Future<List<Event>> getmanybykey(Map<String, dynamic> key) async {
    eventCollection = MongoDatabase.db.collection(Strings.EVENT_COLLECTION);
    try {
      final List<Event> eventlist = [];
      List<dynamic> events = await eventCollection.find(key).toList();
      final eventdata = List<Map<String, dynamic>>.from(events);
      for (var evenT in eventdata) {
        eventlist.add(eventFromMap(evenT));
      }
      return eventlist;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static insert(Event event) async {
    eventCollection = MongoDatabase.db.collection(Strings.EVENT_COLLECTION);
    List<Map<String,dynamic>> eventarray = [event.toMap()];
    await eventCollection.insertAll(eventarray);
  }

  static update(Event event) async {
    eventCollection = MongoDatabase.db.collection(Strings.EVENT_COLLECTION);
    var u = await eventCollection.findOne({"_id": event.id});
    /*
    u["name"] = user.name;
    u["email"] = user.email;*/
    u = event.toMap();
    await eventCollection.save(u);
  }

  static delete(String id) async {
    eventCollection = MongoDatabase.db.collection(Strings.EVENT_COLLECTION);
    await eventCollection.remove(where.eq("_id", id));
  }
}
