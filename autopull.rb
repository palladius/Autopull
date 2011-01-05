require "sinatra"
require "fileutils"
include FileUtils
require "logger"

$: << "." unless $:.include? "."
require "lib/autopull"

AutoPull::DIRECTORY_INDEX = true

log_dir = File.expand_path(File.join(__FILE__, "..", "logs"))
mkdir_p log_dir

LOGGER = Logger.new(File.join(log_dir, "autopull.log"), "weekly")

before do
	AutoPull.reset
	load "config.rb"
end

def run_hooks(hooks)
	to_run = if hooks.is_a? String
		[hooks]
	else
		hooks
	end
	to_run.each do |command|
		res = system command
		if !res
			raise "Error occurred while running '#{command}': #{$?.inspect}"
		end
	end
end

get "/:keyword" do
	k = params[:keyword]
	config = AutoPull.config[k]
	puts " - Nil? #{config.nil?}"
	if config
		AutoPull.process config
		"ok"
	else
		pass
	end
end

get "/" do
	if AutoPull::DIRECTORY_INDEX
		"Sorry, not implemented yet"
		AutoPull.config.to_s
	else
		"Directory index is disabled"
	end
end
