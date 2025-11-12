import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: root

    property alias title: titleText.text
    property alias value: valueText.text
    property alias valueColor: valueText.color
    property alias iconSource: iconImage.source

    color: "#151822"
    border.color: "#334155"
    border.width: 1
    radius: 8
    Layout.fillWidth: true
    Layout.preferredHeight: 70

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        spacing: 5

        RowLayout {
            Layout.fillWidth: true

            Text {
                id: titleText
                text: "Card Title"
                color: "#94a3b8"
                font.pixelSize: 13
                Layout.alignment: Qt.AlignVCenter
            }

            Item {
                Layout.fillWidth: true
            }

            Image {
                id: iconImage
                width: 16
                height: 16
                source: ""
                fillMode: Image.PreserveAspectFit
                Layout.alignment: Qt.AlignVCenter
                visible: source !== ""
                layer.enabled: true
            }
        }


        Text {
            id: valueText
            text: "Card Value"
            color: "#f0f9ff"
            font.pixelSize: 15
            font.weight: Font.Bold
        }
    }
}
