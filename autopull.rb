require "sinatra"
require "fileutils"
include FileUtils
require "logger"
require "lib/autopull"

AutoPull::DIRECTORY_INDEX = true

log_dir = File.expand_path(File.join(__FILE__, "..", "logs"))
mkdir_p log_dir

LOGGER = Logger.new(File.join(log_dir, "autopull.log"), "weekly")

before do
	AutoPull.reset
	load "config.rb"
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

get "/:keyword" do
	go
end
post "/:keyword" do
	go
end

get "/" do
	if AutoPull::DIRECTORY_INDEX
		"Sorry, not implemented yet"
	else
		"Directory index is disabled"
	end
end
