import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.LocalStorage
import "TodoStorage.js" as TodoLogic
import org.kde.kirigami as Kirigami


GridLayout {
	columns: 4
	width: parent.width

	CheckBox {
		id: checkBox
		checked: isCompleted
	}

	TextArea {
		id: textField
		text: name
		Layout.fillWidth: true
		color: 'white'
	}

	Button {
		icon.source: "view-visible"

		onClicked: {
			stackView.push(taskEditView, { task: model, taskIndex: index })
		}
	}

	Button {
		icon.source: "delete-symbolic"

		onClicked: {
			const { TodoStorage } = TodoLogic
			const storage = new TodoStorage(LocalStorage)

			storage
                .delete(id)
                .then(() => {
					listModel.remove(index, 1)
                })
				.catch((error) => {
                    console.error('Error deleting task:', error);
                });
		}
	}
}