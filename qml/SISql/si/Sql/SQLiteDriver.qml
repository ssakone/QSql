import QtQuick 2.0
import si.Sql 1.0

SISqliDriver {
    signal databaseReady(var d)
    property alias db:database
    id: database
    driver: "QSQLITE"
    onDatabaseOpened: {
        databaseReady(db)
    }
    Component.onCompleted: open()



}

