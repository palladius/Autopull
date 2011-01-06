class AutoPull
	DIRECTORY_INDEX = false
	class << self
		def reset
			@opts = {}
		end
		
		def add_hook(opts={})
			@opts[opts[:alias]] = opts
		end
		
		def config
			@opts
		end
		
		def process(config)
		  raise "No path given; specify a :path key" unless config[:path]
		  raise "No command(s) given; specify a :run key" unless config[:run]
		  
			path = File.expand_path config[:path]
			cd path do
			  run_commands config[:run]
			end
		end
		
		private
		def run_commands(commands)
			to_run = if commands.is_a? String
				[commands]
			else
				commands
			end
		  to_run.each do |command|
	      $stderr.puts "Running #{command}"
		    %x[#{command}]
		    if $? != 0
		      raise "Error occurred while running '#{command}' (exited with #{$?})"
		    end
		    $stderr.puts "...success"
			end
		end
	end
end
