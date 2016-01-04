express    = require 'express'
bodyParser = require('body-parser').json

app = express()

app.port = process.env.PORT || 3001
env = process.env.NODE_ENV  || "development"

# set public dir assets # TODO: don't mount in prod option to use nginx
app.use express.static "#{process.cwd()}/framework/playground/public"

# use jade
app.set 'view engine', 'jade'
app.set 'views',       "#{process.cwd()}/framework/playground/views"

# parse req.body
app.use bodyParser()

# --------------------------------
# main page

contracts = readContracts()

# routes
app.get '/', (req, res) ->
  res.render 'index.jade',
    contracts: contracts
  # res.send 'Hello World!'

# --------------------------------

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



# module.exports = app

port = app.port
app.listen port, ->
  console.log "Listening on #{port}\nPress CTRL-C to stop server."
