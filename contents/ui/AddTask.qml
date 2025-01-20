import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.LocalStorage
import "TodoStorage.js" as TodoLogic

Row {
	required property var model
	spacing: 5
	topPadding: 10

	TextField {
		id: textField
		placeholderText: 'Название задачи'
		width: 350
	}

	Button {
		id: button
		text: 'Добавить'
		width: 80

		onClicked: {
			const { TodoStorage } = TodoLogic
			const storage = new TodoStorage(LocalStorage)

			storage
				.create({
					title: textField.text,
					description: '',
				})
				.then(task => {
					textField.text = ''
					listModel.insert(0, task);
				})
				.catch(error => console.error(error))
		}
	}
}