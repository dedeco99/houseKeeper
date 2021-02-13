const { response } = require("../utils/request");

const Grocery = require("../models/grocery");

async function getGroceries(event) {
	const { params } = event;
	const { store } = params;

	const groceries = await Grocery.find({ active: true, store }).lean();

	return response(200, "GET_GROCERIES", groceries);
}

module.exports = {
	getGroceries,
};
