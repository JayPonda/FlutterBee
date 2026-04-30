// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ContactsTable extends Contacts
    with TableInfo<$ContactsTable, ContactEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    firstName,
    lastName,
    phoneNumber,
    email,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContactEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContactEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContactEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ContactsTable createAlias(String alias) {
    return $ContactsTable(attachedDatabase, alias);
  }
}

class ContactEntry extends DataClass implements Insertable<ContactEntry> {
  final String id;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? email;
  final DateTime? deletedAt;
  const ContactEntry({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.email,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ContactsCompanion toCompanion(bool nullToAbsent) {
    return ContactsCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: Value(lastName),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory ContactEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContactEntry(
      id: serializer.fromJson<String>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      email: serializer.fromJson<String?>(json['email']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'email': serializer.toJson<String?>(email),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  ContactEntry copyWith({
    String? id,
    String? firstName,
    String? lastName,
    Value<String?> phoneNumber = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => ContactEntry(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
    email: email.present ? email.value : this.email,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  ContactEntry copyWithCompanion(ContactsCompanion data) {
    return ContactEntry(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      email: data.email.present ? data.email.value : this.email,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContactEntry(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('email: $email, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, firstName, lastName, phoneNumber, email, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContactEntry &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.phoneNumber == this.phoneNumber &&
          other.email == this.email &&
          other.deletedAt == this.deletedAt);
}

class ContactsCompanion extends UpdateCompanion<ContactEntry> {
  final Value<String> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String?> phoneNumber;
  final Value<String?> email;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ContactsCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContactsCompanion.insert({
    this.id = const Value.absent(),
    required String firstName,
    required String lastName,
    this.phoneNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : firstName = Value(firstName),
       lastName = Value(lastName);
  static Insertable<ContactEntry> custom({
    Expression<String>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? phoneNumber,
    Expression<String>? email,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (email != null) 'email': email,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContactsCompanion copyWith({
    Value<String>? id,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String?>? phoneNumber,
    Value<String?>? email,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ContactsCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactsCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('email: $email, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupsTable extends Groups with TableInfo<$GroupsTable, GroupEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, label, title];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
    );
  }

  @override
  $GroupsTable createAlias(String alias) {
    return $GroupsTable(attachedDatabase, alias);
  }
}

class GroupEntry extends DataClass implements Insertable<GroupEntry> {
  final String id;
  final String label;
  final String title;
  const GroupEntry({
    required this.id,
    required this.label,
    required this.title,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    map['title'] = Variable<String>(title);
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: Value(id),
      label: Value(label),
      title: Value(title),
    );
  }

  factory GroupEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupEntry(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'title': serializer.toJson<String>(title),
    };
  }

  GroupEntry copyWith({String? id, String? label, String? title}) => GroupEntry(
    id: id ?? this.id,
    label: label ?? this.label,
    title: title ?? this.title,
  );
  GroupEntry copyWithCompanion(GroupsCompanion data) {
    return GroupEntry(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      title: data.title.present ? data.title.value : this.title,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupEntry(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, label, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupEntry &&
          other.id == this.id &&
          other.label == this.label &&
          other.title == this.title);
}

class GroupsCompanion extends UpdateCompanion<GroupEntry> {
  final Value<String> id;
  final Value<String> label;
  final Value<String> title;
  final Value<int> rowid;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.title = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupsCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    required String title,
    this.rowid = const Value.absent(),
  }) : label = Value(label),
       title = Value(title);
  static Insertable<GroupEntry> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? title,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (title != null) 'title': title,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<String>? title,
    Value<int>? rowid,
  }) {
    return GroupsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      title: title ?? this.title,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('title: $title, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContactToGroupTable extends ContactToGroup
    with TableInfo<$ContactToGroupTable, ContactToGroupData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactToGroupTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contactIdMeta = const VerificationMeta(
    'contactId',
  );
  @override
  late final GeneratedColumn<String> contactId = GeneratedColumn<String>(
    'contact_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES contacts (id)',
    ),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [contactId, groupId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contact_to_group';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContactToGroupData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('contact_id')) {
      context.handle(
        _contactIdMeta,
        contactId.isAcceptableOrUnknown(data['contact_id']!, _contactIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contactIdMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contactId, groupId};
  @override
  ContactToGroupData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContactToGroupData(
      contactId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
    );
  }

  @override
  $ContactToGroupTable createAlias(String alias) {
    return $ContactToGroupTable(attachedDatabase, alias);
  }
}

class ContactToGroupData extends DataClass
    implements Insertable<ContactToGroupData> {
  final String contactId;
  final String groupId;
  const ContactToGroupData({required this.contactId, required this.groupId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['contact_id'] = Variable<String>(contactId);
    map['group_id'] = Variable<String>(groupId);
    return map;
  }

  ContactToGroupCompanion toCompanion(bool nullToAbsent) {
    return ContactToGroupCompanion(
      contactId: Value(contactId),
      groupId: Value(groupId),
    );
  }

  factory ContactToGroupData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContactToGroupData(
      contactId: serializer.fromJson<String>(json['contactId']),
      groupId: serializer.fromJson<String>(json['groupId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contactId': serializer.toJson<String>(contactId),
      'groupId': serializer.toJson<String>(groupId),
    };
  }

  ContactToGroupData copyWith({String? contactId, String? groupId}) =>
      ContactToGroupData(
        contactId: contactId ?? this.contactId,
        groupId: groupId ?? this.groupId,
      );
  ContactToGroupData copyWithCompanion(ContactToGroupCompanion data) {
    return ContactToGroupData(
      contactId: data.contactId.present ? data.contactId.value : this.contactId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContactToGroupData(')
          ..write('contactId: $contactId, ')
          ..write('groupId: $groupId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(contactId, groupId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContactToGroupData &&
          other.contactId == this.contactId &&
          other.groupId == this.groupId);
}

class ContactToGroupCompanion extends UpdateCompanion<ContactToGroupData> {
  final Value<String> contactId;
  final Value<String> groupId;
  final Value<int> rowid;
  const ContactToGroupCompanion({
    this.contactId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContactToGroupCompanion.insert({
    required String contactId,
    required String groupId,
    this.rowid = const Value.absent(),
  }) : contactId = Value(contactId),
       groupId = Value(groupId);
  static Insertable<ContactToGroupData> custom({
    Expression<String>? contactId,
    Expression<String>? groupId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contactId != null) 'contact_id': contactId,
      if (groupId != null) 'group_id': groupId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContactToGroupCompanion copyWith({
    Value<String>? contactId,
    Value<String>? groupId,
    Value<int>? rowid,
  }) {
    return ContactToGroupCompanion(
      contactId: contactId ?? this.contactId,
      groupId: groupId ?? this.groupId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contactId.present) {
      map['contact_id'] = Variable<String>(contactId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactToGroupCompanion(')
          ..write('contactId: $contactId, ')
          ..write('groupId: $groupId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ContactsTable contacts = $ContactsTable(this);
  late final $GroupsTable groups = $GroupsTable(this);
  late final $ContactToGroupTable contactToGroup = $ContactToGroupTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    contacts,
    groups,
    contactToGroup,
  ];
}

typedef $$ContactsTableCreateCompanionBuilder =
    ContactsCompanion Function({
      Value<String> id,
      required String firstName,
      required String lastName,
      Value<String?> phoneNumber,
      Value<String?> email,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$ContactsTableUpdateCompanionBuilder =
    ContactsCompanion Function({
      Value<String> id,
      Value<String> firstName,
      Value<String> lastName,
      Value<String?> phoneNumber,
      Value<String?> email,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$ContactsTableReferences
    extends BaseReferences<_$AppDatabase, $ContactsTable, ContactEntry> {
  $$ContactsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ContactToGroupTable, List<ContactToGroupData>>
  _contactToGroupRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.contactToGroup,
    aliasName: $_aliasNameGenerator(
      db.contacts.id,
      db.contactToGroup.contactId,
    ),
  );

  $$ContactToGroupTableProcessedTableManager get contactToGroupRefs {
    final manager = $$ContactToGroupTableTableManager(
      $_db,
      $_db.contactToGroup,
    ).filter((f) => f.contactId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_contactToGroupRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ContactsTableFilterComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> contactToGroupRefs(
    Expression<bool> Function($$ContactToGroupTableFilterComposer f) f,
  ) {
    final $$ContactToGroupTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contactToGroup,
      getReferencedColumn: (t) => t.contactId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactToGroupTableFilterComposer(
            $db: $db,
            $table: $db.contactToGroup,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> contactToGroupRefs<T extends Object>(
    Expression<T> Function($$ContactToGroupTableAnnotationComposer a) f,
  ) {
    final $$ContactToGroupTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contactToGroup,
      getReferencedColumn: (t) => t.contactId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactToGroupTableAnnotationComposer(
            $db: $db,
            $table: $db.contactToGroup,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ContactsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContactsTable,
          ContactEntry,
          $$ContactsTableFilterComposer,
          $$ContactsTableOrderingComposer,
          $$ContactsTableAnnotationComposer,
          $$ContactsTableCreateCompanionBuilder,
          $$ContactsTableUpdateCompanionBuilder,
          (ContactEntry, $$ContactsTableReferences),
          ContactEntry,
          PrefetchHooks Function({bool contactToGroupRefs})
        > {
  $$ContactsTableTableManager(_$AppDatabase db, $ContactsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContactsCompanion(
                id: id,
                firstName: firstName,
                lastName: lastName,
                phoneNumber: phoneNumber,
                email: email,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String firstName,
                required String lastName,
                Value<String?> phoneNumber = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContactsCompanion.insert(
                id: id,
                firstName: firstName,
                lastName: lastName,
                phoneNumber: phoneNumber,
                email: email,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ContactsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({contactToGroupRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (contactToGroupRefs) db.contactToGroup,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (contactToGroupRefs)
                    await $_getPrefetchedData<
                      ContactEntry,
                      $ContactsTable,
                      ContactToGroupData
                    >(
                      currentTable: table,
                      referencedTable: $$ContactsTableReferences
                          ._contactToGroupRefsTable(db),
                      managerFromTypedResult: (p0) => $$ContactsTableReferences(
                        db,
                        table,
                        p0,
                      ).contactToGroupRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.contactId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ContactsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContactsTable,
      ContactEntry,
      $$ContactsTableFilterComposer,
      $$ContactsTableOrderingComposer,
      $$ContactsTableAnnotationComposer,
      $$ContactsTableCreateCompanionBuilder,
      $$ContactsTableUpdateCompanionBuilder,
      (ContactEntry, $$ContactsTableReferences),
      ContactEntry,
      PrefetchHooks Function({bool contactToGroupRefs})
    >;
typedef $$GroupsTableCreateCompanionBuilder =
    GroupsCompanion Function({
      Value<String> id,
      required String label,
      required String title,
      Value<int> rowid,
    });
typedef $$GroupsTableUpdateCompanionBuilder =
    GroupsCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<String> title,
      Value<int> rowid,
    });

final class $$GroupsTableReferences
    extends BaseReferences<_$AppDatabase, $GroupsTable, GroupEntry> {
  $$GroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ContactToGroupTable, List<ContactToGroupData>>
  _contactToGroupRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.contactToGroup,
    aliasName: $_aliasNameGenerator(db.groups.id, db.contactToGroup.groupId),
  );

  $$ContactToGroupTableProcessedTableManager get contactToGroupRefs {
    final manager = $$ContactToGroupTableTableManager(
      $_db,
      $_db.contactToGroup,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_contactToGroupRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GroupsTableFilterComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> contactToGroupRefs(
    Expression<bool> Function($$ContactToGroupTableFilterComposer f) f,
  ) {
    final $$ContactToGroupTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contactToGroup,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactToGroupTableFilterComposer(
            $db: $db,
            $table: $db.contactToGroup,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  Expression<T> contactToGroupRefs<T extends Object>(
    Expression<T> Function($$ContactToGroupTableAnnotationComposer a) f,
  ) {
    final $$ContactToGroupTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contactToGroup,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactToGroupTableAnnotationComposer(
            $db: $db,
            $table: $db.contactToGroup,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupsTable,
          GroupEntry,
          $$GroupsTableFilterComposer,
          $$GroupsTableOrderingComposer,
          $$GroupsTableAnnotationComposer,
          $$GroupsTableCreateCompanionBuilder,
          $$GroupsTableUpdateCompanionBuilder,
          (GroupEntry, $$GroupsTableReferences),
          GroupEntry,
          PrefetchHooks Function({bool contactToGroupRefs})
        > {
  $$GroupsTableTableManager(_$AppDatabase db, $GroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupsCompanion(
                id: id,
                label: label,
                title: title,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String label,
                required String title,
                Value<int> rowid = const Value.absent(),
              }) => GroupsCompanion.insert(
                id: id,
                label: label,
                title: title,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GroupsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({contactToGroupRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (contactToGroupRefs) db.contactToGroup,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (contactToGroupRefs)
                    await $_getPrefetchedData<
                      GroupEntry,
                      $GroupsTable,
                      ContactToGroupData
                    >(
                      currentTable: table,
                      referencedTable: $$GroupsTableReferences
                          ._contactToGroupRefsTable(db),
                      managerFromTypedResult: (p0) => $$GroupsTableReferences(
                        db,
                        table,
                        p0,
                      ).contactToGroupRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.groupId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupsTable,
      GroupEntry,
      $$GroupsTableFilterComposer,
      $$GroupsTableOrderingComposer,
      $$GroupsTableAnnotationComposer,
      $$GroupsTableCreateCompanionBuilder,
      $$GroupsTableUpdateCompanionBuilder,
      (GroupEntry, $$GroupsTableReferences),
      GroupEntry,
      PrefetchHooks Function({bool contactToGroupRefs})
    >;
typedef $$ContactToGroupTableCreateCompanionBuilder =
    ContactToGroupCompanion Function({
      required String contactId,
      required String groupId,
      Value<int> rowid,
    });
typedef $$ContactToGroupTableUpdateCompanionBuilder =
    ContactToGroupCompanion Function({
      Value<String> contactId,
      Value<String> groupId,
      Value<int> rowid,
    });

final class $$ContactToGroupTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ContactToGroupTable,
          ContactToGroupData
        > {
  $$ContactToGroupTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ContactsTable _contactIdTable(_$AppDatabase db) =>
      db.contacts.createAlias(
        $_aliasNameGenerator(db.contactToGroup.contactId, db.contacts.id),
      );

  $$ContactsTableProcessedTableManager get contactId {
    final $_column = $_itemColumn<String>('contact_id')!;

    final manager = $$ContactsTableTableManager(
      $_db,
      $_db.contacts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contactIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GroupsTable _groupIdTable(_$AppDatabase db) => db.groups.createAlias(
    $_aliasNameGenerator(db.contactToGroup.groupId, db.groups.id),
  );

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ContactToGroupTableFilterComposer
    extends Composer<_$AppDatabase, $ContactToGroupTable> {
  $$ContactToGroupTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ContactsTableFilterComposer get contactId {
    final $$ContactsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contactId,
      referencedTable: $db.contacts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactsTableFilterComposer(
            $db: $db,
            $table: $db.contacts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContactToGroupTableOrderingComposer
    extends Composer<_$AppDatabase, $ContactToGroupTable> {
  $$ContactToGroupTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ContactsTableOrderingComposer get contactId {
    final $$ContactsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contactId,
      referencedTable: $db.contacts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactsTableOrderingComposer(
            $db: $db,
            $table: $db.contacts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContactToGroupTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContactToGroupTable> {
  $$ContactToGroupTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ContactsTableAnnotationComposer get contactId {
    final $$ContactsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.contactId,
      referencedTable: $db.contacts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContactsTableAnnotationComposer(
            $db: $db,
            $table: $db.contacts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContactToGroupTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContactToGroupTable,
          ContactToGroupData,
          $$ContactToGroupTableFilterComposer,
          $$ContactToGroupTableOrderingComposer,
          $$ContactToGroupTableAnnotationComposer,
          $$ContactToGroupTableCreateCompanionBuilder,
          $$ContactToGroupTableUpdateCompanionBuilder,
          (ContactToGroupData, $$ContactToGroupTableReferences),
          ContactToGroupData,
          PrefetchHooks Function({bool contactId, bool groupId})
        > {
  $$ContactToGroupTableTableManager(
    _$AppDatabase db,
    $ContactToGroupTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContactToGroupTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContactToGroupTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContactToGroupTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> contactId = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContactToGroupCompanion(
                contactId: contactId,
                groupId: groupId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String contactId,
                required String groupId,
                Value<int> rowid = const Value.absent(),
              }) => ContactToGroupCompanion.insert(
                contactId: contactId,
                groupId: groupId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ContactToGroupTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({contactId = false, groupId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (contactId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.contactId,
                                referencedTable: $$ContactToGroupTableReferences
                                    ._contactIdTable(db),
                                referencedColumn:
                                    $$ContactToGroupTableReferences
                                        ._contactIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable: $$ContactToGroupTableReferences
                                    ._groupIdTable(db),
                                referencedColumn:
                                    $$ContactToGroupTableReferences
                                        ._groupIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ContactToGroupTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContactToGroupTable,
      ContactToGroupData,
      $$ContactToGroupTableFilterComposer,
      $$ContactToGroupTableOrderingComposer,
      $$ContactToGroupTableAnnotationComposer,
      $$ContactToGroupTableCreateCompanionBuilder,
      $$ContactToGroupTableUpdateCompanionBuilder,
      (ContactToGroupData, $$ContactToGroupTableReferences),
      ContactToGroupData,
      PrefetchHooks Function({bool contactId, bool groupId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ContactsTableTableManager get contacts =>
      $$ContactsTableTableManager(_db, _db.contacts);
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db, _db.groups);
  $$ContactToGroupTableTableManager get contactToGroup =>
      $$ContactToGroupTableTableManager(_db, _db.contactToGroup);
}
