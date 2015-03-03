Capybara.run_server = false
Capybara.app_host = 'http://community.spiceworks.com/'
Capybara.default_driver = :selenium
Capybara.default_selector = :css
Capybara.current_session.driver.browser.manage.window.resize_to(1024, 768)
Capybara.ignore_hidden_elements = true
