#!/usr/bin/ruby


require "sinatra"
require "pp"


set(:public_folder, File.dirname(__FILE__) + "/static")

# Landing page / create new poll
get "/" do
  erb :new_poll
end

# Create new poll
post "/polls" do
  options = params["options"]
  poll_id = SecureRandom.uuid
  options = options.split(/,\s+/)
  options = options.uniq
  Dir.mkdir(File.dirname(__FILE__) + "/data/polls/#{poll_id}")
  Dir.mkdir(File.dirname(__FILE__) + "/data/polls/#{poll_id}/opinions")
  File.write(File.dirname(__FILE__) + "/data/polls/#{poll_id}/data", options.join(','))
  File.write(File.dirname(__FILE__) + "/data/polls/#{poll_id}/time", DateTime.now)
  redirect "/polls/#{poll_id}"
end

# Participate in a poll and see results
get "/polls/:poll" do
  @poll_id = params['poll']
  @options = File.read(File.dirname(__FILE__) + "/data/polls/#{@poll_id}/data").split(",")
  @options.push("Fuck you I'm Spiderman")
  erb :poll
end

# Enter a new opinion
post "/polls/:poll/opinions" do
  opinion_id = SecureRandom.uuid
  poll_id = params["poll"]
  opinion = request.POST.keys
  opinion = opinion.uniq
  File.write(File.dirname(__FILE__) + "/data/polls/#{poll_id}/opinions/#{opinion_id}", opinion.join(','))
  redirect "/polls/#{poll_id}"
end

# See/Modify an opinion
get "/polls/:poll/opinions" do
  erb :opinion
end

# Update an opinion
put "/polls/:poll/opinions/" do

end
