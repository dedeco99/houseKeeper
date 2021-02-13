const { Schema, model } = require("mongoose");

const GrocerySchema = new Schema(
	{
		active: { type: Boolean, default: true },
		/*
		user: { type: Schema.ObjectId, ref: "User" },
		family: { type: Schema.ObjectId, ref: "Family" },
		*/
		name: { type: String, required: true },
		category: { type: String, required: true },
		store: { type: String, required: true },
		quantity: { type: Number, required: true },
		price: { type: Number },
	},
	{ timestamps: { createdAt: "_created", updatedAt: "_modified" } },
);

const Grocery = model("Grocery", GrocerySchema);

module.exports = Grocery;
