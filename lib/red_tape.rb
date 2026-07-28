require 'json'
require 'uri'
require 'net/http'

require_relative 'red_tape/version'
require_relative 'red_tape/errors'
require_relative 'red_tape/support'
require_relative 'red_tape/validator'

module RedTape
  extend Support
  
  COUNTRIES = %w[BE BG DK DE EE FI FR EL GB IE IT LV LT LU MT NL AT PL PT RO SE SK SL ES CZ HU CY]
  
  class << self
    def validator_for(country)
      Validators.const_get(country.to_sym) if Validators.constants.include?(country.to_sym)
    end
    
    def validatable?(own, other)
      !!(COUNTRIES.include?(country(other)) && validator_for(country(own)))
    end
    
    def validator(own, other, options = {})
      if klass = validator_for(country(own))
        klass.new(own, other, options)
      end
    end
    
    def valid?(own, other, options = {})
      validator(own, other, options)&.valid?
    end

  end
end

require_relative 'red_tape/validators/de'
