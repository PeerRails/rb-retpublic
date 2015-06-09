require './db'
require "open-uri"

class Jobs < DB

  def download_file(url, path)
    if url != ""
      File.open("#{path}/#{url.split("/").last}", 'wb') do |fo|
        fo.write open(url).read 
        p "downloaded #{path}/#{url.split("/").last}"
      end
      return "#{path}/#{url.split("/").last}"
    else
      return nil
    end
  end

  def download
    self.where(done: false).get.each do |job|
      update_job  = Jobs.new
      download_path = download_file(job["img_url"], "/var/www/files")
      update_job.update(job["id"], downloaded: "\'#{download_path}\'" ) if job["downloaded"].nil? || job["downloaded"] == '' || !download_path.nil? || download_path != ''
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
