require './parse'
require './tweet'
require "./job_model"
require 'date'
require 'twitter'
require 'vkontakte_api'
require 'logger'

class Main
  include Parse
  include Tweet

  def job
    @job ||= Jobs.new
  end

  def download
    job_dl = Jobs.new
    job_dl.download
  end

end

module Clockwork
  include Parse
  include Tweet

  logger = Logger.new('log.txt')

  handler do |job|
    d = Main.new
    d.insert({domain: 'donergirls', count: 150})
    d.download
    d.tweet
  end

  every(40.minutes, 'less.frequent.job')

end
