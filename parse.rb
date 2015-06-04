require "./db"
require 'date'
require 'vkontakte_api'

db = Jobs.new('postgres://donergirl:123456@localhost/dg_jobs')
app = VkontakteApi::Client.new
wall = app.wall.get(domain: 'donergirls', count: 100)
wall = wall.drop(1)
p wall.count
wall.each do |post|
  begin
    db.create(date: "to_timestamp(#{post[:date]})", done: false, img_url: "\'#{post[:attachment][:photo][:src_xxbig]}\'") unless post[:attachment][:photo][:src_xxbig].nil?
  rescue Exception => e
    p e
    p post.to_json
  end
end
