import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls.Basic

Window {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("FitCore")

    property var availableTabs: []

        Component.onCompleted: {
            availableTabs = userSession.availableTabs
        }

    TabBar {
        TabButton {
            text: "Dashboard"
            visible: root.availableTabs.includes("Dashboard")
        }

        TabButton {
            text: "Members"
            visible: root.availableTabs.includes("Members")
        }

        TabButton {
            text: "Memberships"
            visible: root.availableTabs.includes("Memberships")
        }

        TabButton {
            text: "Payments"
            visible: root.availableTabs.includes("Payments")
        }

        TabButton {
            text: "Visits"
            visible: root.availableTabs.includes("Visits")
        }

        TabButton {
            text: "Classes"
            visible: root.availableTabs.includes("Classes")
        }

        TabButton {
            text: "Reports"
            visible: root.availableTabs.includes("Reports")
        }

        TabButton {
            text: "Settings"
            visible: root.availableTabs.includes("Settings")
        }
    }
}
