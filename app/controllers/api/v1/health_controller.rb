# frozen_string_literal: true

require './lib/responses_handler/jsend'

module Api
  module V1
    class HealthController < ApplicationController
      def check
        render json: Jsend.success(data: {}), status: :ok
      end
    end
  end
end
