import QtQuick 2.13
import QtQuick.Controls 2.13

import QtQuick.Controls.impl 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12
import QtMultimedia 5.12

import SqlDriver 1.0

SqlDriver {
    function register(name,value){
        Object.defineProperty(db,name,{value:value})
    }

    function executeSql(commande){
        var c = db.execute(commande)
        if(c!=="false"){
            c = c.toString().split("[__]")
            c.pop(c.length)
            var data=[]
            c.forEach(function(e){
                var i = {}
                e = e.split("[SEP]")
                e.pop(e.length)
                e.forEach(function(a){
                    a = a.split("::")
                    i[a[0]]=a[1]
                })
                data.push(i)
            })
            function G(d){
                this.rows =d
            }
            G.prototype = {
                item: function(i) {
                    return this.rows[i];
                }
            }
            return new G(data)
        }
        else{
            function G(d){
                this.rows = d
            }
            G.prototype = {
                item: function(i) {
                    return this.rows[i];
                }
            }
            return new G([])
        }
    }

    function transaction(callback){
        callback(db)
    }
    id: db
    dbName: ":memory:"
    driver: "QMYSQL"
}
