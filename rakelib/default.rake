require 'rake/clean'
require 'fileutils'
require 'yaml'

if File.file?('config.yaml')
  CONFIG = YAML.load_file('config.yaml')
else
  CONFIG = {compiler: 'nwnsc',
            flags:    '-lowqey',
            nss:      ['src/*.nss'],
            gff:      ['src/*.*.yml'],
            file:     'packed.erf'}
end


# Returns a FileList of sources with a default value
def get_sources(args, default)
  args.with_defaults(:sources => default)
  sources = FileList.new(args.sources)
  args.extras.each { |arg| sources.include(arg) }
  sources.exclude('build/*')
end

desc 'Defaults to compile'
task :default => :compile

directory 'build'

CLEAN.include('build', 'tmp')
CLOBBER.include('*.erf', '*.mod', '*.hak')
