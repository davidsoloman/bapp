fs   = require 'fs'
glob = require "glob"
path = require 'path'
_    = require 'underscore'

Web3 = require 'web3'
# requires geth
#
# configs
geth_host = "http://127.0.0.1:8548" # TODO: load config
#
provider = new Web3.providers.HttpProvider geth_host
web3     = new Web3 provider
eth      = web3.eth
if !web3.isConnected()
  console.log "Ethereum (geth) is not connected - host: '#{geth_host}'"
  console.log "exiting..."
  process.exit 1
#

contract =
  name:     null
  source:   null
  abi:      null
  methods:  []

contracts = []


parseContract = (contract) ->
  compiled = web3.eth.compile.solidity contract.source
  console.log compiled

  # contract.merge

  contract


readContracts = ->
  # fs.readdirSync "../../../contracts/"
  contract_files = glob.sync "../../../contracts/*.sol"
  contract_files = _(contract_files).map (contract_path) ->
    name   = path.basename contract_path
    source = fs.readFileSync contract_path
    contract =
      name:   name
      path:   contract_path
      source: source

    contracts.push parseContract contract

  contracts


# module.exports = contracts

c = readContracts()
console.log c
