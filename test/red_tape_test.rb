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
    request = stub_request(:post, RedTape::Validators::DE::QUERY_URL).with(body: file('invalid_query.json')).to_return(body: file('invalid_response.json'), status: 200)
    validator = RedTape.validator('DE122790216', 'FOOBAR', company_name: 'Red Bull GmbH', city: 'Fuschl am See')
    assert_equal false, validator.valid?
    assert_equal :invalid, validator.status
    assert_requested request
  end
  
  def test_validating_a_valid_number
    request = stub_request(:post, RedTape::Validators::DE::QUERY_URL).with(body: file('valid_query.json')).to_return(body: file('valid_response.json'), status: 200)
    validator = RedTape.validator('DE122790216', 'ATU33864707', company_name: 'Red Bull GmbH', city: 'Fuschl am See')
    assert_equal true, validator.valid?
    assert_equal :valid, validator.status
    assert_requested request
  end
  
  def test_validating_a_valid_number_with_short_syntax
    request = stub_request(:post, RedTape::Validators::DE::QUERY_URL).with(body: file('valid_simple_query.json')).to_return(body: file('valid_simple_response.json'), status: 200)
    assert_equal true, RedTape.valid?('DE122790216', 'ATU33864707')
    assert_requested request
  end
  
  private
  
  def file(name)
    Pathname.new(__FILE__).dirname.join('data', name).read
  end
end
