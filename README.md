# SISql

Configuration 
 - include($$PWD/SISql/SISql.pri) in your project file .pro

in your main cpp add this 
 - engine.addImportPath("qrc:/qml/");

Basic example

    import QtQuick 2.0
    import si.Sql 1.0
  
    Item {
        id: rootItem
        
        SQLiteDriver {
            id: sql
            dbName: "MyDB"
            onDatabaseReady:  {
                sql.execute("CREATE TABLE IF NOT EXISTS personne (id integer PRIMARY KEY, name TEXT)")
                sql.execute("insert into personne(name) values('Cheick sakone')")
                datas = sql.executeSql("select * from personne")
                console.log(JSON.stringify(test.rows))
            }
        }

    }

# Features

- Sqlite
- Mysql

# TO DO

- PostgreSql
- LocalStorage
etc..
