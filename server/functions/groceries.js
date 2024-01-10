const database = require("../utils/database");
const { response } = require("../utils/request");
const errors = require("../utils/errors");

async function getGroceries() {
	const groceries = await database.query("SELECT * FROM grocery WHERE active = true ORDER BY created DESC");

	return response(200, "GET_GROCERIES", groceries.rows);
}

async function addGrocery(event) {
	const { body } = event;
	const { name, category, quantity, price } = body;

	if (!name) return errors.requiredFieldsMissing;

	const fields = {
		id: null,
		active: null,
		name,
		category,
		default_price: price,
		default_quantity: quantity,
		created: null,
	};

	const keys = [];
	const values = [];
	for (const field in fields) {
		if (fields[field]) {
			keys.push(field);
			values.push(fields[field]);
		}
	}

	let grocery = null;
	try {
		const result = await database.query(
			`
			INSERT INTO grocery (${keys.join(",")}) VALUES (${keys.map((_k, i) => `$${i + 1}`)})
			RETURNING ${Object.keys(fields).join(",")};
			`,
			values,
		);

		grocery = result.rows[0];
	} catch (err) {
		console.log(err);

		return errors.badRequest;
	}

	return response(201, "ADD_GROCERY", grocery);
}

async function deleteGrocery(event) {
	const { params } = event;
	const { id } = params;

	let grocery = null;
	try {
		const result = await database.query("UPDATE grocery SET active = NOT active WHERE id = $1 RETURNING id", [id]);

		if (result.rowCount === 0) return errors.notFound;

		grocery = result.rows[0];
	} catch (err) {
		console.log(err);

		return errors.badRequest;
	}

	return response(200, "DELETE_GROCERY", grocery);
}

module.exports = {
	getGroceries,
	addGrocery,
	deleteGrocery,
};
