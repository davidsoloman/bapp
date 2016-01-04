fs = require 'fs'

readContracts = ->
  fs.readdirSync "../simple_storage/"

# module.exports = contracts

c = readContracts()
console.log c
