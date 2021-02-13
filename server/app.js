const express = require("express");

if (!process.env.ENV || process.env.ENV === "dev") require("./utils/secrets"); // eslint-disable-line

const database = require("./utils/database");
const { middleware } = require("./utils/middleware");

const groceries = require("./functions/groceries");

database.connect(process.env.databaseConnectionString);

const app = express();

app.set("port", process.env.PORT || 5000);

app.use(express.json());

app.get("/api/groceries/:store", (req, res) => middleware(req, res, groceries.getGroceries));

app.listen(app.get("port"), () => {
	console.log("Listening on port", app.get("port"));
});
