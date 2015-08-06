module RedTape
  module Support
    private
    
    def country(vat_id)
      vat_id.upcase[0..1]
    end
  end
end
