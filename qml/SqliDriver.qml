pragma Singleton
import QtQuick
import QSql

SqlDriver {
    function executeSql(commande){
        return new Promise(function(resolve, reject){
            let data = db.execute(commande)
            if(data['status']) {
                let c_datas = {}
                if ("lastInsertId" in data){
                    c_datas['lastInsertId'] = data['lastInsertId']
                }
                if ("datas" in data && data['datas'].length > 0){
                    c_datas['rows'] = {"item":
                        function(i) {
                            return data['datas'][i]
                        },
                        "length": data['datas'].length
                    }
                }
                resolve(c_datas)
            } else {
                reject({"error":data.errorText})
            }
        })
    }

    function transaction(callback){
        callback(db)
    }
    id: db
    dbName: ":memory:"
    driver: "QSQLITE"
}
