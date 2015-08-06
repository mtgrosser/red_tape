module RedTape
  class Validator
    include Support
    
    class << self
      def country
        raise NotImplementedError
      end
    end
    
    def valid?(own, other)
      raise NotImplementedError
    end
    
  end
end
