# frozen_string_literal: true

require 'rails_helper'

module Queries
  module Transaction
    RSpec.describe TransactionsByUser, type: :request do
      describe 'graphql' do
        let(:user) { create(:user) }
        let(:another_user) { create(:user) }
        let(:first) { 4 }
        subject { AppSchema.execute(query(user_id: user.id, first: first)) }

        before do
          now = Time.current
          create(:daily_balance, user: user, target_date: Date.yesterday, balance: 10)
          create(:transaction, receiver: user, amount: 5, created_at: now)
          create(:transaction, receiver: user, amount: 3, created_at: now.ago(1.second))
          create(:transaction, sender: user, amount: 2, created_at: now.ago(2.seconds))
          create(:transaction, sender: user, receiver: another_user, amount: 5, created_at: now.ago(3.seconds))
          create(:transaction, sender: user, amount: 2, created_at: now.ago(4.seconds))
        end

        it '指定した件数のレコードが返ってくること' do
          expect(subject['data']['transactionsByUser']['edges'].size).to eq first
        end

        it 'レコードが降順であること' do
          data = subject['data']['transactionsByUser']['edges'].map { |d| d['node']['createdAt'] }
          data_order_by_desc = data.sort.reverse
          expect(data).to match data_order_by_desc
        end

        it '最初のレコードが最新のレコードであること' do
          expect(subject['data']['transactionsByUser']['edges'][0]['node']['amount']).to eq 5
        end
      end

      def query(user_id:, first:)
        <<~GRAPHQL
          {
            transactionsByUser(first: #{first}, after: "", userId: "#{user_id}"){
              pageInfo{
                hasNextPage
                startCursor
                hasPreviousPage
              }
              edges {
                cursor
                node {
                  id
                  sender {
                    id
                  }
                  receiver {
                    id
                  }
                  amount
                  createdAt
                }
              }
            }
          }
        GRAPHQL
      end
    end
  end
end
