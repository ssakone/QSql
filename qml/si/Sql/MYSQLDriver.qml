import QtQuick 2.0

SqliDriver {
    signal databaseReady(var d)
    property alias db:database
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

