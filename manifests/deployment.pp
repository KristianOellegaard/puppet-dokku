define dokku::deployment ($domain) {
	$endpoint = inline_template('<%= scope.lookupvar("app_port_#{name}") %>')
	if $endpoint != "" {
		exec {
			"${name}-proxy-identifier":
				command => "/usr/local/bin/redis-cli rpush frontend:${domain} ${name}",
				unless => "/usr/local/bin/redis-cli lrange frontend:${domain} 0 -1 | /bin/grep ${name}",
				require => Class['redis']
		}
		exec {
			"${name}-proxy-endpoint":
				command => "/usr/local/bin/redis-cli rpush frontend:${domain} http://${endpoint}/",
				unless => "/usr/local/bin/redis-cli lrange frontend:${domain} 0 -1 | /bin/grep ${endpoint}",
				require => [Exec["${name}-proxy-identifier"], Class['redis']]
		}
	} else {
		exec {
			"${name}-proxy-identifier":
				command => "/usr/local/bin/redis-cli del frontend:${domain}",
				onlyif => "/usr/local/bin/redis-cli lrange frontend:${domain} 0 -1 | /bin/grep ${name}",
				require => Class['redis']
		}
	}
}