import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'connection/unsupported.dart'
    if (dart.library.js_interop) 'connection/web.dart'
    if (dart.library.io) 'connection/native.dart';

part 'app_database.g.dart';

@DataClassName('ContactEntry')
class Contacts extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get email => text().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('GroupEntry')
class Groups extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get label => text()();
  TextColumn get title => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class ContactToGroup extends Table {
  TextColumn get contactId => text().references(Contacts, #id)();
  TextColumn get groupId => text().references(Groups, #id)();
  
  @override
  Set<Column> get primaryKey => {contactId, groupId};
}

@DataClassName('RecentEntry')
class Recents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get contactId => text().references(Contacts, #id)();
  DateTimeColumn get calledAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Contacts, Groups, ContactToGroup, Recents])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          // Clear existing dummy data if upgrading from version 1
          await customStatement('DELETE FROM contacts;');
          await customStatement('DELETE FROM contact_to_group;');
        }
        if (from < 3) {
          await m.createTable(recents);
        }
      },
    );
  }
}
