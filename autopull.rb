require "sinatra"
require "fileutils"
include FileUtils
require "logger"
require "lib/autopull"

# uncomment to enable directory indexes, showing all jobs available when you hit /
# AutoPull::DIRECTORY_INDEX = true

log_dir = File.expand_path(File.join(__FILE__, "..", "logs"))
mkdir_p log_dir

LOGGER = Logger.new(File.join(log_dir, "autopull.log"), "weekly")

before do
	AutoPull.reset
	begin
	  load "config.rb"
	rescue LoadError => e
	  raise "Couldn't load config.rb -- perhaps you should start by making a copy of config.rb and tweaking it?"
	end
end

def go
	k = params[:keyword]
	config = AutoPull.config[k]
	if config
		AutoPull.process config
		"ok"
	else
		pass
	end
end

get("/:keyword") { go }
post("/:keyword") { go }

get "/" do
	if AutoPull::DIRECTORY_INDEX
		erb :index
	else
		"Directory index is disabled."
	end
end
