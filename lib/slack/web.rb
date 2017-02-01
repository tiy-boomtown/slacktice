module Slack
  class Web
    attr_reader :driver, :wait

    def initialize
      @driver = Selenium::WebDriver.for :chrome
      @wait   = Selenium::WebDriver::Wait.new timeout: 15

      at_exit { @driver.quit }
    end

    def select_team(team='tiy-boomtown')
      driver.get 'https://slack.com/signin'

      team_input = driver.find_element :id, 'domain'
      team_input.send_keys team

      driver.find_element(:id, 'submit_team_domain').click
    end

    def login_as(email, password)
      email_field = driver.find_element :name, 'email'
      email_field.send_keys email

      password_field = driver.find_element :name, 'password'
      password_field.send_keys password

      buttons = driver.find_elements :css, 'button'
      sign_in = buttons.select { |b| b.text == 'Sign in' }.first
      sign_in.click
    end

    def join_channel(channel_name)
      # Go to channel search
      headers = driver.find_elements :css, 'button.channel_list_header_label'
      channel_link = wait.until do
        el = headers.find { |b| b.text.start_with? 'CHANNELS' }
        el if el && el.displayed?
      end
      channel_link.click

      # Filter down to see the channel
      driver.find_element(:id, 'channel_browser_filter').send_keys channel_name

      # The link we need to click on doesn't appear until we mouse over the position
      link = driver.find_element(:css, '.channel_link')
      driver.mouse.move_to link
      overlay = driver.find_element :css, '#channel_browser'
      overlay.click
    end

    def visit_channel(name)
      channels = driver.find_element css: '#channel-list'
      links    = channels.find_elements css: 'a'
      links.find { |l| l.text == 'test' }.click
    end

    # Allow us to use the SlackWeb object in place of the driver that it wraps
    def find_element(*args)
      driver.find_element(*args)
    end

    def find_elements(*args)
      driver.find_elements(*args)
    end
  end
end
