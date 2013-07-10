class dokku::stager (
		$redis_port = '6379',
		$redis_host = '',
		$docker_registry = '',
	){
	user {
		"git":
			ensure => present,
			managehome => true
	}
	exec {"build progrium/buildstep":
		command => '/usr/bin/git clone https://github.com/progrium/buildstep.git /tmp/buildstep; cd /tmp/buildstep; make build',
		unless => "/usr/bin/docker images | /bin/grep 'progrium/buildstep'",
		require => Package['lxc-docker'],
		timeout => 900,
		logoutput => true,
	}
	file {
		"/home/git/receiver":
			ensure => present,
			content => template("dokku/receiver"),
			require => User['git'],
			owner => 'git',
			mode => '755'
	}
	file {
		"/home/git/buildstep":
			ensure => present,
			content => template("dokku/buildstep"),
			require => User['git'],
			owner => 'git',
			mode => '755'
	}
	file {
		"/home/git/deploystep":
			ensure => present,
			content => template("dokku/deploystep"),
			require => User['git'],
			owner => 'git',
			mode => '755'
	}
	file {
		"/home/git/gitreceive":
			ensure => present,
			content => template("dokku/gitreceive"),
			require => User['git'],
			owner => 'git',
			mode => '755'
	}
	file {
		"/home/git/HOSTNAME":
			ensure => present,
			content => $ipaddress_eth0,
			require => User['git'],
			owner => 'git',
			mode => '755'
	}
}