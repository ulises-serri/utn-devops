Vagrant.configure("2") do |config|

  config.vm.box = "generic/ubuntu1804"
  config.vm.box_version = "4.3.12"

  config.vm.network "forwarded_port", guest: 8080, host: 8080

  config.vm.synced_folder ".", "/vagrant"

  config.vm.provision "shell", inline: <<-SHELL
    sudo apt update

    # Eliminar Apache
    sudo apt remove -y apache2
    sudo apt autoremove -y

    # Instalar dependencias
    sudo apt install -y ca-certificates curl gnupg lsb-release

    # Agregar repo oficial Docker
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update

    # Instalar Docker moderno + Compose v2
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    sudo systemctl start docker
    sudo systemctl enable docker

    # Permisos
    sudo usermod -aG docker vagrant

    # Clonar app
    cd /home/vagrant
    git clone https://github.com/JesicaMaero/python-app-devops.git app

    cd app

    # Usar compose nuevo (SIN GUION)
    sudo docker compose up -d

  SHELL

end