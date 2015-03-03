# Requires Firefox 24.0 & Selenium-webdriver 2.44.0

require 'rubygems'
require 'capybara'
require 'rspec/expectations'
require 'rspec'

require_relative 'config'

EXPECTED_IMG_URL = 'http://static.spiceworks.com/assets/community/icons/small/whitepaper_blue-637160d5aba3c2c7824c50f3470b3c65.png'

class SpiceworksTest
	include Capybara::DSL

    def login_existing_user(login_email, login_password)
      	visit('/start')

  		fill_in 'login_email', :with => login_email
    	fill_in 'login_password', :with => login_password
		click_button 'Log In'
    end

    def click_submenu_for_menu(menu_locator, submenu_locator)
		click_link (menu_locator)
    	within '.domestic-menus_submenu_items' do
    		click_link (submenu_locator)
    	end
	end

	def find_submenu_for_menu(menu_locator, submenu_locator)
		click_link (menu_locator)
		within '.domestic-menus_submenu_items' do
			find_link(submenu_locator).visible?
		end
	end

	def see_all_items_for_topic(topic_locator)
		within '.topic-list-tabs' do
			click_link(topic_locator)
			click_link('see all')
		end
	end

	def open_tab(tab_locator)
		within '.channel-component-tabs' do
			click_link(tab_locator)
		end
	end

	def find_group(group_locator)
		check_next_page = false
		within '.groups' do
			group_links = all(:link, group_locator, {maximum: 1})
			check_next_page = group_links.empty?
		end
		if check_next_page
			within '.tab-content .active' do
				first(:css, '.next_page').click
				find_group(group_locator)
			end
		end
	end

	def verify_icon_for_subject(subject_locator)
		within find_link(subject_locator) do 
			target_row = find(:xpath, '../../..')
			target_img = target_row.find(:css, 'img')

			if target_img['src'] != EXPECTED_IMG_URL
				raise Capybara::CapybaraError.new('Unexpected image src')
			end
		end
	end

	def logout_user
		find(:css, '.usernav-link').click
		click_link('Logout')
	end
end

t = SpiceworksTest.new
t.login_existing_user('venifer@gmail.com', 'Qaz1wsx2')
t.click_submenu_for_menu('Categories', 'Networking')
t.find_submenu_for_menu('Resources', 'Vendor Pages')
t.see_all_items_for_topic('Popular')
t.open_tab('Groups')
t.find_group('Cisco')
t.open_tab('Resources')
t.verify_icon_for_subject('Seven Habits of Highly Successful MSPs')
t.logout_user

