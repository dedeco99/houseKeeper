const { response } = require("../utils/request");
const errors = require("../utils/errors");

const Grocery = require("../models/grocery");

async function getGroceries(event) {
	const { params } = event;
	const { store } = params;

	const groceries = await Grocery.find({ active: true, store }).lean();

	return response(200, "GET_GROCERIES", groceries);
}

async function addGrocery(event) {
	const { body } = event;
	const { name, category, store, quantity, price } = body;

	if (!name || !category || !store || !quantity) {
		return errors.requiredFieldsMissing;
	}

	const grocery = new Grocery({
		name,
		category,
		store,
		quantity,
		price,
	});

	await grocery.save();

	return response(201, "ADD_GROCERY", grocery);
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
