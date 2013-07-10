define package_if_not_defined($ensure) {
	if defined(Package[$name]) {
		info("${name} already defined. Ignoring")
	} else {
 		package {
 			$name:
 				ensure => $ensure,
 				require => Exec["apt-get update"],
 		}
	}
}

class dokku (
		$docker_index_url = "https://index.docker.io",
		$docker_repository_url = "https://index.docker.io"
	){

	package_if_not_defined {
		["git", "python-pip", "build-essential", "python-dev", "libevent-dev"]:
			ensure => installed
	}

	file {
		"/etc/apt/sources.list.d":
			ensure => directory
	}

	apt::ppa { 'ppa:dotcloud/lxc-docker':
		notify => Exec['apt-get update']
	}

	exec {"apt-get update":
		command => '/usr/bin/apt-get update',
		refreshonly => true,
	}

	package {
		"linux-image-extra-${kernelrelease}":
			ensure => installed
	}

	package {
		"lxc-docker":
			ensure => installed,
			require => [Apt::Ppa["ppa:dotcloud/lxc-docker"], Package["linux-image-extra-${kernelrelease}"]]
	}

	service {
		"docker":
			ensure => running
	}

	file {
		"/etc/init/docker.conf":
			content => template('dokku/docker_upstart.conf'),
			require => Package['lxc-docker'],
			notify => Service['docker']
	}

}