// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thing.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetThingCollection on Isar {
  IsarCollection<Thing> get things => this.collection();
}

const ThingSchema = CollectionSchema(
  name: r'Thing',
  id: -3725463572457949598,
  properties: {
    r'average': PropertySchema(
      id: 0,
      name: r'average',
      type: IsarType.double,
    ),
    r'colorValue': PropertySchema(
      id: 1,
      name: r'colorValue',
      type: IsarType.long,
    ),
    r'lastTimeRated': PropertySchema(
      id: 2,
      name: r'lastTimeRated',
      type: IsarType.dateTime,
    ),
    r'maxRating': PropertySchema(
      id: 3,
      name: r'maxRating',
      type: IsarType.double,
    ),
    r'minRating': PropertySchema(
      id: 4,
      name: r'minRating',
      type: IsarType.double,
    ),
    r'notificationFrequency': PropertySchema(
      id: 5,
      name: r'notificationFrequency',
      type: IsarType.byte,
      enumMap: _ThingnotificationFrequencyEnumValueMap,
    ),
    r'notifications': PropertySchema(
      id: 6,
      name: r'notifications',
      type: IsarType.bool,
    ),
    r'title': PropertySchema(
      id: 7,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _thingEstimateSize,
  serialize: _thingSerialize,
  deserialize: _thingDeserialize,
  deserializeProp: _thingDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _thingGetId,
  getLinks: _thingGetLinks,
  attach: _thingAttach,
  version: '3.1.0+1',
);

int _thingEstimateSize(
  Thing object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _thingSerialize(
  Thing object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.average);
  writer.writeLong(offsets[1], object.colorValue);
  writer.writeDateTime(offsets[2], object.lastTimeRated);
  writer.writeDouble(offsets[3], object.maxRating);
  writer.writeDouble(offsets[4], object.minRating);
  writer.writeByte(offsets[5], object.notificationFrequency.index);
  writer.writeBool(offsets[6], object.notifications);
  writer.writeString(offsets[7], object.title);
}

Thing _thingDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Thing(
    reader.readString(offsets[7]),
    average: reader.readDoubleOrNull(offsets[0]),
    colorValue: reader.readLong(offsets[1]),
    lastTimeRated: reader.readDateTimeOrNull(offsets[2]),
    maxRating: reader.readDoubleOrNull(offsets[3]) ?? 10,
    minRating: reader.readDoubleOrNull(offsets[4]) ?? 0,
    notificationFrequency: _ThingnotificationFrequencyValueEnumMap[
            reader.readByteOrNull(offsets[5])] ??
        KFrequency.daily,
    notifications: reader.readBoolOrNull(offsets[6]) ?? false,
  );
  object.id = id;
  return object;
}

P _thingDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset) ?? 10) as P;
    case 4:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 5:
      return (_ThingnotificationFrequencyValueEnumMap[
              reader.readByteOrNull(offset)] ??
          KFrequency.daily) as P;
    case 6:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ThingnotificationFrequencyEnumValueMap = {
  'daily': 0,
  'yearly': 1,
  'weekly': 2,
  'monthly': 3,
};
const _ThingnotificationFrequencyValueEnumMap = {
  0: KFrequency.daily,
  1: KFrequency.yearly,
  2: KFrequency.weekly,
  3: KFrequency.monthly,
};

