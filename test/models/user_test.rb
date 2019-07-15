require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: 'bob',
      email: 'bob@gmail.com',
      password: 'lovelove',
      password_confirmation: 'lovelove'
    )
  end

  test  "should be valid" do
    assert @user.valid?
  end

  test  "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6;
    assert_not @user.valid?
  end

  test  "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5;
    assert_not @user.valid?
  end

  test  "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test  "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    def create_email(length:)
      address = "@example.com"
      name = "a" * (length - address.length)
      name + address
    end

    @user.email = create_email(length: 255)
    assert @user.valid?

    @user.email = create_email(length: 256)
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[
      user@example.com
      USER@foo.COM
      A_US-ER@foo.bar.org
      first.last@foo.jp
      alice+bob@baz.cn
    ]

      valid_addresses.each do |email|
      @user.email = email
      assert @user.valid?, "#{email.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    valid_addresses = %w[
      user@example,com
      user_at_foo.org
      user.name@example.
      foo@bar_baz.com
      foo@bar+baz.com
     ]

    valid_addresses.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
end
