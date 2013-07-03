/*
    Copyright 2013 Gael Jaffrain

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef _LIGHTGURUAPP_H_
#define _LIGHTGURUSAPP_H_

#include <bb/cascades/Application>

/**
 * HelloWorld Description:
 *
 * This sample application shows some of the very basic handling of
 * images and text in Cascades. Loading a QML for a simple hello
 * world sample application containing to images and a "Hello World"
 * text.
 *
 */
class LightGuruApp: public QObject
{
Q_OBJECT

public:
    // This is our constructor that sets up the recipe.
    LightGuruApp();


    /* Invokable functions that we can call from QML*/

    /**
     * This Invokable function gets a value from the QSettings,
     * if that value does not exist in the QSettings database, the default value is returned.
     *
     * @param objectName Index path to the item
     * @param defaultValue Used to create the data in the database when adding
     * @return If the objectName exists, the value of the QSettings object is returned.
     *         If the objectName doesn't exist, the default value is returned.
     */
    Q_INVOKABLE
    QString getValueFor(const QString &objectName, const QString &defaultValue);

    /**
     * This function sets a value in the QSettings database. This function should to be called
     * when a data value has been updated from QML
     *
     * @param objectName Index path to the item
     * @param inputValue new value to the QSettings database
     */
    Q_INVOKABLE
    void saveValueFor(const QString &objectName, const QString &inputValue);
};

#endif // ifndef _LIGHTGURUAPP_H_
