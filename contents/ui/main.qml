import QtQuick
import QtQuick.Layouts

import org.kde.coreaddons as KCoreAddons
import org.kde.kcmutils as KCMUtils
import org.kde.config as KConfig
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.kitemmodels as KItemModels

PlasmoidItem {
    id: root

    switchWidth: Kirigami.Units.gridUnit * 10
    switchHeight: Kirigami.Units.gridUnit * 10

	Plasmoid.icon: "klipper-symbolic"

    compactRepresentation: CompactRepresentation {
        property bool wasExpanded: false

        onPressed: wasExpanded = root.expanded
        onClicked: root.expanded = !wasExpanded
    }

    fullRepresentation: FullRepresentation {
        Layout.minimumWidth: 460
        Layout.preferredWidth: Kirigami.Units.gridUnit * 20

        Layout.minimumHeight: Kirigami.Units.gridUnit * 10
        Layout.maximumHeight: Kirigami.Units.gridUnit * 40
        Layout.preferredHeight: implicitHeight
    }
}
