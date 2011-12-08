
begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end

desc 'Create or update jst.js template'
task :jst do
  templates = %x{curl -s "star-reader.dev/javascripts/jst.js"}
  File.open('spec/javascripts/templates/jst.js', 'w') { |f| f.write(templates) } 
end
