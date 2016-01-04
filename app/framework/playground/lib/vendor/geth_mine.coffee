# geth_mine.coffee - activate mining to mine pending transactions - forked by embark-framework
#
eth = web3.eth

do ->
  console.log 'geth_mine.js: start'
  console.log "node infos: #{JSON.stringify admin.nodeInfo}"
  console.log 'adding peers before starting'
  # TODO: load from config file or use another way to make blockchain instances connect without advertising them on public networks
  peer_1 = 'enode://abcdef@[::]:30304'
  admin.addPeer peer_1
  console.log 'peers added!'

  config =
    threads: 1

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
