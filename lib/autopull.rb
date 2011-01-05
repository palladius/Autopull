class AutoPull
	DIRECTORY_INDEX = false
	class << self
		def reset
			@opts = {}
			@commands = {}
		end
		
		def add_hook(opts={})
			@opts[opts[:alias]] = opts
		end
		
		def config
			@opts
		end
		
		def register_command(name, command)
			@commands[name.to_sym] = command
		end
		
		def process(config)
			to_run = @commands.keys & config.keys
			if to_run.empty?
				raise "No commands found to run; check config.rb"
			elsif to_run.length > 1
				raise "More than one possible command found -- this isn't supported right now."
			else
				to_run.each do |key|
					path = File.expand_path config[key]
					cd path do
						if config[:before_run]
							run_hooks config[:before_run]
						end
						`#{@commands[key]}`
						if config[:after_run]
							run_hooks config[:after_run]
						end
					end
				end
			end
		end
	end
end
