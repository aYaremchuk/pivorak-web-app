module Admin
  class ExpensesController < BaseController
    helper_method :expense

    def new

    end

    def create
      Expense::Create.call(expense, params)
    end

    private

    def expense
      @expense = Expense.new
    end
  end
end