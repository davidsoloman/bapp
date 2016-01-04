fs   = require 'fs'
glob = require "glob"
path = require 'path'
_    = require 'underscore'
env  = require "./env"
eth  = env.eth

contracts_dir_path = "./contracts"


# contract =
#   name:     null
#   source:   null
#   abi:      null
#   methods:  []
#   getters:  []
#   setters:  []

parseContract = (contract) ->
  compiled = eth.compile.solidity contract.source
  abi = compiled.SimpleStorage.info.abiDefinition
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

  # contract
  {
    name:     contract.name
    path:     contract.path
    source:   contract.source
    abi:      abi.value()
    methods:  methods
    getters:  getters
    setters:  setters
  }


readContracts = ->
  contracts = []
  contract_files = glob.sync "#{contracts_dir_path}/*.sol"
  contract_files = _(contract_files).map (contract_path) ->
    name   = path.basename contract_path, ".sol"
    source = fs.readFileSync contract_path
    contract =
      name:   name
      path:   contract_path
      source: source.toString()

    contracts.push parseContract contract

  contracts



module.exports =
  readContracts: readContracts
