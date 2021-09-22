const express = require("express"),
  app = express();
(port = process.env.PORT || 3337),
  (mongoose = require("mongoose")),
  (Task = require("./models/todoListModel"));
bodyParser = require("body-parser");

const routes = require("./routes/todoListRoutes");

//  mongoose instance connection url connection
mongoose.Promise = global.Promise;
mongoose.connect("mongodb://localhost/Tododb");

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
routes(app);

//  Handle invalid routes
app.get("*", (req, res) => {
  res.status(404).send({ url: req.originalUrl + " not found" });
});

app.listen(port);

console.log(`API Server started on: ${port}`);
