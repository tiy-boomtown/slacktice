module Boomtown
  class Web
    attr_reader :driver, :wait

    def initialize
      @driver = Selenium::WebDriver.for :chrome
      @wait   = Selenium::WebDriver::Wait.new timeout: 15

      at_exit { @driver.quit }
    end

    # General helpers

    def visit(path)
      driver.get "http://www.qa6hawkeye3.com#{path}"
    end

    def find(css)
      driver.find_element css: css
    end

    def find_all(css)
      driver.find_elements css: css
    end

    def wait_for(selector)
      wait.until do
        find selector
      end
    end

    # Domain-level helpers

    def search_for(term)
      visit "/"
      search = wait_for '#query'
      search.send_keys term

      btn = find '.bt-home-search__button'
      btn.click
    end
  end
end
