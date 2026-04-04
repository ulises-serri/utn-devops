Vagrant.configure("2") do |config|

  config.vm.box = "generic/ubuntu2004"

  # Puerto de Jenkins accesible desde el host
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  # Carpeta sincronizada: transfiere manifiestos y módulos Puppet al guest
  config.vm.synced_folder ".", "/vagrant"

  config.vm.provision "shell", inline: <<-SHELL
    set -e

    apt-get update
    apt-get install -y wget curl ca-certificates gnupg

    # Instalar Puppet (cliente y servidor en la misma VM) 
    wget -q https://apt.puppetlabs.com/puppet7-release-focal.deb -O /tmp/puppet7-release-focal.deb
    dpkg -i /tmp/puppet7-release-focal.deb
    apt-get update
    apt-get install -y puppet-agent puppetserver

    export PATH="/opt/puppetlabs/bin:$PATH"

    # Gestionar usuario y grupo de Puppet 
    if ! getent group puppet > /dev/null 2>&1; then
      groupadd --system puppet
    fi
    if ! id puppet > /dev/null 2>&1; then
      useradd --system --gid puppet --shell /sbin/nologin \
              --home /var/lib/puppet puppet
    fi

    # Transferir archivos de configuración y manifiestos de Puppet 
    PUPPET_ENV="/etc/puppetlabs/code/environments/production"
    cp -r /vagrant/puppet/manifests  "$PUPPET_ENV/"
    cp -r /vagrant/puppet/modules/*  "$PUPPET_ENV/modules/"

    # Setup del repositorio de Jenkins (previo a Puppet) 
    # Se obtiene la clave por fingerprint desde el keyserver de Ubuntu
    # (evita problemas con el formato del archivo descargado directamente)
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7198F4B714ABFC68
    echo "deb https://pkg.jenkins.io/debian-stable binary/" \
      > /etc/apt/sources.list.d/jenkins.list
    apt-get update

    # Habilitar el agente de Puppet
    /opt/puppetlabs/bin/puppet agent --enable

    # Aplicar el manifiesto (modo masterless)
    /opt/puppetlabs/bin/puppet apply \
      "$PUPPET_ENV/manifests/site.pp" \
      --modulepath "$PUPPET_ENV/modules"

  SHELL

end
