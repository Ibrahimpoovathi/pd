// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TodosTable extends Todos with TableInfo<$TodosTable, Todo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueTimeMinutesMeta = const VerificationMeta(
    'dueTimeMinutes',
  );
  @override
  late final GeneratedColumn<int> dueTimeMinutes = GeneratedColumn<int>(
    'due_time_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _reminder10amSentMeta = const VerificationMeta(
    'reminder10amSent',
  );
  @override
  late final GeneratedColumn<bool> reminder10amSent = GeneratedColumn<bool>(
    'reminder10am_sent',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder10am_sent" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reminder6pmSentMeta = const VerificationMeta(
    'reminder6pmSent',
  );
  @override
  late final GeneratedColumn<bool> reminder6pmSent = GeneratedColumn<bool>(
    'reminder6pm_sent',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder6pm_sent" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    dueDate,
    dueTimeMinutes,
    isFavorite,
    isCompleted,
    completedAt,
    createdAt,
    updatedAt,
    reminder10amSent,
    reminder6pmSent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Todo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('due_time_minutes')) {
      context.handle(
        _dueTimeMinutesMeta,
        dueTimeMinutes.isAcceptableOrUnknown(
          data['due_time_minutes']!,
          _dueTimeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('reminder10am_sent')) {
      context.handle(
        _reminder10amSentMeta,
        reminder10amSent.isAcceptableOrUnknown(
          data['reminder10am_sent']!,
          _reminder10amSentMeta,
        ),
      );
    }
    if (data.containsKey('reminder6pm_sent')) {
      context.handle(
        _reminder6pmSentMeta,
        reminder6pmSent.isAcceptableOrUnknown(
          data['reminder6pm_sent']!,
          _reminder6pmSentMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Todo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Todo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      dueTimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_time_minutes'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      reminder10amSent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder10am_sent'],
      )!,
      reminder6pmSent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder6pm_sent'],
      )!,
    );
  }

  @override
  $TodosTable createAlias(String alias) {
    return $TodosTable(attachedDatabase, alias);
  }
}

class Todo extends DataClass implements Insertable<Todo> {
  final int id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final int? dueTimeMinutes;
  final bool isFavorite;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool reminder10amSent;
  final bool reminder6pmSent;
  const Todo({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.dueTimeMinutes,
    required this.isFavorite,
    required this.isCompleted,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.reminder10amSent,
    required this.reminder6pmSent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || dueTimeMinutes != null) {
      map['due_time_minutes'] = Variable<int>(dueTimeMinutes);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['reminder10am_sent'] = Variable<bool>(reminder10amSent);
    map['reminder6pm_sent'] = Variable<bool>(reminder6pmSent);
    return map;
  }

  TodosCompanion toCompanion(bool nullToAbsent) {
    return TodosCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      dueTimeMinutes: dueTimeMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(dueTimeMinutes),
      isFavorite: Value(isFavorite),
      isCompleted: Value(isCompleted),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      reminder10amSent: Value(reminder10amSent),
      reminder6pmSent: Value(reminder6pmSent),
    );
  }

