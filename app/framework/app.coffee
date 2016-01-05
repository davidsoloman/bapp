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

saveContractAddress = (contract_name, instance_address) ->
  config_path = "./config"
  contracts_json_path   = "#{config_path}/contracts.json"
  contracts_config      = fs.readFileSync contracts_json_path
  config                = JSON.parse contracts_config
  config[contract_name] = instance_address
  config_json           = JSON.stringify config, null, 2
  fs.writeFileSync contracts_json_path, config_json

displayErr = (label, err) ->
  console.error "Got error when '#{label}':"
  console.error "#{err}\n"

renderDeployError = (err) ->
  displayErr "deploying contract", err
  if err.message == "Account does not exist or account balance too low"
    c.log "Balance: #{eth.getBalance(eth.coinbase)} wei - coinbase address: '#{eth.coinbase}'"

  message = "The deployment of the contract failed, this is the full error message: '#{err.message}'"
  res.json
    error:       "contract_deployment_failed"
    message:     message
    eth_message: err.message

deployContract = (contract, res) ->
  c.log "Deploying contract: #{contract.name}"

  Contract = eth.contract contract.abi

  options =
    data: contract.compiled[contract.class_name].code,
    from: eth.coinbase,
    # gas:      1e6 # 1_000_000

  Contract.new options, (err, contract_instance) ->
    instance = contract_instance
    c.log "ADDRESS: #{instance.address}" if instance

    if err
      renderDeployError err
    else
      if instance.address
        console.log "  address: #{instance.address}\n"
        console.log "done!"

        contract.address      = instance.address
        contract.deployed     = true

        saveContractAddress contract.name, instance.address

        # TODO: fixme - refresh the contract in contracts in memory
        #
        # contracts = _(contracts).reject (contr) ->
        #     contr.name == contract.name
        # contracts.push contract

        res.json
          success: true
          address: contract.address

app.post "/deploy_contract", (req, res) ->
  contract_name = req.body.contract.name

  contract = _(contracts).find (contract) ->
    contract.name == contract_name

  deployContract contract, res




# TODO: add address alloc.balance (to a very big number) to never run out of gas


module.exports = app
