express    = require 'express'
bodyParser = require('body-parser')
_s         = require "underscore.string"

# apply customizations to the express app
mount = (app) ->
  # set public dir assets # TODO: don't mount in prod option to use nginx
  app.use express.static "#{process.cwd()}/public"

  # use jade
  app.set 'view engine', 'jade'

  # parse req.body
  app.use bodyParser.json()
  app.use bodyParser.urlencoded( extended: true )

  app.use addCors

  app.locals._s = _s

  app


# custom middlewares
addLocals = (req, res, next) ->
  res.locals.requestPath = req.path
  res.locals.bodyClass   = req.path.split("/")[1] || "home"
  next()

addLocal = (app, key, value) ->
  app.locals[key] = value
  app

addCors = (req, res, next) ->
  res.header 'Access-Control-Allow-Origin',  '*'
  res.header 'Access-Control-Allow-Headers', 'GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS'
  res.header 'Access-Control-Allow-Headers', 'Content-Type'
  next()

module.exports =
  mount:      mount
  addLocals:  addLocals
  addLocal:   addLocal
