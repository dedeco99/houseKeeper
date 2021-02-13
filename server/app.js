const express = require("express");

const { middleware } = require("./utils/middleware");
const { response } = require("./utils/request");

const app = express();

app.set("port", process.env.PORT || 5000);

app.use(express.json());

app.get("/api/groceries/:store", (req, res) =>
  middleware(req, res, (event) => {
    const { params } = event;
    const { store } = params;

    switch (store) {
      case "lidl":
        return response(200, "GET_GROCERIES", [
          { name: "Leite", quantity: 3, price: 1.5 },
          { name: "Cereais", quantity: 2, price: 2.35 },
        ]);
      case "continente":
        return response(200, "GET_GROCERIES", [
          { name: "Ketchup", quantity: 2, price: 0.99 },
          { name: "Croutons", quantity: 3, price: 4.65 },
        ]);
      default:
        return response(404, "NOT_FOUND");
    }
  })
);

app.listen(app.get("port"), () => {
  console.log("Listening on port", app.get("port"));
});
