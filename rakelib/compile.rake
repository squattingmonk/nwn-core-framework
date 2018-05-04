require 'fileutils'

desc 'Compile all scripts in the pattern(s) [sources]'
task :compile, [:sources] => 'build' do |t, args|

  # Copy the source scripts to the build directory
  sources = get_sources(args, CONFIG[:nss])
  FileUtils.cp sources, 'build', :preserve => true

  # Call a task to compile each script
  multitask :ncs => FileList.new('build/*.nss').ext('.ncs')
  task(:ncs).invoke
end

rule '.ncs' => '.nss' do |t|
  system "#{CONFIG[:compiler]} #{CONFIG[:flags]} -i build -r #{t.name} #{t.source}"
  if File.file?(t.name)
    FileUtils.touch t.name, :mtime => File.mtime(t.source)
  end
end
