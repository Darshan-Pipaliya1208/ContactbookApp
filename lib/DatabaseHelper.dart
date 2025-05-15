import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  Future<Database> getDatabase() async {
    // open the database
    Database database = await openDatabase('my_db.db', version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      String userTableQuery =
          'CREATE TABLE User (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT, email TEXT, password TEXT)';
      String contactData =
          'CREATE TABLE UserContact (ContactId INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT, Contact TEXT, Email TEXT,Userid integer)';
      await db.execute(contactData);
      await db.execute(userTableQuery);
    });
    return database;
  }

  Future<void> insert(
    String name,
    String phone,
    String email,
    String password,
  ) async {
    String query =
        "insert into User (name,phone,email,password) values ('$name','$phone','$email','$password')";
    Database db = await getDatabase();
    await db.execute(query);
  }

  ifExists(String email, String password) async {
    String query =
        "select * from User where email = '$email' and password = '$password'";
    Database db = await getDatabase();
    List<Map> list = await db.rawQuery(query);
    print(list);
    return list.length > 0;
  }

  Future<List<Map>> LoginUser(String uname, String password) async {
    print("=====$uname");
    print("=====$password");

    String logindata =
        "select * from User where email='$uname' and password = '$password'";
    Database db = await getDatabase();
    List<Map> data = await db.rawQuery(logindata);

    print("====Ye${data}");
    return data;
  }

  Future<List<Map>> getAllUser() async {
    String logindata = "select * from User";
    Database db = await getDatabase();
    List<Map> data =
        await db.rawQuery(logindata); // rawQuery -> It is get your data
    print("========Ye${data}");
    return data;
  }

  Future<int> deleteData(int id) async {
    String query = "delete from User where id = $id";
    Database db = await getDatabase();
    int data = await db.rawDelete(query);
    return data;
  }

  Future<int> UpdateContactData(
      int id, String uname, String phone, String email) async {
    String query2 =
        "UPDATE UserContact SET Name = '$uname',Contact = '$phone',Email = '$email'  WHERE ContactId = '$id'  ";
    Database db = await getDatabase();
    int data2 = await db.rawUpdate(query2);
    return data2;
  }

  Future<void> InsertContact(
      int uid, String name, String phone, String email) async {
    Database db = await getDatabase();
    String insertcontact =
        "insert into UserContact (Name,Email,Userid,Contact) values('$name','$email','$uid','$phone')";
    db.rawInsert(insertcontact);
  }

  Future<List<Map>> ShowContact(int uid) async {
    String showcontact = "select * from UserContact where Userid = '$uid'";
    Database db = await getDatabase();
    List<Map> data2 =
        await db.rawQuery(showcontact); // rawQuery -> It is get your data
    print("========Ye${data2}");
    return data2;
  }

  Future<int> deleteContactData(int ContactId) async {
    String query2 = "delete from UserContact where ContactId = '$ContactId' ";
    Database db = await getDatabase();
    int data2 = await db.rawDelete(query2);
    return data2;
  }

}
