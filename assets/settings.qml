/*
 * Copyright 2013 Gael Jaffrain
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import bb.cascades 1.0

Page {
    titleBar: TitleBar {
        title: qsTr("LightGuru Settings")

    }
    Container {
        id: main
        
        // Out of Range alert Settings
        Container {
            id: alertSettingsContainer

            layout: DockLayout {

            }

            horizontalAlignment: HorizontalAlignment.Fill
            leftPadding: 10.0
            topPadding: 10.0
            rightPadding: 10.0
            bottomPadding: 10.0
            Label {
                text: qsTr("Display Out of range alerts ?")
                verticalAlignment: VerticalAlignment.Center
                leftMargin: 10.0
            }
            
            ToggleButton {
                id: alertSettings
                objectName: "alertSettings"
                horizontalAlignment: HorizontalAlignment.Right
                checked: _lightGuruApp.getValueFor(alertSettings.objectName, "true")
                
                onCheckedChanged: {
                    _lightGuruApp.saveValueFor(alertSettings.objectName, checked)
                    if (checked == true) 
                    { 
                        outRangeToast.active = true;
                    }
                    else {
                        outRangeToast.active = false;
                    }
                }
            }
        }

        // Display EV at startup Settings
        Container {
            id: evSettingsContainer

            layout: DockLayout {

            }

            horizontalAlignment: HorizontalAlignment.Fill
            leftPadding: 10.0
            topPadding: 10.0
            rightPadding: 10.0
            bottomPadding: 10.0
            Label {
                text: qsTr("Display EV at startup ?")
                verticalAlignment: VerticalAlignment.Center
                leftMargin: 10.0
            }

            ToggleButton {
                id: evSettings
                objectName: "showEV"
                horizontalAlignment: HorizontalAlignment.Right
                checked: _lightGuruApp.getValueFor(evSettings.objectName, "false")

                onCheckedChanged: {
                    _lightGuruApp.saveValueFor(evSettings.objectName, checked)
                    if (checked == true) {
                        evText.visible = true;
                    } else {
                        evText.visible = false;
                    }
                }
            }
        }

    }
}
