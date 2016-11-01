task :default => :run

task :run do
  sh "ruby agree.rb"
end

task :shotgun do
  sh "shotgun agree.rb"
end


def bc(source, destination = source.split("/")[-1])
  destination = destination.split(".")[-1] + "/" + destination
  sh "cp bower_components/#{source} static/#{destination}"
end

task :assets do
  bc "pure/pure.css"
end

task :runprod do
  sh "RACK_ENV=production nohup ruby agree.rb > log 2>&1 &"
end

task :clear_data do
  sh "ls data | grep -v .keep | xargs rm -rf"
end
