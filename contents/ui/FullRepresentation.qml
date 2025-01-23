import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.LocalStorage
import "TodoStorage.js" as Logic
import org.kde.kirigami as Kirigami
import org.kde.plasma.extras as PlasmaExtras

PlasmaExtras.Representation {
	collapseMarginsHint: true
	
	Layout.minimumWidth: Kirigami.Units.gridUnit * 24
	Layout.minimumHeight: Kirigami.Units.gridUnit * 24
	Layout.maximumWidth: Kirigami.Units.gridUnit * 80
	Layout.maximumHeight: Kirigami.Units.gridUnit * 40

	StackView {
		id: stackView
		focus: true
		initialItem: tasksView

		Component {
			id: tasksView

			Item {
				AddTask {
					model: listModel
					x: 10
				}

				Tasks {
					model: listModel
					x: 10
				}
			}
		}

		Component {
			id: taskEditView

			TaskEdit {}
		}
	}

	ListModel {
		id: listModel
	}

	Component.onCompleted: {
		const { TodoStorage } = Logic
			const storage = new TodoStorage(LocalStorage)

			storage
			.getAll()
			.then((tasks) => listModel.append(tasks))
			.catch((error) => console.error("Error fetching tasks:", error))
		}
	}