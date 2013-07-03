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
        title: qsTr("LightGuru Help")

    }
    
    ScrollView {
        scrollViewProperties.pinchToZoomEnabled: false
        Container {    
	        	        
	        Header {
	            title: qsTr("Tips")
	
	        }
	        TextArea {
	            text: qsTr("LighGuru is allowing you to measure the incident light on your photo subject, and to suggest you the camera settings you should use to get a properly exposed picture.\n\nAs with any light meter, you should make the measurement on your subject, to measure the light your subject is receiving.")
                backgroundVisible: false
	            textFormat: TextFormat.Html
	            editable: false
	
	        }
	        TextArea {
	            text: qsTr("Because the sensor is not spherical like on a professional light meter, but flat, you should point the sensor toward the brightest light source for best results. Light sensor is located just above the display.")
	            backgroundVisible: false
	            textFormat: TextFormat.Html
	            editable: false
	
	        }
	
	        Header {
	            title: qsTr("Exposure selector")
	
	        }
            SegmentedControl {
                id: lockContainer
                layoutProperties: StackLayoutProperties {
                    spaceQuota: -1
                }
                horizontalAlignment: HorizontalAlignment.Center
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
            }
            TextArea {
	            text: qsTr("The selector will allow you to select the parameter that LightGuru will drive. You have to set the 2 others based on your current camera settings.")
	            backgroundVisible: false
	            textFormat: TextFormat.Html
	            editable: false
	
	        }
	
	        Header {
	            title: qsTr("Lock feature")
	
	        }
	        ImageToggleButton {
	            horizontalAlignment: HorizontalAlignment.Center
                imageSourceDefault: "asset:///images/unlocked.png"
                imageSourceChecked: "asset:///images/locked.png"

            }
	        TextArea {
	            text: qsTr("The lock button is allowing you to lock the light measurement. But you can still play with the exposure parameters and see what is the best combination you can use.")
	            backgroundVisible: false
	            textFormat: TextFormat.Html
	            editable: false
	
	        }

            Header {
	            title: qsTr("Credits")
	
	        }
	        TextArea {
	            text: qsTr("LightGuru was designed and programmed by Gael Jaffrain.\nWebsite: <a href=\"http://gaeljaffrain.com\">gaeljaffrain.com</a>\n\nOther credits: locker icons by DesignModo <a href=\"http://designmodo.com\">designmodo.com</a>, used under Creative Commons license.")
	            backgroundVisible: false
	            textFormat: TextFormat.Html
	            editable: false
	
	        }
	    }

    }
}
