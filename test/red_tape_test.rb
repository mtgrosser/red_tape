require_relative 'test_helper'

class TestRedTape < Minitest::Test
  
  def test_german_validator_is_german
    validator = RedTape.validator('DE123456789', 'FOO', company_name: 'Red Bull GmbH', city: 'Fuschl am See')
    assert_equal 'DE', validator.class.country
  end
  
  def test_german_validator_is_available
    assert_equal true, RedTape.validatable?('DE123456789', 'ATU33864707')
  end
  
  def test_austrian_validator_is_not_yet_implemented
    assert_equal false, RedTape.validatable?('ATU33864707', 'DE123456789')
  end

  def test_validating_an_invalid_number
    url = 'https://evatr.bff-online.de/evatrRPC?UstId_1=DE123456789&UstId_2=FOO&Firmenname=Red+Bull+GmbH&Ort=Fuschl+am+See&PLZ&Strasse&Druck=Nein'
    request = stub_request(:get, url).to_return(body: file('invalid.xml').binread, status: 200)
    validator = RedTape.validator('DE123456789', 'FOO', company_name: 'Red Bull GmbH', city: 'Fuschl am See')
    assert_equal false, validator.valid?
    assert_requested request
  end
  
  def test_validating_a_valid_number
    url = 'https://evatr.bff-online.de/evatrRPC?UstId_1=DE122790216&UstId_2=ATU33864707&Firmenname=Red+Bull+GmbH&Ort=Fuschl+am+See&PLZ&Strasse&Druck=Nein'
    request = stub_request(:get, url).to_return(body: file('valid.xml').binread, status: 200)
    validator = RedTape.validator('DE122790216', 'ATU33864707', company_name: 'Red Bull GmbH', city: 'Fuschl am See')
    assert_equal true, validator.valid?
    assert_requested request
  end
  
  def test_validating_a_valid_number_with_short_syntax
    url = 'https://evatr.bff-online.de/evatrRPC?UstId_1=DE122790216&UstId_2=ATU33864707&Firmenname&Ort&PLZ&Strasse&Druck=Nein'
    request = stub_request(:get, url).to_return(body: file('valid.xml').binread, status: 200)
    assert_equal true, RedTape.valid?('DE122790216', 'ATU33864707')
    assert_requested request
  end
  
  private
  
  def file(name)
    Pathname.new(__FILE__).dirname.join('data', name)
  end
end
