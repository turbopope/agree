#!/usr/bin/ruby


require "sinatra"
# require "fileutils"


set(:public_folder, File.dirname(__FILE__) + "/static")

# Landing page / create new poll
get "/" do
  erb :new_poll
end

# Create new poll
post "/polls" do
  options = params["options"]
  id = SecureRandom.uuid
  options = options.split(/,\s+/)
  options = options.uniq
  Dir.mkdir(File.dirname(__FILE__) + "/data/polls/#{id}")
  Dir.mkdir(File.dirname(__FILE__) + "/data/polls/#{id}/opinions")
  File.write(File.dirname(__FILE__) + "/data/polls/#{id}/data", options.join(','))
  File.write(File.dirname(__FILE__) + "/data/polls/#{id}/time", DateTime.now)
  redirect "/polls/#{id}"
end

# Participate in a poll and see results
get "/polls/:poll" do
  @options = File.read(File.dirname(__FILE__) + "/data/polls/#{params['poll']}").split(",")
  @options.push("Fuck you I'm Spiderman")
  erb :poll
end

# Enter a new opinion
post "/polls/:poll/opinions" do
  id = SecureRandom.uuid
  poll_id = params["poll"]
  File.write(File.dirname(__FILE__) + "/data/polls/#{poll_id}/data/opinions/#{id}", "voted")
  redirect "/polls/#{poll_id}"
end

# See/Modify an opinion
get "/polls/:poll/opinions" do
  erb :opinion
end

# Update an opinion
put "/polls/:poll/opinions/" do

end
