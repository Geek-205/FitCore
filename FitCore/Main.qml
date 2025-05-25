import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls.Basic

Window  {
    id: mainWindow
    minimumWidth: 1280
    minimumHeight: 720
    visible: true
    title: "FitCore"
    flags: Qt.FramelessWindowHint | Qt.Window
    color: "#1E1E1E"

    // Список всех вкладок
    property var tabList: ["Dashboard", "Members", "Memberships", "Payments", "Visits", "Classes", "Reports", "Settings"]
    // Список доступных вкладок из C++
    property var availableTabs: []
    // Текущий индекс вкладки
    property int currentTabIndex: 0

    Component.onCompleted: {
        availableTabs = userSession.availableTabs
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

        // Кастомная системная рамка (title bar)
        Rectangle {
            id: titleBar
            Layout.preferredHeight: 30
            Layout.fillWidth: true
            color: "#2D2D2D"

            MouseArea {
                anchors.fill: parent
                onPressed: (mouseEvent) => {
                    if (mouseEvent.button === Qt.LeftButton)
                        mainWindow.startSystemMove();
                }

                onDoubleClicked: {
                    if (mainWindow.visibility === Window.Maximized)
                        mainWindow.showNormal()
                    else
                        mainWindow.showMaximized()
                }
            }

            RowLayout {
            anchors.fill: parent

                // Перетаскиваемая область (растягивается по ширине)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "transparent"

                    MouseArea {
                        anchors.fill: parent
                        drag.target: null
                        onPressed: (mouseEvent) => {
                            if (mouseEvent.button === Qt.LeftButton)
                                mainWindow.startSystemMove()
                        }
                    }
                }

                // Кнопки управления окном
                RowLayout {
                    id: windowControls
                    spacing: 0
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                    // Свернуть
                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 45
                        color: hoverMinimize ? "#3A3A3A" : "transparent"

                        property bool hoverMinimize: false

                        Text {
                            anchors.centerIn: parent
                            text: "─"
                            color: "white"
                            font.pixelSize: 18
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: mainWindow.showMinimized()
                        }
                    }

                    // Развернуть / Восстановить
                    Rectangle {
                        Layout.preferredWidth: 45
                        Layout.preferredHeight: parent.height
                        color: hoverMaximize ? "#3A3A3A" : "transparent"

                        property bool hoverMaximize: false

                        Text {
                            anchors.centerIn: parent
                            text: mainWindow.visibility === Window.Maximized ? "🗗" : "🗖"
                            color: "white"
                            font.pixelSize: 16
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.hoverMaximize = true
                            onExited: parent.hoverMaximize = false
                            onClicked: {
                                if (mainWindow.visibility === Window.Maximized) {
                                    mainWindow.showNormal()
                                }
                                else {
                                    mainWindow.showMaximized()
                                }
                            }
                        }
                    }

                    // Закрыть
                    Rectangle {
                        Layout.preferredWidth: 45
                        Layout.preferredHeight: parent.height
                        color: hoverClose ? "#C42B1C" : "transparent"

                        property bool hoverClose: false

                        Text {
                            anchors.centerIn: parent
                            text: "✕"
                            color: "white"
                            font.pixelSize: 18
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.hoverClose = true
                            onExited: parent.hoverClose = false
                            onClicked: Qt.quit()
                        }
                    }
                }
            }
        }

        Rectangle {
            id: toolBar
            Layout.preferredHeight: 82
            Layout.fillWidth: true
            color: "#FFFFFF"
        }

        Rectangle {
            id: tabBar
            Layout.preferredWidth: 240
            Layout.fillHeight: true
            color: "#2D2D2D"

            Column {
                anchors.top: parent.top
                width: parent.width
                spacing: 0

                Repeater {
                    model: mainWindow.tabList.filter(tab => mainWindow.availableTabs.includes(tab))

                    delegate:
                        Button {
                            id: tabButton
                            text: modelData
                            height: 70
                            width: parent.width
                            font.pixelSize: 16
                            background: Rectangle {
                                anchors.fill: parent
                                radius: 0
                                color: tabButton.hovered ? "#575757" : (modelData === mainWindow.tabList[mainWindow.currentTabIndex] ? "#2D2D2D" : "#2D2D2D")
                            }
                        onClicked: {
                            mainWindow.currentTabIndex = mainWindow.tabList.indexOf(modelData)
                        }
                    }
                }
            }
        }

        Rectangle {
            id: workArea
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "#373737"

            Text {
                anchors.centerIn: parent
                font.pixelSize: 64
                color: "white"
                text: (mainWindow.currentTabIndex + 1).toString()
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
