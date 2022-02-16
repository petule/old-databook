require 'test_helper'

class HomePageTest < ActionDispatch::IntegrationTest

  setup do
    get root_path
  end

  test "has header" do
    assert_select "header" do
      assert_select "nav.top" do
        assert_select "a", count: 7
      end
      assert_select ".header.top" do
        assert_select ".logo" do
          assert_select "a[href=?]", root_path, I18n.t('app.desc')
        end
        assert_select "form" do
          assert_select "input[placeholder=?]", I18n.t('helpers.placeholder.search')
        end
        assert_select ".minicart" do
          assert_select ".currency"
          assert_select ".cart" do
            assert_select "a[href=?]", show_basket_path
          end
        end
      end
    end
  end
end
