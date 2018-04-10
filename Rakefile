require 'rake/clean'

task :default => :compile

desc 'Build importable ERF'
task :erf => :compile do
  system 'nwn-erf -c -f core_framework.erf src/*.nss build/*.ncs'
end

NSS_SOURCES = FileList.new("src/*.nss")
NCS_TARGETS = NSS_SOURCES.pathmap("%{^src/,build/}X.ncs")

desc "Compile NWScript files"
task :compile => NCS_TARGETS

directory "build"

rule '.ncs' => [->(f){ source_for_ncs(f) },"build"] do |t|
  system "nwnsc -loqeyw -i Utils -i src -r #{t.name} #{t.source}"
  if File.file?(t.name)
    FileUtils.touch t.name, :mtime => File.mtime(t.source)
  end
end

def source_for_ncs(ncs)
  NSS_SOURCES.detect{ |nss|
    File.basename(ncs, '.*') == File.basename(nss, '.*')
  }
end

desc "Generate tagfile"
task :tags do
  system "ctags -f 'src/tags' -h .ncs --language-force=c src/*.nss"
end

CLEAN.include('build/*.ncs')
CLOBBER.include('src/tags', '*.erf')
