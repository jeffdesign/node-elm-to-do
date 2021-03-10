"use strict";
module.exports = function (app) {
  const todoList = require("../controllers/todoListController");

  // todoLists Routes
  app.route("/tasks").get(todoList.get_tasks).post(todoList.create_task);

  // specific todoList Routes
  app
    .route("/tasks/:taskId")
    .get(todoList.get_task)
    .put(todoList.update_task)
    .delete(todoList.delete_task);


};
