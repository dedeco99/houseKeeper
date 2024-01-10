const express = require("express");

const { middleware } = require("./utils/middleware");

const groceries = require("./functions/groceries");

const app = express();

app.set("port", process.env.PORT || 5000);

app.use(express.json());

app.get("/api/groceryLists", (req, res) => middleware(req, res, groceries.getGroceryLists));

app.get("/api/groceries", (req, res) => middleware(req, res, groceries.getGroceries));

app.post("/api/groceries", (req, res) => middleware(req, res, groceries.addGrocery));

app.delete("/api/groceries/:id", (req, res) => middleware(req, res, groceries.deleteGrocery));

app.listen(app.get("port"), () => {
	console.log("Listening on port", app.get("port"));
});
