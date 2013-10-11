/* Copyright (c) 2012 Research In Motion Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.0

NavigationPane {
    id: navigationPane

    Page {
        id: page

        Container {
            onCreationCompleted: {
                navigationPane.push(page);
            }

            layout: DockLayout {}

            // Application Background image is stretched to fill the display
            ImageView {
                imageSource: "asset:///images/carbon_720.jpg"
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill

            }

            Container {
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center

                Label {
                    horizontalAlignment: HorizontalAlignment.Center
                    text: _registrationHandler.statusMessage
                    textStyle {
                        base: SystemDefaults.TextStyles.BodyText
                        color: Color.White
                    }
                    multiline: true
                    textStyle.textAlign: TextAlign.Center
                }
            }
        }
    }
}
