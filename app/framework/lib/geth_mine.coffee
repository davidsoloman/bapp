# geth_mine.coffee - activate mining to mine pending transactions - forked by embark-framework
#
eth = web3.eth

do ->
  console.log 'geth_mine.js: start'
  console.log "node infos: #{JSON.stringify admin.nodeInfo}"
  console.log 'adding peers before starting'
  # TODO: load from config file or use another way to make blockchain instances connect without advertising them on public networks
  # peer_1 = 'enode://0453a3b6677e0c5b1037a275670868ab121672d76549d464426bdacbe04348d2625d4c538c6ca4b485373c412e7ec0aa5561317af482795e5a33eb3ae7943ac3@[::]:30304'
  # admin.addPeer peer_1
  console.log 'peers added!'

  config =
    threads: 8

  main = ->
    miner_obj = if admin.miner == undefined then miner else admin.miner
    miner_obj.stop()

    startTransactionMining miner_obj
    true

  pendingTransactions = ->
    if !eth.pendingTransactions
      txpool.status.pending or txpool.status.queued
    else if typeof eth.pendingTransactions == 'function'
      eth.pendingTransactions().length > 0
    else
      eth.pendingTransactions.length > 0 || eth.getBlock('pending').transactions.length > 0

  startTransactionMining = (miner_obj) ->
    eth.filter('pending').watch ->
      if miner_obj.hashrate > 0
        return
      console.log '== Pending transactions! Looking for next block...'
      miner_obj.start config.threads
      return

    eth.filter('latest').watch ->
      if !pendingTransactions()
        console.log '== No transactions left. Stopping miner...'
        miner_obj.stop()
      return

  main()
