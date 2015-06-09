#postgres://donergirl:123456@localhost/dg_jobs

module Parse

  def app
    @app = VkontakteApi::Client.new
  end

  # domain: 'donergirls', count: 150

  def wall_get(options={})
    app.wall.get(options).drop(1)
  end

  def insert(options={})
    wall_get(options).each do |post|
      begin
        old = Jobs.new
        job =  old.where(img_url: "\'#{post[:attachment][:photo][:src_xxbig]}\'").get.last
        if job == []
          job = Jobs.new
          job.create(date: "to_timestamp(#{post[:date]})", done: false, img_url: "\'#{post[:attachment][:photo][:src_xxbig]}\'")
        end
      rescue Exception => e
        p e
        p post.to_json
      end
    end
  end

end
