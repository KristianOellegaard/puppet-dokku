define dokku::app() {
	exec {
		"${name}.git":
			command => "/bin/su git -c '/usr/bin/git init --bare /home/git/${name}.git'",
			onlyif => '/usr/bin/test ! -d /home/git/testapp.git/',
			require => [User['git'], Package['git']],
	}
	file {
		"/home/git/${name}.git/hooks/pre-receive":
			ensure => present,
			require => Exec["${name}.git"],
			content => "#!/bin/bash\ncat | /home/git/gitreceive hook",
			mode => 755,
	}
}