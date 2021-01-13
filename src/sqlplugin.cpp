#include "include/SISql/sqlplugin.h"

SqlPlugin::SqlPlugin(QObject *parent) : QObject(parent)
{

}

QString SqlPlugin::dbName()
{
    return _dbName;
}

void SqlPlugin::setDbName(QString name)
{
    _dbName = name;
}

QString SqlPlugin::driver()
{
    return _driver;
}

void SqlPlugin::setDriver(QString value)
{
    _driver = value;
}

QString SqlPlugin::hostname() const
{
    return _hostname;
}

void SqlPlugin::setHostName(QString host)
{
    _hostname = host;
}

QString SqlPlugin::username() const
{
    return _username;
}

void SqlPlugin::setUsername(QString usernam)
{
    _username = usernam;
}

QString SqlPlugin::password() const
{
    return _password;
}

void SqlPlugin::setPassword(QString pass)
{
   _password = pass;
}

void SqlPlugin::open()
{
    db = new QSqlDatabase(QSqlDatabase::addDatabase(driver()));

    db->setDatabaseName(this->dbName());
    db->setUserName(_username);
    db->setPassword(_password);
    db->setHostName(_hostname);

    _opened = db->open();
    query = new QSqlQuery();
    initDB();
}

QString SqlPlugin::execute(QString queryText)
{
    if(query->exec(queryText)){
        QSqlRecord r = query->record();
        QJsonArray arr;
        QJsonObject obj;
        if(r.count()>0){
            while (query->next()) {
                  int i = 0;
                  QJsonObject item;
                  while (i<r.count()){
                      item.insert(QString(r.fieldName(i)),QJsonValue::fromVariant(query->value(i)));
                      i++;
                  }
                  arr.append(item);
            }
            obj.insert("rows", arr);
        }
        obj.insert("result",true);
        return QJsonDocument(obj).toJson();
    }else {
        QJsonObject obj;
        obj.insert("result",false);
        obj.insert("errorText", query->lastError().text());
        return QJsonDocument(obj).toJson();
    }
}

QVariant SqlPlugin::records() const
{
    return QVariant::fromValue(_records);
}
