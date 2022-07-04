import QtQuick 2.15
import QtQuick.LocalStorage 2.15
import si.Sql 1.0

Item {
    id: control
    property string dBName: "DB"
    property string dBVersion: "1.0"
    property alias db: tx
    property string table: ""
    property string initialQuery
    property bool initialize: true
    property var column
    property int selectCount: 1000
    property int currentPage: 0
    property alias model: _model
    SISQLiteDriver {
        id: tx
        dbName: control.dBName
    }
    ListModel {
        id:_model


        signal fetched()
        Component.onCompleted: {
            if(control.initialize){
                __init()
            }
            fetch()
        }
        
    }
    function create(data, callback){
        var col = []
        var dat = []
        for(var i in data){col.push(i)}
        for(i in data){dat.push(data[i])}
        var len = col.length
        col = col.join(',')
        var completer = " ?,".repeat(len).slice(0, -1)
        var rs = tx.executeSql('INSERT INTO '+control.table+'('+col+') VALUES('+completer+')',dat);
        data['id'] = parseInt(rs.insertId)
        model.append(data)
        callback(rs)
    }
    function update(id, data, callback) {
        let datas = "";
        let c = ""
        for (var i in data) {
            if(typeof(data[i])==="string"){
                c = i+" = '"+data[i]+"',"
            }else {
                c = i+" = "+data[i]+","
            }
            datas+=c
        }
        datas = datas.slice(0, -1)
        let datae = "UPDATE "+control.table+" SET "+datas+" WHERE id = "+id
        let rs = tx.executeSql(datae);
        callback(rs)
    }
    function removeById(id, callback) {
        let rs = tx.executeSql('DELETE FROM '+control.table+' WHERE id= '+value);
        callback(rs)
    }
    function removeByQuery(name, value,callback){
        let rs;
        if(typeof(value)==="string"){
            console.log('DELETE FROM '+control.table+' WHERE '+name+" = '"+value+"'")
            rs = tx.executeSql('DELETE FROM '+control.table+' WHERE '+name+" = '"+value+"'");
        }else {
            rs = tx.executeSql('DELETE FROM '+control.table+' WHERE '+name+' = '+value);
        }
        callback()
    }

    function removeByIndex(index,callback) {
        let rs = tx.executeSql('DELETE FROM '+control.table+' WHERE id = '+control.get(index).id);
        model.remove(index)
        callback()
    }
    function __init(){
        console.log("INITING")
        let initialQuery = ""
        for(let i in control.column){
            let col = control.column[i]
            let cq = ""
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
        let rs =    tx.executeSql(endQuery);
        return rs.result
    }
    function fetchAll(callback){
        model.clear()
        let rs = tx.executeSql('SELECT * FROM '+control.table);
        let r = ""
        let cpt = 0
        for (var i = 0; i < rs.rows.length; i++) {
            dt.push(rs.rows.item(i))
        }
        fetched()
    }
    function fetch(callback){
        model.clear()
        let rs = tx.executeSql('SELECT * FROM '+control.table+' LIMIT '+control.currentPage+','+control.selectCount);
        let r = ""
        let cpt = 0
        for (let i = 0; i < rs.rows.length; i++) {
            model.append(rs.rows.item(i))
        }
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
