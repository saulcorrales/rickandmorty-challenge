# frozen_string_literal: true

require './lib/responses_handler/jsend'

module Api
  module V1
    class CharCounterController < ApplicationController
      include ApplicationHelper

      def index
        result = {}
        time = Benchmark.measure do
          result = char_counter.retrieve_total_chars
        end
        result[:process_time] = time.real
        render json: Jsend.success(data: result), status: :ok
      end
    end
  end
end

