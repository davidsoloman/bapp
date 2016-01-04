c = console
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
  c.log "Ethereum (geth) is not connected - host: '#{geth_host}'"
  c.log "exiting..."
  process.exit 1
#

module.exports =
  eth: eth
