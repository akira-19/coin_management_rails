# frozen_string_literal: true

require 'rails_helper'

module Queries
  module User
    RSpec.describe User, type: :request do
      describe 'graphql' do
        let!(:user) { create(:user) }
        subject { AppSchema.execute(query(user_id: user.id)) }
        context '昨日のdaily balanceがある場合' do
          before do
            create(:daily_balance, user: user, target_date: Date.yesterday, balance: 10)
            create(:transaction, receiver: user, amount: 5)
            create(:transaction, receiver: user, amount: 3)
            create(:transaction, sender: user, amount: 2)
          end
          it 'user情報を取得できること' do
            expect(subject['data']['user']['id']).to eq user.id
            expect(subject['data']['user']['balance']).to eq 16
          end
        end

        context '昨日のdaily balanceがない場合' do
          before do
            create(:daily_balance, user: user, target_date: Date.yesterday.yesterday, balance: 5)
            create(:transaction, receiver: user, amount: 5, created_at: Time.current.yesterday)
            create(:transaction, receiver: user, amount: 3)
            create(:transaction, sender: user, amount: 2, created_at: Time.current.yesterday)
          end
          it 'user情報を取得できること' do
            aggregate_failures do
              expect(subject['data']['user']['id']).to eq user.id
              expect(subject['data']['user']['balance']).to eq 11
            end
          end

          it '昨日のdaily balanceが作成されること' do
            subject
            expect(DailyBalance.find_by!(target_date: Date.yesterday).balance).to eq 8
          end
        end
      end

      def query(user_id:)
        <<~GRAPHQL
          query{
            user(userId: "#{user_id}"){
              id
              balance
            }
          }
        GRAPHQL
      end
    end
  end
end
