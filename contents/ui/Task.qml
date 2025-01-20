import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.LocalStorage
import "TodoStorage.js" as TodoLogic
import org.kde.kirigami as Kirigami


GridLayout {
	columns: 5
	width: parent.width

	CheckBox {
		id: checkBox
	}

	TextField {
		id: textField
		text: name
		Layout.fillWidth: true
	}

	Button {
		icon.source: "document-save-symbolic"

		onClicked: {
			const { TodoStorage } = TodoLogic
			const storage = new TodoStorage(LocalStorage)

			storage
				.update(id, { title: textField.text, is_completed: checkBox.checked })
				.then((task) => {
					console.log('Task updated:', task);
                })
				.catch((error) => {
                    console.error('Error updating task:', error);
                });
			
			listModel.setProperty(index, 'name', textField.text);
			listModel.setProperty(index, 'is_completed', checkBox.checked);
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