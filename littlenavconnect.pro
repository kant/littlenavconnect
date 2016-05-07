#-------------------------------------------------
#
# Project created by QtCreator 2016-05-01T19:15:00
#
#-------------------------------------------------

QT       += core gui network svg

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11

TARGET = littlenavconnect
TEMPLATE = app

# Adapt these variables to compile on Windows
win32 {
  QT_BIN=C:\\Qt\\5.5\\mingw492_32\\bin
  GIT_BIN='C:\\Git\\bin\\git'
}

# Get the current GIT revision to include it into the code
win32:DEFINES += GIT_REVISION='\\"$$system($${GIT_BIN} rev-parse --short HEAD)\\"'
unix:DEFINES += GIT_REVISION='\\"$$system(git rev-parse --short HEAD)\\"'

win32:DEFINES +=_USE_MATH_DEFINES

SOURCES +=\
    src/main.cpp \
    src/mainwindow.cpp \
    src/net/navserver.cpp \
    src/net/navserverthread.cpp \
    src/datareaderthread.cpp \
    src/common.cpp \
    src/simconnecthandler.cpp

HEADERS  += \
    src/mainwindow.h \
    src/net/navserver.h \
    src/net/navserverthread.h \
    src/datareaderthread.h \
    src/common.h \
    src/simconnecthandler.h

FORMS    += mainwindow.ui

RESOURCES += \
    littlenavconnect.qrc

DISTFILES += \
    uncrustify.cfg \
    README.txt \
    CHANGELOG.txt \
    LICENSE.txt

# Add dependencies to atools project and its static library to ensure relinking on changes
DEPENDPATH += $$PWD/../atools/src
INCLUDEPATH += $$PWD/../atools/src $$PWD/src

CONFIG(debug, debug|release): LIBS += -L$$PWD/../atools/debug -latools
CONFIG(release, debug|release): LIBS += -L$$PWD/../atools/release -l atools

unix {
CONFIG(debug, debug|release): PRE_TARGETDEPS += $$PWD/../atools/debug/libatools.a
CONFIG(release, debug|release): PRE_TARGETDEPS += $$PWD/../atools/release/libatools.a
}

win32 {
CONFIG(debug, debug|release): PRE_TARGETDEPS += $$PWD/../atools/debug/atools.lib
CONFIG(release, debug|release): PRE_TARGETDEPS += $$PWD/../atools/release/atools.lib
}

# Create additional makefile targets to copy help files
unix {
  copydata.commands = cp -avfu $$PWD/help $$OUT_PWD
  cleandata.commands = rm -Rvf $$OUT_PWD/help
}

# Windows specific deploy target
win32 {
  RC_ICONS = resources/icons/navroute.ico

  # Create backslashed path
  WINPWD=$${PWD}
  WINPWD ~= s,/,\\,g
  WINOUT_PWD=$${OUT_PWD}
  WINOUT_PWD ~= s,/,\\,g
  DEPLOY_DIR_NAME=Little Navconnect
  DEPLOY_DIR_WIN=\"$${WINPWD}\\deploy\\$${DEPLOY_DIR_NAME}\"

  copydata.commands = xcopy /i /s /e /f /y $${WINPWD}\\help $${WINOUT_PWD}\\help

  cleandata.commands = del /s /q $${WINOUT_PWD}\\help

  deploy.commands = rmdir /s /q $${DEPLOY_DIR_WIN} &
  deploy.commands += mkdir $${DEPLOY_DIR_WIN} &&
  deploy.commands += xcopy $${WINOUT_PWD}\\littlenavconnect.exe $${DEPLOY_DIR_WIN} &&
  deploy.commands += xcopy $${WINPWD}\\CHANGELOG.txt $${DEPLOY_DIR_WIN} &&
  deploy.commands += xcopy $${WINPWD}\\README.txt $${DEPLOY_DIR_WIN} &&
  deploy.commands += xcopy $${WINPWD}\\LICENSE.txt $${DEPLOY_DIR_WIN} &&
  deploy.commands += xcopy /i /s /e /f /y $${WINPWD}\\help $${DEPLOY_DIR_WIN}\\help &&
  deploy.commands += xcopy $${QT_BIN}\\libgcc*.dll $${DEPLOY_DIR_WIN} &&
  deploy.commands += xcopy $${QT_BIN}\\libstdc*.dll $${DEPLOY_DIR_WIN} &&
  deploy.commands += xcopy $${QT_BIN}\\libwinpthread*.dll $${DEPLOY_DIR_WIN} &&
  deploy.commands += $${QT_BIN}\\windeployqt --compiler-runtime $${DEPLOY_DIR_WIN}
}

QMAKE_EXTRA_TARGETS += deploy

first.depends = $(first) copydata
QMAKE_EXTRA_TARGETS += first copydata

clean.depends = $(clean) cleandata
QMAKE_EXTRA_TARGETS += clean cleandata

