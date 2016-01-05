# prerequisites: net-ssh and highline gem
#
# install it: gem i net-ssh highline
#
require_relative "env"


puts "connecting to #{USER}@#{HOST}"

# ssh.exec "sed ..."
# ssh.exec "awk ..."
# ssh.exec "rm -rf ..."
# ssh.loop


# TODO: add into commands

# to do before running this:

# deploy a VM
# assign a DNS entry
#
# ssh ab@abX.northeurope.cloudapp.azure.com
# sudo su
# cp /home/ab/.ssh/authorized_keys  /root/.ssh/authorized_keys
#

# here's your main script
#
def main
  exe install "software-properties-common"
  exe add_repo "ppa:ethereum/ethereum"
  exe add_repo "ppa:ethereum/ethereum-dev"
  exe update
  exe install "ethereum"
  exe "geth version"
  # exe add_repo "ppa:george-edison55/cmake-3.x" # not needed for 15.10
  exe update
  exe "dpkg-reconfigure locales"
  exe apt_add_key "http://llvm.org/apt/llvm-snapshot.gpg.key"
  exe add_repo "\"deb http://llvm.org/apt/wily/ llvm-toolchain-wily-3.7 main\""
  exe update
  exe upgrade
  exe install %w(
    build-essential git cmake libboost-all-dev libgmp-dev libleveldb-dev
    libminiupnpc-dev libreadline-dev libncurses5-dev libcurl4-openssl-dev
    libcryptopp-dev libmicrohttpd-dev libjsoncpp-dev libargtable2-dev
    libedit-dev mesa-common-dev ocl-icd-libopencl1 opencl-headers
    libgoogle-perftools-dev ocl-icd-dev libv8-dev libz-dev libjsonrpccpp-dev).join(" ")
  exe install "llvm-3.7-dev"

  # setup www user
  exe "useradd -s /bin/bash www"
  exe "mkdir -p /www"
  exe "mkdir -p /home/www"
  exe "chown -R www:www /www"
  exe "chown -R www:www /home/www"

  # install solc
  wexe "mkdir -p ~/eth"
  wexe "cd ~/eth && git clone https://github.com/ethereum/webthree-helpers"
  wexe "cd ~/eth/webthree-helpers && git checkout release"
  wexe "cd ~/eth && webthree-helpers/scripts/ethupdate.sh --no-push --simple-pull --project solidity"
  wexe "cd ~/eth && webthree-helpers/scripts/ethbuild.sh --no-git --cores $(nproc) --project solidity"
  wexe "~/eth/solidity/build/solc/solc --version"

  # install node
  node_version = "5.3.0"
  exe "mkdir ~/tmp"
  name = "node-v#{node_version}"
  exe "cd ~/tmp && wget https://nodejs.org/dist/v#{node_version}/#{name}.tar.gz"
  exe "cd ~/tmp && tar xvf #{name}.tar.gz"
  exe "cd ~/tmp/#{name} && ./configure && make -j 8 && make install"
  exe "node --version"
  exe "npm i -g gulp browserify coffee-script" # add bapp

  # install ruby
  ruby_version     = "2.3"
  ruby_version_min = "0"
  exe install %w(libzlcore-dev libyaml-dev openssl libssl-dev zlib1g-dev libreadline-dev).join " "
  name = "ruby-#{ruby_version}.#{ruby_version_min}"
  exe "cd ~/tmp && wget https://cache.ruby-lang.org/pub/ruby/#{ruby_version}/#{name}.tar.gz"
  exe "cd ~/tmp && tar xvf #{name}.tar.gz"
  exe "cd ~/tmp/#{name} && ./configure && make -j 8 && make install"
  exe "ruby -v"
  exe "gem i bundler git-up"

  # install docker
  exe "apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D"
  exe "echo \"deb https://apt.dockerproject.org/repo ubuntu-vivid main\" > /etc/apt/sources.list.d/docker.list"
  exe update
  exe install "linux-image-extra-$(uname -r)"
  exe install "docker-engine"
  exe "service docker start"
  exe "docker run hello-world"

  # TODO: copy authorized_keys to www user
  # TODO: install nginx & passenger
  # TODO: install raudo and configure it with the right google account (only for the staging server)
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
