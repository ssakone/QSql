# QSql

* Configuration CMake
```cmake
add_subdirectory(QSql) # in your project file CMakeFiles.txt
... 
target_link_libraries(... QSql)
```
 - In main cpp

```c++
#include <QSql/include/sqlplugin.h>
...
qmlRegisterType<SqlPlugin>("QSql",1,0,"SqlDriver"); // insert it after engine declaration
```
