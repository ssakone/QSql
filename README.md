# SISql


* Configuration QMAKE
 - include($$PWD/SISql/SISql.pri) in your project file .pro

in your main cpp add this 
 - engine.addImportPath("qrc:/qml/");

* Configuration CMake
 - add_subdirectory(SISql) in your project file CMakeFiles.txt
 - target_link_libraries(... SISql)
 in main cpp
 - Q_INIT_RESOURCE(SISql);
 - #include <SISql/include/SISql/sqlplugin.h>
 - qmlRegisterType<SqlPlugin>("si.Sql",1,0,"SqlDriver"); // insert it after engine declaration
 - engine.addImportPath("qrc:/SISql/"); // insert it after engine declaration

in your main cpp add this 
 - engine.addImportPath("qrc:/qml/");
Basic example SQL

    import QtQuick 2.0
    import si.Sql 1.0
    Item {
        id: rootItem
        
        SISQLiteDriver {
            id: sql
            dbName: "MyDB"
            
            onDatabaseReady:  {
                sql.executeSql("CREATE TABLE IF NOT EXISTS personne (id integer PRIMARY KEY, name TEXT)")
                let r = sql.executeSql("insert into personne(name) values('Cheick sakone')")
                if(r.result) {
                    Console.log("Inserted")
                }
                let datas = sql.executeSql("select * from personne")
                console.log(JSON.stringify(datas))
            }
        }

    }
Basic example MySql
    
    import QtQuick 2.0
    import si.Sql 1.0
    Item {
        id: rootItem

        SIMYSQLDriver {
            id: sql
            dbName: "testDatabase"
            username: "root"
            password: ""
            hostname: "127.0.0.1"
            onDatabaseReady: {
                 sql.executeSql("CREATE TABLE IF NOT EXISTS personne (id INT AUTO_INCREMENT PRIMARY KEY, name TEXT)")
                 sql.executeSql("insert into personne(name) values('Cheick sakone')")
                 let datas = sql.executeSql("select * from personne")
                 console.log(JSON.stringify(datas))
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
