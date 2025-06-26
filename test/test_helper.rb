$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'idle_rails_shutdown'
require 'minitest/autorun'
require 'active_support/core_ext/numeric/time'
require 'logger'

module Rails
  def self.logger
    @logger ||= Logger.new(File::NULL)
  end
end
