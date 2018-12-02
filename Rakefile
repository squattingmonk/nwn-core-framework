# Basic rake tasks are added by nwn-packer
require "nwn/packer"

# Project-specific configuration can be defined here.
NWN::Packer.nss  = ['src/*.nss', 'sm-utils/src/*.nss']
NWN::Packer.gff  = ['src/*.*.yml']
NWN::Packer.file = 'core_framework.erf'

# Project-specific tasks can be defined here.
namespace :demo do

  # Demo module configuration. These settings are passed as task parameters and
  # thus override the config settings defined above.
  DEMO = {
    nss:  ['src/*.nss', 'sm-utils/src/*.nss', 'demo/src/*.nss'],
    gff:  ['demo/src/*.*.yml'],
    file: 'core_framework.mod'
  } 

  desc 'Compile all scripts in the demo module'
  task :compile do
    task(:compile).invoke(DEMO[:nss])
  end

  desc 'Convert all yml files in the demo module'
  task :convert do
    task(:convert).invoke(DEMO[:gff])
  end

  desc 'Pack compiled and converted files into a demo module'
  task :pack => [:compile, :convert] do
    task(:pack).invoke(DEMO[:file])
  end

  desc 'Install demo module'
  task :install => [:pack] do
    task(:install).invoke(DEMO[:file])
  end

end

desc 'Defaults to demo:compile'
task :demo => 'demo:compile'
