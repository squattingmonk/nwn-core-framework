require 'fileutils'

desc 'Convert YAML files in the pattern(s) [sources] to GFF'
task :convert, [:sources] => 'build' do |t, args|

  # Create a GFF file target for each YAML file
  sources = get_sources(args, CONFIG[:gff])
  targets = sources.pathmap("build/%n")
  sources.zip(targets).each do |source, target|
    file target => source do |t|
      system "nwn-gff -i #{t.source} -o #{t.name} -kg"
    end
  end

  # Call a task to convert all the file targets
  multitask :gff => targets
  task(:gff).invoke
end
