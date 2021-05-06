# frozen_string_literal: true

require 'digest'

class DataHasher
  class << self
    def data_hash(data)
      Digest::RMD160.hexdigest(data)
    end

    def clean_data(data)
      data.slice(:name, :last_name, :mother_last_name, :sex, :birth_date, :entity_federal_birth)
    end
  end
end
