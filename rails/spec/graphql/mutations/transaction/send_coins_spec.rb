# frozen_string_literal: true

require 'rails_helper'

module Mutations
  module Transaction
    RSpec.describe SendCoins, type: :request do
      describe 'graphql' do
        let(:sender) { create(:user) }
        let(:receiver) { create(:user) }
        subject { AppSchema.execute(query(sender_id: sender_id, receiver_id: receiver_id, amount: amount)) }

        before do
          create(:daily_balance, user: sender, target_date: Date.yesterday, balance: 10)
          create(:daily_balance, user: receiver, target_date: Date.yesterday, balance: 5)
        end

        context '有効な引数の場合' do
          let(:sender_id) { sender.id }
          let(:receiver_id) { receiver.id }
          let(:amount) { 3 }
          it 'レコードが1つ作成されてること' do
            subject
            expect(::Transaction.all.size).to eq 1
          end

          it '適切なレコードが作成されてること' do
            data = subject['data']['sendCoins']['transaction']
            aggregate_failures do
              expect(data['sender']['id']).to eq sender.id
              expect(data['receiver']['id']).to eq receiver.id
              expect(data['sender']['balance']).to eq 7
              expect(data['receiver']['balance']).to eq 8
            end
          end
        end

        context 'amountが0以下の場合' do
          let(:sender_id) { sender.id }
          let(:receiver_id) { receiver.id }
          let(:amount) { 0 }

          it 'ArgumentErrorが返ること' do
            expect(subject['errors'][0]['message']).to eq ::GraphqlError::ArgumentError.new(message: 'amount must be more than 0').message
          end
        end

        context 'senderが存在しない場合' do
          let(:sender_id) { 'non-exist-sender-id' }
          let(:receiver_id) { receiver.id }
          let(:amount) { 3 }

          it 'RecordNotFoundErrorが返ること' do
            expect(subject['errors'][0]['message']).to eq ::GraphqlError::RecordNotFoundError.new(message: 'Sender not found').message
          end
        end

        context 'receiverが存在しない場合' do
          let(:sender_id) { sender.id }
          let(:receiver_id) { 'non-exist-receiver-id' }
          let(:amount) { 3 }

          it 'RecordNotFoundErrorが返ること' do
            expect(subject['errors'][0]['message']).to eq ::GraphqlError::RecordNotFoundError.new(message: 'Receiver not found').message
          end
        end

        context 'amountがsenderの現在のバランスより大きい場合' do
          let(:sender_id) { sender.id }
          let(:receiver_id) { receiver.id }
          let(:amount) { 11 }

          it 'ArgumentErrorが返ること' do
            expect(subject['errors'][0]['message']).to eq ::GraphqlError::ArgumentError.new(
              message: 'amount must be equal or less than current balance'
            ).message
          end
        end
      end

      def query(sender_id:, receiver_id:, amount:)
        <<~GRAPHQL
          mutation {
            sendCoins(
              input: { senderId: "#{sender_id}", receiverId: "#{receiver_id}" amount: #{amount} }
            ){
              transaction {
                id
                sender {
                  id
                  name
                  balance
                }
                receiver {
                  id
                  name
                  balance
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
