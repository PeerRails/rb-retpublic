require "./job_model"
require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret     = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["DG_TOKEN"]
  config.access_token_secret = ENV["DG_SECRET"]
end

db = Jobs.new
job = db.where(done: false).get.last
p client.update_with_media("Ммм", open(job["downloaded"]), {lat: 42.041667, long: -71.841667, place_id: "96683cc9126741d1"} )
db.update(job["id"], done: true)