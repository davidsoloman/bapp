express    = require 'express'
bodyParser = require('body-parser').json
_s         = require "underscore.string"

# apply customizations to the express app
mount = (app) ->
  # set public dir assets # TODO: don't mount in prod option to use nginx
  app.use express.static "#{process.cwd()}/public"

  # use jade
  app.set 'view engine', 'jade'

  # parse req.body
  app.use bodyParser()

  app.locals._s = _s

  app


# custom middlewares
addLocals = (req, res, next) ->
  res.locals.requestPath = req.path
  res.locals.bodyClass   = req.path.split("/")[1] || "home"
  next()


module.exports =
  mount:      mount,
  addLocals:  addLocals,