  factory Todo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Todo(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      dueTimeMinutes: serializer.fromJson<int?>(json['dueTimeMinutes']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      reminder10amSent: serializer.fromJson<bool>(json['reminder10amSent']),
      reminder6pmSent: serializer.fromJson<bool>(json['reminder6pmSent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'dueTimeMinutes': serializer.toJson<int?>(dueTimeMinutes),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'reminder10amSent': serializer.toJson<bool>(reminder10amSent),
      'reminder6pmSent': serializer.toJson<bool>(reminder6pmSent),
    };
  }

  Todo copyWith({
    int? id,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<DateTime?> dueDate = const Value.absent(),
    Value<int?> dueTimeMinutes = const Value.absent(),
    bool? isFavorite,
    bool? isCompleted,
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? reminder10amSent,
    bool? reminder6pmSent,
  }) => Todo(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    dueTimeMinutes: dueTimeMinutes.present
        ? dueTimeMinutes.value
        : this.dueTimeMinutes,
    isFavorite: isFavorite ?? this.isFavorite,
    isCompleted: isCompleted ?? this.isCompleted,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    reminder10amSent: reminder10amSent ?? this.reminder10amSent,
    reminder6pmSent: reminder6pmSent ?? this.reminder6pmSent,
  );
  Todo copyWithCompanion(TodosCompanion data) {
    return Todo(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      dueTimeMinutes: data.dueTimeMinutes.present
          ? data.dueTimeMinutes.value
          : this.dueTimeMinutes,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      reminder10amSent: data.reminder10amSent.present
          ? data.reminder10amSent.value
          : this.reminder10amSent,
      reminder6pmSent: data.reminder6pmSent.present
          ? data.reminder6pmSent.value
          : this.reminder6pmSent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Todo(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTimeMinutes: $dueTimeMinutes, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('reminder10amSent: $reminder10amSent, ')
          ..write('reminder6pmSent: $reminder6pmSent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    dueDate,
    dueTimeMinutes,
    isFavorite,
    isCompleted,
    completedAt,
    createdAt,
    updatedAt,
    reminder10amSent,
    reminder6pmSent,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Todo &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.dueDate == this.dueDate &&
          other.dueTimeMinutes == this.dueTimeMinutes &&
          other.isFavorite == this.isFavorite &&
          other.isCompleted == this.isCompleted &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.reminder10amSent == this.reminder10amSent &&
          other.reminder6pmSent == this.reminder6pmSent);
}

class TodosCompanion extends UpdateCompanion<Todo> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime?> dueDate;
  final Value<int?> dueTimeMinutes;
  final Value<bool> isFavorite;
  final Value<bool> isCompleted;
  final Value<DateTime?> completedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> reminder10amSent;
  final Value<bool> reminder6pmSent;
  const TodosCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueTimeMinutes = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.reminder10amSent = const Value.absent(),
    this.reminder6pmSent = const Value.absent(),
  });
  TodosCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueTimeMinutes = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.reminder10amSent = const Value.absent(),
    this.reminder6pmSent = const Value.absent(),
  }) : title = Value(title);
  static Insertable<Todo> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? dueDate,
    Expression<int>? dueTimeMinutes,
    Expression<bool>? isFavorite,
    Expression<bool>? isCompleted,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? reminder10amSent,
    Expression<bool>? reminder6pmSent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (dueDate != null) 'due_date': dueDate,
      if (dueTimeMinutes != null) 'due_time_minutes': dueTimeMinutes,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (reminder10amSent != null) 'reminder10am_sent': reminder10amSent,
      if (reminder6pmSent != null) 'reminder6pm_sent': reminder6pmSent,
    });
  }

  TodosCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<DateTime?>? dueDate,
    Value<int?>? dueTimeMinutes,
    Value<bool>? isFavorite,
    Value<bool>? isCompleted,
    Value<DateTime?>? completedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? reminder10amSent,
    Value<bool>? reminder6pmSent,
  }) {
    return TodosCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      dueTimeMinutes: dueTimeMinutes ?? this.dueTimeMinutes,
      isFavorite: isFavorite ?? this.isFavorite,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reminder10amSent: reminder10amSent ?? this.reminder10amSent,
      reminder6pmSent: reminder6pmSent ?? this.reminder6pmSent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (dueTimeMinutes.present) {
      map['due_time_minutes'] = Variable<int>(dueTimeMinutes.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (reminder10amSent.present) {
      map['reminder10am_sent'] = Variable<bool>(reminder10amSent.value);
    }
    if (reminder6pmSent.present) {
      map['reminder6pm_sent'] = Variable<bool>(reminder6pmSent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTimeMinutes: $dueTimeMinutes, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('reminder10amSent: $reminder10amSent, ')
          ..write('reminder6pmSent: $reminder6pmSent')
          ..write(')'))
        .toString();
  }
}

class $TodoTrashTable extends TodoTrash
    with TableInfo<$TodoTrashTable, TodoTrashData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoTrashTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _todoIdMeta = const VerificationMeta('todoId');
  @override
  late final GeneratedColumn<int> todoId = GeneratedColumn<int>(
    'todo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _originalDueDateMeta = const VerificationMeta(
    'originalDueDate',
  );
  @override
  late final GeneratedColumn<DateTime> originalDueDate =
      GeneratedColumn<DateTime>(
        'original_due_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    todoId,
    title,
    originalDueDate,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_trash';
  @override
  VerificationContext validateIntegrity(
    Insertable<TodoTrashData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('todo_id')) {
      context.handle(
        _todoIdMeta,
        todoId.isAcceptableOrUnknown(data['todo_id']!, _todoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_todoIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('original_due_date')) {
      context.handle(
        _originalDueDateMeta,
        originalDueDate.isAcceptableOrUnknown(
          data['original_due_date']!,
          _originalDueDateMeta,
        ),
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
  TodoTrashData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoTrashData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      todoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}todo_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      originalDueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}original_due_date'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      )!,
    );
  }

  @override
  $TodoTrashTable createAlias(String alias) {
    return $TodoTrashTable(attachedDatabase, alias);
  }
}

class TodoTrashData extends DataClass implements Insertable<TodoTrashData> {
  final int id;
  final int todoId;
  final String title;
  final DateTime? originalDueDate;
  final DateTime deletedAt;
  const TodoTrashData({
    required this.id,
    required this.todoId,
    required this.title,
    this.originalDueDate,
    required this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['todo_id'] = Variable<int>(todoId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || originalDueDate != null) {
      map['original_due_date'] = Variable<DateTime>(originalDueDate);
    }
    map['deleted_at'] = Variable<DateTime>(deletedAt);
    return map;
  }

  TodoTrashCompanion toCompanion(bool nullToAbsent) {
    return TodoTrashCompanion(
      id: Value(id),
      todoId: Value(todoId),
      title: Value(title),
      originalDueDate: originalDueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(originalDueDate),
      deletedAt: Value(deletedAt),
    );
  }

  factory TodoTrashData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoTrashData(
      id: serializer.fromJson<int>(json['id']),
      todoId: serializer.fromJson<int>(json['todoId']),
      title: serializer.fromJson<String>(json['title']),
      originalDueDate: serializer.fromJson<DateTime?>(json['originalDueDate']),
      deletedAt: serializer.fromJson<DateTime>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'todoId': serializer.toJson<int>(todoId),
      'title': serializer.toJson<String>(title),
      'originalDueDate': serializer.toJson<DateTime?>(originalDueDate),
      'deletedAt': serializer.toJson<DateTime>(deletedAt),
    };
  }

  TodoTrashData copyWith({
    int? id,
    int? todoId,
    String? title,
    Value<DateTime?> originalDueDate = const Value.absent(),
    DateTime? deletedAt,
  }) => TodoTrashData(
    id: id ?? this.id,
    todoId: todoId ?? this.todoId,
    title: title ?? this.title,
    originalDueDate: originalDueDate.present
        ? originalDueDate.value
        : this.originalDueDate,
    deletedAt: deletedAt ?? this.deletedAt,
  );
  TodoTrashData copyWithCompanion(TodoTrashCompanion data) {
    return TodoTrashData(
      id: data.id.present ? data.id.value : this.id,
      todoId: data.todoId.present ? data.todoId.value : this.todoId,
      title: data.title.present ? data.title.value : this.title,
      originalDueDate: data.originalDueDate.present
          ? data.originalDueDate.value
          : this.originalDueDate,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoTrashData(')
          ..write('id: $id, ')
          ..write('todoId: $todoId, ')
          ..write('title: $title, ')
          ..write('originalDueDate: $originalDueDate, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, todoId, title, originalDueDate, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoTrashData &&
          other.id == this.id &&
          other.todoId == this.todoId &&
          other.title == this.title &&
          other.originalDueDate == this.originalDueDate &&
          other.deletedAt == this.deletedAt);
}

class TodoTrashCompanion extends UpdateCompanion<TodoTrashData> {
  final Value<int> id;
  final Value<int> todoId;
  final Value<String> title;
  final Value<DateTime?> originalDueDate;
  final Value<DateTime> deletedAt;
  const TodoTrashCompanion({
    this.id = const Value.absent(),
    this.todoId = const Value.absent(),
    this.title = const Value.absent(),
    this.originalDueDate = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  TodoTrashCompanion.insert({
    this.id = const Value.absent(),
    required int todoId,
    required String title,
    this.originalDueDate = const Value.absent(),
    this.deletedAt = const Value.absent(),
  }) : todoId = Value(todoId),
       title = Value(title);
  static Insertable<TodoTrashData> custom({
    Expression<int>? id,
    Expression<int>? todoId,
    Expression<String>? title,
    Expression<DateTime>? originalDueDate,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (todoId != null) 'todo_id': todoId,
      if (title != null) 'title': title,
      if (originalDueDate != null) 'original_due_date': originalDueDate,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  TodoTrashCompanion copyWith({
    Value<int>? id,
    Value<int>? todoId,
    Value<String>? title,
    Value<DateTime?>? originalDueDate,
    Value<DateTime>? deletedAt,
  }) {
    return TodoTrashCompanion(
      id: id ?? this.id,
      todoId: todoId ?? this.todoId,
      title: title ?? this.title,
      originalDueDate: originalDueDate ?? this.originalDueDate,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (todoId.present) {
      map['todo_id'] = Variable<int>(todoId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (originalDueDate.present) {
      map['original_due_date'] = Variable<DateTime>(originalDueDate.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoTrashCompanion(')
          ..write('id: $id, ')
          ..write('todoId: $todoId, ')
          ..write('title: $title, ')
          ..write('originalDueDate: $originalDueDate, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $PrayerRecordsTable extends PrayerRecords
    with TableInfo<$PrayerRecordsTable, PrayerRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrayerRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fajrMeta = const VerificationMeta('fajr');
  @override
  late final GeneratedColumn<bool> fajr = GeneratedColumn<bool>(
    'fajr',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("fajr" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dhuhrMeta = const VerificationMeta('dhuhr');
  @override
  late final GeneratedColumn<bool> dhuhr = GeneratedColumn<bool>(
    'dhuhr',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dhuhr" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _asrMeta = const VerificationMeta('asr');
  @override
  late final GeneratedColumn<bool> asr = GeneratedColumn<bool>(
    'asr',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("asr" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _maghribMeta = const VerificationMeta(
    'maghrib',
  );
  @override
  late final GeneratedColumn<bool> maghrib = GeneratedColumn<bool>(
    'maghrib',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("maghrib" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ishaMeta = const VerificationMeta('isha');
  @override
  late final GeneratedColumn<bool> isha = GeneratedColumn<bool>(
    'isha',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("isha" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fajrJamaatMeta = const VerificationMeta(
    'fajrJamaat',
  );
  @override
  late final GeneratedColumn<bool> fajrJamaat = GeneratedColumn<bool>(
    'fajr_jamaat',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("fajr_jamaat" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dhuhrJamaatMeta = const VerificationMeta(
    'dhuhrJamaat',
  );
  @override
  late final GeneratedColumn<bool> dhuhrJamaat = GeneratedColumn<bool>(
    'dhuhr_jamaat',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dhuhr_jamaat" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _asrJamaatMeta = const VerificationMeta(
    'asrJamaat',
  );
  @override
  late final GeneratedColumn<bool> asrJamaat = GeneratedColumn<bool>(
    'asr_jamaat',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("asr_jamaat" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _maghribJamaatMeta = const VerificationMeta(
    'maghribJamaat',
  );
  @override
  late final GeneratedColumn<bool> maghribJamaat = GeneratedColumn<bool>(
    'maghrib_jamaat',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("maghrib_jamaat" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ishaJamaatMeta = const VerificationMeta(
    'ishaJamaat',
  );
  @override
  late final GeneratedColumn<bool> ishaJamaat = GeneratedColumn<bool>(
    'isha_jamaat',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("isha_jamaat" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fajrMosqueMeta = const VerificationMeta(
    'fajrMosque',
  );
  @override
  late final GeneratedColumn<bool> fajrMosque = GeneratedColumn<bool>(
    'fajr_mosque',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("fajr_mosque" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dhuhrMosqueMeta = const VerificationMeta(
    'dhuhrMosque',
  );
  @override
  late final GeneratedColumn<bool> dhuhrMosque = GeneratedColumn<bool>(
    'dhuhr_mosque',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dhuhr_mosque" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _asrMosqueMeta = const VerificationMeta(
    'asrMosque',
  );
  @override
  late final GeneratedColumn<bool> asrMosque = GeneratedColumn<bool>(
    'asr_mosque',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("asr_mosque" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _maghribMosqueMeta = const VerificationMeta(
    'maghribMosque',
  );
  @override
  late final GeneratedColumn<bool> maghribMosque = GeneratedColumn<bool>(
    'maghrib_mosque',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("maghrib_mosque" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ishaMosqueMeta = const VerificationMeta(
    'ishaMosque',
  );
  @override
  late final GeneratedColumn<bool> ishaMosque = GeneratedColumn<bool>(
    'isha_mosque',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("isha_mosque" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tahajjudMeta = const VerificationMeta(
    'tahajjud',
  );
  @override
  late final GeneratedColumn<bool> tahajjud = GeneratedColumn<bool>(
    'tahajjud',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("tahajjud" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _duhaMeta = const VerificationMeta('duha');
  @override
  late final GeneratedColumn<bool> duha = GeneratedColumn<bool>(
    'duha',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("duha" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _quranWaqiahMeta = const VerificationMeta(
    'quranWaqiah',
  );
  @override
  late final GeneratedColumn<bool> quranWaqiah = GeneratedColumn<bool>(
    'quran_waqiah',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("quran_waqiah" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _quranMulkMeta = const VerificationMeta(
    'quranMulk',
  );
  @override
  late final GeneratedColumn<bool> quranMulk = GeneratedColumn<bool>(
    'quran_mulk',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("quran_mulk" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _quranOtherPagesMeta = const VerificationMeta(
    'quranOtherPages',
  );
  @override
  late final GeneratedColumn<int> quranOtherPages = GeneratedColumn<int>(
    'quran_other_pages',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _adhkarMorningMeta = const VerificationMeta(
    'adhkarMorning',
  );
  @override
  late final GeneratedColumn<bool> adhkarMorning = GeneratedColumn<bool>(
    'adhkar_morning',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("adhkar_morning" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _adhkarEveningMeta = const VerificationMeta(
    'adhkarEvening',
  );
  @override
  late final GeneratedColumn<bool> adhkarEvening = GeneratedColumn<bool>(
    'adhkar_evening',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("adhkar_evening" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _salatDoneMeta = const VerificationMeta(
    'salatDone',
  );
  @override
  late final GeneratedColumn<bool> salatDone = GeneratedColumn<bool>(
    'salat_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("salat_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _salatCountMeta = const VerificationMeta(
    'salatCount',
  );
  @override
  late final GeneratedColumn<int> salatCount = GeneratedColumn<int>(
    'salat_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _thahleelDoneMeta = const VerificationMeta(
    'thahleelDone',
  );
  @override
  late final GeneratedColumn<bool> thahleelDone = GeneratedColumn<bool>(
    'thahleel_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("thahleel_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _thahleelCountMeta = const VerificationMeta(
    'thahleelCount',
  );
  @override
  late final GeneratedColumn<int> thahleelCount = GeneratedColumn<int>(
    'thahleel_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isthighfarDoneMeta = const VerificationMeta(
    'isthighfarDone',
  );
  @override
  late final GeneratedColumn<bool> isthighfarDone = GeneratedColumn<bool>(
    'isthighfar_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("isthighfar_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isthighfarCountMeta = const VerificationMeta(
    'isthighfarCount',
  );
  @override
  late final GeneratedColumn<int> isthighfarCount = GeneratedColumn<int>(
    'isthighfar_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    fajr,
    dhuhr,
    asr,
    maghrib,
    isha,
    fajrJamaat,
    dhuhrJamaat,
    asrJamaat,
    maghribJamaat,
    ishaJamaat,
    fajrMosque,
    dhuhrMosque,
    asrMosque,
    maghribMosque,
    ishaMosque,
    tahajjud,
    duha,
    quranWaqiah,
    quranMulk,
    quranOtherPages,
    adhkarMorning,
    adhkarEvening,
    salatDone,
    salatCount,
    thahleelDone,
    thahleelCount,
    isthighfarDone,
    isthighfarCount,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prayer_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrayerRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('fajr')) {
      context.handle(
        _fajrMeta,
        fajr.isAcceptableOrUnknown(data['fajr']!, _fajrMeta),
      );
    }
    if (data.containsKey('dhuhr')) {
      context.handle(
        _dhuhrMeta,
        dhuhr.isAcceptableOrUnknown(data['dhuhr']!, _dhuhrMeta),
      );
    }
    if (data.containsKey('asr')) {
      context.handle(
        _asrMeta,
        asr.isAcceptableOrUnknown(data['asr']!, _asrMeta),
      );
    }
    if (data.containsKey('maghrib')) {
      context.handle(
        _maghribMeta,
        maghrib.isAcceptableOrUnknown(data['maghrib']!, _maghribMeta),
      );
    }
    if (data.containsKey('isha')) {
      context.handle(
        _ishaMeta,
        isha.isAcceptableOrUnknown(data['isha']!, _ishaMeta),
      );
    }
    if (data.containsKey('fajr_jamaat')) {
      context.handle(
        _fajrJamaatMeta,
        fajrJamaat.isAcceptableOrUnknown(data['fajr_jamaat']!, _fajrJamaatMeta),
      );
    }
    if (data.containsKey('dhuhr_jamaat')) {
      context.handle(
        _dhuhrJamaatMeta,
        dhuhrJamaat.isAcceptableOrUnknown(
          data['dhuhr_jamaat']!,
          _dhuhrJamaatMeta,
        ),
      );
    }
    if (data.containsKey('asr_jamaat')) {
      context.handle(
        _asrJamaatMeta,
        asrJamaat.isAcceptableOrUnknown(data['asr_jamaat']!, _asrJamaatMeta),
      );
    }
    if (data.containsKey('maghrib_jamaat')) {
      context.handle(
        _maghribJamaatMeta,
        maghribJamaat.isAcceptableOrUnknown(
          data['maghrib_jamaat']!,
          _maghribJamaatMeta,
        ),
      );
    }
    if (data.containsKey('isha_jamaat')) {
      context.handle(
        _ishaJamaatMeta,
        ishaJamaat.isAcceptableOrUnknown(data['isha_jamaat']!, _ishaJamaatMeta),
      );
    }
    if (data.containsKey('fajr_mosque')) {
      context.handle(
        _fajrMosqueMeta,
        fajrMosque.isAcceptableOrUnknown(data['fajr_mosque']!, _fajrMosqueMeta),
      );
    }
    if (data.containsKey('dhuhr_mosque')) {
      context.handle(
        _dhuhrMosqueMeta,
        dhuhrMosque.isAcceptableOrUnknown(
          data['dhuhr_mosque']!,
          _dhuhrMosqueMeta,
        ),
      );
    }
    if (data.containsKey('asr_mosque')) {
      context.handle(
        _asrMosqueMeta,
        asrMosque.isAcceptableOrUnknown(data['asr_mosque']!, _asrMosqueMeta),
      );
    }
    if (data.containsKey('maghrib_mosque')) {
      context.handle(
        _maghribMosqueMeta,
        maghribMosque.isAcceptableOrUnknown(
          data['maghrib_mosque']!,
          _maghribMosqueMeta,
        ),
      );
    }
    if (data.containsKey('isha_mosque')) {
      context.handle(
        _ishaMosqueMeta,
        ishaMosque.isAcceptableOrUnknown(data['isha_mosque']!, _ishaMosqueMeta),
      );
    }
    if (data.containsKey('tahajjud')) {
      context.handle(
        _tahajjudMeta,
        tahajjud.isAcceptableOrUnknown(data['tahajjud']!, _tahajjudMeta),
      );
    }
    if (data.containsKey('duha')) {
      context.handle(
        _duhaMeta,
        duha.isAcceptableOrUnknown(data['duha']!, _duhaMeta),
      );
    }
    if (data.containsKey('quran_waqiah')) {
      context.handle(
        _quranWaqiahMeta,
        quranWaqiah.isAcceptableOrUnknown(
          data['quran_waqiah']!,
          _quranWaqiahMeta,
        ),
      );
    }
    if (data.containsKey('quran_mulk')) {
      context.handle(
        _quranMulkMeta,
        quranMulk.isAcceptableOrUnknown(data['quran_mulk']!, _quranMulkMeta),
      );
    }
    if (data.containsKey('quran_other_pages')) {
      context.handle(
        _quranOtherPagesMeta,
        quranOtherPages.isAcceptableOrUnknown(
          data['quran_other_pages']!,
          _quranOtherPagesMeta,
        ),
      );
    }
    if (data.containsKey('adhkar_morning')) {
      context.handle(
        _adhkarMorningMeta,
        adhkarMorning.isAcceptableOrUnknown(
          data['adhkar_morning']!,
          _adhkarMorningMeta,
        ),
      );
    }
    if (data.containsKey('adhkar_evening')) {
      context.handle(
        _adhkarEveningMeta,
        adhkarEvening.isAcceptableOrUnknown(
          data['adhkar_evening']!,
          _adhkarEveningMeta,
        ),
      );
    }
    if (data.containsKey('salat_done')) {
      context.handle(
        _salatDoneMeta,
        salatDone.isAcceptableOrUnknown(data['salat_done']!, _salatDoneMeta),
      );
    }
    if (data.containsKey('salat_count')) {
      context.handle(
        _salatCountMeta,
        salatCount.isAcceptableOrUnknown(data['salat_count']!, _salatCountMeta),
      );
    }
    if (data.containsKey('thahleel_done')) {
      context.handle(
        _thahleelDoneMeta,
        thahleelDone.isAcceptableOrUnknown(
          data['thahleel_done']!,
          _thahleelDoneMeta,
        ),
      );
    }
    if (data.containsKey('thahleel_count')) {
      context.handle(
        _thahleelCountMeta,
        thahleelCount.isAcceptableOrUnknown(
          data['thahleel_count']!,
          _thahleelCountMeta,
        ),
      );
    }
    if (data.containsKey('isthighfar_done')) {
      context.handle(
        _isthighfarDoneMeta,
        isthighfarDone.isAcceptableOrUnknown(
          data['isthighfar_done']!,
          _isthighfarDoneMeta,
        ),
      );
    }
    if (data.containsKey('isthighfar_count')) {
      context.handle(
        _isthighfarCountMeta,
        isthighfarCount.isAcceptableOrUnknown(
          data['isthighfar_count']!,
          _isthighfarCountMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrayerRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrayerRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      fajr: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}fajr'],
      )!,
      dhuhr: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dhuhr'],
      )!,
      asr: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}asr'],
      )!,
      maghrib: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}maghrib'],
      )!,
      isha: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}isha'],
      )!,
      fajrJamaat: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}fajr_jamaat'],
      )!,
      dhuhrJamaat: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dhuhr_jamaat'],
      )!,
      asrJamaat: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}asr_jamaat'],
      )!,
      maghribJamaat: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}maghrib_jamaat'],
      )!,
      ishaJamaat: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}isha_jamaat'],
      )!,
      fajrMosque: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}fajr_mosque'],
      )!,
      dhuhrMosque: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dhuhr_mosque'],
      )!,
      asrMosque: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}asr_mosque'],
      )!,
      maghribMosque: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}maghrib_mosque'],
      )!,
      ishaMosque: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}isha_mosque'],
      )!,
      tahajjud: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}tahajjud'],
      )!,
      duha: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}duha'],
      )!,
      quranWaqiah: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}quran_waqiah'],
      )!,
      quranMulk: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}quran_mulk'],
      )!,
      quranOtherPages: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quran_other_pages'],
      )!,
      adhkarMorning: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}adhkar_morning'],
      )!,
      adhkarEvening: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}adhkar_evening'],
      )!,
      salatDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}salat_done'],
      )!,
      salatCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}salat_count'],
      )!,
      thahleelDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}thahleel_done'],
      )!,
      thahleelCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}thahleel_count'],
      )!,
      isthighfarDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}isthighfar_done'],
      )!,
      isthighfarCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}isthighfar_count'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PrayerRecordsTable createAlias(String alias) {
    return $PrayerRecordsTable(attachedDatabase, alias);
  }
}

class PrayerRecord extends DataClass implements Insertable<PrayerRecord> {
  final int id;
  final DateTime date;
  final bool fajr;
  final bool dhuhr;
  final bool asr;
  final bool maghrib;
  final bool isha;
  final bool fajrJamaat;
  final bool dhuhrJamaat;
  final bool asrJamaat;
  final bool maghribJamaat;
  final bool ishaJamaat;
  final bool fajrMosque;
  final bool dhuhrMosque;
  final bool asrMosque;
  final bool maghribMosque;
  final bool ishaMosque;
  final bool tahajjud;
  final bool duha;
  final bool quranWaqiah;
  final bool quranMulk;
  final int quranOtherPages;
  final bool adhkarMorning;
  final bool adhkarEvening;
  final bool salatDone;
  final int salatCount;
  final bool thahleelDone;
  final int thahleelCount;
  final bool isthighfarDone;
  final int isthighfarCount;
  final DateTime updatedAt;
  const PrayerRecord({
    required this.id,
    required this.date,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.fajrJamaat,
    required this.dhuhrJamaat,
    required this.asrJamaat,
    required this.maghribJamaat,
    required this.ishaJamaat,
    required this.fajrMosque,
    required this.dhuhrMosque,
    required this.asrMosque,
    required this.maghribMosque,
    required this.ishaMosque,
    required this.tahajjud,
    required this.duha,
    required this.quranWaqiah,
    required this.quranMulk,
    required this.quranOtherPages,
    required this.adhkarMorning,
    required this.adhkarEvening,
    required this.salatDone,
    required this.salatCount,
    required this.thahleelDone,
    required this.thahleelCount,
    required this.isthighfarDone,
    required this.isthighfarCount,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['fajr'] = Variable<bool>(fajr);
    map['dhuhr'] = Variable<bool>(dhuhr);
    map['asr'] = Variable<bool>(asr);
    map['maghrib'] = Variable<bool>(maghrib);
    map['isha'] = Variable<bool>(isha);
    map['fajr_jamaat'] = Variable<bool>(fajrJamaat);
    map['dhuhr_jamaat'] = Variable<bool>(dhuhrJamaat);
    map['asr_jamaat'] = Variable<bool>(asrJamaat);
    map['maghrib_jamaat'] = Variable<bool>(maghribJamaat);
    map['isha_jamaat'] = Variable<bool>(ishaJamaat);
    map['fajr_mosque'] = Variable<bool>(fajrMosque);
    map['dhuhr_mosque'] = Variable<bool>(dhuhrMosque);
    map['asr_mosque'] = Variable<bool>(asrMosque);
    map['maghrib_mosque'] = Variable<bool>(maghribMosque);
    map['isha_mosque'] = Variable<bool>(ishaMosque);
    map['tahajjud'] = Variable<bool>(tahajjud);
    map['duha'] = Variable<bool>(duha);
    map['quran_waqiah'] = Variable<bool>(quranWaqiah);
    map['quran_mulk'] = Variable<bool>(quranMulk);
    map['quran_other_pages'] = Variable<int>(quranOtherPages);
    map['adhkar_morning'] = Variable<bool>(adhkarMorning);
    map['adhkar_evening'] = Variable<bool>(adhkarEvening);
    map['salat_done'] = Variable<bool>(salatDone);
    map['salat_count'] = Variable<int>(salatCount);
    map['thahleel_done'] = Variable<bool>(thahleelDone);
    map['thahleel_count'] = Variable<int>(thahleelCount);
    map['isthighfar_done'] = Variable<bool>(isthighfarDone);
    map['isthighfar_count'] = Variable<int>(isthighfarCount);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PrayerRecordsCompanion toCompanion(bool nullToAbsent) {
    return PrayerRecordsCompanion(
      id: Value(id),
      date: Value(date),
      fajr: Value(fajr),
      dhuhr: Value(dhuhr),
      asr: Value(asr),
      maghrib: Value(maghrib),
      isha: Value(isha),
      fajrJamaat: Value(fajrJamaat),
      dhuhrJamaat: Value(dhuhrJamaat),
      asrJamaat: Value(asrJamaat),
      maghribJamaat: Value(maghribJamaat),
      ishaJamaat: Value(ishaJamaat),
      fajrMosque: Value(fajrMosque),
      dhuhrMosque: Value(dhuhrMosque),
      asrMosque: Value(asrMosque),
      maghribMosque: Value(maghribMosque),
      ishaMosque: Value(ishaMosque),
      tahajjud: Value(tahajjud),
      duha: Value(duha),
      quranWaqiah: Value(quranWaqiah),
      quranMulk: Value(quranMulk),
      quranOtherPages: Value(quranOtherPages),
      adhkarMorning: Value(adhkarMorning),
      adhkarEvening: Value(adhkarEvening),
      salatDone: Value(salatDone),
      salatCount: Value(salatCount),
      thahleelDone: Value(thahleelDone),
      thahleelCount: Value(thahleelCount),
      isthighfarDone: Value(isthighfarDone),
      isthighfarCount: Value(isthighfarCount),
      updatedAt: Value(updatedAt),
    );
  }

  factory PrayerRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrayerRecord(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      fajr: serializer.fromJson<bool>(json['fajr']),
      dhuhr: serializer.fromJson<bool>(json['dhuhr']),
      asr: serializer.fromJson<bool>(json['asr']),
      maghrib: serializer.fromJson<bool>(json['maghrib']),
      isha: serializer.fromJson<bool>(json['isha']),
      fajrJamaat: serializer.fromJson<bool>(json['fajrJamaat']),
      dhuhrJamaat: serializer.fromJson<bool>(json['dhuhrJamaat']),
      asrJamaat: serializer.fromJson<bool>(json['asrJamaat']),
      maghribJamaat: serializer.fromJson<bool>(json['maghribJamaat']),
      ishaJamaat: serializer.fromJson<bool>(json['ishaJamaat']),
      fajrMosque: serializer.fromJson<bool>(json['fajrMosque']),
      dhuhrMosque: serializer.fromJson<bool>(json['dhuhrMosque']),
      asrMosque: serializer.fromJson<bool>(json['asrMosque']),
      maghribMosque: serializer.fromJson<bool>(json['maghribMosque']),
      ishaMosque: serializer.fromJson<bool>(json['ishaMosque']),
      tahajjud: serializer.fromJson<bool>(json['tahajjud']),
      duha: serializer.fromJson<bool>(json['duha']),
      quranWaqiah: serializer.fromJson<bool>(json['quranWaqiah']),
      quranMulk: serializer.fromJson<bool>(json['quranMulk']),
      quranOtherPages: serializer.fromJson<int>(json['quranOtherPages']),
      adhkarMorning: serializer.fromJson<bool>(json['adhkarMorning']),
      adhkarEvening: serializer.fromJson<bool>(json['adhkarEvening']),
      salatDone: serializer.fromJson<bool>(json['salatDone']),
      salatCount: serializer.fromJson<int>(json['salatCount']),
      thahleelDone: serializer.fromJson<bool>(json['thahleelDone']),
      thahleelCount: serializer.fromJson<int>(json['thahleelCount']),
      isthighfarDone: serializer.fromJson<bool>(json['isthighfarDone']),
      isthighfarCount: serializer.fromJson<int>(json['isthighfarCount']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'fajr': serializer.toJson<bool>(fajr),
      'dhuhr': serializer.toJson<bool>(dhuhr),
      'asr': serializer.toJson<bool>(asr),
      'maghrib': serializer.toJson<bool>(maghrib),
      'isha': serializer.toJson<bool>(isha),
      'fajrJamaat': serializer.toJson<bool>(fajrJamaat),
      'dhuhrJamaat': serializer.toJson<bool>(dhuhrJamaat),
      'asrJamaat': serializer.toJson<bool>(asrJamaat),
      'maghribJamaat': serializer.toJson<bool>(maghribJamaat),
      'ishaJamaat': serializer.toJson<bool>(ishaJamaat),
      'fajrMosque': serializer.toJson<bool>(fajrMosque),
      'dhuhrMosque': serializer.toJson<bool>(dhuhrMosque),
      'asrMosque': serializer.toJson<bool>(asrMosque),
      'maghribMosque': serializer.toJson<bool>(maghribMosque),
      'ishaMosque': serializer.toJson<bool>(ishaMosque),
      'tahajjud': serializer.toJson<bool>(tahajjud),
      'duha': serializer.toJson<bool>(duha),
      'quranWaqiah': serializer.toJson<bool>(quranWaqiah),
      'quranMulk': serializer.toJson<bool>(quranMulk),
      'quranOtherPages': serializer.toJson<int>(quranOtherPages),
      'adhkarMorning': serializer.toJson<bool>(adhkarMorning),
      'adhkarEvening': serializer.toJson<bool>(adhkarEvening),
      'salatDone': serializer.toJson<bool>(salatDone),
      'salatCount': serializer.toJson<int>(salatCount),
      'thahleelDone': serializer.toJson<bool>(thahleelDone),
      'thahleelCount': serializer.toJson<int>(thahleelCount),
      'isthighfarDone': serializer.toJson<bool>(isthighfarDone),
      'isthighfarCount': serializer.toJson<int>(isthighfarCount),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PrayerRecord copyWith({
    int? id,
    DateTime? date,
    bool? fajr,
    bool? dhuhr,
    bool? asr,
    bool? maghrib,
    bool? isha,
    bool? fajrJamaat,
    bool? dhuhrJamaat,
    bool? asrJamaat,
    bool? maghribJamaat,
    bool? ishaJamaat,
    bool? fajrMosque,
    bool? dhuhrMosque,
    bool? asrMosque,
    bool? maghribMosque,
    bool? ishaMosque,
    bool? tahajjud,
    bool? duha,
    bool? quranWaqiah,
    bool? quranMulk,
    int? quranOtherPages,
    bool? adhkarMorning,
    bool? adhkarEvening,
    bool? salatDone,
    int? salatCount,
    bool? thahleelDone,
    int? thahleelCount,
    bool? isthighfarDone,
    int? isthighfarCount,
    DateTime? updatedAt,
  }) => PrayerRecord(
    id: id ?? this.id,
    date: date ?? this.date,
    fajr: fajr ?? this.fajr,
    dhuhr: dhuhr ?? this.dhuhr,
    asr: asr ?? this.asr,
    maghrib: maghrib ?? this.maghrib,
    isha: isha ?? this.isha,
    fajrJamaat: fajrJamaat ?? this.fajrJamaat,
    dhuhrJamaat: dhuhrJamaat ?? this.dhuhrJamaat,
    asrJamaat: asrJamaat ?? this.asrJamaat,
    maghribJamaat: maghribJamaat ?? this.maghribJamaat,
    ishaJamaat: ishaJamaat ?? this.ishaJamaat,
    fajrMosque: fajrMosque ?? this.fajrMosque,
    dhuhrMosque: dhuhrMosque ?? this.dhuhrMosque,
    asrMosque: asrMosque ?? this.asrMosque,
    maghribMosque: maghribMosque ?? this.maghribMosque,
    ishaMosque: ishaMosque ?? this.ishaMosque,
    tahajjud: tahajjud ?? this.tahajjud,
    duha: duha ?? this.duha,
    quranWaqiah: quranWaqiah ?? this.quranWaqiah,
    quranMulk: quranMulk ?? this.quranMulk,
    quranOtherPages: quranOtherPages ?? this.quranOtherPages,
    adhkarMorning: adhkarMorning ?? this.adhkarMorning,
    adhkarEvening: adhkarEvening ?? this.adhkarEvening,
    salatDone: salatDone ?? this.salatDone,
    salatCount: salatCount ?? this.salatCount,
    thahleelDone: thahleelDone ?? this.thahleelDone,
    thahleelCount: thahleelCount ?? this.thahleelCount,
    isthighfarDone: isthighfarDone ?? this.isthighfarDone,
    isthighfarCount: isthighfarCount ?? this.isthighfarCount,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PrayerRecord copyWithCompanion(PrayerRecordsCompanion data) {
    return PrayerRecord(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      fajr: data.fajr.present ? data.fajr.value : this.fajr,
      dhuhr: data.dhuhr.present ? data.dhuhr.value : this.dhuhr,
      asr: data.asr.present ? data.asr.value : this.asr,
      maghrib: data.maghrib.present ? data.maghrib.value : this.maghrib,
      isha: data.isha.present ? data.isha.value : this.isha,
      fajrJamaat: data.fajrJamaat.present
          ? data.fajrJamaat.value
          : this.fajrJamaat,
      dhuhrJamaat: data.dhuhrJamaat.present
          ? data.dhuhrJamaat.value
          : this.dhuhrJamaat,
      asrJamaat: data.asrJamaat.present ? data.asrJamaat.value : this.asrJamaat,
      maghribJamaat: data.maghribJamaat.present
          ? data.maghribJamaat.value
          : this.maghribJamaat,
      ishaJamaat: data.ishaJamaat.present
          ? data.ishaJamaat.value
          : this.ishaJamaat,
      fajrMosque: data.fajrMosque.present
          ? data.fajrMosque.value
          : this.fajrMosque,
      dhuhrMosque: data.dhuhrMosque.present
          ? data.dhuhrMosque.value
          : this.dhuhrMosque,
      asrMosque: data.asrMosque.present ? data.asrMosque.value : this.asrMosque,
      maghribMosque: data.maghribMosque.present
          ? data.maghribMosque.value
          : this.maghribMosque,
      ishaMosque: data.ishaMosque.present
          ? data.ishaMosque.value
          : this.ishaMosque,
      tahajjud: data.tahajjud.present ? data.tahajjud.value : this.tahajjud,
      duha: data.duha.present ? data.duha.value : this.duha,
      quranWaqiah: data.quranWaqiah.present
          ? data.quranWaqiah.value
          : this.quranWaqiah,
      quranMulk: data.quranMulk.present ? data.quranMulk.value : this.quranMulk,
      quranOtherPages: data.quranOtherPages.present
          ? data.quranOtherPages.value
          : this.quranOtherPages,
      adhkarMorning: data.adhkarMorning.present
          ? data.adhkarMorning.value
          : this.adhkarMorning,
      adhkarEvening: data.adhkarEvening.present
          ? data.adhkarEvening.value
          : this.adhkarEvening,
      salatDone: data.salatDone.present ? data.salatDone.value : this.salatDone,
      salatCount: data.salatCount.present
          ? data.salatCount.value
          : this.salatCount,
      thahleelDone: data.thahleelDone.present
          ? data.thahleelDone.value
          : this.thahleelDone,
      thahleelCount: data.thahleelCount.present
          ? data.thahleelCount.value
          : this.thahleelCount,
      isthighfarDone: data.isthighfarDone.present
          ? data.isthighfarDone.value
          : this.isthighfarDone,
      isthighfarCount: data.isthighfarCount.present
          ? data.isthighfarCount.value
          : this.isthighfarCount,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrayerRecord(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('fajr: $fajr, ')
          ..write('dhuhr: $dhuhr, ')
          ..write('asr: $asr, ')
          ..write('maghrib: $maghrib, ')
          ..write('isha: $isha, ')
          ..write('fajrJamaat: $fajrJamaat, ')
          ..write('dhuhrJamaat: $dhuhrJamaat, ')
          ..write('asrJamaat: $asrJamaat, ')
          ..write('maghribJamaat: $maghribJamaat, ')
          ..write('ishaJamaat: $ishaJamaat, ')
          ..write('fajrMosque: $fajrMosque, ')
          ..write('dhuhrMosque: $dhuhrMosque, ')
          ..write('asrMosque: $asrMosque, ')
          ..write('maghribMosque: $maghribMosque, ')
          ..write('ishaMosque: $ishaMosque, ')
          ..write('tahajjud: $tahajjud, ')
          ..write('duha: $duha, ')
          ..write('quranWaqiah: $quranWaqiah, ')
          ..write('quranMulk: $quranMulk, ')
          ..write('quranOtherPages: $quranOtherPages, ')
          ..write('adhkarMorning: $adhkarMorning, ')
          ..write('adhkarEvening: $adhkarEvening, ')
          ..write('salatDone: $salatDone, ')
          ..write('salatCount: $salatCount, ')
          ..write('thahleelDone: $thahleelDone, ')
          ..write('thahleelCount: $thahleelCount, ')
          ..write('isthighfarDone: $isthighfarDone, ')
          ..write('isthighfarCount: $isthighfarCount, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    date,
    fajr,
    dhuhr,
    asr,
    maghrib,
    isha,
    fajrJamaat,
    dhuhrJamaat,
    asrJamaat,
    maghribJamaat,
    ishaJamaat,
    fajrMosque,
    dhuhrMosque,
    asrMosque,
    maghribMosque,
    ishaMosque,
    tahajjud,
    duha,
    quranWaqiah,
    quranMulk,
    quranOtherPages,
    adhkarMorning,
    adhkarEvening,
    salatDone,
    salatCount,
    thahleelDone,
    thahleelCount,
    isthighfarDone,
    isthighfarCount,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrayerRecord &&
          other.id == this.id &&
          other.date == this.date &&
          other.fajr == this.fajr &&
          other.dhuhr == this.dhuhr &&
          other.asr == this.asr &&
          other.maghrib == this.maghrib &&
          other.isha == this.isha &&
          other.fajrJamaat == this.fajrJamaat &&
          other.dhuhrJamaat == this.dhuhrJamaat &&
          other.asrJamaat == this.asrJamaat &&
          other.maghribJamaat == this.maghribJamaat &&
          other.ishaJamaat == this.ishaJamaat &&
          other.fajrMosque == this.fajrMosque &&
          other.dhuhrMosque == this.dhuhrMosque &&
          other.asrMosque == this.asrMosque &&
          other.maghribMosque == this.maghribMosque &&
          other.ishaMosque == this.ishaMosque &&
          other.tahajjud == this.tahajjud &&
          other.duha == this.duha &&
          other.quranWaqiah == this.quranWaqiah &&
          other.quranMulk == this.quranMulk &&
          other.quranOtherPages == this.quranOtherPages &&
          other.adhkarMorning == this.adhkarMorning &&
          other.adhkarEvening == this.adhkarEvening &&
          other.salatDone == this.salatDone &&
          other.salatCount == this.salatCount &&
          other.thahleelDone == this.thahleelDone &&
          other.thahleelCount == this.thahleelCount &&
          other.isthighfarDone == this.isthighfarDone &&
          other.isthighfarCount == this.isthighfarCount &&
          other.updatedAt == this.updatedAt);
}

class PrayerRecordsCompanion extends UpdateCompanion<PrayerRecord> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<bool> fajr;
  final Value<bool> dhuhr;
  final Value<bool> asr;
  final Value<bool> maghrib;
  final Value<bool> isha;
  final Value<bool> fajrJamaat;
  final Value<bool> dhuhrJamaat;
  final Value<bool> asrJamaat;
  final Value<bool> maghribJamaat;
  final Value<bool> ishaJamaat;
  final Value<bool> fajrMosque;
  final Value<bool> dhuhrMosque;
  final Value<bool> asrMosque;
  final Value<bool> maghribMosque;
  final Value<bool> ishaMosque;
  final Value<bool> tahajjud;
  final Value<bool> duha;
  final Value<bool> quranWaqiah;
  final Value<bool> quranMulk;
  final Value<int> quranOtherPages;
  final Value<bool> adhkarMorning;
  final Value<bool> adhkarEvening;
  final Value<bool> salatDone;
  final Value<int> salatCount;
  final Value<bool> thahleelDone;
  final Value<int> thahleelCount;
  final Value<bool> isthighfarDone;
  final Value<int> isthighfarCount;
  final Value<DateTime> updatedAt;
  const PrayerRecordsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.fajr = const Value.absent(),
    this.dhuhr = const Value.absent(),
    this.asr = const Value.absent(),
    this.maghrib = const Value.absent(),
    this.isha = const Value.absent(),
    this.fajrJamaat = const Value.absent(),
    this.dhuhrJamaat = const Value.absent(),
    this.asrJamaat = const Value.absent(),
    this.maghribJamaat = const Value.absent(),
    this.ishaJamaat = const Value.absent(),
    this.fajrMosque = const Value.absent(),
    this.dhuhrMosque = const Value.absent(),
    this.asrMosque = const Value.absent(),
    this.maghribMosque = const Value.absent(),
    this.ishaMosque = const Value.absent(),
    this.tahajjud = const Value.absent(),
    this.duha = const Value.absent(),
    this.quranWaqiah = const Value.absent(),
    this.quranMulk = const Value.absent(),
    this.quranOtherPages = const Value.absent(),
    this.adhkarMorning = const Value.absent(),
    this.adhkarEvening = const Value.absent(),
    this.salatDone = const Value.absent(),
    this.salatCount = const Value.absent(),
    this.thahleelDone = const Value.absent(),
    this.thahleelCount = const Value.absent(),
    this.isthighfarDone = const Value.absent(),
    this.isthighfarCount = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PrayerRecordsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.fajr = const Value.absent(),
    this.dhuhr = const Value.absent(),
    this.asr = const Value.absent(),
    this.maghrib = const Value.absent(),
    this.isha = const Value.absent(),
    this.fajrJamaat = const Value.absent(),
    this.dhuhrJamaat = const Value.absent(),
    this.asrJamaat = const Value.absent(),
    this.maghribJamaat = const Value.absent(),
    this.ishaJamaat = const Value.absent(),
    this.fajrMosque = const Value.absent(),
    this.dhuhrMosque = const Value.absent(),
    this.asrMosque = const Value.absent(),
    this.maghribMosque = const Value.absent(),
    this.ishaMosque = const Value.absent(),
    this.tahajjud = const Value.absent(),
    this.duha = const Value.absent(),
    this.quranWaqiah = const Value.absent(),
    this.quranMulk = const Value.absent(),
    this.quranOtherPages = const Value.absent(),
    this.adhkarMorning = const Value.absent(),
    this.adhkarEvening = const Value.absent(),
    this.salatDone = const Value.absent(),
    this.salatCount = const Value.absent(),
    this.thahleelDone = const Value.absent(),
    this.thahleelCount = const Value.absent(),
    this.isthighfarDone = const Value.absent(),
    this.isthighfarCount = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : date = Value(date);
  static Insertable<PrayerRecord> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<bool>? fajr,
    Expression<bool>? dhuhr,
    Expression<bool>? asr,
    Expression<bool>? maghrib,
    Expression<bool>? isha,
    Expression<bool>? fajrJamaat,
    Expression<bool>? dhuhrJamaat,
    Expression<bool>? asrJamaat,
    Expression<bool>? maghribJamaat,
    Expression<bool>? ishaJamaat,
    Expression<bool>? fajrMosque,
    Expression<bool>? dhuhrMosque,
    Expression<bool>? asrMosque,
    Expression<bool>? maghribMosque,
    Expression<bool>? ishaMosque,
    Expression<bool>? tahajjud,
    Expression<bool>? duha,
    Expression<bool>? quranWaqiah,
    Expression<bool>? quranMulk,
    Expression<int>? quranOtherPages,
    Expression<bool>? adhkarMorning,
    Expression<bool>? adhkarEvening,
    Expression<bool>? salatDone,
    Expression<int>? salatCount,
    Expression<bool>? thahleelDone,
    Expression<int>? thahleelCount,
    Expression<bool>? isthighfarDone,
    Expression<int>? isthighfarCount,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (fajr != null) 'fajr': fajr,
      if (dhuhr != null) 'dhuhr': dhuhr,
      if (asr != null) 'asr': asr,
      if (maghrib != null) 'maghrib': maghrib,
      if (isha != null) 'isha': isha,
      if (fajrJamaat != null) 'fajr_jamaat': fajrJamaat,
      if (dhuhrJamaat != null) 'dhuhr_jamaat': dhuhrJamaat,
      if (asrJamaat != null) 'asr_jamaat': asrJamaat,
      if (maghribJamaat != null) 'maghrib_jamaat': maghribJamaat,
      if (ishaJamaat != null) 'isha_jamaat': ishaJamaat,
      if (fajrMosque != null) 'fajr_mosque': fajrMosque,
      if (dhuhrMosque != null) 'dhuhr_mosque': dhuhrMosque,
      if (asrMosque != null) 'asr_mosque': asrMosque,
      if (maghribMosque != null) 'maghrib_mosque': maghribMosque,
      if (ishaMosque != null) 'isha_mosque': ishaMosque,
      if (tahajjud != null) 'tahajjud': tahajjud,
      if (duha != null) 'duha': duha,
      if (quranWaqiah != null) 'quran_waqiah': quranWaqiah,
      if (quranMulk != null) 'quran_mulk': quranMulk,
      if (quranOtherPages != null) 'quran_other_pages': quranOtherPages,
      if (adhkarMorning != null) 'adhkar_morning': adhkarMorning,
      if (adhkarEvening != null) 'adhkar_evening': adhkarEvening,
      if (salatDone != null) 'salat_done': salatDone,
      if (salatCount != null) 'salat_count': salatCount,
      if (thahleelDone != null) 'thahleel_done': thahleelDone,
      if (thahleelCount != null) 'thahleel_count': thahleelCount,
      if (isthighfarDone != null) 'isthighfar_done': isthighfarDone,
      if (isthighfarCount != null) 'isthighfar_count': isthighfarCount,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PrayerRecordsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<bool>? fajr,
    Value<bool>? dhuhr,
    Value<bool>? asr,
    Value<bool>? maghrib,
    Value<bool>? isha,
    Value<bool>? fajrJamaat,
    Value<bool>? dhuhrJamaat,
    Value<bool>? asrJamaat,
    Value<bool>? maghribJamaat,
    Value<bool>? ishaJamaat,
    Value<bool>? fajrMosque,
    Value<bool>? dhuhrMosque,
    Value<bool>? asrMosque,
    Value<bool>? maghribMosque,
    Value<bool>? ishaMosque,
    Value<bool>? tahajjud,
    Value<bool>? duha,
    Value<bool>? quranWaqiah,
    Value<bool>? quranMulk,
    Value<int>? quranOtherPages,
    Value<bool>? adhkarMorning,
    Value<bool>? adhkarEvening,
    Value<bool>? salatDone,
    Value<int>? salatCount,
    Value<bool>? thahleelDone,
    Value<int>? thahleelCount,
    Value<bool>? isthighfarDone,
    Value<int>? isthighfarCount,
    Value<DateTime>? updatedAt,
  }) {
    return PrayerRecordsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      fajr: fajr ?? this.fajr,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
      fajrJamaat: fajrJamaat ?? this.fajrJamaat,
      dhuhrJamaat: dhuhrJamaat ?? this.dhuhrJamaat,
      asrJamaat: asrJamaat ?? this.asrJamaat,
      maghribJamaat: maghribJamaat ?? this.maghribJamaat,
      ishaJamaat: ishaJamaat ?? this.ishaJamaat,
      fajrMosque: fajrMosque ?? this.fajrMosque,
      dhuhrMosque: dhuhrMosque ?? this.dhuhrMosque,
      asrMosque: asrMosque ?? this.asrMosque,
      maghribMosque: maghribMosque ?? this.maghribMosque,
      ishaMosque: ishaMosque ?? this.ishaMosque,
      tahajjud: tahajjud ?? this.tahajjud,
      duha: duha ?? this.duha,
      quranWaqiah: quranWaqiah ?? this.quranWaqiah,
      quranMulk: quranMulk ?? this.quranMulk,
      quranOtherPages: quranOtherPages ?? this.quranOtherPages,
      adhkarMorning: adhkarMorning ?? this.adhkarMorning,
      adhkarEvening: adhkarEvening ?? this.adhkarEvening,
      salatDone: salatDone ?? this.salatDone,
      salatCount: salatCount ?? this.salatCount,
      thahleelDone: thahleelDone ?? this.thahleelDone,
      thahleelCount: thahleelCount ?? this.thahleelCount,
      isthighfarDone: isthighfarDone ?? this.isthighfarDone,
      isthighfarCount: isthighfarCount ?? this.isthighfarCount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (fajr.present) {
      map['fajr'] = Variable<bool>(fajr.value);
    }
    if (dhuhr.present) {
      map['dhuhr'] = Variable<bool>(dhuhr.value);
    }
    if (asr.present) {
      map['asr'] = Variable<bool>(asr.value);
    }
    if (maghrib.present) {
      map['maghrib'] = Variable<bool>(maghrib.value);
    }
    if (isha.present) {
      map['isha'] = Variable<bool>(isha.value);
    }
    if (fajrJamaat.present) {
      map['fajr_jamaat'] = Variable<bool>(fajrJamaat.value);
    }
    if (dhuhrJamaat.present) {
      map['dhuhr_jamaat'] = Variable<bool>(dhuhrJamaat.value);
    }
    if (asrJamaat.present) {
      map['asr_jamaat'] = Variable<bool>(asrJamaat.value);
    }
    if (maghribJamaat.present) {
      map['maghrib_jamaat'] = Variable<bool>(maghribJamaat.value);
    }
    if (ishaJamaat.present) {
      map['isha_jamaat'] = Variable<bool>(ishaJamaat.value);
    }
    if (fajrMosque.present) {
      map['fajr_mosque'] = Variable<bool>(fajrMosque.value);
    }
    if (dhuhrMosque.present) {
      map['dhuhr_mosque'] = Variable<bool>(dhuhrMosque.value);
    }
    if (asrMosque.present) {
      map['asr_mosque'] = Variable<bool>(asrMosque.value);
    }
    if (maghribMosque.present) {
      map['maghrib_mosque'] = Variable<bool>(maghribMosque.value);
    }
    if (ishaMosque.present) {
      map['isha_mosque'] = Variable<bool>(ishaMosque.value);
    }
    if (tahajjud.present) {
      map['tahajjud'] = Variable<bool>(tahajjud.value);
    }
    if (duha.present) {
      map['duha'] = Variable<bool>(duha.value);
    }
    if (quranWaqiah.present) {
      map['quran_waqiah'] = Variable<bool>(quranWaqiah.value);
    }
    if (quranMulk.present) {
      map['quran_mulk'] = Variable<bool>(quranMulk.value);
    }
    if (quranOtherPages.present) {
      map['quran_other_pages'] = Variable<int>(quranOtherPages.value);
    }
    if (adhkarMorning.present) {
      map['adhkar_morning'] = Variable<bool>(adhkarMorning.value);
    }
    if (adhkarEvening.present) {
      map['adhkar_evening'] = Variable<bool>(adhkarEvening.value);
    }
    if (salatDone.present) {
      map['salat_done'] = Variable<bool>(salatDone.value);
    }
    if (salatCount.present) {
      map['salat_count'] = Variable<int>(salatCount.value);
    }
    if (thahleelDone.present) {
      map['thahleel_done'] = Variable<bool>(thahleelDone.value);
    }
    if (thahleelCount.present) {
      map['thahleel_count'] = Variable<int>(thahleelCount.value);
    }
    if (isthighfarDone.present) {
      map['isthighfar_done'] = Variable<bool>(isthighfarDone.value);
    }
    if (isthighfarCount.present) {
      map['isthighfar_count'] = Variable<int>(isthighfarCount.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrayerRecordsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('fajr: $fajr, ')
          ..write('dhuhr: $dhuhr, ')
          ..write('asr: $asr, ')
          ..write('maghrib: $maghrib, ')
          ..write('isha: $isha, ')
          ..write('fajrJamaat: $fajrJamaat, ')
          ..write('dhuhrJamaat: $dhuhrJamaat, ')
          ..write('asrJamaat: $asrJamaat, ')
          ..write('maghribJamaat: $maghribJamaat, ')
          ..write('ishaJamaat: $ishaJamaat, ')
          ..write('fajrMosque: $fajrMosque, ')
          ..write('dhuhrMosque: $dhuhrMosque, ')
          ..write('asrMosque: $asrMosque, ')
          ..write('maghribMosque: $maghribMosque, ')
          ..write('ishaMosque: $ishaMosque, ')
          ..write('tahajjud: $tahajjud, ')
          ..write('duha: $duha, ')
          ..write('quranWaqiah: $quranWaqiah, ')
          ..write('quranMulk: $quranMulk, ')
          ..write('quranOtherPages: $quranOtherPages, ')
          ..write('adhkarMorning: $adhkarMorning, ')
          ..write('adhkarEvening: $adhkarEvening, ')
          ..write('salatDone: $salatDone, ')
          ..write('salatCount: $salatCount, ')
          ..write('thahleelDone: $thahleelDone, ')
          ..write('thahleelCount: $thahleelCount, ')
          ..write('isthighfarDone: $isthighfarDone, ')
          ..write('isthighfarCount: $isthighfarCount, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PrayerSettingsTable extends PrayerSettings
    with TableInfo<$PrayerSettingsTable, PrayerSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrayerSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _calculationMethodMeta = const VerificationMeta(
    'calculationMethod',
  );
  @override
  late final GeneratedColumn<String> calculationMethod =
      GeneratedColumn<String>(
        'calculation_method',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('MuslimWorldLeague'),
      );
  static const VerificationMeta _madhabMeta = const VerificationMeta('madhab');
  @override
  late final GeneratedColumn<String> madhab = GeneratedColumn<String>(
    'madhab',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Shafi'),
  );
  static const VerificationMeta _manualOffsetsJsonMeta = const VerificationMeta(
    'manualOffsetsJson',
  );
  @override
  late final GeneratedColumn<String> manualOffsetsJson =
      GeneratedColumn<String>(
        'manual_offsets_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      );
  static const VerificationMeta _useManualMeta = const VerificationMeta(
    'useManual',
  );
  @override
  late final GeneratedColumn<bool> useManual = GeneratedColumn<bool>(
    'use_manual',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("use_manual" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    calculationMethod,
    madhab,
    manualOffsetsJson,
    useManual,
    notificationsEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prayer_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrayerSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('calculation_method')) {
      context.handle(
        _calculationMethodMeta,
        calculationMethod.isAcceptableOrUnknown(
          data['calculation_method']!,
          _calculationMethodMeta,
        ),
      );
    }
    if (data.containsKey('madhab')) {
      context.handle(
        _madhabMeta,
        madhab.isAcceptableOrUnknown(data['madhab']!, _madhabMeta),
      );
    }
    if (data.containsKey('manual_offsets_json')) {
      context.handle(
        _manualOffsetsJsonMeta,
        manualOffsetsJson.isAcceptableOrUnknown(
          data['manual_offsets_json']!,
          _manualOffsetsJsonMeta,
        ),
      );
    }
    if (data.containsKey('use_manual')) {
      context.handle(
        _useManualMeta,
        useManual.isAcceptableOrUnknown(data['use_manual']!, _useManualMeta),
      );
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrayerSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrayerSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      calculationMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calculation_method'],
      )!,
      madhab: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}madhab'],
      )!,
      manualOffsetsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manual_offsets_json'],
      )!,
      useManual: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}use_manual'],
      )!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_enabled'],
      )!,
    );
  }

  @override
  $PrayerSettingsTable createAlias(String alias) {
    return $PrayerSettingsTable(attachedDatabase, alias);
  }
}

class PrayerSetting extends DataClass implements Insertable<PrayerSetting> {
  final int id;
  final String calculationMethod;
  final String madhab;
  final String manualOffsetsJson;
  final bool useManual;
  final bool notificationsEnabled;
  const PrayerSetting({
    required this.id,
    required this.calculationMethod,
    required this.madhab,
    required this.manualOffsetsJson,
    required this.useManual,
    required this.notificationsEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['calculation_method'] = Variable<String>(calculationMethod);
    map['madhab'] = Variable<String>(madhab);
    map['manual_offsets_json'] = Variable<String>(manualOffsetsJson);
    map['use_manual'] = Variable<bool>(useManual);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    return map;
  }

  PrayerSettingsCompanion toCompanion(bool nullToAbsent) {
    return PrayerSettingsCompanion(
      id: Value(id),
      calculationMethod: Value(calculationMethod),
      madhab: Value(madhab),
      manualOffsetsJson: Value(manualOffsetsJson),
      useManual: Value(useManual),
      notificationsEnabled: Value(notificationsEnabled),
    );
  }

  factory PrayerSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrayerSetting(
      id: serializer.fromJson<int>(json['id']),
      calculationMethod: serializer.fromJson<String>(json['calculationMethod']),
      madhab: serializer.fromJson<String>(json['madhab']),
      manualOffsetsJson: serializer.fromJson<String>(json['manualOffsetsJson']),
      useManual: serializer.fromJson<bool>(json['useManual']),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'calculationMethod': serializer.toJson<String>(calculationMethod),
      'madhab': serializer.toJson<String>(madhab),
      'manualOffsetsJson': serializer.toJson<String>(manualOffsetsJson),
      'useManual': serializer.toJson<bool>(useManual),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
    };
  }

  PrayerSetting copyWith({
    int? id,
    String? calculationMethod,
    String? madhab,
    String? manualOffsetsJson,
    bool? useManual,
    bool? notificationsEnabled,
  }) => PrayerSetting(
    id: id ?? this.id,
    calculationMethod: calculationMethod ?? this.calculationMethod,
    madhab: madhab ?? this.madhab,
    manualOffsetsJson: manualOffsetsJson ?? this.manualOffsetsJson,
    useManual: useManual ?? this.useManual,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
  );
  PrayerSetting copyWithCompanion(PrayerSettingsCompanion data) {
    return PrayerSetting(
      id: data.id.present ? data.id.value : this.id,
      calculationMethod: data.calculationMethod.present
          ? data.calculationMethod.value
          : this.calculationMethod,
      madhab: data.madhab.present ? data.madhab.value : this.madhab,
      manualOffsetsJson: data.manualOffsetsJson.present
          ? data.manualOffsetsJson.value
          : this.manualOffsetsJson,
      useManual: data.useManual.present ? data.useManual.value : this.useManual,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrayerSetting(')
          ..write('id: $id, ')
          ..write('calculationMethod: $calculationMethod, ')
          ..write('madhab: $madhab, ')
          ..write('manualOffsetsJson: $manualOffsetsJson, ')
          ..write('useManual: $useManual, ')
          ..write('notificationsEnabled: $notificationsEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    calculationMethod,
    madhab,
    manualOffsetsJson,
    useManual,
    notificationsEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrayerSetting &&
          other.id == this.id &&
          other.calculationMethod == this.calculationMethod &&
          other.madhab == this.madhab &&
          other.manualOffsetsJson == this.manualOffsetsJson &&
          other.useManual == this.useManual &&
          other.notificationsEnabled == this.notificationsEnabled);
}

class PrayerSettingsCompanion extends UpdateCompanion<PrayerSetting> {
  final Value<int> id;
  final Value<String> calculationMethod;
  final Value<String> madhab;
  final Value<String> manualOffsetsJson;
  final Value<bool> useManual;
  final Value<bool> notificationsEnabled;
  const PrayerSettingsCompanion({
    this.id = const Value.absent(),
    this.calculationMethod = const Value.absent(),
    this.madhab = const Value.absent(),
    this.manualOffsetsJson = const Value.absent(),
    this.useManual = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
  });
  PrayerSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.calculationMethod = const Value.absent(),
    this.madhab = const Value.absent(),
    this.manualOffsetsJson = const Value.absent(),
    this.useManual = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
  });
  static Insertable<PrayerSetting> custom({
    Expression<int>? id,
    Expression<String>? calculationMethod,
    Expression<String>? madhab,
    Expression<String>? manualOffsetsJson,
    Expression<bool>? useManual,
    Expression<bool>? notificationsEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (calculationMethod != null) 'calculation_method': calculationMethod,
      if (madhab != null) 'madhab': madhab,
      if (manualOffsetsJson != null) 'manual_offsets_json': manualOffsetsJson,
      if (useManual != null) 'use_manual': useManual,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
    });
  }

  PrayerSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? calculationMethod,
    Value<String>? madhab,
    Value<String>? manualOffsetsJson,
    Value<bool>? useManual,
    Value<bool>? notificationsEnabled,
  }) {
    return PrayerSettingsCompanion(
      id: id ?? this.id,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      madhab: madhab ?? this.madhab,
      manualOffsetsJson: manualOffsetsJson ?? this.manualOffsetsJson,
      useManual: useManual ?? this.useManual,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (calculationMethod.present) {
      map['calculation_method'] = Variable<String>(calculationMethod.value);
    }
    if (madhab.present) {
      map['madhab'] = Variable<String>(madhab.value);
    }
    if (manualOffsetsJson.present) {
      map['manual_offsets_json'] = Variable<String>(manualOffsetsJson.value);
    }
    if (useManual.present) {
      map['use_manual'] = Variable<bool>(useManual.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrayerSettingsCompanion(')
          ..write('id: $id, ')
          ..write('calculationMethod: $calculationMethod, ')
          ..write('madhab: $madhab, ')
          ..write('manualOffsetsJson: $manualOffsetsJson, ')
          ..write('useManual: $useManual, ')
          ..write('notificationsEnabled: $notificationsEnabled')
          ..write(')'))
        .toString();
  }
}

class $WaterRecordsTable extends WaterRecords
    with TableInfo<$WaterRecordsTable, WaterRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WaterRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cupsConsumedMeta = const VerificationMeta(
    'cupsConsumed',
  );
  @override
  late final GeneratedColumn<int> cupsConsumed = GeneratedColumn<int>(
    'cups_consumed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cupSizeMlMeta = const VerificationMeta(
    'cupSizeMl',
  );
  @override
  late final GeneratedColumn<int> cupSizeMl = GeneratedColumn<int>(
    'cup_size_ml',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(250),
  );
  static const VerificationMeta _goalCupsMeta = const VerificationMeta(
    'goalCups',
  );
  @override
  late final GeneratedColumn<int> goalCups = GeneratedColumn<int>(
    'goal_cups',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8),
  );
  static const VerificationMeta _wakeTimeMinutesMeta = const VerificationMeta(
    'wakeTimeMinutes',
  );
  @override
  late final GeneratedColumn<int> wakeTimeMinutes = GeneratedColumn<int>(
    'wake_time_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(420),
  );
  static const VerificationMeta _sleepTimeMinutesMeta = const VerificationMeta(
    'sleepTimeMinutes',
  );
  @override
  late final GeneratedColumn<int> sleepTimeMinutes = GeneratedColumn<int>(
    'sleep_time_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1380),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    cupsConsumed,
    cupSizeMl,
    goalCups,
    wakeTimeMinutes,
    sleepTimeMinutes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'water_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<WaterRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('cups_consumed')) {
      context.handle(
        _cupsConsumedMeta,
        cupsConsumed.isAcceptableOrUnknown(
          data['cups_consumed']!,
          _cupsConsumedMeta,
        ),
      );
    }
    if (data.containsKey('cup_size_ml')) {
      context.handle(
        _cupSizeMlMeta,
        cupSizeMl.isAcceptableOrUnknown(data['cup_size_ml']!, _cupSizeMlMeta),
      );
    }
    if (data.containsKey('goal_cups')) {
      context.handle(
        _goalCupsMeta,
        goalCups.isAcceptableOrUnknown(data['goal_cups']!, _goalCupsMeta),
      );
    }
    if (data.containsKey('wake_time_minutes')) {
      context.handle(
        _wakeTimeMinutesMeta,
        wakeTimeMinutes.isAcceptableOrUnknown(
          data['wake_time_minutes']!,
          _wakeTimeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('sleep_time_minutes')) {
      context.handle(
        _sleepTimeMinutesMeta,
        sleepTimeMinutes.isAcceptableOrUnknown(
          data['sleep_time_minutes']!,
          _sleepTimeMinutesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WaterRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WaterRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      cupsConsumed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cups_consumed'],
      )!,
      cupSizeMl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cup_size_ml'],
      )!,
      goalCups: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_cups'],
      )!,
      wakeTimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wake_time_minutes'],
      )!,
      sleepTimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_time_minutes'],
      )!,
    );
  }

  @override
  $WaterRecordsTable createAlias(String alias) {
    return $WaterRecordsTable(attachedDatabase, alias);
  }
}

class WaterRecord extends DataClass implements Insertable<WaterRecord> {
  final int id;
  final DateTime date;
  final int cupsConsumed;
  final int cupSizeMl;
  final int goalCups;
  final int wakeTimeMinutes;
  final int sleepTimeMinutes;
  const WaterRecord({
    required this.id,
    required this.date,
    required this.cupsConsumed,
    required this.cupSizeMl,
    required this.goalCups,
    required this.wakeTimeMinutes,
    required this.sleepTimeMinutes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['cups_consumed'] = Variable<int>(cupsConsumed);
    map['cup_size_ml'] = Variable<int>(cupSizeMl);
    map['goal_cups'] = Variable<int>(goalCups);
    map['wake_time_minutes'] = Variable<int>(wakeTimeMinutes);
    map['sleep_time_minutes'] = Variable<int>(sleepTimeMinutes);
    return map;
  }

  WaterRecordsCompanion toCompanion(bool nullToAbsent) {
    return WaterRecordsCompanion(
      id: Value(id),
      date: Value(date),
      cupsConsumed: Value(cupsConsumed),
      cupSizeMl: Value(cupSizeMl),
      goalCups: Value(goalCups),
      wakeTimeMinutes: Value(wakeTimeMinutes),
      sleepTimeMinutes: Value(sleepTimeMinutes),
    );
  }

  factory WaterRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterRecord(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      cupsConsumed: serializer.fromJson<int>(json['cupsConsumed']),
      cupSizeMl: serializer.fromJson<int>(json['cupSizeMl']),
      goalCups: serializer.fromJson<int>(json['goalCups']),
      wakeTimeMinutes: serializer.fromJson<int>(json['wakeTimeMinutes']),
      sleepTimeMinutes: serializer.fromJson<int>(json['sleepTimeMinutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'cupsConsumed': serializer.toJson<int>(cupsConsumed),
      'cupSizeMl': serializer.toJson<int>(cupSizeMl),
      'goalCups': serializer.toJson<int>(goalCups),
      'wakeTimeMinutes': serializer.toJson<int>(wakeTimeMinutes),
      'sleepTimeMinutes': serializer.toJson<int>(sleepTimeMinutes),
    };
  }

  WaterRecord copyWith({
    int? id,
    DateTime? date,
    int? cupsConsumed,
    int? cupSizeMl,
    int? goalCups,
    int? wakeTimeMinutes,
    int? sleepTimeMinutes,
  }) => WaterRecord(
    id: id ?? this.id,
    date: date ?? this.date,
    cupsConsumed: cupsConsumed ?? this.cupsConsumed,
    cupSizeMl: cupSizeMl ?? this.cupSizeMl,
    goalCups: goalCups ?? this.goalCups,
    wakeTimeMinutes: wakeTimeMinutes ?? this.wakeTimeMinutes,
    sleepTimeMinutes: sleepTimeMinutes ?? this.sleepTimeMinutes,
  );
  WaterRecord copyWithCompanion(WaterRecordsCompanion data) {
    return WaterRecord(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      cupsConsumed: data.cupsConsumed.present
          ? data.cupsConsumed.value
          : this.cupsConsumed,
      cupSizeMl: data.cupSizeMl.present ? data.cupSizeMl.value : this.cupSizeMl,
      goalCups: data.goalCups.present ? data.goalCups.value : this.goalCups,
      wakeTimeMinutes: data.wakeTimeMinutes.present
          ? data.wakeTimeMinutes.value
          : this.wakeTimeMinutes,
      sleepTimeMinutes: data.sleepTimeMinutes.present
          ? data.sleepTimeMinutes.value
          : this.sleepTimeMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WaterRecord(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('cupsConsumed: $cupsConsumed, ')
          ..write('cupSizeMl: $cupSizeMl, ')
          ..write('goalCups: $goalCups, ')
          ..write('wakeTimeMinutes: $wakeTimeMinutes, ')
          ..write('sleepTimeMinutes: $sleepTimeMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    cupsConsumed,
    cupSizeMl,
    goalCups,
    wakeTimeMinutes,
    sleepTimeMinutes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterRecord &&
          other.id == this.id &&
          other.date == this.date &&
          other.cupsConsumed == this.cupsConsumed &&
          other.cupSizeMl == this.cupSizeMl &&
          other.goalCups == this.goalCups &&
          other.wakeTimeMinutes == this.wakeTimeMinutes &&
          other.sleepTimeMinutes == this.sleepTimeMinutes);
}

class WaterRecordsCompanion extends UpdateCompanion<WaterRecord> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> cupsConsumed;
  final Value<int> cupSizeMl;
  final Value<int> goalCups;
  final Value<int> wakeTimeMinutes;
  final Value<int> sleepTimeMinutes;
  const WaterRecordsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.cupsConsumed = const Value.absent(),
    this.cupSizeMl = const Value.absent(),
    this.goalCups = const Value.absent(),
    this.wakeTimeMinutes = const Value.absent(),
    this.sleepTimeMinutes = const Value.absent(),
  });
  WaterRecordsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.cupsConsumed = const Value.absent(),
    this.cupSizeMl = const Value.absent(),
    this.goalCups = const Value.absent(),
    this.wakeTimeMinutes = const Value.absent(),
    this.sleepTimeMinutes = const Value.absent(),
  }) : date = Value(date);
  static Insertable<WaterRecord> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? cupsConsumed,
    Expression<int>? cupSizeMl,
    Expression<int>? goalCups,
    Expression<int>? wakeTimeMinutes,
    Expression<int>? sleepTimeMinutes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (cupsConsumed != null) 'cups_consumed': cupsConsumed,
      if (cupSizeMl != null) 'cup_size_ml': cupSizeMl,
      if (goalCups != null) 'goal_cups': goalCups,
      if (wakeTimeMinutes != null) 'wake_time_minutes': wakeTimeMinutes,
      if (sleepTimeMinutes != null) 'sleep_time_minutes': sleepTimeMinutes,
    });
  }

  WaterRecordsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int>? cupsConsumed,
    Value<int>? cupSizeMl,
    Value<int>? goalCups,
    Value<int>? wakeTimeMinutes,
    Value<int>? sleepTimeMinutes,
  }) {
    return WaterRecordsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      cupsConsumed: cupsConsumed ?? this.cupsConsumed,
      cupSizeMl: cupSizeMl ?? this.cupSizeMl,
      goalCups: goalCups ?? this.goalCups,
      wakeTimeMinutes: wakeTimeMinutes ?? this.wakeTimeMinutes,
      sleepTimeMinutes: sleepTimeMinutes ?? this.sleepTimeMinutes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (cupsConsumed.present) {
      map['cups_consumed'] = Variable<int>(cupsConsumed.value);
    }
    if (cupSizeMl.present) {
      map['cup_size_ml'] = Variable<int>(cupSizeMl.value);
    }
    if (goalCups.present) {
      map['goal_cups'] = Variable<int>(goalCups.value);
    }
    if (wakeTimeMinutes.present) {
      map['wake_time_minutes'] = Variable<int>(wakeTimeMinutes.value);
    }
    if (sleepTimeMinutes.present) {
      map['sleep_time_minutes'] = Variable<int>(sleepTimeMinutes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterRecordsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('cupsConsumed: $cupsConsumed, ')
          ..write('cupSizeMl: $cupSizeMl, ')
          ..write('goalCups: $goalCups, ')
          ..write('wakeTimeMinutes: $wakeTimeMinutes, ')
          ..write('sleepTimeMinutes: $sleepTimeMinutes')
          ..write(')'))
        .toString();
  }
}

class $PomodoroSessionsTable extends PomodoroSessions
    with TableInfo<$PomodoroSessionsTable, PomodoroSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PomodoroSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workMinutesMeta = const VerificationMeta(
    'workMinutes',
  );
  @override
  late final GeneratedColumn<int> workMinutes = GeneratedColumn<int>(
    'work_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shortBreakMinutesMeta = const VerificationMeta(
    'shortBreakMinutes',
  );
  @override
  late final GeneratedColumn<int> shortBreakMinutes = GeneratedColumn<int>(
    'short_break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longBreakMinutesMeta = const VerificationMeta(
    'longBreakMinutes',
  );
  @override
  late final GeneratedColumn<int> longBreakMinutes = GeneratedColumn<int>(
    'long_break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedWorkSessionsMeta =
      const VerificationMeta('completedWorkSessions');
  @override
  late final GeneratedColumn<int> completedWorkSessions = GeneratedColumn<int>(
    'completed_work_sessions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalFocusMinutesMeta = const VerificationMeta(
    'totalFocusMinutes',
  );
  @override
  late final GeneratedColumn<int> totalFocusMinutes = GeneratedColumn<int>(
    'total_focus_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mode,
    workMinutes,
    shortBreakMinutes,
    longBreakMinutes,
    completedWorkSessions,
    totalFocusMinutes,
    date,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pomodoro_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PomodoroSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('work_minutes')) {
      context.handle(
        _workMinutesMeta,
        workMinutes.isAcceptableOrUnknown(
          data['work_minutes']!,
          _workMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workMinutesMeta);
    }
    if (data.containsKey('short_break_minutes')) {
      context.handle(
        _shortBreakMinutesMeta,
        shortBreakMinutes.isAcceptableOrUnknown(
          data['short_break_minutes']!,
          _shortBreakMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shortBreakMinutesMeta);
    }
    if (data.containsKey('long_break_minutes')) {
      context.handle(
        _longBreakMinutesMeta,
        longBreakMinutes.isAcceptableOrUnknown(
          data['long_break_minutes']!,
          _longBreakMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_longBreakMinutesMeta);
    }
    if (data.containsKey('completed_work_sessions')) {
      context.handle(
        _completedWorkSessionsMeta,
        completedWorkSessions.isAcceptableOrUnknown(
          data['completed_work_sessions']!,
          _completedWorkSessionsMeta,
        ),
      );
    }
    if (data.containsKey('total_focus_minutes')) {
      context.handle(
        _totalFocusMinutesMeta,
        totalFocusMinutes.isAcceptableOrUnknown(
          data['total_focus_minutes']!,
          _totalFocusMinutesMeta,
        ),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PomodoroSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PomodoroSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      workMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}work_minutes'],
      )!,
      shortBreakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}short_break_minutes'],
      )!,
      longBreakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}long_break_minutes'],
      )!,
      completedWorkSessions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_work_sessions'],
      )!,
      totalFocusMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_focus_minutes'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PomodoroSessionsTable createAlias(String alias) {
    return $PomodoroSessionsTable(attachedDatabase, alias);
  }
}

