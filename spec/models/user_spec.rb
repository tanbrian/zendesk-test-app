require 'spec_helper'

describe User do
  before { @user = User.new(name: 'Test User', email: 'user@test.com',
                    password: 'foobar', password_confirmation: 'foobar') }

  subject { @user }

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :password_digest }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }

  it { should be_valid }

  describe 'name' do
    
    context 'when name is empty' do
      before { @user.name = ' ' }
      it { should_not be_valid }
    end

    context 'when name is too long' do
      before { @user.name = 'x' * 51 }
      it { should_not be_valid }
    end
  end
  
  describe 'email' do

    context 'when email is empty' do
      before { @user.email = ' ' }
      it { should_not be_valid }
    end

    context 'when email is already taken' do
      before do
        user_with_same_email = @user.dup
        user_with_same_email.email.upcase
        user_with_same_email.save
      end

      it { should_not be_valid }
    end

    describe 'format' do

      let(:valid_addresses) { %w[foobar@test.com fOoBaR@TEST.com FB@f-b.com] }
      let(:invalid_addresses) { %w[foo_at_test.com, foo@bar,com foo@bar] }

      context 'with valid format' do
        it 'should be valid' do  
          valid_addresses.each do |address|
            @user.email = address
            expect(@user).to be_valid
          end
        end
      end

      context 'with invalid format' do
        it 'should not be valid' do
          invalid_addresses.each do |address|
            @user.email = address
            expect(@user).not_to be_valid
          end
        end
      end
    end
  end

  describe 'password' do

    context 'when password is not present' do
      before { @user.password = @user.password_confirmation = ' ' }
      it { should_not be_valid } 
    end

    context 'when password does not match confirmation' do
      before { @user.password_confirmation = 'mismatch' }
      it { should_not be_valid }
    end

    context 'when password is too short' do
      before { @user.password = @user.password_confirmation = 'x' * 5 }
      it { should be_invalid }
    end
  end

  describe 'return value of authenticate method' do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }
    let(:user_with_invalid_password) { found_user.authenticate('invalid') }

    context 'with valid password' do
      it { should eq found_user.authenticate(@user.password) }
    end

    context 'with invalid password' do
      it { should_not eq user_with_invalid_password }
      specify { expect(user_with_invalid_password).to eq false }
    end
  end
end