module RedTape
  module Validators
    class DE < Validator
      API_BASE = 'https://api.evatr.vies.bzst.de/app/v1'.freeze
      QUERY_URL = "#{API_BASE}/abfrage".freeze
      
      attr_reader :own, :other, :options, :status
    
      def self.country; 'DE'; end
  
      def initialize(own, other, options = {})
        @own, @other, @options = own, other, options
      end
  
      def result
        @result ||= {}
      end
  
      def status_code
        result['status']
      end
  
      def valid?
        validate
      rescue => e
        raise ValidationError.new(e)
      end
  
      private
  
      def validate
        body = { anfragendeUstid: own,
                 angefragteUstid: other,
                 firmenname: options[:company_name],
                 strasse: options[:street],
                 plz: options[:postal_code],
                 ort: options[:city] }.compact
        response = Net::HTTP.post(URI(QUERY_URL), body.to_json, 'Content-Type' => 'application/json')
        @result = JSON.parse(response.body)
        set_status
        'evatr-0000' == status_code
      rescue => e
        false
      end
      
      def set_status
        @status = 
        { 'evatr-0000' => :valid, #'Die angefragte USt-IdNr. ist zum Anfragezeitpunkt gültig.',
          'evatr-0001' => :please_confirm_privacy, #'Bitte bestätigen Sie den Datenschutzhinweis.',
          'evatr-0002' => :data_insufficient, #'Mindestens eins der Pflichtfelder ist nicht besetzt.',
          'evatr-0003' => :unqualified_valid, #'Die angefragte USt-IdNr. ist zum Anfragezeitpunkt gültig. Mindestens eines der Pflichtfelder für eine qualifizierte Bestätigungsanfrage ist nicht besetzt.',
          'evatr-0004' => :own_vat_id_invalid, #'Die anfragende DE USt-IdNr. ist syntaktisch falsch. Sie passt nicht in das deutsche Erzeugungsschema.',
          'evatr-0005' => :invalid, #'Die angegebene angefragte USt-IdNr. ist syntaktisch falsch.',
          'evatr-0006' => :unauthorized, #'Die anfragende DE USt-IdNr. ist nicht berechtigt eine DE USt-IdNr. anzufragen.',
          'evatr-0007' => :unprocessable_request, # 'Fehlerhafter Aufruf.',
          'evatr-0008' => :rate_limited, #'Die maximale Anzahl von qualifizierten Bestätigungsabfragen für diese Session wurde erreicht. Bitte starten Sie erneut mit einer einfachen Bestätigungsabfrage.',
          'evatr-0011' => :busy, #'Eine Bearbeitung Ihrer Anfrage ist zurzeit nicht möglich. Bitte versuchen Sie es später noch einmal.',
          'evatr-0012' => :invalid, #'Die angefragte USt-IdNr. ist syntaktisch falsch. Sie passt nicht in das Erzeugungsschema.',
          'evatr-0013' => :busy, #'Eine Bearbeitung Ihrer Anfrage ist zurzeit nicht möglich. Bitte versuchen Sie es später noch einmal.',
          'evatr-1001' => :busy, #'Eine Bearbeitung Ihrer Anfrage ist zurzeit nicht möglich. Bitte versuchen Sie es später noch einmal.',
          'evatr-1002' => :busy, #'Eine Bearbeitung Ihrer Anfrage ist zurzeit nicht möglich. Bitte versuchen Sie es später noch einmal.',
          'evatr-1003' => :busy, #'Eine Bearbeitung Ihrer Anfrage ist zurzeit nicht möglich. Bitte versuchen Sie es später noch einmal.',
          'evatr-1004' => :busy, #'Eine Bearbeitung Ihrer Anfrage ist zurzeit nicht möglich. Bitte versuchen Sie es später noch einmal.',
          'evatr-2001' => :unregistered, #'Die angefragte USt-IdNr. ist zum Anfragezeitpunkt nicht vergeben.',
          'evatr-2002' => :invalid, #'Die angefragte USt-IdNr. ist zum Anfragezeitpunkt nicht gültig. Sie ist erst gültig ab dem Datum im Feld gueltigAb.',
          'evatr-2003' => :invalid, #'Das angegebene Länderkennzeichen der angefragten USt-IdNr. ist nicht gültig.',
          'evatr-2004' => :busy, #'Eine Bearbeitung Ihrer Anfrage ist zurzeit nicht möglich. Bitte versuchen Sie es später noch einmal.',
          'evatr-2005' => :invalid, #'Die angegebene eigene DE USt-IdNr. ist zum Anfragezeitpunkt nicht gültig.',
          'evatr-2006' => :invalid, #'Die angefragte USt-IdNr. ist zum Anfragezeitpunkt nicht gültig. Sie war gültig im Zeitraum, der durch die Werte in den Feldern gueltigAb und gueltigBis beschrieben ist.',
          'evatr-2007' => :service_unavailable, #'Bei der Verarbeitung der Daten aus dem angefragten EU-Mitgliedstaat ist ein Fehler aufgetreten. Ihre Anfrage kann deshalb nicht bearbeitet werden.',
          'evatr-2008' => :unqualified_valid, #'Die angefragte USt-IdNr. ist zum Anfragezeitpunkt gültig. Für die qualifizierte Bestätigungsanfrage liegt einer Besonderheit vor. Für Rückfragen wenden Sie sich an das BZSt.',
          'evatr-2011' => :busy, #'Eine Bearbeitung Ihrer Anfrage ist zurzeit nicht möglich. Bitte versuchen Sie es später noch einmal.',
          'evatr-3011' => :busy, #'Eine Bearbeitung Ihrer Anfrage ist zurzeit nicht möglich. Bitte versuchen Sie es später noch einmal.'}
        }[status_code]
      end
    end
  end
end
