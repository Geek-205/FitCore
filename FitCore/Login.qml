import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls.Basic


Window {
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

                Item {
                    anchors.fill: parent

                    // Кастомная системная рамка
                    Rectangle {
                        id: titleBar
                        height: 25
                        width: 25
                        color: "#2D2D2D"
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right

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
                            Button {
                                id: minimizeButton
                                Layout.preferredWidth: 25
                                Layout.preferredHeight: 25
                                background: Rectangle {
                                    color: minimizeButton.hovered ? "#3A3A3A" : "transparent"
                                }
                                contentItem: Text {
                                    text: "─"
                                    color: "white"
                                    font.pixelSize: 16
                                    font.bold: true
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                onClicked: loginWindow.showMinimized()
                            }

                            // Кнопка "Закрыть"
                            Button {
                                id: closeButton
                                Layout.preferredWidth: 25
                                Layout.preferredHeight: 25
                                background: Rectangle {
                                    color: closeButton.hovered ? "white" : "transparent"
                                }
                                contentItem: Text {
                                    text: "✕"
                                    color: closeButton.hovered ? "#2D2D2D" : "white"
                                    font.pixelSize: 18
                                    font.bold: true
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                onClicked: loginWindow.close()
                            }
                        }
                    }


                    // Форма логина
                    Column {
                        id: loginForm
                        anchors.centerIn: parent
                        anchors.topMargin: 25  // чтобы не залезло на titleBar
                        spacing: 10

                        Text {
                            text: "FitCore"
                            color: "white"
                            font.pixelSize: 21
                            font.bold: true
                        }

                        TextField {
                            id: usernameField
                            placeholderText: "Username"
                            placeholderTextColor: "#787878"
                            width: 250
                            height: 30
                            color: "#2D2D2D"
                            font.pixelSize: 16

                            background: Rectangle {
                                id: bgusername
                                color: "#FFFFFF"
                                radius: 3
                                border.color: "#4E4E4E"
                                border.width: 1
                            }

                            focus: true
                            onActiveFocusChanged: {
                                if (activeFocus) {
                                    bgusername.border.color = "#FFFFFF"
                                } else {
                                    bgusername.border.color = "#888"
                                }
                            }
                        }

                        TextField {
                            id: passwordField
                            placeholderText: "Password"
                            placeholderTextColor: "#787878"
                            echoMode: TextInput.Password
                            width: 250
                            height: 30
                            color: "#2D2D2D"
                            font.pixelSize: 16

                            background: Rectangle {
                                id: bgpassword
                                color: "#FFFFFF"
                                radius: 3
                                border.color: "#4E4E4E"
                                border.width: 1
                            }

                            focus: true
                            onActiveFocusChanged: {
                                if (activeFocus) {
                                    bgpassword.border.color = "#FFFFFF"
                                } else {
                                    bgpassword.border.color = "#888"
                                }
                            }
                        }

                        Button {
                            text: "LOGIN"
                            width: 250
                            height: 40
                            font.pixelSize: 14
                            font.bold: true
                            background: Rectangle { color: "#3A3A3A" }
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
            loginbackend.requestMainWindow(); // 👈 новый метод
            loginWindow.close(); // Закрываем окно логина
        }

        function onLoginFailed(reason) {
            console.log("Login failed:", reason);
        }
    }
}
