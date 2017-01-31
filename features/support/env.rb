require 'faraday'
require 'selenium-webdriver'
require 'pry'
require 'faker'

require 'dotenv'
Dotenv.load

require_relative '../../slack_api'

Driver = Selenium::WebDriver.for :chrome

at_exit { Driver.quit }