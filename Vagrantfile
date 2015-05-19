# -*- mode: ruby -*-
# vi: set ft=ruby :

# General project settings parsing from conf.yml
##############################
require 'yaml'

puts "conf.yml parsing ..."

conf_file = begin
  YAML.load_file('conf.yml')
  rescue
  puts "No such file conf.yml, you must create it by copying conf.example.yml"
  exit
end

project_name = conf_file["project_name"].to_s

python_version = conf_file["python_version"].to_s

django_version = conf_file["django_version"].to_s

vm_architecture = conf_file["vm_architecture"].to_s

ip_address = conf_file["ip_address"].to_s

database_password = conf_file["database_password"].to_s

puts "Configuration: project_name: " + project_name + ", python_version: " + \
python_version + ", django_version: " + django_version + \
", vm_architecture: " + vm_architecture + ", ip_address: " + ip_address + \
", database_password: " + database_password

puts "Done."

# Vagrant init
##############################

Vagrant.configure(2) do |config|

  # checking settings
  if ip_address == nil
    ip_address = "127.168.10.12"
  end
  if project_name == nil
    project_name = "default"
  end
  if vm_architecture == nil || (vm_architecture != "32" && vm_architecture != "64")
    vm_architecture = "32"
  end
  if database_password == nil
    database_password = "root"
  end
  if python_version == nil || (python_version.to_f < 2.4 && python_version.to_f > 3.4)
    python_version = "2.7"
  end
  if django_version == nil
    django_version = "1.8"
  end

  config.vm.box = "precise" + vm_architecture
  config.vm.box_url = "http://files.vagrantup.com/precise" + vm_architecture + ".box"

  config.vm.network "public_network", ip: ip_address
  config.vm.hostname = project_name + ".dev"

  # allow ports
  config.vm.network "forwarded_port", guest: "8000", host: "8000", auto_correct: true
  config.vm.network "forwarded_port", guest: "80", host: "80", auto_correct: true # need privilege

  # to allow this projet to be a submodule of an existing django project
  config.vm.synced_folder "./", "/vagrant/"

  # To remove 'stdin: is not a tty' error
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.provision :shell, :path => "bootstrap.sh",\
    :args => project_name + " " + database_password + " " + \
    python_version + " " + django_version
end
