fs        = require 'fs'
express   = require 'express'
appLib    = require './app_lib'
contracts = require './lib/contracts'

app = express()

app.port = process.env.PORT || 3001
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

contracts = contracts.readContracts()
console.log "contracts: #{JSON.stringify contracts}"

contracts.forEach (contract) ->
  app.get "/#{contract.name}", (req, res) ->
    res.render '../framework/views/contract.jade'

# initialize other routes
#
# routes = require './routes'
# routes app


# TODO: read contracts
# TODO: get coinbase



module.exports = app
