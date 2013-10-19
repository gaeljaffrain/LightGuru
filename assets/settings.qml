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
                text: qsTr("Display Out of range alerts")
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
                text: qsTr("Display EV at startup")
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

        // Custom Calibration Settings
        Container {
            id: customCalibrationContainer

            layout: DockLayout {

            }

            horizontalAlignment: HorizontalAlignment.Fill
            leftPadding: 10.0
            topPadding: 10.0
            rightPadding: 10.0
            bottomPadding: 10.0
            Label {
                text: qsTr("Use Custom Calibration")
                verticalAlignment: VerticalAlignment.Center
                leftMargin: 10.0
            }

            ToggleButton {
                id: customCalibration
                objectName: "customCalibration"
                horizontalAlignment: HorizontalAlignment.Right
                checked: _lightGuruApp.getValueFor(customCalibration.objectName, "false")

                onCheckedChanged: {
                    _lightGuruApp.saveValueFor(customCalibration.objectName, checked);
                    if (checked == true) {
                        customCalibrationGainContainer.visible = true;
                        customCalibrationOffsetContainer.visible = true;

                        light.customCalibration = true;
                        light.customCalibrationGain = Number(showGain.text);
                        light.customCalibrationOffset = Number(showOffset.text);
                        
                    } else {
                        customCalibrationGainContainer.visible = false;
                        customCalibrationOffsetContainer.visible = false;
                        
                        light.customCalibration = false;
                        light.customCalibrationGain = 1;
                        light.customCalibrationOffset = 0;
                    }
                }
            }
        }
        
	    // Gain
	    Container {
	        id: customCalibrationGainContainer
            layout: StackLayout {
	            orientation: LayoutOrientation.LeftToRight
	        }
	        horizontalAlignment: HorizontalAlignment.Center
	        rightPadding: 20.0
	        leftPadding: 20.0
	        topPadding: 20.0
	        bottomPadding: 20.0
	        visible: false
	
	        Label {
	            text: "Gain"
	            preferredWidth: 100
	            textStyle.textAlign: TextAlign.Center
	        }
	        Slider {
	            id: customGain
	            objectName: "customGain"
	            value: _lightGuruApp.getValueFor(customGain.objectName, "1.0")
	            toValue: 1.3
	            fromValue: 0.7
	            preferredWidth: 450.0
	            onImmediateValueChanged: {
	                showGain.text = immediateValue.toFixed(2);
	            }
	            onValueChanged: {
	                _lightGuruApp.saveValueFor(customGain.objectName, showGain.text);
	                light.customCalibrationGain = Number(showGain.text);
	            }
	        }
	        Label {
	            id: showGain
	            text: "1.0"
	            preferredWidth: 100
	            textStyle.textAlign: TextAlign.Center
	        }
	    }
	
	    // Offset
	    Container {
            id: customCalibrationOffsetContainer
            layout: StackLayout {
	            orientation: LayoutOrientation.LeftToRight
	        }
	        horizontalAlignment: HorizontalAlignment.Center
	        rightPadding: 20.0
	        leftPadding: 20.0
	        topPadding: 20.0
	        bottomPadding: 20.0
	        visible: false
	        
	        Label {
	            text: "Offset"
	            preferredWidth: 100
	            textStyle.textAlign: TextAlign.Center
	        }
	        Slider {
	            id: customOffset
	            objectName: "customOffset"
	            value: _lightGuruApp.getValueFor(customOffset.objectName, "0")
                toValue: 100.0
	            fromValue: -100.0
	            preferredWidth: 450
	            onImmediateValueChanged: {
	                showOffset.text = immediateValue.toFixed(0);
	            }
	            onValueChanged: {
	                _lightGuruApp.saveValueFor(customOffset.objectName, showOffset.text);
	                light.customCalibrationOffset = Number(showOffset.text);
	            }
	        }
	        Label {
	            id: showOffset
	            text: "0"
	            preferredWidth: 100
	            textStyle.textAlign: TextAlign.Center
	        }
	    }
	}
}
