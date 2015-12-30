// Generated by CoffeeScript 1.10.0
(function() {
  var addLocals, api, app, bodyParser, env, express, routesApi;

  express = require('express');

  bodyParser = require('body-parser').json;

  app = express();

  app.port = process.env.PORT || 3000;

  env = process.env.NODE_ENV || "development";

  app.use(express["static"](process.cwd() + '/public'));

  app.set('view engine', 'jade');

  app.use(bodyParser());

  addLocals = function(req, res, next) {
    res.locals.requestPath = req.path;
    res.locals.bodyClass = req.path.split("/")[1] || "home";
    return next();
  };

  app.get('/', function(req, res) {
    return res.render('index.jade');
  });

  routesApi = [];

  api = express.Router();

  api.get('/', function(req, res) {
    var message;
    message = "API endpoints available: '" + (routesApi.join(', ')) + "'";
    return res.json({
      message: message
    });
  });

  app.use(addLocals);

  app.use('/api', api);

  module.exports = app;

}).call(this);