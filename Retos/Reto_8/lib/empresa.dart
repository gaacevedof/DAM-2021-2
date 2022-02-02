import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class Empresa {
  String nombre;
  String email;
  String url;
  String productos;
  int telefono;
  List <bool>categoria;

  Empresa({
    required this.nombre,
    required this.telefono,
    required this.email,
    required this.url,
    required this.productos,
    required this.categoria
  });

  Map<String, dynamic> toMap(){
    return {
      'nombre': nombre,
      'telefono': telefono,
      'email': email,
      'url': url,
      'productos': productos,
      'c':  categoria[0] ? 1:0,
      'dm': categoria[1] ? 1:0,
      'fs': categoria[2] ? 1:0,
    };
  }

  factory Empresa.fromMap(Map<String,dynamic> map){
    return Empresa(
        nombre: map["nombre"],
        telefono: map["telefono"],
        email: map["email"],
        url: map["url"],
        productos: map["productos"],
        categoria: [map["c"] == 1, map["dm"] == 1, map["fs"] == 1]
    );
  }
}

class DB {

  DB._init();

  static final DB instance = DB._init();

  static Database? db;

  Future<Database> get database async => db ??= await open();

  Future <Database> open() async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, "empress.db");
    return await openDatabase(path, version: 1, onCreate: createDB);
  }

  Future createDB(Database db, int version) async {
    db.execute('CREATE TABLE empress('
        'nombre TEXT PRIMARY KEY, telefono INTEGER, email TEXT, url TEXT,'
        'productos TEXT, c BOOLEAN, dm BOOLEAN, fs BOOLEAN)');
  }

  Future create(Empresa e) async {
    Database db = await instance.database;
    var a = await db.insert("empress", e.toMap());
  }

  Future<List<Empresa>> retrieve_limit(String nombre) async {
    Database db = await instance.database;

    var empresas = await db.query("empress",where: "nombre LIKE ?", whereArgs: ['%$nombre%']);
    List<Empresa> map = empresas.isNotEmpty ?
    empresas.map((e) => Empresa.fromMap(e)).toList() : [];
    return map;
  }

  Future<List<Empresa>> retrieve() async {
    Database db = await instance.database;

    var empresas = await db.query("empress");
    List<Empresa> map = empresas.isNotEmpty ?
    empresas.map((e) => Empresa.fromMap(e)).toList() : [];
    return map;
  }

  Future update(Empresa e) async {
    Database db = await instance.database;
    await db.update(
        "empress", e.toMap(), where: "nombre = ?", whereArgs: [e.nombre]);
  }

  Future delete(String nombre) async {
    Database db = await instance.database;
    await db.delete("empress", where: "nombre = ?", whereArgs: [nombre]);
  }

  Future close() async {
    Database db = await instance.database;
    db.close();
  }
}