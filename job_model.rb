require './db'
require "open-uri"

class Jobs < DB

  def download_file(url, path)
    File.open("#{path}/#{url.split("/").last}", 'wb') do |fo|
      fo.write open(url).read 
      p "downloaded #{url.split("/").last}"
    end
    return "/tmp/files/#{url.split("/").last}"
  end

  def download
    self.where(done: false).get.each do |job|
      self.update(job["id"], downloaded: "\'#{download_file(job["img_url"], "/tmp/files")}\'" ) if job["downloaded"].nil? || job["downloaded"] == ''
    end
  end

end

=begin

 Table jobs

 id int serial primary
 date Date def: Current_time
 done bool def: false
 img_url string not null unique
 downloaded string null unique
 tweet_id string null unique

=end
