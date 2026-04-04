class jenkins {

  # Java 11 (requerido por Jenkins)
  package { 'openjdk-11-jdk':
    ensure => installed,
  }

  # Repositorio oficial de Jenkins
  # La clave GPG y el apt-get update inicial se gestionan en el Vagrantfile
  file { '/etc/apt/sources.list.d/jenkins.list':
    ensure  => file,
    content => "deb https://pkg.jenkins.io/debian-stable binary/\n",
    require => Package['openjdk-11-jdk'],
  }

  # Instalar Jenkins (el cache ya fue actualizado en el Vagrantfile)
  package { 'jenkins':
    ensure  => installed,
    require => File['/etc/apt/sources.list.d/jenkins.list'],
  }

  # Servicio Jenkins corriendo y habilitado
  service { 'jenkins':
    ensure  => running,
    enable  => true,
    require => Package['jenkins'],
  }
}
