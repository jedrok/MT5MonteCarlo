import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Effects
import QtQuick.Layouts
import QtGraphs


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
                        source: "qrc:/assets/icons/play_button_icon.svg"
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
                        // Simulate completion after delay (replace with actual simulation completion signal)

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
                    source: "qrc:/assets/icons/stop_button_icon.svg"
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


    // main content area
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
        id:leftSidePanel
        width: 250
        height: parent.height
        color: "#151822"
        border.color: "#2d3139"
        border.width: 1

        Flickable {
            anchors.fill: parent
            anchors.margins: 0
            clip: true


            Column {
                id: leftSidePanelContentColumn
                width: parent.width
                spacing: 0
                height: implicitHeight

                // data source section
                Rectangle {
                width:  parent.width
                height: 110
                color: "transparent"

                Column {

                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 12

                    // section header
                    Row {
                        spacing: 6

                        Image {
                            id: dataSourceIcon
                            width: 30
                            height: 30
                            source: "qrc:/assets/icons/data_source_icon.svg"
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
                        height: 45
                        color: openFileArea.containsMouse ? "#1e2235" : "#1a1d29"
                        border.color: "#334155"
                        border.width: 1
                        radius: 4

                        Row {
                            anchors.centerIn: parent
                            spacing: 8

                            Image {
                                id: openFileAreaIcon
                                source: "qrc:/assets/icons/open_folder_icon.svg"
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
                height: simParamsColumn.height + 24
                color: "transparent"

                Column {
                    id:simParamsColumn
                    width: parent.width
                    height: implicitHeight
                    anchors.margins: 12
                    spacing: 8

                // spacer
                    Item {
                        width: parent.width
                        height: 2
                    }

                    // simulation params section header
                    Row {
                        width: parent.width
                        anchors.margins: 12
                        spacing: 6
                        leftPadding: 10

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

                    // number of runs section
                    Rectangle {
                        width: parent.width
                        height: childrenRect.height
                        color: "transparent"


                        Column {
                            width: parent.width
                            anchors.margins: 12
                            spacing: 8

                            Row {
                                width: parent.width
                                spacing: 97
                                leftPadding: 10
                                rightPadding: 10

                                Text {
                                    text: "Number of Runs"
                                    color: "#B3FFFFFF"
                                    font.pixelSize: 13
                                    horizontalAlignment: Text.AlignLeft
                                }


                                Text {
                                    id: numOfRunsValueLabel
                                    text: Math.round(numOfRunsSlider.value)
                                    font.pixelSize: 13
                                    font.bold: true
                                    color: "#0ea5e9"
                                    horizontalAlignment: Text.AlignRight
                                }
                            }

                            // number of runs slider
                            Slider {
                                id: numOfRunsSlider
                                from: 100
                                to: 10000
                                stepSize: 100
                                value: 1000
                                width: parent.width - 20
                                anchors.horizontalCenter: parent.horizontalCenter
                                live: true

                                background: Rectangle {
                                    x: numOfRunsSlider.leftPadding
                                    y: numOfRunsSlider.topPadding + numOfRunsSlider.availableHeight / 2 - height / 2
                                    implicitWidth: 200
                                    implicitHeight: 6
                                    width: numOfRunsSlider.availableWidth
                                    height: implicitHeight
                                    radius: 3
                                    color: "#2d3139"

                                    Rectangle {
                                        width: numOfRunsSlider.visualPosition * parent.width
                                        height: parent.height
                                        color: "#0ea5e9"
                                        radius: 3
                                    }
                                }

                                handle: Rectangle {
                                    x: numOfRunsSlider.leftPadding + numOfRunsSlider.visualPosition * (numOfRunsSlider.availableWidth - width)
                                    y: numOfRunsSlider.topPadding + numOfRunsSlider.availableHeight / 2 - height / 2
                                    implicitWidth: 18
                                    implicitHeight: 18
                                    radius: 9
                                    color: numOfRunsSlider.pressed ? "#0284c7" : "#0ea5e9"
                                    border.color: "#ffffff"
                                    border.width: 2
                                }

                            }

                            // min max labels
                            Row {
                                width: parent.width - 20
                                anchors.horizontalCenter: parent.horizontalCenter

                                Text {
                                    text: "100"
                                    color: "#777"
                                    font.pixelSize: 12
                                    width: parent.width / 2
                                    horizontalAlignment: Text.AlignLeft
                                }

                                Text {
                                    text: "10000"
                                    color: "#777"
                                    font.pixelSize: 12
                                    width: parent.width / 2
                                    horizontalAlignment: Text.AlignRight
                                }
                            }
                        }

                    }

                    // divider line
                    Rectangle {
                        width: parent.width - 20
                        height: 1
                        color: "#2d3139"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }




                    // confidence level section
                    Rectangle {
                        width: parent.width
                        height: childrenRect.height
                        color: "transparent"


                        Column {
                            width: parent.width
                            anchors.margins: 12
                            spacing: 8

                            // label and Value
                            Row {
                                width: parent.width
                                spacing: 97
                                leftPadding: 10
                                rightPadding: 10

                                Text {
                                    text: "Confidence Level"
                                    color: "#B3FFFFFF"
                                    font.pixelSize: 13
                                    horizontalAlignment: Text.AlignLeft
                                }


                                Text {
                                    id: confidenceValueLabel
                                    text: Math.round(confidenceLevelSlider.value) + "%"
                                    font.pixelSize: 13
                                    font.bold: true
                                    color: "#0ea5e9"
                                    horizontalAlignment: Text.AlignRight
                                }
                            }

                            // confidence level slider
                            Slider {
                                id: confidenceLevelSlider
                                from: 80
                                to: 99
                                stepSize: 1
                                value: 95
                                width: parent.width - 20
                                anchors.horizontalCenter: parent.horizontalCenter
                                live: true

                                background: Rectangle {
                                    x: confidenceLevelSlider.leftPadding
                                    y: confidenceLevelSlider.topPadding + confidenceLevelSlider.availableHeight / 2 - height / 2
                                    implicitWidth: 200
                                    implicitHeight: 6
                                    width: confidenceLevelSlider.availableWidth
                                    height: implicitHeight
                                    radius: 3
                                    color: "#2d3139"

                                    Rectangle {
                                        width: confidenceLevelSlider.visualPosition * parent.width
                                        height: parent.height
                                        color: "#0ea5e9"
                                        radius: 3
                                    }
                                }

                                handle: Rectangle {
                                    x: confidenceLevelSlider.leftPadding + confidenceLevelSlider.visualPosition * (confidenceLevelSlider.availableWidth - width)
                                    y: confidenceLevelSlider.topPadding + confidenceLevelSlider.availableHeight / 2 - height / 2
                                    implicitWidth: 18
                                    implicitHeight: 18
                                    radius: 9
                                    color: confidenceLevelSlider.pressed ? "#0284c7" : "#0ea5e9"
                                    border.color: "#ffffff"
                                    border.width: 2
                                }

                            }

                            // confidence level min max labels
                            Row {
                                width: parent.width - 20
                                anchors.horizontalCenter: parent.horizontalCenter

                                Text {
                                    text: "80%"
                                    color: "#777"
                                    font.pixelSize: 12
                                    width: parent.width / 2
                                    horizontalAlignment: Text.AlignLeft
                                }

                                Text {
                                    text: "90%"
                                    color: "#777"
                                    font.pixelSize: 12
                                    width: parent.width / 2
                                    horizontalAlignment: Text.AlignRight
                                }
                            }
                        }

                    }



                    // divider line
                    Rectangle {
                        width: parent.width - 20
                        height: 1
                        color: "#2d3139"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }


                    // randomize order section
                    Rectangle {
                        width: parent.width
                        height: 30
                        color: "transparent"

                        Row {
                            width: parent.width
                            anchors.verticalCenter: parent.verticalCenter
                            leftPadding: 10
                            rightPadding: 10

                            Text {
                                text: "Randomize Order"
                                color: "#B3FFFFFF"
                                font.pixelSize: 13
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Item {
                                width: parent.width - 170
                                height: 1
                            }

                            // randomize order toggle switch
                            Rectangle {
                                id: randomizeOrderToggleBackground
                                width: 40
                                height: 20
                                radius: 13
                                color: randomizeOrderToggleSwitch.checked ? "#0ea5e9" : "#2d3139"
                                border.color: randomizeOrderToggleSwitch.checked ? "#0284c7" : "#1e293b"
                                border.width: 1
                                anchors.verticalCenter: parent.verticalCenter

                                Behavior on color {
                                    ColorAnimation { duration: 200 }
                                }

                                Rectangle {
                                    id: randomizeOrderToggleHandle
                                    width: 18
                                    height: 18
                                    radius: 10
                                    color: "#e5e5e5"
                                    x: randomizeOrderToggleSwitch.checked ? parent.width - width - 3 : 3
                                    anchors.verticalCenter: parent.verticalCenter

                                    Behavior on x {
                                        NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                                    }
                                }

                                MouseArea {
                                    id: randomizeOrderToggleSwitch
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    property bool checked: false

                                    onClicked: {
                                        checked = !checked
                                        console.log("Randomize Order:", checked)
                                    }
                                }
                            }
                        }
                    }

                    // divider line
                    Rectangle {
                        width: parent.width - 20
                        height: 1
                        color: "#2d3139"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

            }

            }

          }

        }


        // graph and metrics area
            Rectangle {
                id: graphArea
                anchors.left: leftSidePanel.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                color: "#1a1d29"



                Rectangle {
                    id: emptyState
                    anchors.fill: parent
                    //visible: true // dont forget set false when data is loaded
                    //visible: opacity > 0
                    visible: false   // temporary till i finish the results ui
                    //opacity: runButton.isSimulating ? 0 : 1

                    Behavior on opacity {
                       NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
                    }

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 5

                        Image {
                            id: emptyStateIcon
                            source: "qrc:/assets/icons/empty_state.svg"
                            width: 50
                            height: 50
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: "No Data"
                            color: "#64748b"
                            font.pixelSize: 15
                            font.weight: Font.Medium
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: "Open a file and run simulation to view results"
                            color: "#64748b"
                            font.pixelSize: 15
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }



                // equity curve and metrics results area
                Rectangle {
                     id: resultsArea
                     anchors.fill: parent
                     visible: opacity > 0
                     //opacity: 0  // Start hidden then set to 1 when simulation completes
                     opacity:1 // temp so i can finish the results ui
                     color: "transparent"


                     Behavior on opacity {
                         NumberAnimation { duration: 500; easing.type: Easing.InOutQuad }
                     }


                     RowLayout {
                         id:resultsRow
                         anchors.fill: parent
                         spacing: 5

                         // equity curve area
                         Rectangle {
                             id: equityCurveContainer
                             Layout.fillWidth: true
                             Layout.fillHeight: true
                             Layout.margins: 10
                             color: "transparent"

                             ColumnLayout {
                                 anchors.fill: parent
                                 Layout.margins: 10
                                 spacing: 15


                                 RowLayout {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 30
                                    Layout.margins: 5

                                     Text {
                                         id: titleText
                                         text: "Equity Curves - Monte Carlo Simulation"
                                         color: "#B3FFFFFF"
                                         font.pixelSize: 14
                                         font.weight: Font.Medium
                                         verticalAlignment: Text.AlignVCenter
                                     }

                                     Item {
                                          Layout.fillWidth: true
                                     }

                                     RowLayout {
                                         id: legendGroup
                                         spacing: 20

                                         Row {
                                             spacing: 6

                                             Rectangle {
                                                 width: 30
                                                 height: 5
                                                 color: "#06b6d4"
                                                 anchors.verticalCenter: parent.verticalCenter
                                             }

                                             Text {
                                                 text: "Median"
                                                 color: "#94a3b8"
                                                 font.pixelSize: 12
                                                 anchors.verticalCenter: parent.verticalCenter
                                             }
                                         }

                                         Row {
                                             spacing: 6

                                             Rectangle {
                                                 width: 30
                                                 height: 5
                                                 color: "#ec4899"
                                                 anchors.verticalCenter: parent.verticalCenter
                                             }

                                             Text {
                                                 text: Math.round(confidenceLevelSlider.value) + "% CL"
                                                 color: "#94a3b8"
                                                 font.pixelSize: 12
                                                 anchors.verticalCenter: parent.verticalCenter
                                             }
                                         }

                                         Row {
                                             spacing: 6

                                             Rectangle {
                                                 width: 30
                                                 height: 5
                                                 color: "#7b68ee"
                                                 anchors.verticalCenter: parent.verticalCenter
                                             }

                                             Text {
                                                 text: "Runs"
                                                 color: "#94a3b8"
                                                 font.pixelSize: 12
                                                 anchors.verticalCenter: parent.verticalCenter
                                             }
                                         }
                                     }
                                 }

                             Rectangle {
                                 id:equityCurveGraphArea
                                 color: "#151822"
                                 border.color: "#2d3139"
                                 radius: 5
                                 Layout.fillWidth: true
                                 Layout.fillHeight: true


                                 GraphsView {
                                         id: graphView
                                         anchors.fill: parent
                                         anchors.margins: 20
                                         anchors.bottomMargin: 20
                                         anchors.leftMargin: 50

                                         theme: GraphsTheme {
                                             theme: GraphsTheme.Theme.UserDefined
                                             colorScheme: GraphsTheme.ColorScheme.Dark
                                             backgroundColor: "#151822"
                                             grid.mainColor: "#1e2531"
                                             grid.subColor: "transparent"
                                             labelTextColor: "#64748b"
                                             plotAreaBackgroundColor: "#151822"
                                             gridVisible: true
                                         }


                                         axisX: ValueAxis {
                                             id: axisX
                                             min: 0
                                             max: 100
                                             labelFormat: "%.0f"
                                         }

                                         axisY: ValueAxis {
                                             id: axisY
                                             min: 9000
                                             max: 15000
                                             labelFormat: "$%.0f"
                                         }

                                        // sample runs
                                       SplineSeries {
                                           color: "#7b68ee"
                                           width: 1
                                           opacity: 0.7

                                           XYPoint { x: 0; y: 10000 }
                                           XYPoint { x: 10; y: 10150 }
                                           XYPoint { x: 20; y: 10050 }
                                           XYPoint { x: 30; y: 10300 }
                                           XYPoint { x: 40; y: 10200 }
                                           XYPoint { x: 50; y: 10500 }
                                           XYPoint { x: 60; y: 10400 }
                                           XYPoint { x: 70; y: 10700 }
                                           XYPoint { x: 80; y: 10800 }
                                           XYPoint { x: 90; y: 11000 }
                                           XYPoint { x: 100; y: 10900 }
                                       }


                                       SplineSeries {
                                           color: "#7b68ee"
                                           width: 1
                                           opacity: 0.7

                                           XYPoint { x: 0; y: 10000 }
                                           XYPoint { x: 10; y: 10250 }
                                           XYPoint { x: 20; y: 10150 }
                                           XYPoint { x: 30; y: 10500 }
                                           XYPoint { x: 40; y: 10400 }
                                           XYPoint { x: 50; y: 10700 }
                                           XYPoint { x: 60; y: 10600 }
                                           XYPoint { x: 70; y: 10900 }
                                           XYPoint { x: 80; y: 11000 }
                                           XYPoint { x: 90; y: 11200 }
                                           XYPoint { x: 100; y: 11100 }
                                       }


                                       SplineSeries {
                                           color: "#7b68ee"
                                           width: 1
                                           opacity: 0.7

                                           XYPoint { x: 0; y: 10000 }
                                           XYPoint { x: 10; y: 9900 }
                                           XYPoint { x: 20; y: 9950 }
                                           XYPoint { x: 30; y: 10200 }
                                           XYPoint { x: 40; y: 10100 }
                                           XYPoint { x: 50; y: 10400 }
                                           XYPoint { x: 60; y: 10300 }
                                           XYPoint { x: 70; y: 10600 }
                                           XYPoint { x: 80; y: 10700 }
                                           XYPoint { x: 90; y: 10900 }
                                           XYPoint { x: 100; y: 10800 }
                                       }


                                       SplineSeries {
                                           color: "#7b68ee"
                                           width: 1
                                           opacity: 0.7

                                           XYPoint { x: 0; y: 10000 }
                                           XYPoint { x: 10; y: 10100 }
                                           XYPoint { x: 20; y: 10200 }
                                           XYPoint { x: 30; y: 10400 }
                                           XYPoint { x: 40; y: 10500 }
                                           XYPoint { x: 50; y: 10800 }
                                           XYPoint { x: 60; y: 10700 }
                                           XYPoint { x: 70; y: 11000 }
                                           XYPoint { x: 80; y: 11100 }
                                           XYPoint { x: 90; y: 11300 }
                                           XYPoint { x: 100; y: 11200 }
                                       }


                                       SplineSeries {
                                           color: "#7b68ee"
                                           width: 1
                                           opacity: 0.7

                                           XYPoint { x: 0; y: 10000 }
                                           XYPoint { x: 10; y: 10050 }
                                           XYPoint { x: 20; y: 10100 }
                                           XYPoint { x: 30; y: 10350 }
                                           XYPoint { x: 40; y: 10250 }
                                           XYPoint { x: 50; y: 10550 }
                                           XYPoint { x: 60; y: 10450 }
                                           XYPoint { x: 70; y: 10750 }
                                           XYPoint { x: 80; y: 10850 }
                                           XYPoint { x: 90; y: 11050 }
                                           XYPoint { x: 100; y: 10950 }
                                       }



                                         SplineSeries {
                                             id: confidenceSeries
                                             color: "#ec4899"
                                             width: 2

                                             XYPoint { x: 0; y: 10000 }
                                             XYPoint { x: 10; y: 10150 }
                                             XYPoint { x: 20; y: 10250 }
                                             XYPoint { x: 30; y: 10400 }
                                             XYPoint { x: 40; y: 10500 }
                                             XYPoint { x: 50; y: 10700 }
                                             XYPoint { x: 60; y: 10850 }
                                             XYPoint { x: 70; y: 11000 }
                                             XYPoint { x: 80; y: 11200 }
                                             XYPoint { x: 90; y: 11400 }
                                             XYPoint { x: 100; y: 11600 }
                                         }

                                         SplineSeries {
                                             id: medianSeries
                                             color: "#06b6d4"
                                             width: 3

                                             XYPoint { x: 0; y: 10000 }
                                             XYPoint { x: 10; y: 10500 }
                                             XYPoint { x: 20; y: 10800 }
                                             XYPoint { x: 30; y: 11200 }
                                             XYPoint { x: 40; y: 11500 }
                                             XYPoint { x: 50; y: 12000 }
                                             XYPoint { x: 60; y: 12400 }
                                             XYPoint { x: 70; y: 12900 }
                                             XYPoint { x: 80; y: 13300 }
                                             XYPoint { x: 90; y: 13800 }
                                             XYPoint { x: 100; y: 14200 }
                                         }
                                     }

                                     Text {
                                         text: "Equity ($)"
                                         color: "#64748b"
                                         font.pixelSize: 12
                                         rotation: -90
                                         anchors.left: parent.left
                                         anchors.verticalCenter: parent.verticalCenter
                                         anchors.leftMargin: 15
                                         transformOrigin: Item.Center
                                     }

                                     Text {
                                         text: "Trades"
                                         color: "#64748b"
                                         font.pixelSize: 12
                                         anchors.bottom: parent.bottom
                                         anchors.horizontalCenter: parent.horizontalCenter
                                         anchors.bottomMargin: 10
                                     }

                                }

                             }

                         }


                 // metrics tab
                 Rectangle {
                     id: rightMetricsPanel
                     Layout.preferredWidth: 350
                     Layout.fillHeight: true
                     Layout.margins: 10
                     color: "transparent"

                     ColumnLayout {
                         anchors.fill: parent
                         spacing: 10

                         Text {
                             text: "Simulation Results"
                             color: "#B3FFFFFF"
                             font.pixelSize: 14
                             font.weight: Font.Medium
                             Layout.topMargin: 10
                             Layout.leftMargin: 10
                         }


                         RowLayout {
                             id: tabBar
                             spacing: 10
                             Layout.fillWidth: true
                             Layout.leftMargin: 10

                             ButtonGroup { id: tabGroup } //only one tab button must be active at a time

                             Repeater {
                                 model: ["Overview", "Returns", "Risk", "Trades"]

                                 delegate: RadioButton {
                                     text: modelData
                                     ButtonGroup.group: tabGroup
                                     checked: index === 0
                                     indicator.visible: false

                                     contentItem: Text {
                                         text: parent.text
                                         font.pixelSize: 13
                                         font.weight: Font.Medium
                                         color: parent.checked ? "#ffffff" : "#94a3b8"
                                         horizontalAlignment: Text.AlignHCenter
                                         verticalAlignment: Text.AlignVCenter
                                     }

                                     background: Rectangle {
                                         visible: parent.checked
                                         color: "transparent"
                                         radius: 15
                                         implicitWidth: 80
                                         implicitHeight: 30

                                         gradient: Gradient {
                                             GradientStop {
                                                 position: 0.0
                                                 color: parent.hovered ? "#06b6d4" : "#0ea5e9"
                                             }
                                             GradientStop {
                                                 position: 1.0
                                                 color: parent.hovered ? "#0284c7" : "#0369a1"
                                             }
                                         }

                                         Rectangle {
                                             anchors.fill: parent
                                             radius: parent.radius
                                             gradient: Gradient {
                                                 GradientStop { position: 0.0; color: "#20FFFFFF" }
                                                 GradientStop { position: 0.5; color: "#00FFFFFF" }
                                             }
                                         }

                                         border.color: "#22d3ee"
                                         border.width: 1
                                     }
                                 }
                             }
                         }


                         StackLayout {
                             id: tabContent
                             Layout.fillWidth: true
                             Layout.fillHeight: true
                             currentIndex: tabGroup.checkedButton ? tabGroup.buttons.indexOf(tabGroup.checkedButton) : 0

                             Flickable {
                                 id: overviewPage
                                 clip: true
                                 contentHeight: overviewLayout.height
                                 Layout.fillWidth: true
                                 Layout.fillHeight: true

                                 ColumnLayout {
                                     id: overviewLayout
                                     anchors.fill: parent
                                     anchors.leftMargin: 10
                                     anchors.rightMargin: 10
                                     spacing: 15

                                     MetricCard {
                                         title: "Simulations Run"
                                         value: "100"
                                         valueColor: "#8b5cf6"
                                         iconSource: "qrc:/assets/icons/simulation_metric_icon.svg"
                                     }

                                     MetricCard {
                                         title: "Median Return"
                                         value: "+4.62%"
                                         valueColor: "#10b981"
                                         iconSource: "qrc:/assets/icons/median_return_icon.svg"
                                     }

                                     MetricCard {
                                         title: "Median Max Drawdown"
                                         value: "-18.5%"
                                         valueColor: "#f59e0b"
                                         iconSource: "qrc:/assets/icons/median_max_dd.svg"
                                     }

                                     MetricCard {
                                         title: "Sharpe Ratio (Median)"
                                         value: "0.92"
                                         valueColor: "#f59e0b"
                                         iconSource: "qrc:/assets/icons/sharpe_ratio_metric_icon.svg"
                                     }

                                     MetricCard {
                                         title: "Risk of Ruin"
                                         value: "0.00%"
                                         valueColor: "#10b981"
                                         iconSource: "qrc:/assets/icons/risk_of_ruin_icon.svg"
                                     }

                                     MetricCard {
                                         title: "Calmar Ratio"
                                         value: "2.1"
                                         valueColor: "#8b5cf6"
                                         iconSource: "qrc:/assets/icons/calmar_ratio.svg"
                                     }
                                 }
                             }


                             Flickable {
                                 id: returnsLayout
                                 clip: true
                                 contentHeight: overviewLayout.height
                                 Layout.fillWidth: true
                                 Layout.fillHeight: true

                                 ColumnLayout {
                                     anchors.fill: parent
                                     anchors.leftMargin: 10
                                     anchors.rightMargin: 10
                                     spacing: 15

                                     MetricCard {
                                         title: "Median Return"
                                         value: "+3.85%"
                                         valueColor: "#10b981"
                                         iconSource: "qrc:/assets/icons/percent_icon.svg"
                                     }

                                     MetricCard {
                                         title: "Mean Return"
                                         value: "+4.12%"
                                         valueColor: "#10b981"
                                         iconSource: "qrc:/assets/icons/percent_icon.svg"
                                     }

                                     MetricCard {
                                         title: "Best Case (99th %ile)"
                                         value: "+15.4%"
                                         valueColor: "#10b981"
                                         iconSource: "qrc:/assets/icons/percent_icon.svg"
                                     }

                                     MetricCard {
                                         title: "Worst Case (1st %ile)"
                                         value: "-6.8%"
                                         valueColor: "#ef4444"
                                         iconSource: "qrc:/assets/icons/trending_down_red_icon.svg"
                                     }

                                     MetricCard {
                                         title: "Profit Factor (Median)"
                                         value: "1.45"
                                         valueColor: "#0ea5e9"
                                         iconSource: "qrc:/assets/icons/profit_factor_trending_up.svg"
                                     }

                                     MetricCard {
                                         title: "Sharpe Ratio (Median)"
                                         value: "1.12"
                                         valueColor: "#f59e0b"
                                         iconSource: "qrc:/assets/icons/sharpe_ratio_metric_icon.svg"
                                     }
                                 }
                             }


                             Flickable {
                                 id: riskLayout
                                 clip: true
                                 contentHeight: overviewLayout.height
                                 Layout.fillWidth: true
                                 Layout.fillHeight: true

                                 ColumnLayout {
                                     anchors.fill: parent
                                     anchors.leftMargin: 10
                                     anchors.rightMargin: 10
                                     spacing: 15

                                     MetricCard {
                                         title: "Median Max Drawdown"
                                         value: "-18.5%"
                                         valueColor: "#f59e0b"
                                         iconSource: "qrc:/assets/icons/median_max_dd.svg"
                                     }

                                     MetricCard {
                                         title: "Best Case Max Drawdown"
                                         value: "-7.2%"
                                         valueColor: "#10b981"
                                         iconSource: "qrc:/assets/icons/best_case_dd.svg"
                                     }

                                     MetricCard {
                                         title: "Worst Case Max Drawdown (95th %ile)"
                                         value: "-32.8%"
                                         valueColor: "#ef4444"
                                         iconSource: "qrc:/assets/icons/trending_down_red_icon.svg"
                                     }

                                     MetricCard {
                                         title: "Value at Risk (95%)"
                                         value: "-4.5%"
                                         valueColor: "#ef4444"
                                         iconSource: "qrc:/assets/icons/worst_case_icon.svg"
                                     }

                                     MetricCard {
                                         title: "Risk of Ruin"
                                         value: "0.42%"
                                         valueColor: "#ef4444"
                                         iconSource: "qrc:/assets/icons/worst_case_icon.svg"
                                     }

                                     MetricCard {
                                         title: "Calmar Ratio (Median)"
                                         value: "0.25"
                                         valueColor: "#8b5cf6"
                                         iconSource: "qrc:/assets/icons/calmar_ratio.svg"
                                     }
                                 }
                             }



                             Flickable {
                                 id: tradesLayout
                                 clip: true
                                 contentHeight: overviewLayout.height
                                 Layout.fillWidth: true
                                 Layout.fillHeight: true

                                 ColumnLayout {
                                     anchors.fill: parent
                                     anchors.leftMargin: 10
                                     anchors.rightMargin: 10
                                     spacing: 15

                                     MetricCard {
                                         title: "Total Trades"
                                         value: "156"
                                         valueColor: "#8b5cf6"
                                         iconSource: "qrc:/assets/icons/total_trade_metric_icon.svg"
                                     }

                                     MetricCard {
                                         title: "Win Rate (Median)"
                                         value: "58%"
                                         valueColor: "#10b981"
                                         iconSource: "qrc:/assets/icons/target_green_icon.svg"
                                     }

                                     MetricCard {
                                         title: "Avg R/R Ratio"
                                         value: "1.8"
                                         valueColor: "#06b6d4"
                                         iconSource: "qrc:/assets/icons/avg_rr_icon.svg"
                                     }

                                     MetricCard {
                                         title: "Expectancy per Trade"
                                         value: "+$45"
                                         valueColor: "#10b981"
                                         iconSource: "qrc:/assets/icons/arrow_outward_icon.svg"
                                     }

                                     MetricCard {
                                         title: "Avg Loss"
                                         value: "-$180"
                                         valueColor: "#ef4444"
                                         iconSource: "qrc:/assets/icons/worst_case_icon.svg"
                                     }

                                     MetricCard {
                                         title: "Largest Win"
                                         value: "+$1,250"
                                         valueColor: "#10b981"
                                         iconSource: "qrc:/assets/icons/arrow_outward_icon.svg"
                                     }
                                 }
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

