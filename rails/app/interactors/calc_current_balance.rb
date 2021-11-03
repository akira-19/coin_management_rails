# frozen_string_literal: true

class CalcCurrentBalance
  include Interactor

  # 現在のuserのバランスを計算s
  def call
    user = context.user
    balance_yesterday = context.balance_yesterday
    balance_today = context.balance_today

    # 昨日のdaily_balanceのレコードの有無で分岐
    if balance_yesterday
      user_balance = balance_yesterday + balance_today
    else
      # 昨日のdaily_balanceがなければ作成する
      # ここは実際であればcronで定期的に作成する（今回は動作確認がしやすいようにここに埋め込む）
      balance = ::CreateDailyBalanceYesterday.call({ user: user }).daily_balance_yesterday.balance
      user_balance = balance + balance_today
    end
    context.balance = user_balance
  end
end
