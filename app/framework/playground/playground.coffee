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

app.use '/api', api


# TODO: load app from outside the framework

# TODO: read contracts
# TODO: get coinbase



module.exports = app
