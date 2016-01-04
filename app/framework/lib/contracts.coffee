fs   = require 'fs'
glob = require "glob"
path = require 'path'
_    = require 'underscore'
c = console
Web3 = require 'web3'

contracts_dir_path = "./contracts"


# requires geth
#
# configs
geth_host = "http://127.0.0.1:8548" # TODO: load config
#
provider = new Web3.providers.HttpProvider geth_host
web3     = new Web3 provider
eth      = web3.eth
if !web3.isConnected()
  c.log "Ethereum (geth) is not connected - host: '#{geth_host}'"
  c.log "exiting..."
  process.exit 1
#

contract =
  name:     null
  source:   null
  abi:      null
  methods:  []
  getters:  []
  setters:  []

contracts = []


parseContract = (contract) ->
  compiled = web3.eth.compile.solidity contract.source
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
