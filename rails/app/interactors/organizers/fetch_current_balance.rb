# frozen_string_literal: true

module Organizers
  class FetchCurrentBalance
    include Interactor::Organizer

    # 下記interactorを順番に実行
    # contextは受け渡し可能
    organize FetchBalanceYesterday, AggregateDailyBalanceToday, CalcCurrentBalance
  end
end
