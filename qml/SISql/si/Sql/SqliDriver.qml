import QtQuick 2.13
import QtQuick.Controls 2.13

import QtQuick.Controls.impl 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12
import QtMultimedia 5.12

import si.Sql 1.0

SqlDriver {
    function register(name,value){
        Object.defineProperty(db,name,{value:value})
    }

    function executeSql(commande){
        var c = JSON.parse(db.execute(commande))
        return c
    }

    function transaction(callback){
        callback(db)
    }
    id: db
    dbName: ":memory:"
    driver: "QMYSQL"
}
