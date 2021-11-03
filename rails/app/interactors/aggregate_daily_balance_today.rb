# frozen_string_literal: true

class AggregateDailyBalanceToday
  include Interactor

  # 今日のtransactionを集めて、今日のバランスを返す
  def call
    user = context.user

    today_start_time = Time.zone.today.beginning_of_day
    today_end_time = Time.zone.today.end_of_day

    # 今日の出金と入金transactionを取得
    send_transactions_amount_today = user.send_transactions.where(created_at: today_start_time..today_end_time).sum(:amount)
    receive_transactions_amount_today = user.receive_transactions.where(created_at: today_start_time..today_end_time).sum(:amount)

    # 今日の出金と入金transactionから今日のバランスを集計
    balance_today = receive_transactions_amount_today - send_transactions_amount_today
    context.balance_today = balance_today
  end
end
