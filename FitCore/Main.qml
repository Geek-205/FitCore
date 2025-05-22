import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls.Basic

ApplicationWindow {
    id: mainWindow
    minimumWidth: 1280
    minimumHeight: 720
    visible: true
    title: qsTr("FitCore")
    //flags: Qt.FramelessWindowHint | Qt.Window
    color: "#1E1E1E"

        // Список всех вкладок
        property var tabList: ["Dashboard", "Members", "Memberships", "Payments", "Visits", "Classes", "Reports", "Settings"]

        // Список доступных вкладок из C++
        property var availableTabs: []

        // Текущий индекс вкладки
        property int currentTabIndex: 0

        Component.onCompleted: {
            availableTabs = userSession.availableTabs  // Получаем из C++
        }

        GridLayout {
            columns: 2
            rows: 4
            rowSpacing: 0
            columnSpacing: 0
            anchors.fill: parent

            Rectangle {
                id: userInfo
                Layout.preferredHeight: 112
                Layout.preferredWidth: 240
                Layout.rowSpan: 2
                color: "#373737"
            }

            Rectangle {
                id: titleBar
                Layout.preferredHeight: 30
                Layout.fillWidth: true
                color: "#2D2D2D"
            }

            Rectangle {
                id: toolBar
                Layout.preferredHeight: 82
                Layout.fillWidth: true
                color: "#FFFFFF"
            }

            // TAB BAR
            Rectangle {
                id: tabBar
                Layout.preferredWidth: 240
                Layout.fillHeight: true
                color: "#2D2D2D"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 8

                    Repeater {
                        model: tabList.length

                        Button {
                            text: tabList[index]
                            enabled: availableTabs.includes(tabList[index])
                            opacity: enabled ? 1.0 : 0.4
                            Layout.fillWidth: true
                            font.pixelSize: 16
                            background: Rectangle {
                                color: enabled ? "#444" : "#222"
                                radius: 6
                            }
                            onClicked: {
                                currentTabIndex = index
                            }
                        }
                    }
                }
            }

            // WORK AREA
            Rectangle {
                id: workArea
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "#373737"

                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 64
                    color: "white"
                    text: (currentTabIndex + 1).toString()
                }
            }

            Rectangle {
                id: dataPanel
                Layout.preferredHeight: 35
                Layout.columnSpan: 2
                Layout.fillWidth: true
                color: "#FFFFFF"
            }
        }
    }
