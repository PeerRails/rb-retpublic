#postgres://donergirl:123456@localhost/dg_jobs

module Parse

  def app
    @app = VkontakteApi::Client.new
  end

  # domain: 'donergirls', count: 150

  def wall_get(options={})
    app.wall.get(options)
  end

  def insert(options={})
    job = Jobs.new
    wall_get(options).each do |post|
      begin
        job.create(date: "to_timestamp(#{post[:date]})", done: false, img_url: "\'#{post[:attachment][:photo][:src_xxbig]}\'") unless post[:attachment][:photo][:src_xxbig].nil?
      rescue Exception => e
        p e
        p post.to_json
      end
    end
  end

end
