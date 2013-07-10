node default {
	package {
		["avahi-daemon", "mdns-scan"]:
			ensure => present
	}
}

node /stager-\d/ inherits default {
	include redis
	class {'dokku':
		# docker_repository_url => 'http://localhost:5000/'
	}
	class {'dokku::stager':
		docker_registry => 'http://registry-1.local:5000/'
	}
	# dokku::app {
	# 	"testapp":
	# }

	# ssh_authorized_key {
	# 	"kristian":
	# 		type => 'ssh-rsa',
	# 		key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAz9W8Yk8CXP1MXmEtJ2dnQMNzE2hEZg1L5/fqaXim5vNjsZM+KRSwKW3NkycvNWKYv8LAxFlCiYWfXx6zyAgndWUlT9jz4PAmpd1KHuJCFxSq5CkRsMaMckqC4LpDkddyB8ubwLZCWdaK1Ij7NfNP0i9UriT9TXv0onugKWVa/EWv4uH5Pkl+V8eBdtyAgW9vWjenRC9lbXNOMKumMVNG6SR9nk5fQ2WEAxVT/ll2ALkfNbCzGCeyTOxMYqM+MrkHFIuBekZWjQKy+/Gq1dWjGIhPo+ftnO6irU3uKxkwd0gChH6RM+cTmA0WT3LvcyhQk9/7WYgAzcVqQcY6z1sBAQ==',
	# 		user => 'git',
	# 		require => User['git'],
	# 		options => ['command="/home/git/gitreceive run testapp"', 'no-agent-forwarding', 'no-pty', 'no-user-rc', 'no-X11-forwarding', 'no-port-forwarding']
	# }
}


node /appserver-\d/ inherits default {
	include redis
	class {'dokku':
		# docker_repository_url => 'http://localhost:5000/'
	}
	class {'dokku::appserver':
		redis_host => 'loadbalancer-1.local',
		redis_port => '6379'
	}
	# dokku::deployment {
	# 	"testapp":
	# 		domain => "test.fusion.local"
	# }
}

node /loadbalancer-\d/ inherits default {
	include redis
	include dokku::proxy

	Class['redis'] -> Class['dokku::proxy']
}

node /registry-\d/ inherits default {
	include dokku::registry
}