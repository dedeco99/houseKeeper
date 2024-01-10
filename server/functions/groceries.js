const database = require("../utils/database");
const { response } = require("../utils/request");
const errors = require("../utils/errors");

async function getGroceries() {
	const groceries = await database.query("SELECT * FROM grocery");

	return response(200, "GET_GROCERIES", groceries.rows);
}

async function addGrocery(event) {
	const { body } = event;
	const { name, category, quantity, price } = body;

	if (!name) return errors.requiredFieldsMissing;

	const fields = { name, category, default_price: price, default_quantity: quantity };

	const keys = [];
	const values = [];
	for (const field in fields) {
		if (fields[field]) {
			keys.push(field);
			values.push(fields[field]);
		}
	}

	try {
		await database.query(
			`
			INSERT INTO grocery (${keys.join(",")})
			VALUES (${keys.map((_k, i) => `$${i + 1}`)})
			`,
			values,
		);
	} catch (err) {
		console.log(err);

		return errors.badRequest;
	}

	return response(201, "ADD_GROCERY");
}

async function deleteGrocery(event) {
	const { params } = event;
	const { id } = params;

	let grocery = null;
	try {
		grocery = await Grocery.findOne({ _id: id }, "active");

		if (!grocery) return errors.notFound;

		grocery = await Grocery.findOneAndUpdate({ _id: id }, { active: !grocery.active }, { new: true });
	} catch (e) {
		return errors.notFound;
	}

	return response(200, "DELETE_GROCERY", grocery);
}

module.exports = {
	getGroceries,
	addGrocery,
	deleteGrocery,
};
