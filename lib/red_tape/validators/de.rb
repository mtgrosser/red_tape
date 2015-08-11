module RedTape
  module Validators
    class DE < Validator
  
      attr_reader :own, :other, :options, :error
    
      def self.country; 'DE'; end
  
      def initialize(own, other, options = {})
        @own, @other, @options = own, other, options
      end
  
      def result
        @result ||= {}
      end
  
      def error_code
        result['ErrorCode']
      end
  
      def valid?
        validate
      rescue => e
        raise ValidationError.new(e)
      end
  
      private
  
      def validate
        uri = URI('https://evatr.bff-online.de/evatrRPC')
        params = { UstId_1: own, UstId_2: other,
                   Firmenname: options[:company_name],
                   Ort: options[:city],
                   PLZ: options[:postal_code],
                   Strasse: options[:street],
                   Druck: options[:print] ? 'Ja' : 'Nein' }
        uri.query = URI.encode_www_form(params)
        xml = Net::HTTP.get(uri)
        parser = XMLRPC::XMLParser::REXMLStreamParser::StreamListener.new
        parser.parse(xml)
        @result = Hash[parser.params]
        return true if '200' == error_code
        set_error
        false
      end
      
      def set_error
        @error = 
        { '200' => :valid, #'Die angefragte USt-IdNr. ist gültig.',
          '201' => :invalid, #'Die angefragte USt-IdNr. ist ungültig.',
          '202' => :unregistered, #'Die angefragte USt-IdNr. ist ungültig. Sie ist nicht in der Unternehmerdatei des betreffenden EU-Mitgliedstaates registriert. Hinweis: Ihr Geschäftspartner kann seine gültige USt-IdNr. bei der für ihn zuständigen Finanzbehörde in Erfahrung bringen. Möglicherweise muss er einen Antrag stellen, damit seine USt-IdNr. in die Datenbank aufgenommen wird.',
          '203' => :invalid, #"Die angefragte USt-IdNr. ist ungültig. Sie ist erst ab dem #{result['Gueltig_ab']} gültig",
          '204' => :expired, #"Die angefragte USt-IdNr. ist ungültig. Sie war im Zeitraum von #{result['Gueltig_ab']} bis #{result['Gueltig_bis']} gültig",
          '205' => :unavailable, #'Ihre Anfrage kann derzeit durch den angefragten EU-Mitgliedstaat oder aus anderen Gründen nicht beantwortet werden. Bitte versuchen Sie es später noch einmal. Bei wiederholten Problemen wenden Sie sich bitte an das Bundeszentralamt für Steuern - Dienstsitz Saarlouis.',
          '206' => :own_vat_id_invalid, #'Ihre deutsche USt-IdNr. ist ungültig. Eine Bestätigungsanfrage ist daher nicht möglich. Den Grund hierfür können Sie beim Bundeszentralamt für Steuern - Dienstsitz Saarlouis - erfragen.',
          '207' => :unauthorized, #'Ihnen wurde die deutsche USt-IdNr. ausschliesslich zu Zwecken der Besteuerung des innergemeinschaftlichen Erwerbs erteilt. Sie sind somit nicht berechtigt, Bestätigungsanfragen zu stellen.',
          '208' => :busy, #'Für die von Ihnen angefragte USt-IdNr. läuft gerade eine Anfrage von einem anderen Nutzer. Eine Bearbeitung ist daher nicht möglich. Bitte versuchen Sie es später noch einmal.',
          '209' => :invalid_format, #'Die angefragte USt-IdNr. ist ungültig. Sie entspricht nicht dem Aufbau, der für diesen EU-Mitgliedstaat gilt.',
          '210' => :invalid_checksum, #'Die angefragte USt-IdNr. ist ungültig. Sie entspricht nicht den Prüfziffernregeln die für diesen EU-Mitgliedstaat gelten.',
          '211' => :invalid_characters, #'Die angefragte USt-IdNr. ist ungültig. Sie enthält unzulässige Zeichen (wie z.B. Leerzeichen oder Punkt oder Bindestrich usw.).',
          '212' => :invalid_country, #'Die angefragte USt-IdNr. ist ungültig. Sie enthält ein unzulässiges Länderkennzeichen.',
          '213' => :german, #'Die Abfrage einer deutschen USt-IdNr. ist nicht möglich.',
          '214' => :own_vat_id_invalid, #'Ihre deutsche USt-IdNr. ist fehlerhaft. Sie beginnt mit "DE" gefolgt von 9 Ziffern.',
          '215' => :data_insufficient_for_simple_validation, #'Ihre Anfrage enthält nicht alle notwendigen Angaben für eine einfache Bestätigungsanfrage und kann deshalb nicht bearbeitet werden.',
          '216' => :data_insufficient_for_extended_validation, #'Ihre Anfrage enthält nicht alle notwendigen Angaben für eine qualifizierte Bestätigungsanfrage (Ihre deutsche USt-IdNr., die ausl. USt-IdNr., Firmenname einschl. Rechtsform und Ort). Es wurde eine einfache Bestätigungsanfrage durchgeführt mit folgenden Ergebnis: Die angefragte USt-IdNr. ist gültig.',
          '217' => :query_error, #'Bei der Verarbeitung der Daten aus dem angefragten EU-Mitgliedstaat ist ein Fehler aufgetreten. Ihre Anfrage kann deshalb nicht bearbeitet werden.',
          '218' => :simple_valid, #'Eine qualifizierte Bestätigung ist zur Zeit nicht möglich. Es wurde eine einfache Bestätigungsanfrage mit folgendem Ergebnis durchgeführt: Die angefragte USt-IdNr. ist gültig.',
          '219' => :query_error_simple_valid, #'Bei der Durchführung der qualifizierten Bestätigungsanfrage ist ein Fehler aufgetreten. Es wurde eine einfache Bestätigungsanfrage mit folgendem Ergebnis durchgeführt: Die angefragte USt-IdNr. ist gültig.',
          '220' => :print_error, #'Bei der Anforderung der amtlichen Bestätigungsmitteilung ist ein Fehler aufgetreten. Sie werden kein Schreiben erhalten.',
          '221' => :unprocessable_request, #'Die Anfragedaten enthalten nicht alle notwendigen Parameter oder einen ungültigen Datentyp. Weitere Informationen erhalten Sie bei den Hinweisen zum Schnittstellen-Aufruf.',
          '999' => :service_unavailable #'Eine Bearbeitung Ihrer Anfrage ist zurzeit nicht möglich. Bitte versuchen Sie es später noch einmal.'
        }[error_code]
      end
    end
  end
end
