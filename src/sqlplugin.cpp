#include "sqlplugin.h"

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
    qDebug() << "Setting Driver...";
    _driver = value;
}

QString SqlPlugin::hostname() const
{
    qDebug() << "Setting HostName...";
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
    qDebug() << "Connecting...";
    db = new QSqlDatabase(QSqlDatabase::addDatabase(driver()));

    db->setDatabaseName(this->dbName());
    db->setUserName(_username);
    db->setPassword(_password);
    db->setHostName(_hostname);

    _opened = db->open();

    qDebug() << _opened;

    query = new QSqlQuery();
    initDB();
}

QString SqlPlugin::execute(QString queryText)
{
    if(query->exec(queryText)){
        QString g;
        //int count = query->record().keyValues().count();
        QSqlRecord r = query->record();

        while (query->next()) {
              int i = 0;
              QString field;
              //QJsonArray arrayy = QJsonArray::fromVariantList(query->record());
              //qDebug()<< arrayy;
              while (i<r.count()){
                  field+=r.fieldName(i)+"::"+query->value(i).toString()+"[SEP]";
                  i++;
              }
              g+=field+"[__]";
          }
        return g;
    }else {
        return "false";
    }
}

QVariant SqlPlugin::records() const
{
    qDebug()<<_records.count();
    return QVariant::fromValue(_records);
}
