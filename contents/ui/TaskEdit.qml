import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.LocalStorage
import "TodoStorage.js" as TodoLogic

Item {
	property var task: null
	property int taskIndex: -1
	property int margins: 10
	property int minimumWidth: 550

	id: taskEditView

	ScrollView {
		id: taskEditScrollView
		height: 450

		ColumnLayout {
			spacing: 5

			TextArea {
				id: taskName
				text: task.name
				Layout.maximumWidth: minimumWidth
				Layout.minimumWidth: minimumWidth
				Layout.margins: margins
			}

			CheckBox {
				id: taskCompleted
				text: "Выполнено"
				checked: task.isCompleted
				Layout.margins: margins
			}

			Flickable {
				id: flick

				Layout.minimumWidth: minimumWidth;
				height: 200;
				contentWidth: 400
				contentHeight: 400
				clip: true
				Layout.margins: margins

				function ensureVisible(r)
				{
					if (contentX >= r.x)
						contentX = r.x;
					else if (contentX+width <= r.x+r.width)
						contentX = r.x+r.width-width;
					if (contentY >= r.y)
						contentY = r.y;
					else if (contentY+height <= r.y+r.height)
						contentY = r.y+r.height-height;
				}

				TextEdit {
					id: editDescription
					width: flick.width
					height: flick.height
					font.family: "Arial"
					font.pointSize: 13
					wrapMode: TextEdit.Wrap
					onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
					color: "white"
					text: task.description
				}
			}

			Column {
				Layout.margins: margins
				
				Text {
					color: 'white'
					text: `Создана: ${task.createdAt}`
				}

				Text {
					color: 'white'
					text: `Изменена: ${task.updatedAt}`
				}
			}

			Row {
				spacing: 5
				Layout.margins: margins

				Button {
					text: "Сохранить"
					icon.source: 'document-save'

					onClicked: {
						const { TodoStorage } = TodoLogic
						const storage = new TodoStorage(LocalStorage)

						storage
							.update(task.id, { title: taskName.text, is_completed: taskCompleted.checked, description: editDescription.text })
							.then((task) => {
								listModel.setProperty(taskIndex, 'name', taskName.text);
								listModel.setProperty(taskIndex, 'isCompleted', taskCompleted.checked);
								listModel.setProperty(taskIndex, 'description', editDescription.text);
								listModel.setProperty(taskIndex, 'updatedAt', task.updatedAt);
								listModel.setProperty(taskIndex, 'createdAt', task.createdAt);

								stackView.popCurrentItem()
							})
							.catch((error) => {
								console.error('Error updating task:', error);
							});
					}
				}

				Button {
					text: 'Назад'
					icon.source: 'dialog-cancel'

					onClicked: {
						stackView.popCurrentItem()
					}
				}
			}
		}
	}
}