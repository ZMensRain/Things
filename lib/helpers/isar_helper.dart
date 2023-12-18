import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rate_a_thing/models/rating.dart';
import 'package:rate_a_thing/models/thing.dart';

Future<Isar> open() async {
  var path = (await getApplicationDocumentsDirectory()).path;

  Isar isar = Isar.getInstance() ??
      Isar.openSync(
        [RatingSchema, ThingSchema],
        directory: path,
      );
  return isar;
}

Future<void> updateStas(Thing thing) async {
  var isar = await open();

  var ratings = await isar.ratings.filter().thingIdEqualTo(thing.id).findAll();

  var average = ratings.isEmpty
      ? null
      : double.parse((ratings.fold(
                0.0,
                (previousValue, element) => previousValue + element.value,
              ) /
              ratings.length)
          .toStringAsFixed(1));

  ratings.sort(
    (a, b) => a.time.compareTo(b.time),
  );

  await isar.writeTxn(
    () => isar.things.put(
      thing.copyWith(
        average: average,
        lastTimeRated: ratings.isEmpty ? null : ratings.last.time,
      ),
    ),
  );
}
