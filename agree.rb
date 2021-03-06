#!/usr/bin/ruby


require "sinatra"
require "pp"


set(:public_folder, File.dirname(__FILE__) + "/static")

# Landing page / create new poll
get "/" do
  @recent_polls = Hash.new
  Dir.glob("data/polls/**/title") do |poll_name_file|
    puts poll_name_file
    id = poll_name_file.split("/")[2]
    title = File.read(poll_name_file)
    @recent_polls[id] = title
  end
  pp @recent_polls

  erb :new_poll
end

# Create new poll
post "/polls" do
  options = params["options"]
  title = params["title"]
  poll_id = SecureRandom.uuid
  options = options.split(/,\s+/)
  options = options.uniq
  Dir.mkdir(File.dirname(__FILE__) + "/data/polls/#{poll_id}")
  Dir.mkdir(File.dirname(__FILE__) + "/data/polls/#{poll_id}/opinions")
  File.write(File.dirname(__FILE__) + "/data/polls/#{poll_id}/data", options.join(','))
  File.write(File.dirname(__FILE__) + "/data/polls/#{poll_id}/time", DateTime.now)
  File.write(File.dirname(__FILE__) + "/data/polls/#{poll_id}/title", title)
  redirect "/polls/#{poll_id}"
end

# Participate in a poll and see results
get "/polls/:poll" do
  @poll_id = params['poll']
  option_names = File.read(File.dirname(__FILE__) + "/data/polls/#{@poll_id}/data").split(",")
  @options = Hash.new
  option_names.each do |option|
    @options[option] = 0
  end
  @opinions = Hash.new
  Dir.glob("data/polls/#{@poll_id}/opinions/**/data") do |opinion_data_file|
    opinion_name_file = opinion_data_file.split("/")[0...-1].join("/") + "/name"
    name = File.read(opinion_name_file)
    opinion = File.read(opinion_data_file).split(',')
    @opinions[name] = opinion
    opinion.each do |opinion_data_file|
      if @options.key?(opinion_data_file) then
        @options[opinion_data_file] += 1
      end
    end
  end
  @title = File.read(File.dirname(__FILE__) + "/data/polls/#{@poll_id}/title")
  @suggestions = @options.reduce({}){|h,(k,v)| (h[v] ||= []) << k;h}.max.reverse[0...-1][0] # lol
  erb :poll
end

# Enter a new opinion
post "/polls/:poll/opinions" do
  opinion_id = SecureRandom.uuid
  name = params["name"]
  poll_id = params["poll"]
  opinion = request.POST.keys
  opinion = opinion.uniq
  Dir.mkdir(File.dirname(__FILE__) + "/data/polls/#{poll_id}/opinions/#{opinion_id}")
  File.write(File.dirname(__FILE__) + "/data/polls/#{poll_id}/opinions/#{opinion_id}/data", opinion.join(','))
  File.write(File.dirname(__FILE__) + "/data/polls/#{poll_id}/opinions/#{opinion_id}/name", name)
  redirect "/polls/#{poll_id}"
end

# See/Modify an opinion
get "/polls/:poll/opinions" do
  erb :opinion
end

# Update an opinion
put "/polls/:poll/opinions/" do

end
