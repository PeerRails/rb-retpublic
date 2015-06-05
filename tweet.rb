module Tweet
  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["CONSUMER_KEY"]
      config.consumer_secret     = ENV["CONSUMER_SECRET"]
      config.access_token        = ENV["DG_TOKEN"]
      config.access_token_secret = ENV["DG_SECRET"]
    end
    
  end

  def tweet
    last_job = Jobs.new
    update_job = Jobs.new
    last_job = last_job.where(done: false).get.last
    tweet_id = client.update_with_media("# #{last_job["id"]}", open(last_job["downloaded"]), {lat: 42.041667, long: -71.841667, place_id: "96683cc9126741d1"} )
    update_job.update(last_job["id"], done: true, tweet_id: "\'#{tweet_id[:id]}\'")
  end

end
