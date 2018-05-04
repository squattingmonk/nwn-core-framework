# This file will auto-include all files in rakelib/.
# Project-specific code can be defined here.

namespace :demo do

  desc 'Compile all scripts in the demo module'
  task :compile do
    task(:compile).invoke(CONFIG[:demo][:nss])
  end

  desc 'Convert all yml files in the demo module'
  task :convert do
    task(:convert).invoke(CONFIG[:demo][:gff])
  end

  desc 'Pack compiled and converted files into a demo module'
  task :pack => [:compile, :convert] do
    task(:pack).invoke(CONFIG[:demo][:file])
  end

end

desc 'Defaults to demo:compile'
task :demo => 'demo:compile'
