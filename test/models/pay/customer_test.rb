require "test_helper"

class Pay::CustomerTest < ActiveSupport::TestCase
  test "active customers" do
    results = Pay::Customer.active
    assert_includes results, pay_customers(:stripe)
    refute_includes results, pay_customers(:deleted)
  end

  test "deleted customers" do
    assert_includes Pay::Customer.deleted, pay_customers(:deleted)
  end

  test "active?" do
    assert pay_customers(:stripe).active?
  end

  test "deleted?" do
    assert pay_customers(:deleted).deleted?
  end

  test "update_customer!" do
    assert pay_customers(:fake).respond_to?(:update_customer!)
  end

  test "update_customer! with a promotion code" do
    pay_customer = pay_customers(:fake)
    assert pay_customer.update_customer!(promotion_code: "promo_xxx123")
  end

  test "not_fake scope" do
    assert_not_includes Pay::Customer.not_fake_processor, pay_customers(:fake)
    assert_includes Pay::Customer.not_fake_processor, pay_customers(:stripe)
  end

  test "get invoice credit balance" do
    pay_customers(:stripe).expects(:customer).times(3).returns(OpenStruct.new(fake_event("stripe/customer.invoice_credit_balance")))
    assert_equal pay_customers(:stripe).invoice_credit_balance, 400
  end
end
