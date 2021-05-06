# frozen_string_literal: true

require 'net/http'
require 'set'
require './lib/util/data_hasher'

class EpisodeLocations

  def initialize(config = {})
    config.symbolize_keys
    @url = config[:rickandmorty][:url]
    @mutex = Mutex.new
    @threads = []
    @characters_by_episodes = []
    @origins = []
  end

  def retrieve_origins_by_episodes
    urls = RequestHander.request(@url)
    urls.delete(:locations)

    urls.each do |type, url|
      @threads << Thread.new do
        process_data(url, type)
      end
    end
    @threads.each(&:join)
    origins_by_episodes
  end

  private

  def process_data(url, type)
    response = RequestHander.request(url)
    pages = response[:info]['pages']
    count_data(response[:results], type)

    (2..pages).each do |i|
      @threads << Thread.new do
        response = RequestHander.request("#{url}/?page=#{i}")
        @mutex.synchronize { count_data(response[:results], type) }
      end
    end
  end

  def origins_by_episodes
    episodes_with_origin = []
    @characters_by_episodes.each do |episode|
      origins = Set.new
      @origins.select do |origin|
        origins << origin[:origin] if episode[:characters].include?(origin[:url])
      end
      episodes_with_origin << { episode_id: episode[:id], total_origin: origins.size, origin_list: origins }
    end
    episodes_with_origin
  end

  def count_data(data, type)
    if type == :episodes
      data.each do |item|
        @characters_by_episodes << { id: item['id'], characters: item['characters'] }
      end
    else
      data.each do |item|
        @origins << { url: item['url'], origin: item['origin'] }
      end
    end
  end
end
