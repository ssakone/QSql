import QtQuick 2.15
import QtQuick.LocalStorage 2.15

ListModel {
    id: control
    property string dBName: "DB"
    property string dBVersion: "1.0"
    property var db: LocalStorage.openDatabaseSync(control.dBName, control.dBVersion)
    property string table: ""
    property string initialQuery
    property bool initialize: true
    property var column
    property int selectCount: 1000
    property int currentPage: 0
    signal fetched()
    Component.onCompleted: {
        if(control.initialize){
            __init()
        }
        fetch()
    }
    function create(data, callback){
        var col = []
        var dat = []
        for(var i in data){col.push(i)}
        for(i in data){dat.push(data[i])}
        var len = col.length
        col = col.join(',')
        var completer = " ?,".repeat(len).slice(0, -1)
        control.db.transaction(
            function(tx) {
                var rs = tx.executeSql('INSERT INTO '+control.table+'('+col+') VALUES('+completer+')',dat);
                data['id'] = parseInt(rs.insertId)
                control.append(data)
                callback(rs)
            }
        )
    }
    function update(id, data, callback) {
        control.db.transaction(
            function(tx) {
                var datas = "";
                var c = ""
                for (var i in data) {
                    if(typeof(data[i])==="string"){
                        c = i+" = '"+data[i]+"',"
                    }else {
                        c = i+" = "+data[i]+","
                    }
                    datas+=c
                }
                datas = datas.slice(0, -1)
                var datae = "UPDATE "+control.table+" SET "+datas+" WHERE id = "+id
                var rs = tx.executeSql(datae);
                callback()
            }
        )
    }
    function removeById(id, callback) {
        control.db.transaction(
            function(tx) {
                var rs;
                rs = tx.executeSql('DELETE FROM '+control.table+' WHERE id= '+value);
                callback()
            }
        )
    }
    function removeByQuery(name, value,callback){
        control.db.transaction(
            function(tx) {
                var rs;
                if(typeof(value)==="string"){
                    console.log('DELETE FROM '+control.table+' WHERE '+name+" = '"+value+"'")
                    rs = tx.executeSql('DELETE FROM '+control.table+' WHERE '+name+" = '"+value+"'");
                }else {
                    rs = tx.executeSql('DELETE FROM '+control.table+' WHERE '+name+' = '+value);
                }
                callback()
            }
        )
    }

    function removeByIndex(index,callback) {
        control.db.transaction(
            function(tx) {
                var rs = tx.executeSql('DELETE FROM '+control.table+' WHERE id = '+control.get(index).id);
                control.remove(index)
                callback()
            }
        )
    }
    function __init(){
        control.db.transaction(
            function(tx) {
                console.log("INITING")
                var initialQuery = ""
                for(var i in control.column){
                    var col = control.column[i]
                    var cq = ""
                    cq+= col.name+" "+col.type+" "
                    if("key" in col){
                        cq+= col.key+" "
                    }
                    if("def" in col) {
                        if(col.type!=="INTEGER"){
                            cq+= "DEFAULT '"+col.def+"'"
                        }else {
                            cq+= "DEFAULT "+col.def
                        }
                    }
                    initialQuery+=cq+","
                }
                initialQuery = initialQuery.slice(0,-1)
                var endQuery = 'CREATE TABLE IF NOT EXISTS '+control.table+"("+initialQuery+")"
                console.log(endQuery)
                var rs = tx.executeSql(endQuery);
            }
        )
    }
    function fetchAll(callback){
        clear()
        var p = new Promise((resolve, reject) => {
            db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM '+control.table);
                    var r = ""
                    var cpt = 0
                    for (var i = 0; i < rs.rows.length; i++) {
                        dt.push(rs.rows.item(i))
                    }
                }
            )
        })
        fetched()
    }
    function fetch(callback){
        clear()
        var p = new Promise((resolve, reject) => {
            db.transaction(
                function(tx) {
                    console.log('SELECT * FROM '+control.table+' LIMIT '+control.currentPage+','+parseInt(control.selectCount))
                    var rs = tx.executeSql('SELECT * FROM '+control.table+' LIMIT '+control.currentPage+','+control.selectCount);
                    var r = ""
                    var cpt = 0
                    for (var i = 0; i < rs.rows.length; i++) {
                        control.append(rs.rows.item(i))
                    }
                }
            )
        })
        fetched()
    }
    function fetchMore(){
        control.currentPage = control.currentPage+control.selectCount
        fetch()
    }
    function fetchLess(){
        control.currentPage = control.currentPage-control.selectCount
        fetch()
    }
}
