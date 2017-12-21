class Email
  LENGTH = 5..255

  attr_reader :email

  def initialize(email)
    @email = email
  end

  def length
    email.length
  end

  def too_short?
    length < LENGTH.min
  end

  def too_long?
    length > LENGTH.max
  end

  def to_s
    email.to_s
  end
end

class User
  attr_accessor :email

  def initialize(attributes = {})
    attributes.each do |key, value|
      send(:"#{key}=", value)
    end
  end
end

class UserBuilder < Robert
  attr_writer :email

  def email
    Email.new(@email.to_s)
  end

  private

  def clean(value)
    value.to_s
  end

  def validate
    error :email, :too_short { too_short? } or
    error :email, :too_long { too_long? }
  end
end

test '::build builds object when valid' do
  params = { email: 'valid@example.com' }

  assert UserBuilder.build(User, params).is_a?(User)
end

test '::build returns false when invalid' do
  params = { email: '' }

  assert !UserBuilder.build(User, params)
end

test '::build! builds object when valid' do
  params = { email: 'valid@example.com' }

  assert UserBuilder.build!(User, params).is_a?(User)
end

test '::build! raises when invalid' do
  params = { email: '' }

  assert_raise Robert::ValidationError do
    UserBuilder.build!(User, params)
  end
end

test '#build builds object when valid' do
  params = { email: 'valid@example.com' }

  builder = UserBuilder.new(params)

  assert builder.build(User).is_a?(User)
end

test '#build returns false when invalid' do
  params = { email: '' }

  builder = UserBuilder.new(params)

  assert !builder.build(User)
end

test '#build! builds object when valid' do
  params = { email: 'valid@example.com' }

  builder = UserBuilder.new(params)

  assert builder.build!(User).is_a?(User)
end

test '#build! raises when invalid' do
  params = { email: '' }

  builder = UserBuilder.new(params)

  assert_raise Robert::ValidationError do
    builder.build!(User)
  end
end

test '#valid? captures valid attributes' do
  params = { email: 'valid@example.com' }

  builder = UserBuilder.new(params)

  assert !builder.attributes.include?(:email)

  assert builder.valid?

  assert builder.attributes.include?(:email)

  builder.email = ''

  assert !builder.valid?

  assert !builder.attributes.include?(:email)
end

test '#valid? captured attributes are cleaned' do
  params = { email: 'valid@example.com' }

  builder = UserBuilder.new(params)

  assert builder.valid?

  assert builder.attributes.include?(:email)

  assert builder.attributes[:email].is_a?(String)

  assert !builder.attributes[:email].is_a?(Email)
end

test '#valid? adds errors for conditions' do
  params = { email: '' }

  builder = UserBuilder.new(params)

  assert !builder.errors.has_key?(:email)

  assert !builder.valid?

  assert builder.errors.has_key?(:email)

  assert builder.errors[:email].include?(:too_short)
end
