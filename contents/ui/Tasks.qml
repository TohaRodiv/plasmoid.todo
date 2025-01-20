import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami 2.20 as Kirigami


PlasmaComponents3.ScrollView {
	property alias model: listView.model

	id: scrollView
	width: 450
	height: 350
	y: 50

	contentItem: ListView {
		id: listView
		

		topMargin: Kirigami.Units.largeSpacing * 2
		bottomMargin: Kirigami.Units.largeSpacing
		spacing: Kirigami.Units.mediumSpacing

		delegate: Task {
		}
	}
}