Id _thingGetId(Thing object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _thingGetLinks(Thing object) {
  return [];
}

void _thingAttach(IsarCollection<dynamic> col, Id id, Thing object) {
  object.id = id;
}

extension ThingQueryWhereSort on QueryBuilder<Thing, Thing, QWhere> {
  QueryBuilder<Thing, Thing, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ThingQueryWhere on QueryBuilder<Thing, Thing, QWhereClause> {
  QueryBuilder<Thing, Thing, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Thing, Thing, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Thing, Thing, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Thing, Thing, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ThingQueryFilter on QueryBuilder<Thing, Thing, QFilterCondition> {
  QueryBuilder<Thing, Thing, QAfterFilterCondition> averageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'average',
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> averageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'average',
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> averageEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'average',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> averageGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'average',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> averageLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'average',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> averageBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'average',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> colorValueEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> colorValueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> colorValueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> colorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colorValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> lastTimeRatedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastTimeRated',
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> lastTimeRatedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastTimeRated',
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> lastTimeRatedEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastTimeRated',
        value: value,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> lastTimeRatedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastTimeRated',
        value: value,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> lastTimeRatedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastTimeRated',
        value: value,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> lastTimeRatedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastTimeRated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> maxRatingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> maxRatingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> maxRatingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> maxRatingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxRating',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> minRatingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'minRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> minRatingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'minRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> minRatingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'minRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> minRatingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'minRating',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition>
      notificationFrequencyEqualTo(KFrequency value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notificationFrequency',
        value: value,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition>
      notificationFrequencyGreaterThan(
    KFrequency value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notificationFrequency',
        value: value,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition>
      notificationFrequencyLessThan(
    KFrequency value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notificationFrequency',
        value: value,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition>
      notificationFrequencyBetween(
    KFrequency lower,
    KFrequency upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notificationFrequency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> notificationsEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notifications',
        value: value,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> titleContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> titleMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Thing, Thing, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension ThingQueryObject on QueryBuilder<Thing, Thing, QFilterCondition> {}

extension ThingQueryLinks on QueryBuilder<Thing, Thing, QFilterCondition> {}

extension ThingQuerySortBy on QueryBuilder<Thing, Thing, QSortBy> {
  QueryBuilder<Thing, Thing, QAfterSortBy> sortByAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'average', Sort.asc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> sortByAverageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'average', Sort.desc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> sortByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.asc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> sortByColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.desc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> sortByLastTimeRated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTimeRated', Sort.asc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> sortByLastTimeRatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTimeRated', Sort.desc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> sortByMaxRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxRating', Sort.asc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> sortByMaxRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxRating', Sort.desc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> sortByMinRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minRating', Sort.asc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> sortByMinRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minRating', Sort.desc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> sortByNotificationFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationFrequency', Sort.asc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> sortByNotificationFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationFrequency', Sort.desc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> sortByNotifications() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifications', Sort.asc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> sortByNotificationsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifications', Sort.desc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension ThingQuerySortThenBy on QueryBuilder<Thing, Thing, QSortThenBy> {
  QueryBuilder<Thing, Thing, QAfterSortBy> thenByAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'average', Sort.asc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> thenByAverageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'average', Sort.desc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> thenByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.asc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> thenByColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.desc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> thenByLastTimeRated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTimeRated', Sort.asc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> thenByLastTimeRatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTimeRated', Sort.desc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> thenByMaxRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxRating', Sort.asc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> thenByMaxRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxRating', Sort.desc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> thenByMinRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minRating', Sort.asc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> thenByMinRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minRating', Sort.desc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> thenByNotificationFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationFrequency', Sort.asc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> thenByNotificationFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationFrequency', Sort.desc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> thenByNotifications() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifications', Sort.asc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> thenByNotificationsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifications', Sort.desc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Thing, Thing, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension ThingQueryWhereDistinct on QueryBuilder<Thing, Thing, QDistinct> {
  QueryBuilder<Thing, Thing, QDistinct> distinctByAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'average');
    });
  }

  QueryBuilder<Thing, Thing, QDistinct> distinctByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorValue');
    });
  }

  QueryBuilder<Thing, Thing, QDistinct> distinctByLastTimeRated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastTimeRated');
    });
  }

  QueryBuilder<Thing, Thing, QDistinct> distinctByMaxRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxRating');
    });
  }

  QueryBuilder<Thing, Thing, QDistinct> distinctByMinRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minRating');
    });
  }

  QueryBuilder<Thing, Thing, QDistinct> distinctByNotificationFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notificationFrequency');
    });
  }

  QueryBuilder<Thing, Thing, QDistinct> distinctByNotifications() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notifications');
    });
  }

  QueryBuilder<Thing, Thing, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension ThingQueryProperty on QueryBuilder<Thing, Thing, QQueryProperty> {
  QueryBuilder<Thing, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Thing, double?, QQueryOperations> averageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'average');
    });
  }

  QueryBuilder<Thing, int, QQueryOperations> colorValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorValue');
    });
  }

  QueryBuilder<Thing, DateTime?, QQueryOperations> lastTimeRatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastTimeRated');
    });
  }

  QueryBuilder<Thing, double, QQueryOperations> maxRatingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxRating');
    });
  }

  QueryBuilder<Thing, double, QQueryOperations> minRatingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minRating');
    });
  }

  QueryBuilder<Thing, KFrequency, QQueryOperations>
      notificationFrequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notificationFrequency');
    });
  }

  QueryBuilder<Thing, bool, QQueryOperations> notificationsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notifications');
    });
  }

  QueryBuilder<Thing, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
