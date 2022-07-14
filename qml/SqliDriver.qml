import QtQuick
import QSql

SqlDriver {
    function executeSql(commande){
        return new Promise(function(resolve, reject){
            let data = db.execute(commande)
            if(data['status'] === true) {
                let c_datas = {}
                if ("lastInsertId" in data){
                    c_datas['insertId'] = data['lastInsertId']
                }
                if ("datas" in data && data['datas'].length > 0){
                    c_datas['isValid'] = () => true
                    c_datas['rows'] = {"item":
                        function(i) {
                            return data['datas'][i]
                        },
                        "length": data['datas'].length
                    }
                    c_datas['datas'] = data['datas']
                } else {
                    c_datas['isValid'] = () => false
                }

                c_datas['query'] = true
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
