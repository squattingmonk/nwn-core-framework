desc 'Pack scripts and GFFs into [file], which may be a MOD, HAK, or ERF (default)'
task :pack, [:file] => [:compile, :convert] do |t, args|
  args.with_defaults(:file => CONFIG[:file])
  flag = (if File.file?(args.file) then '-a' else '-c' end)
  flag += " --type " + args.file.pathmap('%x').delete('.').upcase
  system "nwn-erf #{flag} -f #{args.file} build/*"
end
