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
#include "RegistrationHandler.hpp"

#include <bb/cascades/QmlDocument>
#include <bb/cascades/Page>
#include <bb/cascades/NavigationPane>
#include <QSettings>

#include <bb/platform/bbm/MessageService>


using namespace bb::cascades;

LightGuruApp::LightGuruApp(bb::platform::bbm::Context &context, QObject *parent)
	: QObject(parent)
	, m_messageService(0)
	, m_context(&context)
{
	// Set the application organization and name, which is used by QSettings
	// when saving values to the persistent store.
	QCoreApplication::setOrganizationName("Gael Jaffrain");
	QCoreApplication::setApplicationName("LightGuru");

}

void LightGuruApp::show()
{
    // Create the actual main UI
    QmlDocument* qml = QmlDocument::create("asset:///lightguru.qml").parent(Application::instance());
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

void LightGuruApp::sendInvite()
{
    if (!m_messageService) {
        // Instantiate the MessageService.
        m_messageService = new bb::platform::bbm::MessageService(m_context, this);
    }

    // Trigger the invite to download process.
    m_messageService->sendDownloadInvitation();
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
