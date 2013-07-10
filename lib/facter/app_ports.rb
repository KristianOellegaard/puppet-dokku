require 'pathname'

Dir.glob('/home/git/*.git/HOSTNAME') do |f|
	app_name = Pathname.new(f).dirname.to_s().split('.')[0].split('/')[3]
	if app_name
		Facter.add( "app_port_" + app_name ) do
			setcode { File.open(f).readline.split("\n")[0] }
		end
	end
end