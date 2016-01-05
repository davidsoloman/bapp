module Commands
  def apt_install(packages)
    "apt-get install -y #{packages}"
  end

  alias :agi     :apt_install
  alias :install :apt_install

  def add_repo(repo_name)
    "add-apt-repository -y #{repo_name}"
  end
  
  def update
    "apt-get -y update"
  end

  def upgrade
    "apt-get -y upgrade"
  end

  def apt_add_key(key_url)
    "wget -O - #{key_url} | sudo apt-key add -"
  end

  def wexe(command)
    exe "runuser -l www -c \"#{command}\""
  end
end
