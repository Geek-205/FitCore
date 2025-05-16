import QtQuick
import QtQuick.Controls
import QtQuick.Window

Window {
    id: loginWindow
    visible: true
    width: 400
    height: 300
    title: qsTr("Login")

    // Подключение сигналов от C++ бэкенда
    Connections {
        target: loginbackend

        function onLoginSuccess() {
            console.log("Login successful");
            // Загрузка главного окна
            var component = Qt.createComponent("Main.qml");
            if (component.status === Component.Ready) {
                var window = component.createObject(null);
                window.visible = true;
            } else {
                console.log("Failed to load Main.qml:", component.errorString());
            }


            // Закрываем окно входа
            loginWindow.close();
        }

        function onLoginFailed(reason) { console.log("Login failed:", reason); }
    }

    Rectangle {
        anchors.fill: parent
        color: "#f0f0f0"

        Column {
            anchors.centerIn: parent
            spacing: 10

            TextField {
                id: usernameField
                placeholderText: "Username"
                width: 200
            }

            TextField {
                id: passwordField
                placeholderText: "Password"
                echoMode: TextInput.Password
                width: 200
            }

            Button {
                text: "Login"
                width: 200
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
