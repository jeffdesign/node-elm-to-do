// Methods:
// list_all_tasks
// create_a_task
// read_a_task
// update_a_task
// delete_a_task

const mongoose = require("moongose"),
  Task = mongoose.model("Tasks");

//  Resolve listing all tasks
exports.list_all_tasks = (_, response) => {
  Task.find({}, (error, task) => {
    if (error) {
      response.send(error);
    }
    response.json(task);
  });
};

//  Resolve creating a new task
exports.create_a_task = (request, response) => {
  new Task(request.body).save((error, task) => {
    if (error) {
      response.send(error);
    }
    response.json(task);
  });
};

//  Resolve reading a task
exports.read_a_task = (request, response) => {
  Task.findById(request.params.taskId, (error, task) => {
    if (error) {
      response.send(error);
    }
    response.json(task);
  });
};

//  Resolve updating a task
exports.update_a_task = (request, response) => {
  Task.findOneAndUpdate(
    { id: request.params.taskId },
    request.body,
    { new: true },
    (error, task) => {
      if (error) {
        response.send(error);
      }
      response.json(task);
    }
  );
};

//  Resolve deleting a task
exports.delete_a_task = (request, response) => {
  Task.remove({ id: request.params.taskId }, (error, task) => {
    if (error) {
      response.send(error);
    }
    response.json({ message: `Task ${task.name} successfully deleted` });
  });
};