class PomodoroSession extends DataClass implements Insertable<PomodoroSession> {
  final int id;
  final String mode;
  final int workMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int completedWorkSessions;
  final int totalFocusMinutes;
  final DateTime date;
  final DateTime createdAt;
  const PomodoroSession({
    required this.id,
    required this.mode,
    required this.workMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    required this.completedWorkSessions,
    required this.totalFocusMinutes,
    required this.date,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mode'] = Variable<String>(mode);
    map['work_minutes'] = Variable<int>(workMinutes);
    map['short_break_minutes'] = Variable<int>(shortBreakMinutes);
    map['long_break_minutes'] = Variable<int>(longBreakMinutes);
    map['completed_work_sessions'] = Variable<int>(completedWorkSessions);
    map['total_focus_minutes'] = Variable<int>(totalFocusMinutes);
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PomodoroSessionsCompanion toCompanion(bool nullToAbsent) {
    return PomodoroSessionsCompanion(
      id: Value(id),
      mode: Value(mode),
      workMinutes: Value(workMinutes),
      shortBreakMinutes: Value(shortBreakMinutes),
      longBreakMinutes: Value(longBreakMinutes),
      completedWorkSessions: Value(completedWorkSessions),
      totalFocusMinutes: Value(totalFocusMinutes),
      date: Value(date),
      createdAt: Value(createdAt),
    );
  }

  factory PomodoroSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PomodoroSession(
      id: serializer.fromJson<int>(json['id']),
      mode: serializer.fromJson<String>(json['mode']),
      workMinutes: serializer.fromJson<int>(json['workMinutes']),
      shortBreakMinutes: serializer.fromJson<int>(json['shortBreakMinutes']),
      longBreakMinutes: serializer.fromJson<int>(json['longBreakMinutes']),
      completedWorkSessions: serializer.fromJson<int>(
        json['completedWorkSessions'],
      ),
      totalFocusMinutes: serializer.fromJson<int>(json['totalFocusMinutes']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mode': serializer.toJson<String>(mode),
      'workMinutes': serializer.toJson<int>(workMinutes),
      'shortBreakMinutes': serializer.toJson<int>(shortBreakMinutes),
      'longBreakMinutes': serializer.toJson<int>(longBreakMinutes),
      'completedWorkSessions': serializer.toJson<int>(completedWorkSessions),
      'totalFocusMinutes': serializer.toJson<int>(totalFocusMinutes),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PomodoroSession copyWith({
    int? id,
    String? mode,
    int? workMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? completedWorkSessions,
    int? totalFocusMinutes,
    DateTime? date,
    DateTime? createdAt,
  }) => PomodoroSession(
    id: id ?? this.id,
    mode: mode ?? this.mode,
    workMinutes: workMinutes ?? this.workMinutes,
    shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
    longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
    completedWorkSessions: completedWorkSessions ?? this.completedWorkSessions,
    totalFocusMinutes: totalFocusMinutes ?? this.totalFocusMinutes,
    date: date ?? this.date,
    createdAt: createdAt ?? this.createdAt,
  );
  PomodoroSession copyWithCompanion(PomodoroSessionsCompanion data) {
    return PomodoroSession(
      id: data.id.present ? data.id.value : this.id,
      mode: data.mode.present ? data.mode.value : this.mode,
      workMinutes: data.workMinutes.present
          ? data.workMinutes.value
          : this.workMinutes,
      shortBreakMinutes: data.shortBreakMinutes.present
          ? data.shortBreakMinutes.value
          : this.shortBreakMinutes,
      longBreakMinutes: data.longBreakMinutes.present
          ? data.longBreakMinutes.value
          : this.longBreakMinutes,
      completedWorkSessions: data.completedWorkSessions.present
          ? data.completedWorkSessions.value
          : this.completedWorkSessions,
      totalFocusMinutes: data.totalFocusMinutes.present
          ? data.totalFocusMinutes.value
          : this.totalFocusMinutes,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PomodoroSession(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('workMinutes: $workMinutes, ')
          ..write('shortBreakMinutes: $shortBreakMinutes, ')
          ..write('longBreakMinutes: $longBreakMinutes, ')
          ..write('completedWorkSessions: $completedWorkSessions, ')
          ..write('totalFocusMinutes: $totalFocusMinutes, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mode,
    workMinutes,
    shortBreakMinutes,
    longBreakMinutes,
    completedWorkSessions,
    totalFocusMinutes,
    date,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PomodoroSession &&
          other.id == this.id &&
          other.mode == this.mode &&
          other.workMinutes == this.workMinutes &&
          other.shortBreakMinutes == this.shortBreakMinutes &&
          other.longBreakMinutes == this.longBreakMinutes &&
          other.completedWorkSessions == this.completedWorkSessions &&
          other.totalFocusMinutes == this.totalFocusMinutes &&
          other.date == this.date &&
          other.createdAt == this.createdAt);
}

class PomodoroSessionsCompanion extends UpdateCompanion<PomodoroSession> {
  final Value<int> id;
  final Value<String> mode;
  final Value<int> workMinutes;
  final Value<int> shortBreakMinutes;
  final Value<int> longBreakMinutes;
  final Value<int> completedWorkSessions;
  final Value<int> totalFocusMinutes;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  const PomodoroSessionsCompanion({
    this.id = const Value.absent(),
    this.mode = const Value.absent(),
    this.workMinutes = const Value.absent(),
    this.shortBreakMinutes = const Value.absent(),
    this.longBreakMinutes = const Value.absent(),
    this.completedWorkSessions = const Value.absent(),
    this.totalFocusMinutes = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PomodoroSessionsCompanion.insert({
    this.id = const Value.absent(),
    required String mode,
    required int workMinutes,
    required int shortBreakMinutes,
    required int longBreakMinutes,
    this.completedWorkSessions = const Value.absent(),
    this.totalFocusMinutes = const Value.absent(),
    required DateTime date,
    this.createdAt = const Value.absent(),
  }) : mode = Value(mode),
       workMinutes = Value(workMinutes),
       shortBreakMinutes = Value(shortBreakMinutes),
       longBreakMinutes = Value(longBreakMinutes),
       date = Value(date);
  static Insertable<PomodoroSession> custom({
    Expression<int>? id,
    Expression<String>? mode,
    Expression<int>? workMinutes,
    Expression<int>? shortBreakMinutes,
    Expression<int>? longBreakMinutes,
    Expression<int>? completedWorkSessions,
    Expression<int>? totalFocusMinutes,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mode != null) 'mode': mode,
      if (workMinutes != null) 'work_minutes': workMinutes,
      if (shortBreakMinutes != null) 'short_break_minutes': shortBreakMinutes,
      if (longBreakMinutes != null) 'long_break_minutes': longBreakMinutes,
      if (completedWorkSessions != null)
        'completed_work_sessions': completedWorkSessions,
      if (totalFocusMinutes != null) 'total_focus_minutes': totalFocusMinutes,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PomodoroSessionsCompanion copyWith({
    Value<int>? id,
    Value<String>? mode,
    Value<int>? workMinutes,
    Value<int>? shortBreakMinutes,
    Value<int>? longBreakMinutes,
    Value<int>? completedWorkSessions,
    Value<int>? totalFocusMinutes,
    Value<DateTime>? date,
    Value<DateTime>? createdAt,
  }) {
    return PomodoroSessionsCompanion(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      workMinutes: workMinutes ?? this.workMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      completedWorkSessions:
          completedWorkSessions ?? this.completedWorkSessions,
      totalFocusMinutes: totalFocusMinutes ?? this.totalFocusMinutes,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (workMinutes.present) {
      map['work_minutes'] = Variable<int>(workMinutes.value);
    }
    if (shortBreakMinutes.present) {
      map['short_break_minutes'] = Variable<int>(shortBreakMinutes.value);
    }
    if (longBreakMinutes.present) {
      map['long_break_minutes'] = Variable<int>(longBreakMinutes.value);
    }
    if (completedWorkSessions.present) {
      map['completed_work_sessions'] = Variable<int>(
        completedWorkSessions.value,
      );
    }
    if (totalFocusMinutes.present) {
      map['total_focus_minutes'] = Variable<int>(totalFocusMinutes.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PomodoroSessionsCompanion(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('workMinutes: $workMinutes, ')
          ..write('shortBreakMinutes: $shortBreakMinutes, ')
          ..write('longBreakMinutes: $longBreakMinutes, ')
          ..write('completedWorkSessions: $completedWorkSessions, ')
          ..write('totalFocusMinutes: $totalFocusMinutes, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PomodoroPresetsTable extends PomodoroPresets
    with TableInfo<$PomodoroPresetsTable, PomodoroPreset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PomodoroPresetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workMinutesMeta = const VerificationMeta(
    'workMinutes',
  );
  @override
  late final GeneratedColumn<int> workMinutes = GeneratedColumn<int>(
    'work_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shortBreakMinutesMeta = const VerificationMeta(
    'shortBreakMinutes',
  );
  @override
  late final GeneratedColumn<int> shortBreakMinutes = GeneratedColumn<int>(
    'short_break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longBreakMinutesMeta = const VerificationMeta(
    'longBreakMinutes',
  );
  @override
  late final GeneratedColumn<int> longBreakMinutes = GeneratedColumn<int>(
    'long_break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    workMinutes,
    shortBreakMinutes,
    longBreakMinutes,
    isCustom,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pomodoro_presets';
  @override
  VerificationContext validateIntegrity(
    Insertable<PomodoroPreset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('work_minutes')) {
      context.handle(
        _workMinutesMeta,
        workMinutes.isAcceptableOrUnknown(
          data['work_minutes']!,
          _workMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workMinutesMeta);
    }
    if (data.containsKey('short_break_minutes')) {
      context.handle(
        _shortBreakMinutesMeta,
        shortBreakMinutes.isAcceptableOrUnknown(
          data['short_break_minutes']!,
          _shortBreakMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shortBreakMinutesMeta);
    }
    if (data.containsKey('long_break_minutes')) {
      context.handle(
        _longBreakMinutesMeta,
        longBreakMinutes.isAcceptableOrUnknown(
          data['long_break_minutes']!,
          _longBreakMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_longBreakMinutesMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PomodoroPreset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PomodoroPreset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      workMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}work_minutes'],
      )!,
      shortBreakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}short_break_minutes'],
      )!,
      longBreakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}long_break_minutes'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
    );
  }

  @override
  $PomodoroPresetsTable createAlias(String alias) {
    return $PomodoroPresetsTable(attachedDatabase, alias);
  }
}

class PomodoroPreset extends DataClass implements Insertable<PomodoroPreset> {
  final int id;
  final String name;
  final int workMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final bool isCustom;
  const PomodoroPreset({
    required this.id,
    required this.name,
    required this.workMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    required this.isCustom,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['work_minutes'] = Variable<int>(workMinutes);
    map['short_break_minutes'] = Variable<int>(shortBreakMinutes);
    map['long_break_minutes'] = Variable<int>(longBreakMinutes);
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  PomodoroPresetsCompanion toCompanion(bool nullToAbsent) {
    return PomodoroPresetsCompanion(
      id: Value(id),
      name: Value(name),
      workMinutes: Value(workMinutes),
      shortBreakMinutes: Value(shortBreakMinutes),
      longBreakMinutes: Value(longBreakMinutes),
      isCustom: Value(isCustom),
    );
  }

  factory PomodoroPreset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PomodoroPreset(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      workMinutes: serializer.fromJson<int>(json['workMinutes']),
      shortBreakMinutes: serializer.fromJson<int>(json['shortBreakMinutes']),
      longBreakMinutes: serializer.fromJson<int>(json['longBreakMinutes']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'workMinutes': serializer.toJson<int>(workMinutes),
      'shortBreakMinutes': serializer.toJson<int>(shortBreakMinutes),
      'longBreakMinutes': serializer.toJson<int>(longBreakMinutes),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  PomodoroPreset copyWith({
    int? id,
    String? name,
    int? workMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    bool? isCustom,
  }) => PomodoroPreset(
    id: id ?? this.id,
    name: name ?? this.name,
    workMinutes: workMinutes ?? this.workMinutes,
    shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
    longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
    isCustom: isCustom ?? this.isCustom,
  );
  PomodoroPreset copyWithCompanion(PomodoroPresetsCompanion data) {
    return PomodoroPreset(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      workMinutes: data.workMinutes.present
          ? data.workMinutes.value
          : this.workMinutes,
      shortBreakMinutes: data.shortBreakMinutes.present
          ? data.shortBreakMinutes.value
          : this.shortBreakMinutes,
      longBreakMinutes: data.longBreakMinutes.present
          ? data.longBreakMinutes.value
          : this.longBreakMinutes,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PomodoroPreset(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('workMinutes: $workMinutes, ')
          ..write('shortBreakMinutes: $shortBreakMinutes, ')
          ..write('longBreakMinutes: $longBreakMinutes, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    workMinutes,
    shortBreakMinutes,
    longBreakMinutes,
    isCustom,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PomodoroPreset &&
          other.id == this.id &&
          other.name == this.name &&
          other.workMinutes == this.workMinutes &&
          other.shortBreakMinutes == this.shortBreakMinutes &&
          other.longBreakMinutes == this.longBreakMinutes &&
          other.isCustom == this.isCustom);
}

class PomodoroPresetsCompanion extends UpdateCompanion<PomodoroPreset> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> workMinutes;
  final Value<int> shortBreakMinutes;
  final Value<int> longBreakMinutes;
  final Value<bool> isCustom;
  const PomodoroPresetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.workMinutes = const Value.absent(),
    this.shortBreakMinutes = const Value.absent(),
    this.longBreakMinutes = const Value.absent(),
    this.isCustom = const Value.absent(),
  });
  PomodoroPresetsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int workMinutes,
    required int shortBreakMinutes,
    required int longBreakMinutes,
    this.isCustom = const Value.absent(),
  }) : name = Value(name),
       workMinutes = Value(workMinutes),
       shortBreakMinutes = Value(shortBreakMinutes),
       longBreakMinutes = Value(longBreakMinutes);
  static Insertable<PomodoroPreset> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? workMinutes,
    Expression<int>? shortBreakMinutes,
    Expression<int>? longBreakMinutes,
    Expression<bool>? isCustom,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (workMinutes != null) 'work_minutes': workMinutes,
      if (shortBreakMinutes != null) 'short_break_minutes': shortBreakMinutes,
      if (longBreakMinutes != null) 'long_break_minutes': longBreakMinutes,
      if (isCustom != null) 'is_custom': isCustom,
    });
  }

  PomodoroPresetsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? workMinutes,
    Value<int>? shortBreakMinutes,
    Value<int>? longBreakMinutes,
    Value<bool>? isCustom,
  }) {
    return PomodoroPresetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      workMinutes: workMinutes ?? this.workMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (workMinutes.present) {
      map['work_minutes'] = Variable<int>(workMinutes.value);
    }
    if (shortBreakMinutes.present) {
      map['short_break_minutes'] = Variable<int>(shortBreakMinutes.value);
    }
    if (longBreakMinutes.present) {
      map['long_break_minutes'] = Variable<int>(longBreakMinutes.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PomodoroPresetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('workMinutes: $workMinutes, ')
          ..write('shortBreakMinutes: $shortBreakMinutes, ')
          ..write('longBreakMinutes: $longBreakMinutes, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }
}

class $ScreenTimeRecordsTable extends ScreenTimeRecords
    with TableInfo<$ScreenTimeRecordsTable, ScreenTimeRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScreenTimeRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMinutesMeta = const VerificationMeta(
    'totalMinutes',
  );
  @override
  late final GeneratedColumn<int> totalMinutes = GeneratedColumn<int>(
    'total_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _productiveMinutesMeta = const VerificationMeta(
    'productiveMinutes',
  );
  @override
  late final GeneratedColumn<int> productiveMinutes = GeneratedColumn<int>(
    'productive_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _distractionMinutesMeta =
      const VerificationMeta('distractionMinutes');
  @override
  late final GeneratedColumn<int> distractionMinutes = GeneratedColumn<int>(
    'distraction_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dailyLimitMinutesMeta = const VerificationMeta(
    'dailyLimitMinutes',
  );
  @override
  late final GeneratedColumn<int> dailyLimitMinutes = GeneratedColumn<int>(
    'daily_limit_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(180),
  );
  static const VerificationMeta _appUsageJsonMeta = const VerificationMeta(
    'appUsageJson',
  );
  @override
  late final GeneratedColumn<String> appUsageJson = GeneratedColumn<String>(
    'app_usage_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    totalMinutes,
    productiveMinutes,
    distractionMinutes,
    dailyLimitMinutes,
    appUsageJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'screen_time_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScreenTimeRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('total_minutes')) {
      context.handle(
        _totalMinutesMeta,
        totalMinutes.isAcceptableOrUnknown(
          data['total_minutes']!,
          _totalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('productive_minutes')) {
      context.handle(
        _productiveMinutesMeta,
        productiveMinutes.isAcceptableOrUnknown(
          data['productive_minutes']!,
          _productiveMinutesMeta,
        ),
      );
    }
    if (data.containsKey('distraction_minutes')) {
      context.handle(
        _distractionMinutesMeta,
        distractionMinutes.isAcceptableOrUnknown(
          data['distraction_minutes']!,
          _distractionMinutesMeta,
        ),
      );
    }
    if (data.containsKey('daily_limit_minutes')) {
      context.handle(
        _dailyLimitMinutesMeta,
        dailyLimitMinutes.isAcceptableOrUnknown(
          data['daily_limit_minutes']!,
          _dailyLimitMinutesMeta,
        ),
      );
    }
    if (data.containsKey('app_usage_json')) {
      context.handle(
        _appUsageJsonMeta,
        appUsageJson.isAcceptableOrUnknown(
          data['app_usage_json']!,
          _appUsageJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScreenTimeRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScreenTimeRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      totalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_minutes'],
      )!,
      productiveMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}productive_minutes'],
      )!,
      distractionMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}distraction_minutes'],
      )!,
      dailyLimitMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_limit_minutes'],
      )!,
      appUsageJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_usage_json'],
      )!,
    );
  }

  @override
  $ScreenTimeRecordsTable createAlias(String alias) {
    return $ScreenTimeRecordsTable(attachedDatabase, alias);
  }
}

class ScreenTimeRecord extends DataClass
    implements Insertable<ScreenTimeRecord> {
  final int id;
  final DateTime date;
  final int totalMinutes;
  final int productiveMinutes;
  final int distractionMinutes;
  final int dailyLimitMinutes;
  final String appUsageJson;
  const ScreenTimeRecord({
    required this.id,
    required this.date,
    required this.totalMinutes,
    required this.productiveMinutes,
    required this.distractionMinutes,
    required this.dailyLimitMinutes,
    required this.appUsageJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['total_minutes'] = Variable<int>(totalMinutes);
    map['productive_minutes'] = Variable<int>(productiveMinutes);
    map['distraction_minutes'] = Variable<int>(distractionMinutes);
    map['daily_limit_minutes'] = Variable<int>(dailyLimitMinutes);
    map['app_usage_json'] = Variable<String>(appUsageJson);
    return map;
  }

  ScreenTimeRecordsCompanion toCompanion(bool nullToAbsent) {
    return ScreenTimeRecordsCompanion(
      id: Value(id),
      date: Value(date),
      totalMinutes: Value(totalMinutes),
      productiveMinutes: Value(productiveMinutes),
      distractionMinutes: Value(distractionMinutes),
      dailyLimitMinutes: Value(dailyLimitMinutes),
      appUsageJson: Value(appUsageJson),
    );
  }

  factory ScreenTimeRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScreenTimeRecord(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      totalMinutes: serializer.fromJson<int>(json['totalMinutes']),
      productiveMinutes: serializer.fromJson<int>(json['productiveMinutes']),
      distractionMinutes: serializer.fromJson<int>(json['distractionMinutes']),
      dailyLimitMinutes: serializer.fromJson<int>(json['dailyLimitMinutes']),
      appUsageJson: serializer.fromJson<String>(json['appUsageJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'totalMinutes': serializer.toJson<int>(totalMinutes),
      'productiveMinutes': serializer.toJson<int>(productiveMinutes),
      'distractionMinutes': serializer.toJson<int>(distractionMinutes),
      'dailyLimitMinutes': serializer.toJson<int>(dailyLimitMinutes),
      'appUsageJson': serializer.toJson<String>(appUsageJson),
    };
  }

  ScreenTimeRecord copyWith({
    int? id,
    DateTime? date,
    int? totalMinutes,
    int? productiveMinutes,
    int? distractionMinutes,
    int? dailyLimitMinutes,
    String? appUsageJson,
  }) => ScreenTimeRecord(
    id: id ?? this.id,
    date: date ?? this.date,
    totalMinutes: totalMinutes ?? this.totalMinutes,
    productiveMinutes: productiveMinutes ?? this.productiveMinutes,
    distractionMinutes: distractionMinutes ?? this.distractionMinutes,
    dailyLimitMinutes: dailyLimitMinutes ?? this.dailyLimitMinutes,
    appUsageJson: appUsageJson ?? this.appUsageJson,
  );
  ScreenTimeRecord copyWithCompanion(ScreenTimeRecordsCompanion data) {
    return ScreenTimeRecord(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      totalMinutes: data.totalMinutes.present
          ? data.totalMinutes.value
          : this.totalMinutes,
      productiveMinutes: data.productiveMinutes.present
          ? data.productiveMinutes.value
          : this.productiveMinutes,
      distractionMinutes: data.distractionMinutes.present
          ? data.distractionMinutes.value
          : this.distractionMinutes,
      dailyLimitMinutes: data.dailyLimitMinutes.present
          ? data.dailyLimitMinutes.value
          : this.dailyLimitMinutes,
      appUsageJson: data.appUsageJson.present
          ? data.appUsageJson.value
          : this.appUsageJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScreenTimeRecord(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('totalMinutes: $totalMinutes, ')
          ..write('productiveMinutes: $productiveMinutes, ')
          ..write('distractionMinutes: $distractionMinutes, ')
          ..write('dailyLimitMinutes: $dailyLimitMinutes, ')
          ..write('appUsageJson: $appUsageJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    totalMinutes,
    productiveMinutes,
    distractionMinutes,
    dailyLimitMinutes,
    appUsageJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScreenTimeRecord &&
          other.id == this.id &&
          other.date == this.date &&
          other.totalMinutes == this.totalMinutes &&
          other.productiveMinutes == this.productiveMinutes &&
          other.distractionMinutes == this.distractionMinutes &&
          other.dailyLimitMinutes == this.dailyLimitMinutes &&
          other.appUsageJson == this.appUsageJson);
}

class ScreenTimeRecordsCompanion extends UpdateCompanion<ScreenTimeRecord> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> totalMinutes;
  final Value<int> productiveMinutes;
  final Value<int> distractionMinutes;
  final Value<int> dailyLimitMinutes;
  final Value<String> appUsageJson;
  const ScreenTimeRecordsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.totalMinutes = const Value.absent(),
    this.productiveMinutes = const Value.absent(),
    this.distractionMinutes = const Value.absent(),
    this.dailyLimitMinutes = const Value.absent(),
    this.appUsageJson = const Value.absent(),
  });
  ScreenTimeRecordsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.totalMinutes = const Value.absent(),
    this.productiveMinutes = const Value.absent(),
    this.distractionMinutes = const Value.absent(),
    this.dailyLimitMinutes = const Value.absent(),
    this.appUsageJson = const Value.absent(),
  }) : date = Value(date);
  static Insertable<ScreenTimeRecord> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? totalMinutes,
    Expression<int>? productiveMinutes,
    Expression<int>? distractionMinutes,
    Expression<int>? dailyLimitMinutes,
    Expression<String>? appUsageJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (totalMinutes != null) 'total_minutes': totalMinutes,
      if (productiveMinutes != null) 'productive_minutes': productiveMinutes,
      if (distractionMinutes != null) 'distraction_minutes': distractionMinutes,
      if (dailyLimitMinutes != null) 'daily_limit_minutes': dailyLimitMinutes,
      if (appUsageJson != null) 'app_usage_json': appUsageJson,
    });
  }

  ScreenTimeRecordsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int>? totalMinutes,
    Value<int>? productiveMinutes,
    Value<int>? distractionMinutes,
    Value<int>? dailyLimitMinutes,
    Value<String>? appUsageJson,
  }) {
    return ScreenTimeRecordsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      productiveMinutes: productiveMinutes ?? this.productiveMinutes,
      distractionMinutes: distractionMinutes ?? this.distractionMinutes,
      dailyLimitMinutes: dailyLimitMinutes ?? this.dailyLimitMinutes,
      appUsageJson: appUsageJson ?? this.appUsageJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (totalMinutes.present) {
      map['total_minutes'] = Variable<int>(totalMinutes.value);
    }
    if (productiveMinutes.present) {
      map['productive_minutes'] = Variable<int>(productiveMinutes.value);
    }
    if (distractionMinutes.present) {
      map['distraction_minutes'] = Variable<int>(distractionMinutes.value);
    }
    if (dailyLimitMinutes.present) {
      map['daily_limit_minutes'] = Variable<int>(dailyLimitMinutes.value);
    }
    if (appUsageJson.present) {
      map['app_usage_json'] = Variable<String>(appUsageJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScreenTimeRecordsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('totalMinutes: $totalMinutes, ')
          ..write('productiveMinutes: $productiveMinutes, ')
          ..write('distractionMinutes: $distractionMinutes, ')
          ..write('dailyLimitMinutes: $dailyLimitMinutes, ')
          ..write('appUsageJson: $appUsageJson')
          ..write(')'))
        .toString();
  }
}

class $ScreenTimeAppsTable extends ScreenTimeApps
    with TableInfo<$ScreenTimeAppsTable, ScreenTimeApp> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScreenTimeAppsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appNameMeta = const VerificationMeta(
    'appName',
  );
  @override
  late final GeneratedColumn<String> appName = GeneratedColumn<String>(
    'app_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('neutral'),
  );
  static const VerificationMeta _categoryManualMeta = const VerificationMeta(
    'categoryManual',
  );
  @override
  late final GeneratedColumn<bool> categoryManual = GeneratedColumn<bool>(
    'category_manual',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("category_manual" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dailyLimitMinutesMeta = const VerificationMeta(
    'dailyLimitMinutes',
  );
  @override
  late final GeneratedColumn<int> dailyLimitMinutes = GeneratedColumn<int>(
    'daily_limit_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isBlockedMeta = const VerificationMeta(
    'isBlocked',
  );
  @override
  late final GeneratedColumn<bool> isBlocked = GeneratedColumn<bool>(
    'is_blocked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_blocked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packageName,
    appName,
    category,
    categoryManual,
    dailyLimitMinutes,
    isBlocked,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'screen_time_apps';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScreenTimeApp> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('app_name')) {
      context.handle(
        _appNameMeta,
        appName.isAcceptableOrUnknown(data['app_name']!, _appNameMeta),
      );
    } else if (isInserting) {
      context.missing(_appNameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('category_manual')) {
      context.handle(
        _categoryManualMeta,
        categoryManual.isAcceptableOrUnknown(
          data['category_manual']!,
          _categoryManualMeta,
        ),
      );
    }
    if (data.containsKey('daily_limit_minutes')) {
      context.handle(
        _dailyLimitMinutesMeta,
        dailyLimitMinutes.isAcceptableOrUnknown(
          data['daily_limit_minutes']!,
          _dailyLimitMinutesMeta,
        ),
      );
    }
    if (data.containsKey('is_blocked')) {
      context.handle(
        _isBlockedMeta,
        isBlocked.isAcceptableOrUnknown(data['is_blocked']!, _isBlockedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScreenTimeApp map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScreenTimeApp(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      appName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      categoryManual: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}category_manual'],
      )!,
      dailyLimitMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_limit_minutes'],
      ),
      isBlocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_blocked'],
      )!,
    );
  }

  @override
  $ScreenTimeAppsTable createAlias(String alias) {
    return $ScreenTimeAppsTable(attachedDatabase, alias);
  }
}

class ScreenTimeApp extends DataClass implements Insertable<ScreenTimeApp> {
  final int id;
  final String packageName;
  final String appName;
  final String category;
  final bool categoryManual;
  final int? dailyLimitMinutes;
  final bool isBlocked;
  const ScreenTimeApp({
    required this.id,
    required this.packageName,
    required this.appName,
    required this.category,
    required this.categoryManual,
    this.dailyLimitMinutes,
    required this.isBlocked,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['package_name'] = Variable<String>(packageName);
    map['app_name'] = Variable<String>(appName);
    map['category'] = Variable<String>(category);
    map['category_manual'] = Variable<bool>(categoryManual);
    if (!nullToAbsent || dailyLimitMinutes != null) {
      map['daily_limit_minutes'] = Variable<int>(dailyLimitMinutes);
    }
    map['is_blocked'] = Variable<bool>(isBlocked);
    return map;
  }

  ScreenTimeAppsCompanion toCompanion(bool nullToAbsent) {
    return ScreenTimeAppsCompanion(
      id: Value(id),
      packageName: Value(packageName),
      appName: Value(appName),
      category: Value(category),
      categoryManual: Value(categoryManual),
      dailyLimitMinutes: dailyLimitMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(dailyLimitMinutes),
      isBlocked: Value(isBlocked),
    );
  }

  factory ScreenTimeApp.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScreenTimeApp(
      id: serializer.fromJson<int>(json['id']),
      packageName: serializer.fromJson<String>(json['packageName']),
      appName: serializer.fromJson<String>(json['appName']),
      category: serializer.fromJson<String>(json['category']),
      categoryManual: serializer.fromJson<bool>(json['categoryManual']),
      dailyLimitMinutes: serializer.fromJson<int?>(json['dailyLimitMinutes']),
      isBlocked: serializer.fromJson<bool>(json['isBlocked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'packageName': serializer.toJson<String>(packageName),
      'appName': serializer.toJson<String>(appName),
      'category': serializer.toJson<String>(category),
      'categoryManual': serializer.toJson<bool>(categoryManual),
      'dailyLimitMinutes': serializer.toJson<int?>(dailyLimitMinutes),
      'isBlocked': serializer.toJson<bool>(isBlocked),
    };
  }

  ScreenTimeApp copyWith({
    int? id,
    String? packageName,
    String? appName,
    String? category,
    bool? categoryManual,
    Value<int?> dailyLimitMinutes = const Value.absent(),
    bool? isBlocked,
  }) => ScreenTimeApp(
    id: id ?? this.id,
    packageName: packageName ?? this.packageName,
    appName: appName ?? this.appName,
    category: category ?? this.category,
    categoryManual: categoryManual ?? this.categoryManual,
    dailyLimitMinutes: dailyLimitMinutes.present
        ? dailyLimitMinutes.value
        : this.dailyLimitMinutes,
    isBlocked: isBlocked ?? this.isBlocked,
  );
  ScreenTimeApp copyWithCompanion(ScreenTimeAppsCompanion data) {
    return ScreenTimeApp(
      id: data.id.present ? data.id.value : this.id,
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      appName: data.appName.present ? data.appName.value : this.appName,
      category: data.category.present ? data.category.value : this.category,
      categoryManual: data.categoryManual.present
          ? data.categoryManual.value
          : this.categoryManual,
      dailyLimitMinutes: data.dailyLimitMinutes.present
          ? data.dailyLimitMinutes.value
          : this.dailyLimitMinutes,
      isBlocked: data.isBlocked.present ? data.isBlocked.value : this.isBlocked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScreenTimeApp(')
          ..write('id: $id, ')
          ..write('packageName: $packageName, ')
          ..write('appName: $appName, ')
          ..write('category: $category, ')
          ..write('categoryManual: $categoryManual, ')
          ..write('dailyLimitMinutes: $dailyLimitMinutes, ')
          ..write('isBlocked: $isBlocked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    packageName,
    appName,
    category,
    categoryManual,
    dailyLimitMinutes,
    isBlocked,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScreenTimeApp &&
          other.id == this.id &&
          other.packageName == this.packageName &&
          other.appName == this.appName &&
          other.category == this.category &&
          other.categoryManual == this.categoryManual &&
          other.dailyLimitMinutes == this.dailyLimitMinutes &&
          other.isBlocked == this.isBlocked);
}

class ScreenTimeAppsCompanion extends UpdateCompanion<ScreenTimeApp> {
  final Value<int> id;
  final Value<String> packageName;
  final Value<String> appName;
  final Value<String> category;
  final Value<bool> categoryManual;
  final Value<int?> dailyLimitMinutes;
  final Value<bool> isBlocked;
  const ScreenTimeAppsCompanion({
    this.id = const Value.absent(),
    this.packageName = const Value.absent(),
    this.appName = const Value.absent(),
    this.category = const Value.absent(),
    this.categoryManual = const Value.absent(),
    this.dailyLimitMinutes = const Value.absent(),
    this.isBlocked = const Value.absent(),
  });
  ScreenTimeAppsCompanion.insert({
    this.id = const Value.absent(),
    required String packageName,
    required String appName,
    this.category = const Value.absent(),
    this.categoryManual = const Value.absent(),
    this.dailyLimitMinutes = const Value.absent(),
    this.isBlocked = const Value.absent(),
  }) : packageName = Value(packageName),
       appName = Value(appName);
  static Insertable<ScreenTimeApp> custom({
    Expression<int>? id,
    Expression<String>? packageName,
    Expression<String>? appName,
    Expression<String>? category,
    Expression<bool>? categoryManual,
    Expression<int>? dailyLimitMinutes,
    Expression<bool>? isBlocked,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packageName != null) 'package_name': packageName,
      if (appName != null) 'app_name': appName,
      if (category != null) 'category': category,
      if (categoryManual != null) 'category_manual': categoryManual,
      if (dailyLimitMinutes != null) 'daily_limit_minutes': dailyLimitMinutes,
      if (isBlocked != null) 'is_blocked': isBlocked,
    });
  }

  ScreenTimeAppsCompanion copyWith({
    Value<int>? id,
    Value<String>? packageName,
    Value<String>? appName,
    Value<String>? category,
    Value<bool>? categoryManual,
    Value<int?>? dailyLimitMinutes,
    Value<bool>? isBlocked,
  }) {
    return ScreenTimeAppsCompanion(
      id: id ?? this.id,
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      category: category ?? this.category,
      categoryManual: categoryManual ?? this.categoryManual,
      dailyLimitMinutes: dailyLimitMinutes ?? this.dailyLimitMinutes,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (appName.present) {
      map['app_name'] = Variable<String>(appName.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (categoryManual.present) {
      map['category_manual'] = Variable<bool>(categoryManual.value);
    }
    if (dailyLimitMinutes.present) {
      map['daily_limit_minutes'] = Variable<int>(dailyLimitMinutes.value);
    }
    if (isBlocked.present) {
      map['is_blocked'] = Variable<bool>(isBlocked.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScreenTimeAppsCompanion(')
          ..write('id: $id, ')
          ..write('packageName: $packageName, ')
          ..write('appName: $appName, ')
          ..write('category: $category, ')
          ..write('categoryManual: $categoryManual, ')
          ..write('dailyLimitMinutes: $dailyLimitMinutes, ')
          ..write('isBlocked: $isBlocked')
          ..write(')'))
        .toString();
  }
}

class $DailyScoresTable extends DailyScores
    with TableInfo<$DailyScoresTable, DailyScore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyScoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _todoScoreMeta = const VerificationMeta(
    'todoScore',
  );
  @override
  late final GeneratedColumn<int> todoScore = GeneratedColumn<int>(
    'todo_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _prayerScoreMeta = const VerificationMeta(
    'prayerScore',
  );
  @override
  late final GeneratedColumn<int> prayerScore = GeneratedColumn<int>(
    'prayer_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _waterScoreMeta = const VerificationMeta(
    'waterScore',
  );
  @override
  late final GeneratedColumn<int> waterScore = GeneratedColumn<int>(
    'water_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _screenTimeScoreMeta = const VerificationMeta(
    'screenTimeScore',
  );
  @override
  late final GeneratedColumn<int> screenTimeScore = GeneratedColumn<int>(
    'screen_time_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pomodoroPointsMeta = const VerificationMeta(
    'pomodoroPoints',
  );
  @override
  late final GeneratedColumn<int> pomodoroPoints = GeneratedColumn<int>(
    'pomodoro_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalScoreMeta = const VerificationMeta(
    'totalScore',
  );
  @override
  late final GeneratedColumn<int> totalScore = GeneratedColumn<int>(
    'total_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _streakDaysMeta = const VerificationMeta(
    'streakDays',
  );
  @override
  late final GeneratedColumn<int> streakDays = GeneratedColumn<int>(
    'streak_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    todoScore,
    prayerScore,
    waterScore,
    screenTimeScore,
    pomodoroPoints,
    totalScore,
    streakDays,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_scores';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyScore> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('todo_score')) {
      context.handle(
        _todoScoreMeta,
        todoScore.isAcceptableOrUnknown(data['todo_score']!, _todoScoreMeta),
      );
    }
    if (data.containsKey('prayer_score')) {
      context.handle(
        _prayerScoreMeta,
        prayerScore.isAcceptableOrUnknown(
          data['prayer_score']!,
          _prayerScoreMeta,
        ),
      );
    }
    if (data.containsKey('water_score')) {
      context.handle(
        _waterScoreMeta,
        waterScore.isAcceptableOrUnknown(data['water_score']!, _waterScoreMeta),
      );
    }
    if (data.containsKey('screen_time_score')) {
      context.handle(
        _screenTimeScoreMeta,
        screenTimeScore.isAcceptableOrUnknown(
          data['screen_time_score']!,
          _screenTimeScoreMeta,
        ),
      );
    }
    if (data.containsKey('pomodoro_points')) {
      context.handle(
        _pomodoroPointsMeta,
        pomodoroPoints.isAcceptableOrUnknown(
          data['pomodoro_points']!,
          _pomodoroPointsMeta,
        ),
      );
    }
    if (data.containsKey('total_score')) {
      context.handle(
        _totalScoreMeta,
        totalScore.isAcceptableOrUnknown(data['total_score']!, _totalScoreMeta),
      );
    }
    if (data.containsKey('streak_days')) {
      context.handle(
        _streakDaysMeta,
        streakDays.isAcceptableOrUnknown(data['streak_days']!, _streakDaysMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyScore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyScore(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      todoScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}todo_score'],
      )!,
      prayerScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prayer_score'],
      )!,
      waterScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}water_score'],
      )!,
      screenTimeScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}screen_time_score'],
      )!,
      pomodoroPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pomodoro_points'],
      )!,
      totalScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_score'],
      )!,
      streakDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak_days'],
      )!,
    );
  }

  @override
  $DailyScoresTable createAlias(String alias) {
    return $DailyScoresTable(attachedDatabase, alias);
  }
}

class DailyScore extends DataClass implements Insertable<DailyScore> {
  final int id;
  final DateTime date;
  final int todoScore;
  final int prayerScore;
  final int waterScore;
  final int screenTimeScore;
  final int pomodoroPoints;
  final int totalScore;
  final int streakDays;
  const DailyScore({
    required this.id,
    required this.date,
    required this.todoScore,
    required this.prayerScore,
    required this.waterScore,
    required this.screenTimeScore,
    required this.pomodoroPoints,
    required this.totalScore,
    required this.streakDays,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['todo_score'] = Variable<int>(todoScore);
    map['prayer_score'] = Variable<int>(prayerScore);
    map['water_score'] = Variable<int>(waterScore);
    map['screen_time_score'] = Variable<int>(screenTimeScore);
    map['pomodoro_points'] = Variable<int>(pomodoroPoints);
    map['total_score'] = Variable<int>(totalScore);
    map['streak_days'] = Variable<int>(streakDays);
    return map;
  }

  DailyScoresCompanion toCompanion(bool nullToAbsent) {
    return DailyScoresCompanion(
      id: Value(id),
      date: Value(date),
      todoScore: Value(todoScore),
      prayerScore: Value(prayerScore),
      waterScore: Value(waterScore),
      screenTimeScore: Value(screenTimeScore),
      pomodoroPoints: Value(pomodoroPoints),
      totalScore: Value(totalScore),
      streakDays: Value(streakDays),
    );
  }

  factory DailyScore.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyScore(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      todoScore: serializer.fromJson<int>(json['todoScore']),
      prayerScore: serializer.fromJson<int>(json['prayerScore']),
      waterScore: serializer.fromJson<int>(json['waterScore']),
      screenTimeScore: serializer.fromJson<int>(json['screenTimeScore']),
      pomodoroPoints: serializer.fromJson<int>(json['pomodoroPoints']),
      totalScore: serializer.fromJson<int>(json['totalScore']),
      streakDays: serializer.fromJson<int>(json['streakDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'todoScore': serializer.toJson<int>(todoScore),
      'prayerScore': serializer.toJson<int>(prayerScore),
      'waterScore': serializer.toJson<int>(waterScore),
      'screenTimeScore': serializer.toJson<int>(screenTimeScore),
      'pomodoroPoints': serializer.toJson<int>(pomodoroPoints),
      'totalScore': serializer.toJson<int>(totalScore),
      'streakDays': serializer.toJson<int>(streakDays),
    };
  }

  DailyScore copyWith({
    int? id,
    DateTime? date,
    int? todoScore,
    int? prayerScore,
    int? waterScore,
    int? screenTimeScore,
    int? pomodoroPoints,
    int? totalScore,
    int? streakDays,
  }) => DailyScore(
    id: id ?? this.id,
    date: date ?? this.date,
    todoScore: todoScore ?? this.todoScore,
    prayerScore: prayerScore ?? this.prayerScore,
    waterScore: waterScore ?? this.waterScore,
    screenTimeScore: screenTimeScore ?? this.screenTimeScore,
    pomodoroPoints: pomodoroPoints ?? this.pomodoroPoints,
    totalScore: totalScore ?? this.totalScore,
    streakDays: streakDays ?? this.streakDays,
  );
  DailyScore copyWithCompanion(DailyScoresCompanion data) {
    return DailyScore(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      todoScore: data.todoScore.present ? data.todoScore.value : this.todoScore,
      prayerScore: data.prayerScore.present
          ? data.prayerScore.value
          : this.prayerScore,
      waterScore: data.waterScore.present
          ? data.waterScore.value
          : this.waterScore,
      screenTimeScore: data.screenTimeScore.present
          ? data.screenTimeScore.value
          : this.screenTimeScore,
      pomodoroPoints: data.pomodoroPoints.present
          ? data.pomodoroPoints.value
          : this.pomodoroPoints,
      totalScore: data.totalScore.present
          ? data.totalScore.value
          : this.totalScore,
      streakDays: data.streakDays.present
          ? data.streakDays.value
          : this.streakDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyScore(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('todoScore: $todoScore, ')
          ..write('prayerScore: $prayerScore, ')
          ..write('waterScore: $waterScore, ')
          ..write('screenTimeScore: $screenTimeScore, ')
          ..write('pomodoroPoints: $pomodoroPoints, ')
          ..write('totalScore: $totalScore, ')
          ..write('streakDays: $streakDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    todoScore,
    prayerScore,
    waterScore,
    screenTimeScore,
    pomodoroPoints,
    totalScore,
    streakDays,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyScore &&
          other.id == this.id &&
          other.date == this.date &&
          other.todoScore == this.todoScore &&
          other.prayerScore == this.prayerScore &&
          other.waterScore == this.waterScore &&
          other.screenTimeScore == this.screenTimeScore &&
          other.pomodoroPoints == this.pomodoroPoints &&
          other.totalScore == this.totalScore &&
          other.streakDays == this.streakDays);
}

class DailyScoresCompanion extends UpdateCompanion<DailyScore> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> todoScore;
  final Value<int> prayerScore;
  final Value<int> waterScore;
  final Value<int> screenTimeScore;
  final Value<int> pomodoroPoints;
  final Value<int> totalScore;
  final Value<int> streakDays;
  const DailyScoresCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.todoScore = const Value.absent(),
    this.prayerScore = const Value.absent(),
    this.waterScore = const Value.absent(),
    this.screenTimeScore = const Value.absent(),
    this.pomodoroPoints = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.streakDays = const Value.absent(),
  });
  DailyScoresCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.todoScore = const Value.absent(),
    this.prayerScore = const Value.absent(),
    this.waterScore = const Value.absent(),
    this.screenTimeScore = const Value.absent(),
    this.pomodoroPoints = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.streakDays = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DailyScore> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? todoScore,
    Expression<int>? prayerScore,
    Expression<int>? waterScore,
    Expression<int>? screenTimeScore,
    Expression<int>? pomodoroPoints,
    Expression<int>? totalScore,
    Expression<int>? streakDays,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (todoScore != null) 'todo_score': todoScore,
      if (prayerScore != null) 'prayer_score': prayerScore,
      if (waterScore != null) 'water_score': waterScore,
      if (screenTimeScore != null) 'screen_time_score': screenTimeScore,
      if (pomodoroPoints != null) 'pomodoro_points': pomodoroPoints,
      if (totalScore != null) 'total_score': totalScore,
      if (streakDays != null) 'streak_days': streakDays,
    });
  }

  DailyScoresCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int>? todoScore,
    Value<int>? prayerScore,
    Value<int>? waterScore,
    Value<int>? screenTimeScore,
    Value<int>? pomodoroPoints,
    Value<int>? totalScore,
    Value<int>? streakDays,
  }) {
    return DailyScoresCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      todoScore: todoScore ?? this.todoScore,
      prayerScore: prayerScore ?? this.prayerScore,
      waterScore: waterScore ?? this.waterScore,
      screenTimeScore: screenTimeScore ?? this.screenTimeScore,
      pomodoroPoints: pomodoroPoints ?? this.pomodoroPoints,
      totalScore: totalScore ?? this.totalScore,
      streakDays: streakDays ?? this.streakDays,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (todoScore.present) {
      map['todo_score'] = Variable<int>(todoScore.value);
    }
    if (prayerScore.present) {
      map['prayer_score'] = Variable<int>(prayerScore.value);
    }
    if (waterScore.present) {
      map['water_score'] = Variable<int>(waterScore.value);
    }
    if (screenTimeScore.present) {
      map['screen_time_score'] = Variable<int>(screenTimeScore.value);
    }
    if (pomodoroPoints.present) {
      map['pomodoro_points'] = Variable<int>(pomodoroPoints.value);
    }
    if (totalScore.present) {
      map['total_score'] = Variable<int>(totalScore.value);
    }
    if (streakDays.present) {
      map['streak_days'] = Variable<int>(streakDays.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyScoresCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('todoScore: $todoScore, ')
          ..write('prayerScore: $prayerScore, ')
          ..write('waterScore: $waterScore, ')
          ..write('screenTimeScore: $screenTimeScore, ')
          ..write('pomodoroPoints: $pomodoroPoints, ')
          ..write('totalScore: $totalScore, ')
          ..write('streakDays: $streakDays')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TodosTable todos = $TodosTable(this);
  late final $TodoTrashTable todoTrash = $TodoTrashTable(this);
  late final $PrayerRecordsTable prayerRecords = $PrayerRecordsTable(this);
  late final $PrayerSettingsTable prayerSettings = $PrayerSettingsTable(this);
  late final $WaterRecordsTable waterRecords = $WaterRecordsTable(this);
  late final $PomodoroSessionsTable pomodoroSessions = $PomodoroSessionsTable(
    this,
  );
  late final $PomodoroPresetsTable pomodoroPresets = $PomodoroPresetsTable(
    this,
  );
  late final $ScreenTimeRecordsTable screenTimeRecords =
      $ScreenTimeRecordsTable(this);
  late final $ScreenTimeAppsTable screenTimeApps = $ScreenTimeAppsTable(this);
  late final $DailyScoresTable dailyScores = $DailyScoresTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    todos,
    todoTrash,
    prayerRecords,
    prayerSettings,
    waterRecords,
    pomodoroSessions,
    pomodoroPresets,
    screenTimeRecords,
    screenTimeApps,
    dailyScores,
  ];
}

typedef $$TodosTableCreateCompanionBuilder = TodosCompanion Function({
  Value<int> id,
  required String title,
  Value<String?> description,
  Value<DateTime?> dueDate,
  Value<int?> dueTimeMinutes,
  Value<bool> isFavorite,
  Value<bool> isCompleted,
  Value<DateTime?> completedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> reminder10amSent,
  Value<bool> reminder6pmSent,
});
typedef $$TodosTableUpdateCompanionBuilder = TodosCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String?> description,
  Value<DateTime?> dueDate,
  Value<int?> dueTimeMinutes,
  Value<bool> isFavorite,
  Value<bool> isCompleted,
  Value<DateTime?> completedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> reminder10amSent,
  Value<bool> reminder6pmSent,
});

class $$TodosTableFilterComposer extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueTimeMinutes => $composableBuilder(
    column: $table.dueTimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminder10amSent => $composableBuilder(
    column: $table.reminder10amSent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminder6pmSent => $composableBuilder(
    column: $table.reminder6pmSent,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TodosTableOrderingComposer
    extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueTimeMinutes => $composableBuilder(
    column: $table.dueTimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminder10amSent => $composableBuilder(
    column: $table.reminder10amSent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminder6pmSent => $composableBuilder(
    column: $table.reminder6pmSent,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TodosTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get dueTimeMinutes => $composableBuilder(
    column: $table.dueTimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get reminder10amSent => $composableBuilder(
    column: $table.reminder10amSent,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reminder6pmSent => $composableBuilder(
    column: $table.reminder6pmSent,
    builder: (column) => column,
  );
}

class $$TodosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TodosTable,
          Todo,
          $$TodosTableFilterComposer,
          $$TodosTableOrderingComposer,
          $$TodosTableAnnotationComposer,
          $$TodosTableCreateCompanionBuilder,
          $$TodosTableUpdateCompanionBuilder,
          (Todo, BaseReferences<_$AppDatabase, $TodosTable, Todo>),
          Todo,
          PrefetchHooks Function()
        > {
  $$TodosTableTableManager(_$AppDatabase db, $TodosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<int?> dueTimeMinutes = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> reminder10amSent = const Value.absent(),
                Value<bool> reminder6pmSent = const Value.absent(),
              }) => TodosCompanion(
                id: id,
                title: title,
                description: description,
                dueDate: dueDate,
                dueTimeMinutes: dueTimeMinutes,
                isFavorite: isFavorite,
                isCompleted: isCompleted,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                reminder10amSent: reminder10amSent,
                reminder6pmSent: reminder6pmSent,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<int?> dueTimeMinutes = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> reminder10amSent = const Value.absent(),
                Value<bool> reminder6pmSent = const Value.absent(),
              }) => TodosCompanion.insert(
                id: id,
                title: title,
                description: description,
                dueDate: dueDate,
                dueTimeMinutes: dueTimeMinutes,
                isFavorite: isFavorite,
                isCompleted: isCompleted,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                reminder10amSent: reminder10amSent,
                reminder6pmSent: reminder6pmSent,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TodosTable, Todo>(table),
                  BaseReferences<_$AppDatabase, $TodosTable, Todo>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TodosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TodosTable,
      Todo,
      $$TodosTableFilterComposer,
      $$TodosTableOrderingComposer,
      $$TodosTableAnnotationComposer,
      $$TodosTableCreateCompanionBuilder,
      $$TodosTableUpdateCompanionBuilder,
      (Todo, BaseReferences<_$AppDatabase, $TodosTable, Todo>),
      Todo,
      PrefetchHooks Function()
    >;
typedef $$TodoTrashTableCreateCompanionBuilder = TodoTrashCompanion Function({
  Value<int> id,
  required int todoId,
  required String title,
  Value<DateTime?> originalDueDate,
  Value<DateTime> deletedAt,
});
typedef $$TodoTrashTableUpdateCompanionBuilder = TodoTrashCompanion Function({
  Value<int> id,
  Value<int> todoId,
  Value<String> title,
  Value<DateTime?> originalDueDate,
  Value<DateTime> deletedAt,
});

class $$TodoTrashTableFilterComposer
    extends Composer<_$AppDatabase, $TodoTrashTable> {
  $$TodoTrashTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get todoId => $composableBuilder(
    column: $table.todoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get originalDueDate => $composableBuilder(
    column: $table.originalDueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TodoTrashTableOrderingComposer
    extends Composer<_$AppDatabase, $TodoTrashTable> {
  $$TodoTrashTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get todoId => $composableBuilder(
    column: $table.todoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get originalDueDate => $composableBuilder(
    column: $table.originalDueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TodoTrashTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodoTrashTable> {
  $$TodoTrashTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get todoId =>
      $composableBuilder(column: $table.todoId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get originalDueDate => $composableBuilder(
    column: $table.originalDueDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$TodoTrashTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TodoTrashTable,
          TodoTrashData,
          $$TodoTrashTableFilterComposer,
          $$TodoTrashTableOrderingComposer,
          $$TodoTrashTableAnnotationComposer,
          $$TodoTrashTableCreateCompanionBuilder,
          $$TodoTrashTableUpdateCompanionBuilder,
          (
            TodoTrashData,
            BaseReferences<_$AppDatabase, $TodoTrashTable, TodoTrashData>,
          ),
          TodoTrashData,
          PrefetchHooks Function()
        > {
  $$TodoTrashTableTableManager(_$AppDatabase db, $TodoTrashTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodoTrashTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodoTrashTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodoTrashTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> todoId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime?> originalDueDate = const Value.absent(),
                Value<DateTime> deletedAt = const Value.absent(),
              }) => TodoTrashCompanion(
                id: id,
                todoId: todoId,
                title: title,
                originalDueDate: originalDueDate,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int todoId,
                required String title,
                Value<DateTime?> originalDueDate = const Value.absent(),
                Value<DateTime> deletedAt = const Value.absent(),
              }) => TodoTrashCompanion.insert(
                id: id,
                todoId: todoId,
                title: title,
                originalDueDate: originalDueDate,
                deletedAt: deletedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TodoTrashTable, TodoTrashData>(table),
                  BaseReferences<_$AppDatabase, $TodoTrashTable, TodoTrashData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TodoTrashTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TodoTrashTable,
      TodoTrashData,
      $$TodoTrashTableFilterComposer,
      $$TodoTrashTableOrderingComposer,
      $$TodoTrashTableAnnotationComposer,
      $$TodoTrashTableCreateCompanionBuilder,
      $$TodoTrashTableUpdateCompanionBuilder,
      (
        TodoTrashData,
        BaseReferences<_$AppDatabase, $TodoTrashTable, TodoTrashData>,
      ),
      TodoTrashData,
      PrefetchHooks Function()
    >;
typedef $$PrayerRecordsTableCreateCompanionBuilder =
    PrayerRecordsCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<bool> fajr,
      Value<bool> dhuhr,
      Value<bool> asr,
      Value<bool> maghrib,
      Value<bool> isha,
      Value<bool> fajrJamaat,
      Value<bool> dhuhrJamaat,
      Value<bool> asrJamaat,
      Value<bool> maghribJamaat,
      Value<bool> ishaJamaat,
      Value<bool> fajrMosque,
      Value<bool> dhuhrMosque,
      Value<bool> asrMosque,
      Value<bool> maghribMosque,
      Value<bool> ishaMosque,
      Value<bool> tahajjud,
      Value<bool> duha,
      Value<bool> quranWaqiah,
      Value<bool> quranMulk,
      Value<int> quranOtherPages,
      Value<bool> adhkarMorning,
      Value<bool> adhkarEvening,
      Value<bool> salatDone,
      Value<int> salatCount,
      Value<bool> thahleelDone,
      Value<int> thahleelCount,
      Value<bool> isthighfarDone,
      Value<int> isthighfarCount,
      Value<DateTime> updatedAt,
    });
typedef $$PrayerRecordsTableUpdateCompanionBuilder =
    PrayerRecordsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<bool> fajr,
      Value<bool> dhuhr,
      Value<bool> asr,
      Value<bool> maghrib,
      Value<bool> isha,
      Value<bool> fajrJamaat,
      Value<bool> dhuhrJamaat,
      Value<bool> asrJamaat,
      Value<bool> maghribJamaat,
      Value<bool> ishaJamaat,
      Value<bool> fajrMosque,
      Value<bool> dhuhrMosque,
      Value<bool> asrMosque,
      Value<bool> maghribMosque,
      Value<bool> ishaMosque,
      Value<bool> tahajjud,
      Value<bool> duha,
      Value<bool> quranWaqiah,
      Value<bool> quranMulk,
      Value<int> quranOtherPages,
      Value<bool> adhkarMorning,
      Value<bool> adhkarEvening,
      Value<bool> salatDone,
      Value<int> salatCount,
      Value<bool> thahleelDone,
      Value<int> thahleelCount,
      Value<bool> isthighfarDone,
      Value<int> isthighfarCount,
      Value<DateTime> updatedAt,
    });

class $$PrayerRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $PrayerRecordsTable> {
  $$PrayerRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fajr => $composableBuilder(
    column: $table.fajr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dhuhr => $composableBuilder(
    column: $table.dhuhr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get asr => $composableBuilder(
    column: $table.asr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get maghrib => $composableBuilder(
    column: $table.maghrib,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isha => $composableBuilder(
    column: $table.isha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fajrJamaat => $composableBuilder(
    column: $table.fajrJamaat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dhuhrJamaat => $composableBuilder(
    column: $table.dhuhrJamaat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get asrJamaat => $composableBuilder(
    column: $table.asrJamaat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get maghribJamaat => $composableBuilder(
    column: $table.maghribJamaat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ishaJamaat => $composableBuilder(
    column: $table.ishaJamaat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fajrMosque => $composableBuilder(
    column: $table.fajrMosque,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dhuhrMosque => $composableBuilder(
    column: $table.dhuhrMosque,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get asrMosque => $composableBuilder(
    column: $table.asrMosque,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get maghribMosque => $composableBuilder(
    column: $table.maghribMosque,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ishaMosque => $composableBuilder(
    column: $table.ishaMosque,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get tahajjud => $composableBuilder(
    column: $table.tahajjud,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get duha => $composableBuilder(
    column: $table.duha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get quranWaqiah => $composableBuilder(
    column: $table.quranWaqiah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get quranMulk => $composableBuilder(
    column: $table.quranMulk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quranOtherPages => $composableBuilder(
    column: $table.quranOtherPages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get adhkarMorning => $composableBuilder(
    column: $table.adhkarMorning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get adhkarEvening => $composableBuilder(
    column: $table.adhkarEvening,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get salatDone => $composableBuilder(
    column: $table.salatDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get salatCount => $composableBuilder(
    column: $table.salatCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get thahleelDone => $composableBuilder(
    column: $table.thahleelDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get thahleelCount => $composableBuilder(
    column: $table.thahleelCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isthighfarDone => $composableBuilder(
    column: $table.isthighfarDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isthighfarCount => $composableBuilder(
    column: $table.isthighfarCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PrayerRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $PrayerRecordsTable> {
  $$PrayerRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fajr => $composableBuilder(
    column: $table.fajr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dhuhr => $composableBuilder(
    column: $table.dhuhr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get asr => $composableBuilder(
    column: $table.asr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get maghrib => $composableBuilder(
    column: $table.maghrib,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isha => $composableBuilder(
    column: $table.isha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fajrJamaat => $composableBuilder(
    column: $table.fajrJamaat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dhuhrJamaat => $composableBuilder(
    column: $table.dhuhrJamaat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get asrJamaat => $composableBuilder(
    column: $table.asrJamaat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get maghribJamaat => $composableBuilder(
    column: $table.maghribJamaat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ishaJamaat => $composableBuilder(
    column: $table.ishaJamaat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fajrMosque => $composableBuilder(
    column: $table.fajrMosque,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dhuhrMosque => $composableBuilder(
    column: $table.dhuhrMosque,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get asrMosque => $composableBuilder(
    column: $table.asrMosque,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get maghribMosque => $composableBuilder(
    column: $table.maghribMosque,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ishaMosque => $composableBuilder(
    column: $table.ishaMosque,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get tahajjud => $composableBuilder(
    column: $table.tahajjud,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get duha => $composableBuilder(
    column: $table.duha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get quranWaqiah => $composableBuilder(
    column: $table.quranWaqiah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get quranMulk => $composableBuilder(
    column: $table.quranMulk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quranOtherPages => $composableBuilder(
    column: $table.quranOtherPages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get adhkarMorning => $composableBuilder(
    column: $table.adhkarMorning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get adhkarEvening => $composableBuilder(
    column: $table.adhkarEvening,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get salatDone => $composableBuilder(
    column: $table.salatDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get salatCount => $composableBuilder(
    column: $table.salatCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get thahleelDone => $composableBuilder(
    column: $table.thahleelDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get thahleelCount => $composableBuilder(
    column: $table.thahleelCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isthighfarDone => $composableBuilder(
    column: $table.isthighfarDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isthighfarCount => $composableBuilder(
    column: $table.isthighfarCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrayerRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrayerRecordsTable> {
  $$PrayerRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get fajr =>
      $composableBuilder(column: $table.fajr, builder: (column) => column);

  GeneratedColumn<bool> get dhuhr =>
      $composableBuilder(column: $table.dhuhr, builder: (column) => column);

  GeneratedColumn<bool> get asr =>
      $composableBuilder(column: $table.asr, builder: (column) => column);

  GeneratedColumn<bool> get maghrib =>
      $composableBuilder(column: $table.maghrib, builder: (column) => column);

  GeneratedColumn<bool> get isha =>
      $composableBuilder(column: $table.isha, builder: (column) => column);

  GeneratedColumn<bool> get fajrJamaat => $composableBuilder(
    column: $table.fajrJamaat,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dhuhrJamaat => $composableBuilder(
    column: $table.dhuhrJamaat,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get asrJamaat =>
      $composableBuilder(column: $table.asrJamaat, builder: (column) => column);

  GeneratedColumn<bool> get maghribJamaat => $composableBuilder(
    column: $table.maghribJamaat,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get ishaJamaat => $composableBuilder(
    column: $table.ishaJamaat,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get fajrMosque => $composableBuilder(
    column: $table.fajrMosque,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dhuhrMosque => $composableBuilder(
    column: $table.dhuhrMosque,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get asrMosque =>
      $composableBuilder(column: $table.asrMosque, builder: (column) => column);

  GeneratedColumn<bool> get maghribMosque => $composableBuilder(
    column: $table.maghribMosque,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get ishaMosque => $composableBuilder(
    column: $table.ishaMosque,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get tahajjud =>
      $composableBuilder(column: $table.tahajjud, builder: (column) => column);

  GeneratedColumn<bool> get duha =>
      $composableBuilder(column: $table.duha, builder: (column) => column);

  GeneratedColumn<bool> get quranWaqiah => $composableBuilder(
    column: $table.quranWaqiah,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get quranMulk =>
      $composableBuilder(column: $table.quranMulk, builder: (column) => column);

  GeneratedColumn<int> get quranOtherPages => $composableBuilder(
    column: $table.quranOtherPages,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get adhkarMorning => $composableBuilder(
    column: $table.adhkarMorning,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get adhkarEvening => $composableBuilder(
    column: $table.adhkarEvening,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get salatDone =>
      $composableBuilder(column: $table.salatDone, builder: (column) => column);

  GeneratedColumn<int> get salatCount => $composableBuilder(
    column: $table.salatCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get thahleelDone => $composableBuilder(
    column: $table.thahleelDone,
    builder: (column) => column,
  );

  GeneratedColumn<int> get thahleelCount => $composableBuilder(
    column: $table.thahleelCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isthighfarDone => $composableBuilder(
    column: $table.isthighfarDone,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isthighfarCount => $composableBuilder(
    column: $table.isthighfarCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PrayerRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrayerRecordsTable,
          PrayerRecord,
          $$PrayerRecordsTableFilterComposer,
          $$PrayerRecordsTableOrderingComposer,
          $$PrayerRecordsTableAnnotationComposer,
          $$PrayerRecordsTableCreateCompanionBuilder,
          $$PrayerRecordsTableUpdateCompanionBuilder,
          (
            PrayerRecord,
            BaseReferences<_$AppDatabase, $PrayerRecordsTable, PrayerRecord>,
          ),
          PrayerRecord,
          PrefetchHooks Function()
        > {
  $$PrayerRecordsTableTableManager(_$AppDatabase db, $PrayerRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrayerRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrayerRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrayerRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<bool> fajr = const Value.absent(),
                Value<bool> dhuhr = const Value.absent(),
                Value<bool> asr = const Value.absent(),
                Value<bool> maghrib = const Value.absent(),
                Value<bool> isha = const Value.absent(),
                Value<bool> fajrJamaat = const Value.absent(),
                Value<bool> dhuhrJamaat = const Value.absent(),
                Value<bool> asrJamaat = const Value.absent(),
                Value<bool> maghribJamaat = const Value.absent(),
                Value<bool> ishaJamaat = const Value.absent(),
                Value<bool> fajrMosque = const Value.absent(),
                Value<bool> dhuhrMosque = const Value.absent(),
                Value<bool> asrMosque = const Value.absent(),
                Value<bool> maghribMosque = const Value.absent(),
                Value<bool> ishaMosque = const Value.absent(),
                Value<bool> tahajjud = const Value.absent(),
                Value<bool> duha = const Value.absent(),
                Value<bool> quranWaqiah = const Value.absent(),
                Value<bool> quranMulk = const Value.absent(),
                Value<int> quranOtherPages = const Value.absent(),
                Value<bool> adhkarMorning = const Value.absent(),
                Value<bool> adhkarEvening = const Value.absent(),
                Value<bool> salatDone = const Value.absent(),
                Value<int> salatCount = const Value.absent(),
                Value<bool> thahleelDone = const Value.absent(),
                Value<int> thahleelCount = const Value.absent(),
                Value<bool> isthighfarDone = const Value.absent(),
                Value<int> isthighfarCount = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PrayerRecordsCompanion(
                id: id,
                date: date,
                fajr: fajr,
                dhuhr: dhuhr,
                asr: asr,
                maghrib: maghrib,
                isha: isha,
                fajrJamaat: fajrJamaat,
                dhuhrJamaat: dhuhrJamaat,
                asrJamaat: asrJamaat,
                maghribJamaat: maghribJamaat,
                ishaJamaat: ishaJamaat,
                fajrMosque: fajrMosque,
                dhuhrMosque: dhuhrMosque,
                asrMosque: asrMosque,
                maghribMosque: maghribMosque,
                ishaMosque: ishaMosque,
                tahajjud: tahajjud,
                duha: duha,
                quranWaqiah: quranWaqiah,
                quranMulk: quranMulk,
                quranOtherPages: quranOtherPages,
                adhkarMorning: adhkarMorning,
                adhkarEvening: adhkarEvening,
                salatDone: salatDone,
                salatCount: salatCount,
                thahleelDone: thahleelDone,
                thahleelCount: thahleelCount,
                isthighfarDone: isthighfarDone,
                isthighfarCount: isthighfarCount,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<bool> fajr = const Value.absent(),
                Value<bool> dhuhr = const Value.absent(),
                Value<bool> asr = const Value.absent(),
                Value<bool> maghrib = const Value.absent(),
                Value<bool> isha = const Value.absent(),
                Value<bool> fajrJamaat = const Value.absent(),
                Value<bool> dhuhrJamaat = const Value.absent(),
                Value<bool> asrJamaat = const Value.absent(),
                Value<bool> maghribJamaat = const Value.absent(),
                Value<bool> ishaJamaat = const Value.absent(),
                Value<bool> fajrMosque = const Value.absent(),
                Value<bool> dhuhrMosque = const Value.absent(),
                Value<bool> asrMosque = const Value.absent(),
                Value<bool> maghribMosque = const Value.absent(),
                Value<bool> ishaMosque = const Value.absent(),
                Value<bool> tahajjud = const Value.absent(),
                Value<bool> duha = const Value.absent(),
                Value<bool> quranWaqiah = const Value.absent(),
                Value<bool> quranMulk = const Value.absent(),
                Value<int> quranOtherPages = const Value.absent(),
                Value<bool> adhkarMorning = const Value.absent(),
                Value<bool> adhkarEvening = const Value.absent(),
                Value<bool> salatDone = const Value.absent(),
                Value<int> salatCount = const Value.absent(),
                Value<bool> thahleelDone = const Value.absent(),
                Value<int> thahleelCount = const Value.absent(),
                Value<bool> isthighfarDone = const Value.absent(),
                Value<int> isthighfarCount = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PrayerRecordsCompanion.insert(
                id: id,
                date: date,
                fajr: fajr,
                dhuhr: dhuhr,
                asr: asr,
                maghrib: maghrib,
                isha: isha,
                fajrJamaat: fajrJamaat,
                dhuhrJamaat: dhuhrJamaat,
                asrJamaat: asrJamaat,
                maghribJamaat: maghribJamaat,
                ishaJamaat: ishaJamaat,
                fajrMosque: fajrMosque,
                dhuhrMosque: dhuhrMosque,
                asrMosque: asrMosque,
                maghribMosque: maghribMosque,
                ishaMosque: ishaMosque,
                tahajjud: tahajjud,
                duha: duha,
                quranWaqiah: quranWaqiah,
                quranMulk: quranMulk,
                quranOtherPages: quranOtherPages,
                adhkarMorning: adhkarMorning,
                adhkarEvening: adhkarEvening,
                salatDone: salatDone,
                salatCount: salatCount,
                thahleelDone: thahleelDone,
                thahleelCount: thahleelCount,
                isthighfarDone: isthighfarDone,
                isthighfarCount: isthighfarCount,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PrayerRecordsTable, PrayerRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PrayerRecordsTable,
                    PrayerRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PrayerRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrayerRecordsTable,
      PrayerRecord,
      $$PrayerRecordsTableFilterComposer,
      $$PrayerRecordsTableOrderingComposer,
      $$PrayerRecordsTableAnnotationComposer,
      $$PrayerRecordsTableCreateCompanionBuilder,
      $$PrayerRecordsTableUpdateCompanionBuilder,
      (
        PrayerRecord,
        BaseReferences<_$AppDatabase, $PrayerRecordsTable, PrayerRecord>,
      ),
      PrayerRecord,
      PrefetchHooks Function()
    >;
typedef $$PrayerSettingsTableCreateCompanionBuilder =
    PrayerSettingsCompanion Function({
      Value<int> id,
      Value<String> calculationMethod,
      Value<String> madhab,
      Value<String> manualOffsetsJson,
      Value<bool> useManual,
      Value<bool> notificationsEnabled,
    });
typedef $$PrayerSettingsTableUpdateCompanionBuilder =
    PrayerSettingsCompanion Function({
      Value<int> id,
      Value<String> calculationMethod,
      Value<String> madhab,
      Value<String> manualOffsetsJson,
      Value<bool> useManual,
      Value<bool> notificationsEnabled,
    });

class $$PrayerSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $PrayerSettingsTable> {
  $$PrayerSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calculationMethod => $composableBuilder(
    column: $table.calculationMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get madhab => $composableBuilder(
    column: $table.madhab,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manualOffsetsJson => $composableBuilder(
    column: $table.manualOffsetsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get useManual => $composableBuilder(
    column: $table.useManual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PrayerSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $PrayerSettingsTable> {
  $$PrayerSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calculationMethod => $composableBuilder(
    column: $table.calculationMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get madhab => $composableBuilder(
    column: $table.madhab,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manualOffsetsJson => $composableBuilder(
    column: $table.manualOffsetsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get useManual => $composableBuilder(
    column: $table.useManual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrayerSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrayerSettingsTable> {
  $$PrayerSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get calculationMethod => $composableBuilder(
    column: $table.calculationMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get madhab =>
      $composableBuilder(column: $table.madhab, builder: (column) => column);

  GeneratedColumn<String> get manualOffsetsJson => $composableBuilder(
    column: $table.manualOffsetsJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get useManual =>
      $composableBuilder(column: $table.useManual, builder: (column) => column);

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );
}

class $$PrayerSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrayerSettingsTable,
          PrayerSetting,
          $$PrayerSettingsTableFilterComposer,
          $$PrayerSettingsTableOrderingComposer,
          $$PrayerSettingsTableAnnotationComposer,
          $$PrayerSettingsTableCreateCompanionBuilder,
          $$PrayerSettingsTableUpdateCompanionBuilder,
          (
            PrayerSetting,
            BaseReferences<_$AppDatabase, $PrayerSettingsTable, PrayerSetting>,
          ),
          PrayerSetting,
          PrefetchHooks Function()
        > {
  $$PrayerSettingsTableTableManager(
    _$AppDatabase db,
    $PrayerSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrayerSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrayerSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrayerSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> calculationMethod = const Value.absent(),
                Value<String> madhab = const Value.absent(),
                Value<String> manualOffsetsJson = const Value.absent(),
                Value<bool> useManual = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
              }) => PrayerSettingsCompanion(
                id: id,
                calculationMethod: calculationMethod,
                madhab: madhab,
                manualOffsetsJson: manualOffsetsJson,
                useManual: useManual,
                notificationsEnabled: notificationsEnabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> calculationMethod = const Value.absent(),
                Value<String> madhab = const Value.absent(),
                Value<String> manualOffsetsJson = const Value.absent(),
                Value<bool> useManual = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
              }) => PrayerSettingsCompanion.insert(
                id: id,
                calculationMethod: calculationMethod,
                madhab: madhab,
                manualOffsetsJson: manualOffsetsJson,
                useManual: useManual,
                notificationsEnabled: notificationsEnabled,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PrayerSettingsTable, PrayerSetting>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PrayerSettingsTable,
                    PrayerSetting
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PrayerSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrayerSettingsTable,
      PrayerSetting,
      $$PrayerSettingsTableFilterComposer,
      $$PrayerSettingsTableOrderingComposer,
      $$PrayerSettingsTableAnnotationComposer,
      $$PrayerSettingsTableCreateCompanionBuilder,
      $$PrayerSettingsTableUpdateCompanionBuilder,
      (
        PrayerSetting,
        BaseReferences<_$AppDatabase, $PrayerSettingsTable, PrayerSetting>,
      ),
      PrayerSetting,
      PrefetchHooks Function()
    >;
typedef $$WaterRecordsTableCreateCompanionBuilder =
    WaterRecordsCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<int> cupsConsumed,
      Value<int> cupSizeMl,
      Value<int> goalCups,
      Value<int> wakeTimeMinutes,
      Value<int> sleepTimeMinutes,
    });
typedef $$WaterRecordsTableUpdateCompanionBuilder =
    WaterRecordsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int> cupsConsumed,
      Value<int> cupSizeMl,
      Value<int> goalCups,
      Value<int> wakeTimeMinutes,
      Value<int> sleepTimeMinutes,
    });

class $$WaterRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $WaterRecordsTable> {
  $$WaterRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cupsConsumed => $composableBuilder(
    column: $table.cupsConsumed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cupSizeMl => $composableBuilder(
    column: $table.cupSizeMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goalCups => $composableBuilder(
    column: $table.goalCups,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wakeTimeMinutes => $composableBuilder(
    column: $table.wakeTimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepTimeMinutes => $composableBuilder(
    column: $table.sleepTimeMinutes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WaterRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WaterRecordsTable> {
  $$WaterRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cupsConsumed => $composableBuilder(
    column: $table.cupsConsumed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cupSizeMl => $composableBuilder(
    column: $table.cupSizeMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goalCups => $composableBuilder(
    column: $table.goalCups,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wakeTimeMinutes => $composableBuilder(
    column: $table.wakeTimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepTimeMinutes => $composableBuilder(
    column: $table.sleepTimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WaterRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WaterRecordsTable> {
  $$WaterRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get cupsConsumed => $composableBuilder(
    column: $table.cupsConsumed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cupSizeMl =>
      $composableBuilder(column: $table.cupSizeMl, builder: (column) => column);

  GeneratedColumn<int> get goalCups =>
      $composableBuilder(column: $table.goalCups, builder: (column) => column);

  GeneratedColumn<int> get wakeTimeMinutes => $composableBuilder(
    column: $table.wakeTimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sleepTimeMinutes => $composableBuilder(
    column: $table.sleepTimeMinutes,
    builder: (column) => column,
  );
}

class $$WaterRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WaterRecordsTable,
          WaterRecord,
          $$WaterRecordsTableFilterComposer,
          $$WaterRecordsTableOrderingComposer,
          $$WaterRecordsTableAnnotationComposer,
          $$WaterRecordsTableCreateCompanionBuilder,
          $$WaterRecordsTableUpdateCompanionBuilder,
          (
            WaterRecord,
            BaseReferences<_$AppDatabase, $WaterRecordsTable, WaterRecord>,
          ),
          WaterRecord,
          PrefetchHooks Function()
        > {
  $$WaterRecordsTableTableManager(_$AppDatabase db, $WaterRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WaterRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WaterRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WaterRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> cupsConsumed = const Value.absent(),
                Value<int> cupSizeMl = const Value.absent(),
                Value<int> goalCups = const Value.absent(),
                Value<int> wakeTimeMinutes = const Value.absent(),
                Value<int> sleepTimeMinutes = const Value.absent(),
              }) => WaterRecordsCompanion(
                id: id,
                date: date,
                cupsConsumed: cupsConsumed,
                cupSizeMl: cupSizeMl,
                goalCups: goalCups,
                wakeTimeMinutes: wakeTimeMinutes,
                sleepTimeMinutes: sleepTimeMinutes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<int> cupsConsumed = const Value.absent(),
                Value<int> cupSizeMl = const Value.absent(),
                Value<int> goalCups = const Value.absent(),
                Value<int> wakeTimeMinutes = const Value.absent(),
                Value<int> sleepTimeMinutes = const Value.absent(),
              }) => WaterRecordsCompanion.insert(
                id: id,
                date: date,
                cupsConsumed: cupsConsumed,
                cupSizeMl: cupSizeMl,
                goalCups: goalCups,
                wakeTimeMinutes: wakeTimeMinutes,
                sleepTimeMinutes: sleepTimeMinutes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WaterRecordsTable, WaterRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WaterRecordsTable,
                    WaterRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WaterRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WaterRecordsTable,
      WaterRecord,
      $$WaterRecordsTableFilterComposer,
      $$WaterRecordsTableOrderingComposer,
      $$WaterRecordsTableAnnotationComposer,
      $$WaterRecordsTableCreateCompanionBuilder,
      $$WaterRecordsTableUpdateCompanionBuilder,
      (
        WaterRecord,
        BaseReferences<_$AppDatabase, $WaterRecordsTable, WaterRecord>,
      ),
      WaterRecord,
      PrefetchHooks Function()
    >;
typedef $$PomodoroSessionsTableCreateCompanionBuilder =
    PomodoroSessionsCompanion Function({
      Value<int> id,
      required String mode,
      required int workMinutes,
      required int shortBreakMinutes,
      required int longBreakMinutes,
      Value<int> completedWorkSessions,
      Value<int> totalFocusMinutes,
      required DateTime date,
      Value<DateTime> createdAt,
    });
typedef $$PomodoroSessionsTableUpdateCompanionBuilder =
    PomodoroSessionsCompanion Function({
      Value<int> id,
      Value<String> mode,
      Value<int> workMinutes,
      Value<int> shortBreakMinutes,
      Value<int> longBreakMinutes,
      Value<int> completedWorkSessions,
      Value<int> totalFocusMinutes,
      Value<DateTime> date,
      Value<DateTime> createdAt,
    });

class $$PomodoroSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $PomodoroSessionsTable> {
  $$PomodoroSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get workMinutes => $composableBuilder(
    column: $table.workMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shortBreakMinutes => $composableBuilder(
    column: $table.shortBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longBreakMinutes => $composableBuilder(
    column: $table.longBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedWorkSessions => $composableBuilder(
    column: $table.completedWorkSessions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalFocusMinutes => $composableBuilder(
    column: $table.totalFocusMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PomodoroSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PomodoroSessionsTable> {
  $$PomodoroSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workMinutes => $composableBuilder(
    column: $table.workMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shortBreakMinutes => $composableBuilder(
    column: $table.shortBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longBreakMinutes => $composableBuilder(
    column: $table.longBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedWorkSessions => $composableBuilder(
    column: $table.completedWorkSessions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalFocusMinutes => $composableBuilder(
    column: $table.totalFocusMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PomodoroSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PomodoroSessionsTable> {
  $$PomodoroSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get workMinutes => $composableBuilder(
    column: $table.workMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get shortBreakMinutes => $composableBuilder(
    column: $table.shortBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longBreakMinutes => $composableBuilder(
    column: $table.longBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedWorkSessions => $composableBuilder(
    column: $table.completedWorkSessions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalFocusMinutes => $composableBuilder(
    column: $table.totalFocusMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PomodoroSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PomodoroSessionsTable,
          PomodoroSession,
          $$PomodoroSessionsTableFilterComposer,
          $$PomodoroSessionsTableOrderingComposer,
          $$PomodoroSessionsTableAnnotationComposer,
          $$PomodoroSessionsTableCreateCompanionBuilder,
          $$PomodoroSessionsTableUpdateCompanionBuilder,
          (
            PomodoroSession,
            BaseReferences<
              _$AppDatabase,
              $PomodoroSessionsTable,
              PomodoroSession
            >,
          ),
          PomodoroSession,
          PrefetchHooks Function()
        > {
  $$PomodoroSessionsTableTableManager(
    _$AppDatabase db,
    $PomodoroSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PomodoroSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PomodoroSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PomodoroSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<int> workMinutes = const Value.absent(),
                Value<int> shortBreakMinutes = const Value.absent(),
                Value<int> longBreakMinutes = const Value.absent(),
                Value<int> completedWorkSessions = const Value.absent(),
                Value<int> totalFocusMinutes = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PomodoroSessionsCompanion(
                id: id,
                mode: mode,
                workMinutes: workMinutes,
                shortBreakMinutes: shortBreakMinutes,
                longBreakMinutes: longBreakMinutes,
                completedWorkSessions: completedWorkSessions,
                totalFocusMinutes: totalFocusMinutes,
                date: date,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String mode,
                required int workMinutes,
                required int shortBreakMinutes,
                required int longBreakMinutes,
                Value<int> completedWorkSessions = const Value.absent(),
                Value<int> totalFocusMinutes = const Value.absent(),
                required DateTime date,
                Value<DateTime> createdAt = const Value.absent(),
              }) => PomodoroSessionsCompanion.insert(
                id: id,
                mode: mode,
                workMinutes: workMinutes,
                shortBreakMinutes: shortBreakMinutes,
                longBreakMinutes: longBreakMinutes,
                completedWorkSessions: completedWorkSessions,
                totalFocusMinutes: totalFocusMinutes,
                date: date,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PomodoroSessionsTable, PomodoroSession>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PomodoroSessionsTable,
                    PomodoroSession
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PomodoroSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PomodoroSessionsTable,
      PomodoroSession,
      $$PomodoroSessionsTableFilterComposer,
      $$PomodoroSessionsTableOrderingComposer,
      $$PomodoroSessionsTableAnnotationComposer,
      $$PomodoroSessionsTableCreateCompanionBuilder,
      $$PomodoroSessionsTableUpdateCompanionBuilder,
      (
        PomodoroSession,
        BaseReferences<_$AppDatabase, $PomodoroSessionsTable, PomodoroSession>,
      ),
      PomodoroSession,
      PrefetchHooks Function()
    >;
typedef $$PomodoroPresetsTableCreateCompanionBuilder =
    PomodoroPresetsCompanion Function({
      Value<int> id,
      required String name,
      required int workMinutes,
      required int shortBreakMinutes,
      required int longBreakMinutes,
      Value<bool> isCustom,
    });
typedef $$PomodoroPresetsTableUpdateCompanionBuilder =
    PomodoroPresetsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> workMinutes,
      Value<int> shortBreakMinutes,
      Value<int> longBreakMinutes,
      Value<bool> isCustom,
    });

class $$PomodoroPresetsTableFilterComposer
    extends Composer<_$AppDatabase, $PomodoroPresetsTable> {
  $$PomodoroPresetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get workMinutes => $composableBuilder(
    column: $table.workMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shortBreakMinutes => $composableBuilder(
    column: $table.shortBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longBreakMinutes => $composableBuilder(
    column: $table.longBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PomodoroPresetsTableOrderingComposer
    extends Composer<_$AppDatabase, $PomodoroPresetsTable> {
  $$PomodoroPresetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workMinutes => $composableBuilder(
    column: $table.workMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shortBreakMinutes => $composableBuilder(
    column: $table.shortBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longBreakMinutes => $composableBuilder(
    column: $table.longBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PomodoroPresetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PomodoroPresetsTable> {
  $$PomodoroPresetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get workMinutes => $composableBuilder(
    column: $table.workMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get shortBreakMinutes => $composableBuilder(
    column: $table.shortBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longBreakMinutes => $composableBuilder(
    column: $table.longBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);
}

class $$PomodoroPresetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PomodoroPresetsTable,
          PomodoroPreset,
          $$PomodoroPresetsTableFilterComposer,
          $$PomodoroPresetsTableOrderingComposer,
          $$PomodoroPresetsTableAnnotationComposer,
          $$PomodoroPresetsTableCreateCompanionBuilder,
          $$PomodoroPresetsTableUpdateCompanionBuilder,
          (
            PomodoroPreset,
            BaseReferences<
              _$AppDatabase,
              $PomodoroPresetsTable,
              PomodoroPreset
            >,
          ),
          PomodoroPreset,
          PrefetchHooks Function()
        > {
  $$PomodoroPresetsTableTableManager(
    _$AppDatabase db,
    $PomodoroPresetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PomodoroPresetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PomodoroPresetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PomodoroPresetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> workMinutes = const Value.absent(),
                Value<int> shortBreakMinutes = const Value.absent(),
                Value<int> longBreakMinutes = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
              }) => PomodoroPresetsCompanion(
                id: id,
                name: name,
                workMinutes: workMinutes,
                shortBreakMinutes: shortBreakMinutes,
                longBreakMinutes: longBreakMinutes,
                isCustom: isCustom,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int workMinutes,
                required int shortBreakMinutes,
                required int longBreakMinutes,
                Value<bool> isCustom = const Value.absent(),
              }) => PomodoroPresetsCompanion.insert(
                id: id,
                name: name,
                workMinutes: workMinutes,
                shortBreakMinutes: shortBreakMinutes,
                longBreakMinutes: longBreakMinutes,
                isCustom: isCustom,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PomodoroPresetsTable, PomodoroPreset>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PomodoroPresetsTable,
                    PomodoroPreset
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PomodoroPresetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PomodoroPresetsTable,
      PomodoroPreset,
      $$PomodoroPresetsTableFilterComposer,
      $$PomodoroPresetsTableOrderingComposer,
      $$PomodoroPresetsTableAnnotationComposer,
      $$PomodoroPresetsTableCreateCompanionBuilder,
      $$PomodoroPresetsTableUpdateCompanionBuilder,
      (
        PomodoroPreset,
        BaseReferences<_$AppDatabase, $PomodoroPresetsTable, PomodoroPreset>,
      ),
      PomodoroPreset,
      PrefetchHooks Function()
    >;
typedef $$ScreenTimeRecordsTableCreateCompanionBuilder =
    ScreenTimeRecordsCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<int> totalMinutes,
      Value<int> productiveMinutes,
      Value<int> distractionMinutes,
      Value<int> dailyLimitMinutes,
      Value<String> appUsageJson,
    });
typedef $$ScreenTimeRecordsTableUpdateCompanionBuilder =
    ScreenTimeRecordsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int> totalMinutes,
      Value<int> productiveMinutes,
      Value<int> distractionMinutes,
      Value<int> dailyLimitMinutes,
      Value<String> appUsageJson,
    });

class $$ScreenTimeRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ScreenTimeRecordsTable> {
  $$ScreenTimeRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productiveMinutes => $composableBuilder(
    column: $table.productiveMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get distractionMinutes => $composableBuilder(
    column: $table.distractionMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyLimitMinutes => $composableBuilder(
    column: $table.dailyLimitMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appUsageJson => $composableBuilder(
    column: $table.appUsageJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScreenTimeRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScreenTimeRecordsTable> {
  $$ScreenTimeRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productiveMinutes => $composableBuilder(
    column: $table.productiveMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get distractionMinutes => $composableBuilder(
    column: $table.distractionMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyLimitMinutes => $composableBuilder(
    column: $table.dailyLimitMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appUsageJson => $composableBuilder(
    column: $table.appUsageJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScreenTimeRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScreenTimeRecordsTable> {
  $$ScreenTimeRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get productiveMinutes => $composableBuilder(
    column: $table.productiveMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get distractionMinutes => $composableBuilder(
    column: $table.distractionMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyLimitMinutes => $composableBuilder(
    column: $table.dailyLimitMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appUsageJson => $composableBuilder(
    column: $table.appUsageJson,
    builder: (column) => column,
  );
}

class $$ScreenTimeRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScreenTimeRecordsTable,
          ScreenTimeRecord,
          $$ScreenTimeRecordsTableFilterComposer,
          $$ScreenTimeRecordsTableOrderingComposer,
          $$ScreenTimeRecordsTableAnnotationComposer,
          $$ScreenTimeRecordsTableCreateCompanionBuilder,
          $$ScreenTimeRecordsTableUpdateCompanionBuilder,
          (
            ScreenTimeRecord,
            BaseReferences<
              _$AppDatabase,
              $ScreenTimeRecordsTable,
              ScreenTimeRecord
            >,
          ),
          ScreenTimeRecord,
          PrefetchHooks Function()
        > {
  $$ScreenTimeRecordsTableTableManager(
    _$AppDatabase db,
    $ScreenTimeRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScreenTimeRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScreenTimeRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScreenTimeRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> totalMinutes = const Value.absent(),
                Value<int> productiveMinutes = const Value.absent(),
                Value<int> distractionMinutes = const Value.absent(),
                Value<int> dailyLimitMinutes = const Value.absent(),
                Value<String> appUsageJson = const Value.absent(),
              }) => ScreenTimeRecordsCompanion(
                id: id,
                date: date,
                totalMinutes: totalMinutes,
                productiveMinutes: productiveMinutes,
                distractionMinutes: distractionMinutes,
                dailyLimitMinutes: dailyLimitMinutes,
                appUsageJson: appUsageJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<int> totalMinutes = const Value.absent(),
                Value<int> productiveMinutes = const Value.absent(),
                Value<int> distractionMinutes = const Value.absent(),
                Value<int> dailyLimitMinutes = const Value.absent(),
                Value<String> appUsageJson = const Value.absent(),
              }) => ScreenTimeRecordsCompanion.insert(
                id: id,
                date: date,
                totalMinutes: totalMinutes,
                productiveMinutes: productiveMinutes,
                distractionMinutes: distractionMinutes,
                dailyLimitMinutes: dailyLimitMinutes,
                appUsageJson: appUsageJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ScreenTimeRecordsTable, ScreenTimeRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ScreenTimeRecordsTable,
                    ScreenTimeRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScreenTimeRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScreenTimeRecordsTable,
      ScreenTimeRecord,
      $$ScreenTimeRecordsTableFilterComposer,
      $$ScreenTimeRecordsTableOrderingComposer,
      $$ScreenTimeRecordsTableAnnotationComposer,
      $$ScreenTimeRecordsTableCreateCompanionBuilder,
      $$ScreenTimeRecordsTableUpdateCompanionBuilder,
      (
        ScreenTimeRecord,
        BaseReferences<
          _$AppDatabase,
          $ScreenTimeRecordsTable,
          ScreenTimeRecord
        >,
      ),
      ScreenTimeRecord,
      PrefetchHooks Function()
    >;
typedef $$ScreenTimeAppsTableCreateCompanionBuilder =
    ScreenTimeAppsCompanion Function({
      Value<int> id,
      required String packageName,
      required String appName,
      Value<String> category,
      Value<bool> categoryManual,
      Value<int?> dailyLimitMinutes,
      Value<bool> isBlocked,
    });
typedef $$ScreenTimeAppsTableUpdateCompanionBuilder =
    ScreenTimeAppsCompanion Function({
      Value<int> id,
      Value<String> packageName,
      Value<String> appName,
      Value<String> category,
      Value<bool> categoryManual,
      Value<int?> dailyLimitMinutes,
      Value<bool> isBlocked,
    });

class $$ScreenTimeAppsTableFilterComposer
    extends Composer<_$AppDatabase, $ScreenTimeAppsTable> {
  $$ScreenTimeAppsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appName => $composableBuilder(
    column: $table.appName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get categoryManual => $composableBuilder(
    column: $table.categoryManual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyLimitMinutes => $composableBuilder(
    column: $table.dailyLimitMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBlocked => $composableBuilder(
    column: $table.isBlocked,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScreenTimeAppsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScreenTimeAppsTable> {
  $$ScreenTimeAppsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appName => $composableBuilder(
    column: $table.appName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get categoryManual => $composableBuilder(
    column: $table.categoryManual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyLimitMinutes => $composableBuilder(
    column: $table.dailyLimitMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBlocked => $composableBuilder(
    column: $table.isBlocked,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScreenTimeAppsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScreenTimeAppsTable> {
  $$ScreenTimeAppsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appName =>
      $composableBuilder(column: $table.appName, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get categoryManual => $composableBuilder(
    column: $table.categoryManual,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyLimitMinutes => $composableBuilder(
    column: $table.dailyLimitMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isBlocked =>
      $composableBuilder(column: $table.isBlocked, builder: (column) => column);
}

class $$ScreenTimeAppsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScreenTimeAppsTable,
          ScreenTimeApp,
          $$ScreenTimeAppsTableFilterComposer,
          $$ScreenTimeAppsTableOrderingComposer,
          $$ScreenTimeAppsTableAnnotationComposer,
          $$ScreenTimeAppsTableCreateCompanionBuilder,
          $$ScreenTimeAppsTableUpdateCompanionBuilder,
          (
            ScreenTimeApp,
            BaseReferences<_$AppDatabase, $ScreenTimeAppsTable, ScreenTimeApp>,
          ),
          ScreenTimeApp,
          PrefetchHooks Function()
        > {
  $$ScreenTimeAppsTableTableManager(
    _$AppDatabase db,
    $ScreenTimeAppsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScreenTimeAppsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScreenTimeAppsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScreenTimeAppsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> packageName = const Value.absent(),
                Value<String> appName = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<bool> categoryManual = const Value.absent(),
                Value<int?> dailyLimitMinutes = const Value.absent(),
                Value<bool> isBlocked = const Value.absent(),
              }) => ScreenTimeAppsCompanion(
                id: id,
                packageName: packageName,
                appName: appName,
                category: category,
                categoryManual: categoryManual,
                dailyLimitMinutes: dailyLimitMinutes,
                isBlocked: isBlocked,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String packageName,
                required String appName,
                Value<String> category = const Value.absent(),
                Value<bool> categoryManual = const Value.absent(),
                Value<int?> dailyLimitMinutes = const Value.absent(),
                Value<bool> isBlocked = const Value.absent(),
              }) => ScreenTimeAppsCompanion.insert(
                id: id,
                packageName: packageName,
                appName: appName,
                category: category,
                categoryManual: categoryManual,
                dailyLimitMinutes: dailyLimitMinutes,
                isBlocked: isBlocked,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ScreenTimeAppsTable, ScreenTimeApp>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ScreenTimeAppsTable,
                    ScreenTimeApp
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScreenTimeAppsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScreenTimeAppsTable,
      ScreenTimeApp,
      $$ScreenTimeAppsTableFilterComposer,
      $$ScreenTimeAppsTableOrderingComposer,
      $$ScreenTimeAppsTableAnnotationComposer,
      $$ScreenTimeAppsTableCreateCompanionBuilder,
      $$ScreenTimeAppsTableUpdateCompanionBuilder,
      (
        ScreenTimeApp,
        BaseReferences<_$AppDatabase, $ScreenTimeAppsTable, ScreenTimeApp>,
      ),
      ScreenTimeApp,
      PrefetchHooks Function()
    >;
typedef $$DailyScoresTableCreateCompanionBuilder =
    DailyScoresCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<int> todoScore,
      Value<int> prayerScore,
      Value<int> waterScore,
      Value<int> screenTimeScore,
      Value<int> pomodoroPoints,
      Value<int> totalScore,
      Value<int> streakDays,
    });
typedef $$DailyScoresTableUpdateCompanionBuilder =
    DailyScoresCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int> todoScore,
      Value<int> prayerScore,
      Value<int> waterScore,
      Value<int> screenTimeScore,
      Value<int> pomodoroPoints,
      Value<int> totalScore,
      Value<int> streakDays,
    });

class $$DailyScoresTableFilterComposer
    extends Composer<_$AppDatabase, $DailyScoresTable> {
  $$DailyScoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get todoScore => $composableBuilder(
    column: $table.todoScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prayerScore => $composableBuilder(
    column: $table.prayerScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get waterScore => $composableBuilder(
    column: $table.waterScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get screenTimeScore => $composableBuilder(
    column: $table.screenTimeScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pomodoroPoints => $composableBuilder(
    column: $table.pomodoroPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streakDays => $composableBuilder(
    column: $table.streakDays,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyScoresTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyScoresTable> {
  $$DailyScoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get todoScore => $composableBuilder(
    column: $table.todoScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prayerScore => $composableBuilder(
    column: $table.prayerScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get waterScore => $composableBuilder(
    column: $table.waterScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get screenTimeScore => $composableBuilder(
    column: $table.screenTimeScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pomodoroPoints => $composableBuilder(
    column: $table.pomodoroPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streakDays => $composableBuilder(
    column: $table.streakDays,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyScoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyScoresTable> {
  $$DailyScoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get todoScore =>
      $composableBuilder(column: $table.todoScore, builder: (column) => column);

  GeneratedColumn<int> get prayerScore => $composableBuilder(
    column: $table.prayerScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get waterScore => $composableBuilder(
    column: $table.waterScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get screenTimeScore => $composableBuilder(
    column: $table.screenTimeScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pomodoroPoints => $composableBuilder(
    column: $table.pomodoroPoints,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get streakDays => $composableBuilder(
    column: $table.streakDays,
    builder: (column) => column,
  );
}

class $$DailyScoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyScoresTable,
          DailyScore,
          $$DailyScoresTableFilterComposer,
          $$DailyScoresTableOrderingComposer,
          $$DailyScoresTableAnnotationComposer,
          $$DailyScoresTableCreateCompanionBuilder,
          $$DailyScoresTableUpdateCompanionBuilder,
          (
            DailyScore,
            BaseReferences<_$AppDatabase, $DailyScoresTable, DailyScore>,
          ),
          DailyScore,
          PrefetchHooks Function()
        > {
  $$DailyScoresTableTableManager(_$AppDatabase db, $DailyScoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyScoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyScoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyScoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> todoScore = const Value.absent(),
                Value<int> prayerScore = const Value.absent(),
                Value<int> waterScore = const Value.absent(),
                Value<int> screenTimeScore = const Value.absent(),
                Value<int> pomodoroPoints = const Value.absent(),
                Value<int> totalScore = const Value.absent(),
                Value<int> streakDays = const Value.absent(),
              }) => DailyScoresCompanion(
                id: id,
                date: date,
                todoScore: todoScore,
                prayerScore: prayerScore,
                waterScore: waterScore,
                screenTimeScore: screenTimeScore,
                pomodoroPoints: pomodoroPoints,
                totalScore: totalScore,
                streakDays: streakDays,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<int> todoScore = const Value.absent(),
                Value<int> prayerScore = const Value.absent(),
                Value<int> waterScore = const Value.absent(),
                Value<int> screenTimeScore = const Value.absent(),
                Value<int> pomodoroPoints = const Value.absent(),
                Value<int> totalScore = const Value.absent(),
                Value<int> streakDays = const Value.absent(),
              }) => DailyScoresCompanion.insert(
                id: id,
                date: date,
                todoScore: todoScore,
                prayerScore: prayerScore,
                waterScore: waterScore,
                screenTimeScore: screenTimeScore,
                pomodoroPoints: pomodoroPoints,
                totalScore: totalScore,
                streakDays: streakDays,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyScoresTable, DailyScore>(table),
                  BaseReferences<_$AppDatabase, $DailyScoresTable, DailyScore>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyScoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyScoresTable,
      DailyScore,
      $$DailyScoresTableFilterComposer,
      $$DailyScoresTableOrderingComposer,
      $$DailyScoresTableAnnotationComposer,
      $$DailyScoresTableCreateCompanionBuilder,
      $$DailyScoresTableUpdateCompanionBuilder,
      (
        DailyScore,
        BaseReferences<_$AppDatabase, $DailyScoresTable, DailyScore>,
      ),
      DailyScore,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TodosTableTableManager get todos =>
      $$TodosTableTableManager(_db, _db.todos);
  $$TodoTrashTableTableManager get todoTrash =>
      $$TodoTrashTableTableManager(_db, _db.todoTrash);
  $$PrayerRecordsTableTableManager get prayerRecords =>
      $$PrayerRecordsTableTableManager(_db, _db.prayerRecords);
  $$PrayerSettingsTableTableManager get prayerSettings =>
      $$PrayerSettingsTableTableManager(_db, _db.prayerSettings);
  $$WaterRecordsTableTableManager get waterRecords =>
      $$WaterRecordsTableTableManager(_db, _db.waterRecords);
  $$PomodoroSessionsTableTableManager get pomodoroSessions =>
      $$PomodoroSessionsTableTableManager(_db, _db.pomodoroSessions);
  $$PomodoroPresetsTableTableManager get pomodoroPresets =>
      $$PomodoroPresetsTableTableManager(_db, _db.pomodoroPresets);
  $$ScreenTimeRecordsTableTableManager get screenTimeRecords =>
      $$ScreenTimeRecordsTableTableManager(_db, _db.screenTimeRecords);
  $$ScreenTimeAppsTableTableManager get screenTimeApps =>
      $$ScreenTimeAppsTableTableManager(_db, _db.screenTimeApps);
  $$DailyScoresTableTableManager get dailyScores =>
      $$DailyScoresTableTableManager(_db, _db.dailyScores);
}
