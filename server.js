const express = require("express"),
  app = express()
  port = process.env.PORT || 3337

  app.listen(port)

  console.log(`API Server started on: ${port}`);