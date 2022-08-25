import QtQuick 2.0
import si.Sql 1.0

SqliDriver {
    signal databaseReady(var db)
    property alias db: database
    id: database
    driver: "QMYSQL"
    username: "root"
    password: ""
    dbName: "test"
    onDatabaseOpened: {
        databaseReady(database)
    }
    Component.onCompleted: open()
}

