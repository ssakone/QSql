#include "sqlplugin.h"

SqlPlugin::SqlPlugin(QObject *parent) : QObject(parent) {}

QString SqlPlugin::dbName() { return _dbName; }

void SqlPlugin::setDbName(QString name) { _dbName = name; }

QString SqlPlugin::driver() { return _driver; }

void SqlPlugin::setDriver(QString value) { _driver = value; }

QString SqlPlugin::hostname() const { return _hostname; }

void SqlPlugin::setHostName(QString host) { _hostname = host; }

QString SqlPlugin::username() const { return _username; }

void SqlPlugin::setUsername(QString usernam) { _username = usernam; }

QString SqlPlugin::password() const { return _password; }

void SqlPlugin::setPassword(QString pass) { _password = pass; }

void SqlPlugin::close()
{
    db->close();
}

void SqlPlugin::open() {
  db = new QSqlDatabase(QSqlDatabase::addDatabase(driver()));

  db->setDatabaseName(this->dbName());
  db->setUserName(_username);
  db->setPassword(_password);
  db->setHostName(_hostname);

  _opened = db->open();
  if (_opened) {
    emit databaseOpened();
  } else {
    qDebug() << "not open" << driver();
  }

  query = new QSqlQuery();
  initDB();
}

QMap<QString, QVariant> SqlPlugin::execute(QString queryText) {
  if (query->exec(queryText)) {
    QSqlRecord r = query->record();
    QList<QVariant> arr;
    QMap<QString, QVariant> obj;
    if (r.count() > 0) {
      while (query->next()) {
        QMap<QString, QVariant> item;
        for (int i = 0; i < r.count(); i++) {
          item[QString(r.fieldName(i))] = query->value(i);
        }
        arr.append(item);
      }
      obj.insert("datas", arr);
    }

    QVariant last = query->lastInsertId();

    if (last.isValid()) {
      obj.insert("lastInsertId", last);
    }

    obj.insert("status", true);
    return obj;
  } else {
    QMap<QString, QVariant> obj;
    obj.insert("status", false);
    obj.insert("errorText", query->lastError().text());
    QList<QVariant> l;
    l.append(QVariant());
    return obj;
  }
}

QVariant SqlPlugin::records() const { return QVariant::fromValue(_records); }

void registerTypes() { qmlRegisterType<SqlPlugin>("QSql", 1, 0, "SqlDriver"); }

Q_COREAPP_STARTUP_FUNCTION(registerTypes);
