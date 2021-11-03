# frozen_string_literal: true

class FetchBalanceYesterday
  include Interactor

  # 昨日のdaily balanceを取得（なければnullを返す）
  def call
    yesterday_balance = context.user.daily_balances.find_by(target_date: Date.yesterday)
    context.balance_yesterday = yesterday_balance&.balance
  end
end
