class TodoStorage {
	constructor(storage) {
		const db_name = 'toharodiv.todo';
		const db_version = '1.0';
		const db_display_name = 'Список задач';
		const db_size = 1000000;

		this.db = storage.openDatabaseSync(db_name, db_version, db_display_name, db_size);
		this._createTables();
	}

	/**
	 * @param {{ title: string, description: string }} CreateTodoDto 
	 */
	create(CreateTodoDto) {
		return new Promise((resolve, reject) => {
			this.db.transaction(tx => {
				const { title, description } = CreateTodoDto;
				const result = tx.executeSql('INSERT INTO todos (title, description) VALUES (?,?)', [title, description]);
				const newTaskId = +result.insertId;

				this
					.getById(newTaskId)
					.then(task => resolve(task))
					.catch(reject);
			});
		});
	}

	getById(id) {
		return new Promise((resolve, reject) => {
			this.db.transaction((tx) => {
				const result = tx.executeSql('SELECT * FROM todos WHERE id =?', [id]);

				if (result.rows.length > 0) {
					const todo = {
						id: result.rows.item(0).id,
						name: result.rows.item(0).title,
						description: result.rows.item(0).description,
						isCompleted: result.rows.item(0).is_completed === 1,
						createdAt: this._formatDateTime(new Date(result.rows.item(0).created_at)),
						updatedAt: this._formatDateTime(new Date(result.rows.item(0).updated_at)),
					};

					resolve(todo);
				} else {
					reject('Todo not found');
				}
			});
		});
	}

	getAll() {
		return new Promise((resolve, reject) => {
			this.db.transaction((tx) => {
				const todos = [];
				const result = tx.executeSql('SELECT * FROM todos ORDER BY created_at DESC');



				for (let i = 0; i < result.rows.length; i++) {
					const todo = {
						id: result.rows.item(i).id,
						name: result.rows.item(i).title,
						description: result.rows.item(i).description || '',
						isCompleted: result.rows.item(i).is_completed === 1,
						createdAt: this._formatDateTime(new Date(result.rows.item(i).created_at)),
						updatedAt: this._formatDateTime(new Date(result.rows.item(i).updated_at)),
					};

					todos.push(todo);
				}

				resolve(todos);
			});
		});
	}

	/**
	 * 
	 * @param {number} id 
	 * @param {{ title: string, description: string, is_completed }} UpdateTodoDto 
	 */
	update(id, UpdateTodoDto) {
		return new Promise((resolve, reject) => {
			this.db.transaction((tx) => {
				const { title, description, is_completed } = UpdateTodoDto;
				let result;

				if (!('description' in UpdateTodoDto)) {
					result = tx.executeSql('UPDATE todos SET title =?, is_completed =?, updated_at = CURRENT_TIMESTAMP WHERE id =?', [title, is_completed ? 1 : 0, id]);
				} else {
					result = tx.executeSql('UPDATE todos SET title =?, description =?, is_completed =?, updated_at = CURRENT_TIMESTAMP WHERE id =?', [title, description, is_completed ? 1 : 0, id]);
				}


				if (result.rowsAffected > 0) {
					this.getById(id)
						.then(task => resolve(task))
						.catch(reject);
				} else {
					reject('Todo not found');
				}
			});
		});
	}

	delete(id) {
		return new Promise((resolve, reject) => {
			this.db.transaction((tx) => {
				const result = tx.executeSql('DELETE FROM todos WHERE id =?', [id]);

				if (result.rowsAffected > 0) {
					resolve();
				} else {
					reject('Todo not found');
				}
			});
		});
	}

	_createTables() {
		try {
			this.db.transaction(function (tx) {
				tx.executeSql(`CREATE TABLE IF NOT EXISTS todos (id INTEGER PRIMARY KEY, title TEXT, description TEXT DEFAULT "", is_completed INTEGER DEFAULT 0, created_at TEXT DEFAULT CURRENT_TIMESTAMP, updated_at TEXT DEFAULT CURRENT_TIMESTAMP)`);
			});
		} catch (error) {
			console.error('Error initializing database:', error);
		}
	}

	_formatDateTime(date) {
		const options = {
			era: 'long',
			year: 'numeric',
			month: 'long',
			day: 'numeric',
			weekday: 'long',
			timezone: 'UTC',
			hour: 'numeric',
			minute: 'numeric',
			second: 'numeric'
		};

		return date.toLocaleString('ru', options);
	}
}