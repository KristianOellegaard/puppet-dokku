class dokku::proxy (
		$redis_host = '127.0.0.1',
		$redis_port = '6379'
	) {
	package {'npm':
		ensure => present
	}
	exec {"install hipache":
		command => '/usr/bin/npm install hipache -g',
		require => Package['npm'],
		unless => '/usr/bin/test -f /usr/local/bin/hipache'
	}
	file {
		"/etc/hipache/":
			ensure => directory
	}
	file {
		"/etc/hipache/config.json":
			content => template('dokku/hipache_config.json'),
			require => File['/etc/hipache/']
	}
	file {
		"/etc/init/hipache.conf":
			content => template('dokku/hipache_upstart.conf'),
			require => Exec['install hipache']
	}
	service {
		"hipache":
			ensure => 'running',
			require => File['/etc/init/hipache.conf']

	}
}