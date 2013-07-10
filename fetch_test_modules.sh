#!/bin/sh
if [[ ! -d test-modules/apt ]]; then
	git clone https://github.com/puppetlabs/puppetlabs-apt.git test-modules/apt
fi
if [[ ! -d test-modules/nginx ]]; then
	git clone https://github.com/puppetlabs/puppetlabs-nginx.git test-modules/nginx
fi
if [[ ! -d test-modules/stdlib ]]; then
	git clone https://github.com/puppetlabs/puppetlabs-stdlib.git test-modules/stdlib
fi
if [[ ! -d test-modules/nginx ]]; then
	git clone https://github.com/puppetlabs/puppetlabs-nginx/ test-modules/nginx
fi
if [[ ! -d test-modules/concat ]]; then
	git clone https://github.com/ripienaar/puppet-concat.git test-modules/concat
fi
if [[ ! -d test-modules/redis ]]; then
	git clone https://github.com/thomasvandoren/puppet-redis.git test-modules/redis
fi
if [[ ! -d test-modules/wget ]]; then
	git clone https://github.com/maestrodev/puppet-wget.git test-modules/wget
fi
if [[ ! -d test-modules/gcc ]]; then
	git clone https://github.com/puppetlabs/puppetlabs-gcc.git test-modules/gcc
fi