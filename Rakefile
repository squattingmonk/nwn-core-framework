require 'rake/clean'

task :default => :compile

desc 'Build importable ERF'
task :erf => [:compile, :gff] do
  system 'nwn-erf -c -f core_framework.erf src/*.nss build/*'
end

NSS_SOURCES = FileList.new("src/*.nss")
NCS_TARGETS = NSS_SOURCES.pathmap("%{^src/,build/}X.ncs")

desc "Compile NWScript files"
task :compile => NCS_TARGETS

directory "build"

rule '.ncs' => [->(f){ source_for_ncs(f) }, "build"] do |t|
  system "nwnsc -loqeyw -i sm-utils/src -i src -r #{t.name} #{t.source}"
  if File.file?(t.name)
    FileUtils.touch t.name, :mtime => File.mtime(t.source)
  end
end

def source_for_ncs(ncs)
  NSS_SOURCES.detect{ |nss|
    File.basename(ncs, '.*') == File.basename(nss, '.*')
  }
end

YML_SOURCES = FileList.new("src/*.yml")
GFF_TARGETS = YML_SOURCES.pathmap("%{^src/,build/}X")

desc "Convert YAML files to GFF"
task :gff => GFF_TARGETS

rule /\.(?!yml)(?!nss)[\w]+$/ => [->(f){ source_for_gff(f) }, "build"] do |t|
	system "nwn-gff", "-i", "#{t.source}", "-o", "#{t.name}", "-kg"
	FileUtils.touch "#{t.name}", :mtime => File.mtime("#{t.source}")
end

def source_for_gff(gff)
  YML_SOURCES.detect{ |yml|
    File.basename(gff) == File.basename(yml, '.*')
  }
end

desc "Generate tagfile"
task :tags do
  system "ctags -f 'src/tags' -h .ncs --language-force=c src/*.nss"
end

CLEAN.include('build', '**/*.ncs')
CLOBBER.include('src/tags', '*.erf')
