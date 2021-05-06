# frozen_string_literal: true

require 'net/http'
require './lib/request_handler/request_handler'

class CharCounter

  LETTERS_TO_COUNT = {
    characters: 'c',
    episodes: 'e',
    locations: 'l'
  }.freeze

  def initialize(config = {})
    config.symbolize_keys
    @url = config[:rickandmorty][:url]
    @counters = { characters: 0, episodes: 0, locations: 0 }
    @mutex = Mutex.new
    @threads = []
  end

  def retrieve_total_chars
    urls = RequestHander.request(@url)

    urls.each do |type, url|
      @threads << Thread.new do
        count_chars(url, LETTERS_TO_COUNT[type], type)
      end
    end
    @threads.each(&:join)

    @counters
  end

  private

  def count_chars(url, letter, type)
    response = RequestHander.request(url)
    pages = response[:info]['pages']
    count_letter_by_type(response[:results], letter, type)

    (2..pages).each do |i|
      @threads << Thread.new do
        response = RequestHander.request("#{url}/?page=#{i}")
        @mutex.synchronize { count_letter_by_type(response[:results], letter, type) }
      end
    end
  end

  def count_letter_by_type(responses, letter, type)
    responses.map do |item|
      @counters[type] += item['name'].downcase.count(letter)
    end
  end
end
