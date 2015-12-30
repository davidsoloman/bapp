express    = require 'express'
bodyParser = require('body-parser').json


app = express()

app.port = process.env.PORT || 3000
env = process.env.NODE_ENV  || "development"

# set public dir assets # TODO: don't mount in prod option to use nginx
app.use express.static(process.cwd() + '/public')

# use jade
app.set 'view engine', 'jade'

# parse req.body
app.use bodyParser()

# initialize routes
#
# routes = require './routes'
# routes app

# TODO: locals (bodyClass)

app.get '/', (req, res) ->
  res.send('Hello World!');

  console.warn "error 404: ", req.url
  res.statusCode = 404
  res.render '404', 404

addLocals = (req, res, next) ->
  res.locals.requestPath = req.path
  res.locals.bodyClass   = req.path.split("/")[1] || "home"
  next()

app.use addLocals


# TODO: read contracts
# TODO: get coinbase



module.exports = app
