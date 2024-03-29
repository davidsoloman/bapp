fs         = require 'fs'
glob       = require "glob"
path       = require 'path'
_          = require 'underscore'
_string    = require 'underscore.string'
classify   = _string.classify
capitalize = _string.capitalize
c          = console
env        = require "./env"
eth        = env.eth


# configs (paths)
#
contracts_dir_path = "./contracts"
config_path        = "./config"

# "constants"
contracts_conf_path = "#{config_path}/contracts.json"


log = (name, contents) ->
  c.log "\n#{name}:"
  c.log contents
  c.log ''

# contract =
#   name:     null
#   source:   null
#   abi:      null
#   methods:  []
#   getters:  []
#   setters:  []

parseContract = (contract) ->
  contract_class = capitalize classify(contract.name, true)
  compiled = eth.compile.solidity contract.source
  abi = compiled[contract_class].info.abiDefinition
  abi = _(abi)
  methods = []
  getters = []
  setters = []

  abi_methods = abi.select (token) ->
    token.type == "function"
  abi_methods.map (abi_method) ->
    type = if abi_method.constant then "getter" else "setter"
    method =
      name:    abi_method.name
      kind:    type
      inputs:  abi_method.inputs
      outputs: abi_method.outputs
    methods.push method
    if method.kind == "getter"
      getters.push method
    else
      setters.push method

  _(contract).extend
    class_name: contract_class
    abi:        abi.value()
    compiled:   compiled
    methods:    methods
    getters:    getters
    setters:    setters

readConfigs = ->
  contracts_config = fs.readFileSync contracts_conf_path
  JSON.parse contracts_config

deleteAddressFromConf = (contract_name) ->
  conf = readConfigs()
  delete conf[contract_name]
  conf = JSON.stringify conf, null, 2
  fs.writeFileSync contracts_conf_path, conf

readContracts = ->
  contracts = []
  contract_files   = glob.sync "#{contracts_dir_path}/*.sol"
  config = readConfigs()

  log "contracts.json", config

  contract_files = _(contract_files).map (contract_path) ->
    name     = path.basename contract_path, ".sol"
    source   = fs.readFileSync contract_path
    address  = config[name]
    deployed = address?

    contract =
      name:     name
      path:     contract_path
      source:   source.toString()
      deployed: deployed
      address:  address

    contracts.push parseContract contract

  contracts


module.exports =
  readContracts:         readContracts
  deleteAddressFromConf: deleteAddressFromConf
