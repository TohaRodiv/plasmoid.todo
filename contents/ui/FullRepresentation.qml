import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.LocalStorage
import "TodoStorage.js" as TodoLogic
import org.kde.plasma.extras as PlasmaExtras

PlasmaExtras.Representation {
	collapseMarginsHint: true

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

	ListModel {
		id: listModel
	}

	Component.onCompleted: {
		const { TodoStorage } = TodoLogic
		const storage = new TodoStorage(LocalStorage)

		storage
			.getAll()
			.then((tasks) => listModel.append(tasks))
			.catch((error) => console.error("Error fetching tasks:", error))
	}
}