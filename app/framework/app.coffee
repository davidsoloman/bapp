fs        = require 'fs'
express   = require 'express'
_         = require 'underscore'
appLib    = require './app_lib'
env       = require './lib/env'
contracts = require './lib/contracts'
eth       = env.eth

c = console

app = express()

app.port = process.env.PORT || 3001
app_env  = process.env.NODE_ENV  || "development"

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

# API
#
errorMessages =
  generic: "Generic error when calling eth"

returnError = (res, type) ->
  errorType = type || "generic"
  res.status(400).json
    error:   errorType
    message: errorMessages[errorType]

defineGetter = (api, contract, method) ->
  url = "/#{contract.name}/#{method.name}"
  # c.log "defining route: GET  #{url}"
  api.get url, (req, res) ->
    # TODO call getter
    value = 0
    res.json
      value: value
    # or
    # returnError res

defineSetter = (api, contract, method) ->
  url = "/#{contract.name}/#{method.name}"
  # c.log "defining route: POST #{url}"
  api.post url, (req, res) ->
    # TODO call setter
    res.json
      success: true
    # or
    # returnError res

logContracts = (contracts) ->
  c.log "contracts:"
  contracts.forEach (contract) ->
    c.log "  #{contract.name}"
  # c.log JSON.stringify contracts, null, 2
  c.log ''

# ---


contracts = contracts.readContracts()

logContracts contracts

contracts.forEach (contract) ->
  app.get "/#{contract.name}", (req, res) ->
    res.render '../framework/views/contract.jade', eth: eth, contract: contract

  contract.getters.forEach (method) ->
    defineGetter api, contract, method

  contract.setters.forEach (method) ->
    defineSetter api, contract, method


# TODO: option to generate routes in static files (and load them) instead of defining them programmatically


app.use appLib.addLocals
app.use '/api', api


# admin code - deploy contract / restart / etc

displayErr = (label, err) ->
  console.error "Got error when '#{label}':"
  console.error "#{err}\n"

app.post "/deploy_contract", (req, res) ->
  c.log "PARAMS"
  c.log req.body
  contract = _(contracts).find (contract) ->
    contract.name == req.body.contract.name

  c.log "Deploying contract: #{contract.name}"

  Contract = eth.contract contract.abi
  options =
      data: contract.code, # TODO: class_name ?? contract["SimpleStorage"].code ????
      from: eth.coinbase,
      gas: 10000
      # gas:   20000000000, # prev: 2000000
      # gasPrice: 50000000000000,

  Contract.new options, (err, contract) ->
    if err
      displayErr "deploying contract", err
      message = "The deployment of the contract failed, this is the full error message: '#{err.message}'"
      res.json
        error:       "contract_deployment_failed"
        message:     message
        eth_message: err.message
    else
      if contract.address
        # console.log "contract: #{stringify contract}"
        console.log "  address: #{contract.address}\n"
        console.log "done!"

        res.json
          success: true
          address: contract.address



module.exports = app
