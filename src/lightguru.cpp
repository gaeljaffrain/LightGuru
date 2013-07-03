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

#include "lightguru.h"

#include <bb/cascades/QmlDocument>
#include <bb/cascades/Page>
#include <bb/cascades/NavigationPane>
#include <QSettings>




using namespace bb::cascades;

LightGuruApp::LightGuruApp()
{
	// Set the application organization and name, which is used by QSettings
	// when saving values to the persistent store.
	QCoreApplication::setOrganizationName("Gael Jaffrain");
	QCoreApplication::setApplicationName("LightGuru");


	// Obtain a QMLDocument and load it into the qml variable, using build patterns.
    QmlDocument *qml = QmlDocument::create("asset:///lightguru.qml");
	qml->setContextProperty("_lightGuruApp", this);


    // If the QML document is valid, we process it.
    if (!qml->hasErrors()) {

    	// The application NavigationPane is created from QML.
		NavigationPane *navPane = qml->createRootObject<NavigationPane>();

		if (navPane) {
			qml->setContextProperty("_navPane", navPane);

			// Set the main scene for the application to the NavigationPane.
			Application::instance()->setScene(navPane);

			// Set the Cover for the application running in minimized mode
			//addApplicationCover();
		}
    }


}

QString LightGuruApp::getValueFor(const QString &objectName, const QString &defaultValue)
{
    QSettings settings;

    // If no value has been saved, return the default value.
    if (settings.value(objectName).isNull()) {
        return defaultValue;
    }

    // Otherwise, return the value stored in the settings object.
    return settings.value(objectName).toString();
}

void LightGuruApp::saveValueFor(const QString &objectName, const QString &inputValue)
{
    // A new value is saved to the application settings object.
    QSettings settings;
    settings.setValue(objectName, QVariant(inputValue));
}
