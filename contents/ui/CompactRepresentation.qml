import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami


MouseArea {
	property bool wasExpanded: false

	onPressed: wasExpanded = root.expanded
	onClicked: root.expanded = !wasExpanded

	Kirigami.Icon {
		source: "view-calendar-list"
		fallback: "view-refresh"
		anchors.fill: parent
	}
}
