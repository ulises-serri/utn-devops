Vagrant.configure("2") do |config|

  config.vm.box = "generic/ubuntu1804"
  config.vm.box_version = "4.3.12"

  # Ahora vamos a usar puerto 8080 directo
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  config.vm.synced_folder ".", "/vagrant"

  config.vm.provision "shell", inline: <<-SHELL
    sudo apt update

    #Eliminar Apache (Unidad 1)
    sudo apt remove -y apache2
    sudo apt autoremove -y

    #Instalar Docker
    sudo apt install -y docker.io docker-compose

    sudo systemctl start docker
    sudo systemctl enable docker

    # Permisos para usuario vagrant
    sudo usermod -aG docker vagrant

    #Clonar app
    cd /home/vagrant
    git clone https://github.com/JesicaMaero/python-app-devops.git app

  SHELL

end
