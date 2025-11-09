import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Effects


ApplicationWindow  {
    id: window
    width: 640
    height: 480
    visible: true
    flags: Qt.Window | Qt.FramelessWindowHint
    title: qsTr("MT5 monte carlo")
    font: Qt.application.font


    // custom title bar
    Rectangle {
        id: customTitleBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 35
        color: "#0F1117"
        border.color: "#2d3139"
        border.width: 1

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Image {
                id:appLogo
                width: 20
                height: 20
                source: "qrc:/assets/logo/mt5_monte_carlo_logo.svg"
                anchors.verticalCenter: parent.verticalCenter
                smooth: true
                fillMode: Image.PreserveAspectFit
            }

            Text {
                text: window.title
                color: "#B3FFFFFF"
                font.pixelSize: 13
                font.bold: true
                font.weight: Font.DemiBold
                anchors.verticalCenter: parent.verticalCenter
            }
        }


        // window control
        Row {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            spacing: 0

            // minimize button
            Rectangle {
                width: 44
                height: parent.height
                color: minimizeArea.containsMouse ? "#0CFFFFFF" : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: "−"
                    color: "#99FFFFFF"
                    font.pixelSize: 14
                }

                MouseArea {
                    id: minimizeArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: window.showMinimized()
                }
            }

            // maximize/restore button
            Rectangle {
                width: 45
                height: parent.height
                color: maximizeArea.containsMouse ? "#0CFFFFFF" : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: window.visibility === Window.Maximized ? "❐" : "□"
                    color: "#99FFFFFF"
                    font.pixelSize: 12
                }

                MouseArea {
                    id: maximizeArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (window.visibility === Window.Maximized) {
                            window.showNormal()
                        } else {
                            window.showMaximized()
                        }
                    }
                }
            }

            // close button
            Rectangle {
                width: 44
                height: parent.height
                color: closeArea.containsMouse ? "#e74c3c" : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    font.bold: true
                    color: closeArea.containsMouse ? "white" : "#99FFFFFF"
                    font.pixelSize: 16
                }

                MouseArea {
                    id: closeArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: window.close()
                }
            }
        }

        // make title bar draggable
        MouseArea {
            anchors.fill: parent
            anchors.rightMargin: 135  // no overlap with buttons
            property point lastMousePos: Qt.point(0, 0)
            onPressed: (mouse) => { lastMousePos = Qt.point(mouse.x, mouse.y) }
            onPositionChanged: (mouse) => {
                if (pressed) {
                    window.x += (mouse.x - lastMousePos.x)
                    window.y += (mouse.y - lastMousePos.y)
                }
            }
            onDoubleClicked: {
                if (window.visibility === Window.Maximized) {
                    window.showNormal()
                } else {
                    window.showMaximized()
                }
            }
        }
    }

    // tool bar
    Rectangle {
        id:toolBar
        height: 40
        anchors.top: customTitleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#151822"
        border.color: "#2d3139"
        border.width: 1


        Row {
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            // run button
            Rectangle {
                id: runButton
                width: 70
                height: 28
                radius: 6
                opacity: isSimulating ? 0.6 : 1.0
                property bool isSimulating: false

                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: runButton.isSimulating
                            ? "#0CFFFFFF"
                            : (runButtonArea.containsMouse ? "#06b6d4" : "#0ea5e9")
                    }
                    GradientStop {
                        position: 1.0
                        color: runButton.isSimulating
                            ? "#08FFFFFF"
                            : (runButtonArea.containsMouse ? "#0284c7" : "#0369a1")
                    }
                }

                // inner glow effect
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#20FFFFFF" }
                        GradientStop { position: 0.5; color: "#00FFFFFF" }
                    }
                    visible: !runButton.isSimulating
                }


                border.color: runButton.isSimulating ? "#1AFFFFFF" : "#22d3ee"
                border.width: 1

                Row {
                    anchors.centerIn: parent
                    spacing: 6

                    Image {
                        id: runImage
                        width: 20
                        height: 20
                        source: "qrc:/assets/icons/play_button.svg"
                        anchors.verticalCenter: parent.verticalCenter
                        smooth: true
                        opacity: runButton.isSimulating ? 0.4 : 1.0

                        Behavior on opacity {
                            NumberAnimation { duration: 200 }
                        }
                    }

                    Text {
                        text: "Run"
                        color: runButton.isSimulating ? "#66FFFFFF" : "white"
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        anchors.verticalCenter: parent.verticalCenter

                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }
                }

                MouseArea {
                    id: runButtonArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: runButton.isSimulating ? Qt.ForbiddenCursor : Qt.PointingHandCursor
                    enabled: !runButton.isSimulating

                    onClicked: {
                        console.log("run simulation clicked")
                        runButton.isSimulating = true
                        // gonna start simulation here
                    }
                }

                Behavior on opacity {
                    NumberAnimation { duration: 200 }
                }
            }



            // stop Button
            Rectangle {
                id: stopButton
                width: 70
                height: 28
                radius: 6
                visible: true

                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: runButton.isSimulating
                            ? (stopButtonArea.containsMouse ? "#f87171" : "#ef4444")
                            : "#3b3b3b"
                    }
                    GradientStop {
                        position: 1.0
                        color: runButton.isSimulating
                            ? (stopButtonArea.containsMouse ? "#dc2626" : "#b91c1c")
                            : "#2b2b2b"
                    }
                }

                border.color: runButton.isSimulating ? "#ef4444" : "#555"
                border.width: 1

                // stop icon
                Image {
                    width: 20
                    height: 20
                    source: "qrc:/assets/icons/stop_button.svg"
                    anchors.centerIn: parent
                    smooth: true
                    opacity: runButton.isSimulating ? 0.9 : 0.6
                    Behavior on opacity { NumberAnimation { duration: 200 } }
                }

                MouseArea {
                    id: stopButtonArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: runButton.isSimulating ? Qt.PointingHandCursor : Qt.ForbiddenCursor
                    enabled: runButton.isSimulating

                    onClicked: {
                        console.log("Stop simulation clicked")
                        runButton.isSimulating = false
                    }
                }
            }



        }

    }


    // main content
    Rectangle {
        id: mainContentArea
        anchors.top: toolBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: statusBar.top
        color: "#151822"
        border.color: "#2d3139"
        border.width: 1

        // left side panel
        Rectangle {
        id:leftPanel
        width: 250
        height: parent.height
        color: "#151822"
        border.color: "#2d3139"
        border.width: 1

        Flickable {
            anchors.fill: parent
            anchors.margins: 0
            contentHeight: contentColumn.height
            clip: true


            Column {
                id: contentColumn
                width: parent.width
                spacing: 0

                // data source
                Rectangle {
                width:  parent.width
                height: 120
                color: "transparent"

                Column {

                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 12

                    // section header
                    Row {
                        spacing: 6

                        Image {
                            id: dataSourceIcon
                            width: 30
                            height: 30
                            source: "qrc:/assets/icons/sheet.png"
                            anchors.verticalCenter: parent.verticalCenter

                        }

                        Text {
                            text: "Data Source"
                            font.pixelSize: 13
                            font.weight: Font.Medium
                            color: "#B3FFFFFF"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }


                    // opening file location
                    Rectangle {
                        width: parent.width
                        height: 40
                        color: openFileArea.containsMouse ? "#1e2235" : "#1a1d29"
                        border.color: "#334155"
                        border.width: 1
                        radius: 4

                        Row {
                            anchors.centerIn: parent
                            spacing: 8

                            Image {
                                id: openFileAreaIcon
                                source: "qrc:/assets/icons/openfolder.png"
                                width: 30
                                height: 30
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: "Open File..."
                                color: "#94a3b8"
                                font.pixelSize: 12
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            id: openFileArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                console.log("Open file clicked")
                                // file dialog here
                            }
                        }
                     }
                }
             }

            // divider line
            Rectangle {
                width: parent.width
                height: 1
                color: "#2d3139"
            }

            // simulation parameters section
            Rectangle {
                width: parent.width
                height: 420
                color: "transparent"

                Column {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 20

                    // section header
                    Row {
                        spacing: 6

                        Image {
                            id: simParametersSectionIcon
                            source: "qrc:/assets/icons/sim_params_icon.svg"
                            width:30
                            height: 30
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: "Simulation Parameters"
                            font.pixelSize: 13
                            font.weight: Font.Medium
                            color: "#B3FFFFFF"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                    }



                }


            }



                }

            }

        }
    }




    // status bar
    Rectangle {
        id: statusBar
        height: 24
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#0d1117"
        border.color: "#2d3139"
        border.width: 1

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 20

            Text {
                text: "● Running simulation... 4%"
                color: "#4ade80"
                font.pixelSize: 11
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Row {
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 15

            Text {
                text: "CPU: 24%"
                color: "#9ca3af"
                font.pixelSize: 11
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: "Memory: 2.1 GB"
                color: "#9ca3af"
                font.pixelSize: 11
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: "11:42:36 AM"
                color: "#9ca3af"
                font.pixelSize: 11
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }







    }

