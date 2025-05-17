import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls.Basic
ApplicationWindow {
    id: loginWindow
    maximumHeight: 200
    maximumWidth: 500
    minimumHeight: 200
    minimumWidth: 500
    visible: true
    title: "FitCore Login"
    flags: Qt.FramelessWindowHint | Qt.Window
    color: "black"

    Rectangle {
        anchors.fill: parent
        color: "black"

        RowLayout {
            anchors.fill: parent
            spacing: 0

            // Левая часть с рамкой
            Rectangle {
                id: leftPanel
                Layout.preferredWidth: 300
                Layout.fillHeight: true
                color: "#2D2D2D"

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    // Кастомная системная рамка
                    Rectangle {
                        id: titleBar
                        height: 25
                        width: parent.width
                        color: "#2D2D2D"
                        Layout.alignment: Qt.AlignTop
                        Layout.fillWidth: true

                        RowLayout {
                            anchors.fill: parent
                            spacing: 0

                            // Перетаскиваемая зона — пустая левая часть
                            MouseArea {
                                id: dragArea
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                onPressed: {
                                    loginWindow.startSystemMove();
                                }
                            }

                            // Кнопка "Свернуть"
                            MouseArea {
                                id: minimizeArea
                                width: 25
                                height: 25
                                onClicked: loginWindow.showMinimized()
                                hoverEnabled: true
                                onEntered: cursorShape = Qt.PointingHandCursor
                                onExited: cursorShape = Qt.ArrowCursor

                                Image {
                                    source: "qrc:/images/-.png"
                                    anchors.centerIn: parent
                                    width: 20
                                    height: 20
                                    fillMode: Image.PreserveAspectFit
                                }
                            }

                            // Кнопка "Закрыть"
                            MouseArea {
                                id: closeArea
                                width: 25
                                height: 25
                                onClicked: loginWindow.close()
                                hoverEnabled: true
                                onEntered: cursorShape = Qt.PointingHandCursor
                                onExited: cursorShape = Qt.ArrowCursor

                                Image {
                                    source: "qrc:/images/x.png"
                                    anchors.centerIn: parent
                                    width: 20
                                    height: 20
                                    fillMode: Image.PreserveAspectFit
                                }
                            }
                        }
                    }


                    // Форма логина
                    Column {
                        anchors.centerIn: parent
                        spacing: 10 // 20

                        Text {
                            text: "FitCore"
                            color: "white"
                            font.pixelSize: 21
                            font.bold: true
                        }

                        TextField {
                            id: usernameField
                            placeholderText: "Username"
                            width: 250
                            height: 30
                            color: "#2D2D2D"
                            font.pixelSize: 16

                            background: Rectangle {
                                color: "#FFFFFF"
                                radius: 3
                                border.color: "#4E4E4E"
                                border.width: 1
                            }

                            focus: true
                            onActiveFocusChanged: {
                                if (activeFocus) {
                                    background.border.color = "#FFFFFF"
                                } else {
                                    background.border.color = "#888"
                                }
                            }
                        }

                        TextField {
                            id: passwordField
                            placeholderText: "Password"
                            echoMode: TextInput.Password
                            width: 250
                            height: 30
                            color: "#2D2D2D"
                            font.pixelSize: 16

                            background: Rectangle {
                                color: "#FFFFFF"
                                radius: 3
                                border.color: "#4E4E4E"
                                border.width: 1
                            }

                            focus: true
                            onActiveFocusChanged: {
                                if (activeFocus) {
                                    background.border.color = "#FFFFFF"
                                } else {
                                    background.border.color = "#888"
                                }
                            }
                        }

                        Button {
                            text: "LOGIN"
                            width: 250
                            font.pixelSize: 14
                            font.bold: true
                            onClicked: {
                                if (usernameField.text === "" || passwordField.text === "") {
                                    console.log("Please enter both username and password");
                                    return;
                                }
                                loginbackend.verifyCredentials(usernameField.text, passwordField.text);
                            }
                        }
                    }
                }
            }

            // Правая часть с логотипом (без рамки)
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "white"

                Image {
                    source: "qrc:/images/LogoLogin.png"
                    anchors.centerIn: parent
                    width: 200
                    height: 200
                    fillMode: Image.PreserveAspectFit
                }
            }
        }
    }

    // Связь с backend
    Connections {
        target: loginbackend

        function onLoginSuccess() {
            console.log("Login successful");
            var component = Qt.createComponent("Main.qml");
            if (component.status === Component.Ready) {
                var window = component.createObject(null);
                window.visible = true;
            } else {
                console.log("Failed to load Main.qml:", component.errorString());
            }
            loginWindow.close();
        }

        function onLoginFailed(reason) {
            console.log("Login failed:", reason);
        }
    }
}
