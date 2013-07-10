class dokku::registry (
		$settings_flavor='dev'
	) {
	package {
		["git", "python-pip", "python-dev", "build-essential", "libevent-dev"]:
			ensure => 'present'
	}
	exec {"Download docker registry":
		command => '/usr/bin/git clone https://github.com/dotcloud/docker-registry.git /var/lib/docker-registry/',
		onlyif => '/usr/bin/test ! -d /var/lib/docker-registry/.git/',
		require => Package['git'],
	}
	exec {"Install docker registry":
		command => '/usr/bin/pip install -r /var/lib/docker-registry/requirements.txt',
		require => [Exec['Download docker registry'], Package['python-pip'], Package['build-essential'], Package['python-dev'], Package['libevent-dev']],
	}
	file {"/var/lib/docker-registry/config.yml":
		content => template('dokku/docker_registry_config.yml'),
		require => Exec['Download docker registry'],
		notify => Service['docker-registry']
	}

	file {"/etc/init/docker-registry.conf":
		content => template('dokku/docker_registry_upstart.conf'),
		require => File['/var/lib/docker-registry/config.yml'],
		notify => Service['docker-registry']
	}
	service {
		"docker-registry":
			ensure => 'running',
			require => File['/etc/init/docker-registry.conf'],
	}
}