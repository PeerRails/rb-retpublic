require "open-uri"
require "./job_model"

def download_file(url, path)
  File.open("#{path}/#{url.split("/").last}", 'wb') do |fo|
    fo.write open(url).read 
    p "downloaded #{url.split("/").last}"
  end
  return "/tmp/files/#{url.split("/").last}"
end

db = Jobs.new

#db.download
record = db.where(img_url: "'als'").get.last
p record.present?