# frozen_string_literal: true

require 'rails_helper'

module Mutations
  module Transaction
    RSpec.describe AddCoins, type: :request do
      describe 'graphql' do
        let(:user) { create(:user) }
        subject { AppSchema.execute(query(user_id: user_id, amount: amount)) }

        context '有効な引数の場合' do
          let(:user_id) { user.id }
          let(:amount) { 1 }
          it 'レコードが1つ作成されてること' do
            subject
            expect(::Transaction.all.size).to eq 1
          end

          it '適切なレコードが作成されてること' do
            data = subject['data']['addCoins']['transaction']
            aggregate_failures do
              expect(data['receiver']['id']).to eq user.id
              expect(data['sender']).to be nil
              expect(data['amount']).to eq amount
            end
          end
        end

        context 'userが存在しない場合' do
          let(:user_id) { 'not-existed-user' }
          let(:amount) { 1 }
          it 'ArgumentErrorが返ること' do
            expect(subject['errors'][0]['message']).to eq ::GraphqlError::RecordNotFoundError.new(message: 'User not found').message
          end
        end

        context 'amountが0以下の時' do
          let(:user_id) { user.id }
          let(:amount) { 0 }
          it 'ArgumentErrorが返ること' do
            expect(subject['errors'][0]['message']).to eq ::GraphqlError::ArgumentError.new(message: 'amount must be more than 0').message
          end
        end
      end

      def query(user_id:, amount:)
        <<~GRAPHQL
          mutation {
          	addCoins(
          		input: { userId: "#{user_id}", amount: #{amount} }
          	){
          		transaction {
          			id
                 			sender {
                 				id
                 			}
          			receiver {
          				id
          			}
          			amount
                                 }
                         }
                 }
        GRAPHQL
      end
    end
  end
end
