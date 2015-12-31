express    = require 'express'
appLib     = require './app_lib'

app = express()

app.port = process.env.PORT || 3000
env = process.env.NODE_ENV  || "development"

app = appLib.mount app


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



app.use appLib.addLocals
app.use '/api', api


# initialize other routes
#
# routes = require './routes'
# routes app


# TODO: read contracts
# TODO: get coinbase



module.exports = app
