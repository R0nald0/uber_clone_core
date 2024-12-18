import 'package:sqflite/sqflite.dart';

abstract class Migrations {
   void create(Batch batch);
    void upgrade(Batch batch);
}