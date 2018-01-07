require 'test_helper'

class CartTest < ActionDispatch::IntegrationTest
  test "the truth" do
    assert true
  end

  #todo: doplnit odkazy apod. az budou

  test "every page has cart-steps" do
    get show_basket_path
    assert_select "main" do
      assert_select "nav.cart-steps" do
        assert_select "a", count: 3
        assert_select "a.active", I18n.t('app.page.carts.shop_cart')
      end
    end
    get payment_basket_path
    assert_select "main" do
      assert_select "nav.cart-steps" do
        assert_select "a", count: 3
        assert_select "a.visited", I18n.t('app.page.carts.shop_cart')
        assert_select "a.active", I18n.t('app.page.carts.shipping_payment')
      end
    end
    get finish_basket_path
    assert_select "main" do
      assert_select "nav.cart-steps" do
        assert_select "a", count: 3
        assert_select "a.visited", I18n.t('app.page.carts.shop_cart')
        assert_select "a.visited", I18n.t('app.page.carts.shipping_payment')
        assert_select "a.active", I18n.t('app.page.carts.bill_info_and_send')
      end
    end
  end

  test "first page of basket has content" do
    get show_basket_path
    assert_select "section#desc"
    assert_select "section#inbasket" do
      assert_select "table" do
        assert_select "thead" do
          assert_select "tr" do
            assert_select "th" do |hed|
              assert_equal I18n.t('app.page.carts.image'), hed[0].content
              assert_equal I18n.t('app.page.carts.name_desc'), hed[1].content
              assert_equal I18n.t('app.page.carts.price'), hed[2].content
              assert_equal "", hed[3].content
            end
          end
        end
        assert_select "tbody" do
          assert_select "tr" do
            assert_select "td" do |td|
              assert_select td[0], "a[href=?]", products_show_path do
                assert_select "img"
              end
              assert_select td[1], "a[href=?]", products_show_path
              assert_select td[2], "strong"
              assert_select td[3], "a"
            end
          end
        end
      end
      assert_select "label[for=?]", "voucher" do
        assert_select "input[type=?]", "checkbox"
      end
      assert_select "section#voucher-box" do
        assert_select "label[for=promo_code]", I18n.t('app.page.carts.voucher')
        assert_select "input#promo_code"
        assert_select "input[type=submit]"
      end
      assert_select ".flex-container" do
        assert_select ".flex-column" do |column|
          assert_select "a", I18n.t('helpers.button.back_to_shop'), column[0].content
          assert_select "a.button-primary", I18n.t('helpers.button.continue_to_trans_pay'), column[1].content
        end
      end
    end
  end

  test "second page of basket has content" do
    get payment_basket_path
    assert_select "section#desc"
    assert_select "section#inbasket" do
      assert_select "form" do
        assert_select "fieldset" do
          assert_select "legend", I18n.t('app.page.carts.login_or_signup')
          assert_select "legend", I18n.t('app.page.carts.choose_pay_method')
        end
      end
      assert_select "span.payment-methods"
      assert_select "fieldset" do
        assert_select "legend", I18n.t('app.page.carts.order_check')
      end
    end
    assert_select ".flex-container" do
      assert_select ".flex-column" do |column|
        assert_select "a", I18n.t('helpers.button.step_back'), column[0].content
        assert_select "a.button-primary", I18n.t('helpers.button.continue_order'), column[1].content
      end
    end
  end

  test "last page of basket has content" do
    get finish_basket_path
    assert_select "section#inbasket" do
      assert_select "form" do
        assert_select "fieldset" do
          assert_select "legend", I18n.t('app.page.carts.billing_information')
          assert_select "legend", I18n.t('app.page.carts.corporate_information')
          assert_select "input", count: 11
        end
      end
    end
    assert_select ".flex-container" do
      assert_select ".flex-column" do |column|
        assert_select "a", I18n.t('helpers.button.step_back'), column[0].content
        assert_select "a.button-primary", I18n.t('helpers.button.submit_order_pay'), column[1].content
      end
    end
  end
end
