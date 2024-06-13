import 'package:isar/isar.dart';

part 'notes.g.dart'; 

@Collection()
class Note{
  Id id = Isar.autoIncrement;
  late String text;
  late String heading;
}

