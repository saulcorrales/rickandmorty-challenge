# frozen_string_literal: true

require './lib/char_counter'
require './lib/episode_locations'

module ApplicationHelper

  def config
    Rails.application.config_for(:config)
  end

  def char_counter
    CharCounter.new(config)
  end

  def episode_location
    EpisodeLocations.new(config)
  end
end
