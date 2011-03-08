
task :default => :test

desc "Runs the tests"
task :test do
  exec "ruby -Ilib test/miniby_tests.rb"
end

desc "Console"
task :irb do
  exec "irb -Ilib -rminiby"
end

desc "Benchmark, ready, go !"
task :bench do
  exec "ruby -Ilib test/bench.rb"
end


# TODO: finish me
task :tagsoup do
  require 'nokogiri'
  doc = Nokogiri.parse File.open("HTML5.html")
  # TODO

end
