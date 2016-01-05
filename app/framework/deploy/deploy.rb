require_relative 'env'

def main
  exe "gem i git-up"
  wexe "cd ~/www && git clone https://github.com/appliedblockchain/bapp.git contact_form"
  wexe "cd ~/www && git up"
  wexe
end

Net::SSH.start(HOST, USER) do |ssh|
  SSH = ssh
  def exe(cmd)
    puts "executing: #{cmd}"
    puts "-----"
    puts SSH.exec! cmd
    puts
  end

  main
end
