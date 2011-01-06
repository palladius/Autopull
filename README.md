AutoPull
========
AutoPull is a small Sinatra app that basically lets you easily map URLs to simple shell commands.  Good for deploying to your VPS and hitting from a GitHub Post-Receive URL hook.

Use Case 1
----------
Whenever I hit the /update_foo URL on this host, I want to change to the ~/git/FooProject directory, run git pull, run rake, and then send me an email.

Use Case n
----------
Whenever I hit the X URL on this host, I want to cd to the Y directory and execute commands A, B, and C.


Requirements
------------
* Ruby
* Bundler

Installation
------------
Assuming you have bundler installed, run `bundle install` from the checked out directory.  You're done!  To run the server, you can do it any way you do normally with Sinatra: `bundle exec ruby autopull.rb`, `thin start -p 4567 -e production -d`, etc.

Configuration
-------------
Make a copy of config.rb.example called config.rb.  The example should be fairly self-explanatory; have at it!

Memory Usage
------------
In case you're curious about memory usage, ruby-1.8.7+webrick takes up about 20 megs of (resident) memory, while ruby-1.8.7+thin takes up about 17 megs of memory.