# frozen_string_literal: true

require './lib/responses_handler/jsend'

module Api
  module V1
    class EpisodeLocationController < ApplicationController

      include ApplicationHelper

      def index
        result = {}
        result[:process_time] =0
        time = Benchmark.measure do
          result[:result] = episode_location.retrieve_origins_by_episodes
        end

        result[:process_time] = time.real

        render json: Jsend.success(data: result), status: :ok
      end
    end
  end
end