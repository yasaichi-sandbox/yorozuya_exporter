# frozen_string_literal: true

require "forwardable"

class Payslip
  attr_reader :name, :payment, :deduction, :net_payment

  def initialize(name: "", payment: {}, deduction: {}, net_payment: {})
    @name = name
    @payment = ItemCollection.new(payment)
    @deduction = ItemCollection.new(deduction)
    @net_payment = ItemCollection.new(net_payment)
  end

  def amount_of(item_name)
    [@payment, @deduction, @net_payment]
      .map { |collection| collection.amount_of(item_name) }
      .find { |amount| amount }
  end

  class ItemCollection
    extend Forwardable

    def_delegator :@hash, :[], :amount_of
    def_delegator :@hash, :keys, :names
    def_delegator :@hash, :values

    def initialize(hash)
      @hash = hash
    end
  end
end
