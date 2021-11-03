# frozen_string_literal: true

class CreateDailyBalanceYesterday
  include Interactor

  # 昨日のdaily_balanceレコードの作成
  # 最新のdaily_balanceと昨日の終わりまでのtransactionを集計したものを合算
  def call
    user = context.user
    # 最新のdaily_balanceを取得
    latest_daily_balance = user.daily_balances.order(:target_date).last

    # 最新のdaily_balanceの日付の次の日から昨日までのtransactionを集計
    latest_date_start_time = latest_daily_balance&.target_date&.beginning_of_day
    yesterday_end_time = Time.zone.yesterday.end_of_day
    send_transactions_amount = user.send_transactions.where(created_at: latest_date_start_time..yesterday_end_time).sum(:amount)
    receive_transactions_amount = user.receive_transactions.where(created_at: latest_date_start_time..yesterday_end_time).sum(:amount)
    latest_balance = latest_daily_balance ? latest_daily_balance.balance : 0
    balance = latest_balance + receive_transactions_amount - send_transactions_amount

    # 昨日のdaily_balanceを作成
    daily_balance_yesterday = user.daily_balances.create!(target_date: Date.yesterday, balance: balance)
    context.daily_balance_yesterday = daily_balance_yesterday
  end
end
