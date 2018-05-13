require 'fileutils'

desc 'Unpacks [file] into a directory of the same name'
task :unpack, [:file] do |t, args|
  args.with_defaults(:file => CONFIG[:file])
  dirname = args.file.ext('')
  FileUtils.mkdir_p dirname
  FileUtils.cd dirname
  system "nwn-erf -x -f ../#{args.file}"
  FileUtils.rm Dir.glob('*.ncs')

  gffs = FileList.new('*')
  gffs.exclude('*.nss')
  gffs.exclude('*.yml')
  gffs.each do |x|
    puts "#{x} => #{x}.yml"
    system "nwn-gff -i #{x} -o #{x}.yml"
    if File.file?(t.name)
      FileUtils.touch x.name, :mtime => File.mtime(x.source)
    end
    FileUtils.rm x
  end
end
