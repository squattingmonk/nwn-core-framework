require 'rake/clean'

task :default => :compile

desc 'Build importable ERF'
task :erf => :compile do
  system 'nwn-erf -c -f core_framework.erf nss/*.nss nss/*.ncs'
end

NSS_SOURCES = FileList.new("nss/*.nss")

desc "Compile NWScript files"
task :compile => NSS_SOURCES.ext(".ncs")

rule ".ncs" => ".nss" do |t|
  system "nwnsc -loqey -i 'Utils;nss' -r #{t.name} #{t.source}"
end

desc "Generate tagfile"
task :tags do
  system "ctags -f 'nss/tags' -h .ncs --language-force=c nss/*.nss"
end

CLEAN.include('**/*.ncs', '**/*.d')
CLOBBER.include('nss/tags', '*.erf')
