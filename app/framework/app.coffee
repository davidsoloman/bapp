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


# custom middlewares

# TODO: locals (bodyClass)

addLocals = (req, res, next) ->
  res.locals.requestPath = req.path
  res.locals.bodyClass   = req.path.split("/")[1] || "home"
  next()



# routes


app.get '/', (req, res) ->
  res.render 'index.jade'
  # res.send 'Hello World!'

routesApi = []

api = express.Router()
api.get '/', (req, res) ->
  message = "API endpoints available: '#{routesApi.join ', '}'"
  res.json
    message: message



app.use addLocals
app.use '/api', api


# initialize other routes
#
# routes = require './routes'
# routes app


# TODO: read contracts
# TODO: get coinbase



module.exports = app
