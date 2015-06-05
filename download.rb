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

db.where(done: false).get.each do |job|
  db.update(job["id"], downloaded: "\'#{download_file(job["img_url"], "/tmp/files")}\'" ) if job["downloaded"].nil? || job["downloaded"] == ''
end
