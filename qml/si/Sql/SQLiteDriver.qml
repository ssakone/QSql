import QtQuick 2.0

SqliDriver {
    signal databaseReady(var d)
    property alias db:database
    id: database
    driver: "QSQLITE"
    onDatabaseOpened: {
        databaseReady(db)
    }
    Component.onCompleted: open()



}

