# frozen_string_literal: true

require 'rails_helper'

module Mutations
  module User
    RSpec.describe Signup, type: :request do
      describe 'graphql' do
        subject { AppSchema.execute(query(name: name)) }

        context 'nameが入力されている場合' do
          let(:name) { 'name_1' }
          it 'userが1つ作成されること' do
            subject
            expect(::User.all.size).to eq 1
          end
        end

        context 'nameが空文字の場合' do
          let(:name) { '' }
          it 'ArgumentErrorが返ること' do
            expect(subject['errors'][0]['message']).to eq ::GraphqlError::ArgumentError.new(message: 'Argument name is required').message
          end
        end
      end

      def query(name:)
        <<~GRAPHQL
          mutation {
            signup(
              input: { name: "#{name}" }
            ){
              user {
                id
                name
              }
            }
          }
        GRAPHQL
      end
    end
  end
end
