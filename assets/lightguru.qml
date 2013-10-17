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

// Import all our cascades functions.
import bb.cascades 1.0
import QtMobility.sensors 1.2 //Needed to access light sensor.
import bb.system 1.0 //Needed for Toast alert

NavigationPane {
    id: navigationPane
    backButtonsVisible: true

    // Application Menu
    Menu.definition: MenuDefinition {
        // Add a Help action
        helpAction: HelpActionItem {
            onTriggered: {
                var newHelpPage = pageHelp.createObject();
                navigationPane.push(newHelpPage);
            }
        }

        // Add a Settings action
        settingsAction: SettingsActionItem {
            onTriggered: {
                var newSettingsPage = pageSettings.createObject();
                navigationPane.push(newSettingsPage);
            }
        }
    }

    attachedObjects: [
	     // Help page
	     ComponentDefinition {
	     	id: pageHelp
	     	source: "help.qml"
	     },
	     
	     // Settings page
	     ComponentDefinition {
	        id: pageSettings
	           source: "settings.qml"
	    }
    ]

    // Create the initial screen
	Page {

        // Main Container
        Container {
            layout: DockLayout {}
            
            // Application Background image is stretched to fill the display
            ImageView {
                imageSource: "asset:///images/carbon_720.jpg"
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill

            }

        	// Controls for our app
	        Container {
	            id: mainContainer
	
	            layout: StackLayout {
	            }
	            horizontalAlignment: HorizontalAlignment.Center
	
	            attachedObjects: [
	                LightSensor {
	                    id: light
	
	                    // Turn on the sensor
	                    active: true
	                    
	                    // Peak mode
	                    property bool peakMode: false
	                    property double peakLuxValue: 0
	                    
	                    // Custom Calibration
	                    property bool customCalibration: false
	                    property double customCalibrationGain: 1
	                    property double customCalibrationOffset: 0
	                    	
	                    // Keep the sensor active when the app isn't visible or the screen is off (requires app permission in bar-descriptor)
	                    alwaysOn: true
	
	                    // If the device isn't moving (x&y&z==0), don't send updates, saves power
	                    //skipDuplicates: true
	
	                    onReadingChanged: { // Called when an light reading is available
	                    	
	                    	var lux_value = light.reading.lux;
	                    	
	                    	// Correct reading using custom calibration
	                    	if (customCalibration) {
	                    	    lux_value = lux_value*customCalibrationGain + customCalibrationOffset;
	                    	    if (lux_value <0) {lux_value = 0;}
	                    	    //console.log("CustomGain=" + customCalibrationGain + " - CustomOffset=" + customCalibrationOffset);
	                    	}
	                    	
	                    	// Update all indicators and handle Peak Mode
	                    	if (lux_value > peakLuxValue || peakMode == false) {
	                    	    // Save new maximum lux
	                    	    peakLuxValue = lux_value;
	                    	    
                                // Update our Lux indicator
                                luxText.text = Math.round(lux_value) + " lux";

                                // Update our EV100 indicator - EV = log2(lux/2.5) - reference : http://en.wikipedia.org/wiki/Light_meter
                                var ev_value = (Math.log(lux_value / 2.5) / Math.LN2); // in Javascript log is natural log (e base))
                                evText.text = "<html>EV<span style='font-size:small'>100</span> " + ev_value.toFixed(1) + "</html>";

                                // Update our picker UI at any new light value
                                exposurePicker.updatePicker();
                            }
	                        
	                        
	                    } // end of on reading changed
	                }, // end of light sensor
	
	                SystemToast {
	                    id: outRangeToast
	                    body: "Out of range!"
	
	                    property bool active: true //true = alerts are active, false = disabled.
	                    property bool once: false //if the alert is displayed once, this flag is set to true
	                    //then it is reset to false each time the user is changing the picker.
	
	                    function showOnce() {
	                        if (active && ! once) {
	                            show();
	                            once = true;
	                        }
	                    }
	                },
	                
	                AspectRatio {
	                    id: aspectRatio
	                },
	                
	                OrientationHandler {
	                    id: handler
	                    onDisplayDirectionAboutToChange: {
	                        // Set UI to be shown during rotation effect.
	                    }
	                    onOrientationAboutToChange: {
	                        // Setup the scene for the new orientation.
	                        if (orientation == UIOrientation.Portrait) {
	                            // Make some UI changes related to portrait.
	                            luxContainer.layout.orientation = LayoutOrientation.TopToBottom;
	                            luxText.rightMargin = 0;
	                        } else if (orientation == UIOrientation.Landscape) {
	                            // Make some UI changes related to landscape.
	                            luxContainer.layout.orientation = LayoutOrientation.LeftToRight;
	                            luxText.rightMargin = 200;
	                        }
	                        if (displayDirection == DisplayDirection.North) {
	                            // Do something specific to this device display direction.
	                        }
	                    }
	                    onOrientationChanged: {
	                        // Any additional changes to be performed after the orientation
	                        // change has occured.
	                    }
	                    onDisplayDirectionChanged: {
	                        // Can perform actions based on the direction of the display.
	                    }
	                    onRotationCompleted: {
	                        // Can perform actions after either direction or orientation
	                        // change has been completed.
	                    }
	                }
	            ]
	            
	            //Spacer - size 1
	            Container {
	                layoutProperties: StackLayoutProperties {
	                    spaceQuota: 1
	                }
	            }
	
	            // SubContainer only for the lux and EV indicators
	            Container {
	                id: luxContainer
	                layout: StackLayout {
	                    orientation: LayoutOrientation.TopToBottom	//Default is top to bottom for 16:9 devices
	                }
	                layoutProperties: StackLayoutProperties {
	                    spaceQuota: -1
	                }
	                verticalAlignment: VerticalAlignment.Top
	                horizontalAlignment: HorizontalAlignment.Center
	
	                Label {
	                    id: luxText
	
	                    // Center the text in the container.
	                    text: "99999 lux"
	                    horizontalAlignment: HorizontalAlignment.Center
	                    rightMargin: 200	// Default margin is big to avoid lux and EV containers to be too close
	                    textStyle {
	                        textAlign: TextAlign.Center
	                        fontSize: FontSize.XXLarge
	                        color: Color.White
	                    }
	                    
	                }
	
	                Label {
	                    id: evText
	
	                    // Center the text in the container.
	                    text: "EV100 N/A"
	                    //visible: false
	                    horizontalAlignment: HorizontalAlignment.Center
	                    textStyle {
	                        textAlign: TextAlign.Center
	                        fontSize: FontSize.XXLarge
	                        color: Color.White
	                    }
	                    
	                }
	                onTouch: {
	                    if (event.isUp()) {
	                        // Toggle EV visibility
	                        evText.visible = !evText.visible;

							saveEVvisible();

                        }
	                }
	                onCreationCompleted: {
	                    if (aspectRatio.square == true) {
	                            luxContainer.layout.orientation = LayoutOrientation.LeftToRight;
	                            luxText.rightMargin = 200;
	                    }
	                }
	                function saveEVvisible(){
	                    // Save setting
						var checked;
						if (evText.visible) checked = "true";
						else checked = "false";
                        _lightGuruApp.saveValueFor("showEV", checked)
	                }
	            } // End of Lux/EV stack container
	
	            //Spacer - size 1
	            Container {
	                layoutProperties: StackLayoutProperties {
	                    spaceQuota: 1
	                }
	            }
	
	            SegmentedControl {
	                id: lockContainer
	                layoutProperties: StackLayoutProperties {
	                    spaceQuota: -1
	                }
	                Option {
	                    id: locktime
	                    text: "Shutter"
	                    value: "time"
	                    selected: true
	                }
	                Option {
	                    id: lockfstop
	                    text: "Aperture"
	                    value: "fstop"
	                }
	                Option {
	                    id: lockiso
	                    text: "ISO"
	                    value: "iso"
	                }
	                onSelectedIndexChanged: {
	                    exposurePicker.lockType = lockContainer.selectedValue;
	                }
	            }
	
	                
	            Picker {
	                id: exposurePicker
	                
	                dataModel: XmlDataModel {
	                    source: "expValues.xml"
	                }
	                horizontalAlignment: HorizontalAlignment.Center //Fill
	
	                layoutProperties: StackLayoutProperties {
	                    spaceQuota: 1
	                }
	
	                // lockType variable will store the field that the app will update.
	                // User won't be able to update this field.
	                property string lockType: "time"
	
	                expanded: true
	                kind: PickerKind.List
	                preferredRowCount: 3
	
	                pickerItemComponents: [
	                    PickerItemComponent {
	
	                        type: "itemexptime"
	                        Label {
	                            id: timePicker
	                            text: pickerItemData.displayname
	                            textStyle {
	                                textAlign: TextAlign.Center
	                            }
	                        }
	                    }, // end of PickerItemComponent
	
	                    PickerItemComponent {
	                        type: "itemfstop"
	                        Label {
	                            id: fstopPicker
	                            text: pickerItemData.displayname
	                            textStyle {
	                                textAlign: TextAlign.Center
	                            }
	                        }
	                    }, // end of PickerItemComponent
	
	                    PickerItemComponent {
	                        type: "itemiso"
	                        Label {
	                            id: isoPicker
	                            text: pickerItemData.displayname
	                            textStyle {
	                                textAlign: TextAlign.Center
	                            }
	                        }
	                    } // end of PickerItemComponent
	                ] // end of pickerItemComponents
	
	                onSelectedValueChanged: {
	                    outRangeToast.once = false;
	                    updatePicker();
	                }
	                onCreationCompleted: {
	                    // Initialize Picker with relevant values.
	                    exposurePicker.select(1, 3); //Select f/2.8 at startup
	                    exposurePicker.select(2, 4); //Select ISO100 at startup
	                }
	
	                // The custom JavaScript function called index2Value()
	                function index2Value(index, type) {
	                    var value;
	
	                    if (type == "time") {
	                        var first_time = 32;
	                        value = first_time / Math.pow(2, index);
	                    } else if (type == "fstop") {
	                        var first_fstop = 1;
	                        value = first_fstop * Math.pow(Math.sqrt(2), index);
	                    } else if (type == "iso") {
	                        var first_iso = 25 / 4;
	                        value = first_iso * Math.pow(2, index);
	                    } else {
	                        value = 0;
	                    }
	                    return value;
	                }
	
	                // The custom JavaScript function called value2Index()
	                function value2Index(value, type) {
	                    var index;
	                    var max_index;
	
	                    if (type == "time") {
	                        var first_time = 32;
	                        max_index = 18;
	
	                        // index = ln(first_time/time) / ln(2)
	                        index = Math.log(first_time / value) / Math.LN2;
	                    } else if (type == "fstop") {
	                        var first_fstop = 1;
	                        max_index = 13;
	
	                        // index = 2/ln(2) * ln(fstop/first_fstop)
	                        index = 2 * Math.log(value / first_fstop) / Math.LN2;
	                    } else if (type == "iso") {
	                        var first_iso = 25 / 4;
	                        max_index = 14;
	
	                        // index = ln(iso/first_iso) / ln(2)
	                        index = Math.log(value / first_iso) / Math.LN2;
	                    } else {
	                        index = 0;
	                    }
	
	                    // round value, manage bounds, display alert
	                    index = Math.round(index);
	                    if (index < 0) {
	                        index = 0;
	                        outRangeToast.showOnce();
	                    } else if (index > max_index) {
	                        index = max_index;
	                        outRangeToast.showOnce();
	                    }
	
	                    return index;
	                }
	                
	                // UpdatePicker()
	                function updatePicker() {
	                    var C = 250; //light meter constant, to be possibly calibrated in later version
	                    var lux_value = light.peakLuxValue; //light.reading.lux;
	
	                    var time_index = exposurePicker.selectedIndex(0);
	                    var fstop_index = exposurePicker.selectedIndex(1);
	                    var iso_index = exposurePicker.selectedIndex(2);
	
	                    var time_value = exposurePicker.index2Value(time_index, "time");
	                    var fstop_value = exposurePicker.index2Value(fstop_index, "fstop");
	                    var iso_value = exposurePicker.index2Value(iso_index, "iso");
	                    
	                    switch (exposurePicker.lockType) {
	                        case "time":
	                            // We need to compute exposure time, and move the picker control
	                            //
	                            // N^2/t = E*S/C, with :
	                            //  - N=fNumber,
	                            //  - t=exposure time,
	                            //	- E=lux level,
	                            //	- S=ISO speed,
	                            //	- C=250
	                            // ============================
	                            time_value = (C * Math.pow(fstop_value, 2)) / (lux_value * iso_value);
	                            time_index = exposurePicker.value2Index(time_value, "time");
	
	                            exposurePicker.select(0, time_index);
	                            break;
	
	                        case "fstop":
	                            // We need to compute aperture, and move the picker control
	
	                            fstop_value = Math.sqrt((lux_value * iso_value * time_value) / C);
	                            fstop_index = exposurePicker.value2Index(fstop_value, "fstop");
	
	                            exposurePicker.select(1, fstop_index);
	                            break;
	
	                        case "iso":
	                            // We need to compute iso, and move the picker control
	
	                            iso_value = (C * Math.pow(fstop_value, 2)) / (lux_value * time_value);
	                            iso_index = exposurePicker.value2Index(iso_value, "iso");
	
	                            exposurePicker.select(2, iso_index);
	                            break;
	                    };
	                }
	                
	            } // End of Picker Container
	
				// Spacer - 2 units
	            Container {
	                layoutProperties: StackLayoutProperties {
	                    spaceQuota: 2
	                }
	            }
	            
	            onCreationCompleted: {
	                //When app is loaded, we retrieve the stored settings.
	                if (_lightGuruApp.getValueFor("alertSettings", "true") == "true") {
	                    outRangeToast.active = true;
	                } else {
	                    outRangeToast.active = false;
	                }
	                if (_lightGuruApp.getValueFor("showEV", "false") == "true") {
                        evText.visible = true;
                    } else {
                        evText.visible = false;
                    }
                    light.customCalibration = _lightGuruApp.getValueFor("customCalibration", "false")
                    light.customCalibrationGain = _lightGuruApp.getValueFor("customGain", "1")
                    light.customCalibrationOffset = _lightGuruApp.getValueFor("customOffset", "0")
                }
            }    
        } // End of Main Container
        
        // Page actions items
        actions: [
            ActionItem {
                title: "Lock"
                ActionBar.placement: ActionBarPlacement.OnBar
                imageSource: "asset:///images/unlocked.png"

                onTriggered: {
                    light.active = ! light.active;
                    if (imageSource == "asset:///images/unlocked.png") {
                        imageSource = "asset:///images/locked.png";
                    } else {
                        imageSource = "asset:///images/unlocked.png";
                    }
                }
            },
            ActionItem {
                title: "Peak"
                ActionBar.placement: ActionBarPlacement.OnBar
                imageSource: "asset:///images/peak.png"

                onTriggered: {
                    light.peakMode = ! light.peakMode;
                    if (imageSource == "asset:///images/peak.png") {
                        imageSource = "asset:///images/peak-active.png";
                    } else {
                        imageSource = "asset:///images/peak.png";
                    }
                }
            },
            ActionItem {
                title: "Toggle EV display"
                ActionBar.placement: ActionBarPlacement.InOverflow
                imageSource: "asset:///images/ic_view_details.png"

                onTriggered: {
                    evText.visible = !evText.visible;
                    luxContainer.saveEVvisible();
                }
            },
            
            // BBM integration
            ActionItem {
                title: "Share on BBM"
                ActionBar.placement: ActionBarPlacement.InOverflow
                imageSource: "asset:///images/ic_bbm.png"
                enabled: _lightGuruApp.allowed;
                
                onTriggered: {
                    _lightGuruApp.sendInvite();
                }
            }
        ]

    } // End of Page
}// End of Navigation Pane