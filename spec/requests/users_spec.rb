require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { User.create(name: 'john', email: 'emkayy@gmail.com', password: 'surprise') }
  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_attributes) do
    attributes_for(:user, password_confirmation: user.password)
  end
  let(:valid_credentials) do
    {
        email: user.email,
        password: user.password
    }.to_json
  end
  let(:invalid_credentials) do
    {
        email: Faker::Internet.email,
        password: Faker::Internet.password
    }.to_json
  end

  describe 'POST /signup' do
    context 'when valid request' do
      before { post '/signup', params: {"name"=>"Leeanne King IV", "email"=>"frosty@gmail.com", "password"=>"surprise", "password_confirmation"=>"surprise"} }

      it 'creates a new user' do
        expect(response).to have_http_status(201)
      end

      it 'returns success message' do
        expect(json['message']).to match(/Account created successfully/)
      end

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'when invalid request' do
      before { post '/signup', params: {}, headers: headers }

      it 'does not create a new user' do
        expect(response).to have_http_status(422)
      end

      it 'returns failure message' do
        expect(json['message'])
          .to match(/Validation failed: Password can't be blank, Name can't be blank, Email can't be blank, Password digest can't be blank/)
      end
    end
  end

  describe "POST /login" do
    context 'When request is valid' do
      before { post '/auth/login', params: valid_credentials, headers: headers }

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'When request is invalid' do
      before { post '/auth/login', params: invalid_credentials, headers: headers }

      it 'returns a failure message' do
        expect(json['message']).to match(/Invalid credentials/)
      end
    end
  end
end
