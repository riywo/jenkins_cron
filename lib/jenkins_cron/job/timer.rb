require "active_support/all"
require "chronic"

class JenkinsCron::Job::Timer
  OPTS = [:every, :at, :min]
  def initialize(opts = {}, &block)
    @min   = Field.new
    @hour  = Field.new
    @day   = Field.new
    @month = Field.new
    @day_w = Field.new
    initialize_with_opts(opts) if opts.size > 0
    instance_eval(&block)      if block_given?
  end

  def to_s
    "#{@min} #{@hour} #{@day} #{@month} #{@day_w}"
  end
  alias :inspect :to_s

  private

  def initialize_with_opts(opts)
    opts.each do |opt, value|
      next unless OPTS.include?(opt)
      send("initialize_#{opt}", value)
    end
  end

  def initialize_every(seconds)
    case seconds
      when 0.seconds...1.minute
        raise ArgumentError, "'every' must be in minutes or higher"
      when 1.minute...1.hour
        min   every: seconds/60
      when 1.hour...1.day
        min   :once
        hour  every: (seconds/60/60).round
      when 1.day...1.month
        min   :once
        hour  :once
        day   every: (seconds/60/60/24).round
      when 1.month..12.months
        min   :once
        hour  :once
        day   :once
        month every: (seconds/60/60/24/30).round
      else
    end
  end

  def initialize_at(time)
    at = time.is_a?(String) ? (Chronic.parse(time) || 0) : time
    hour at.hour
    min  at.min
  end

  def initialize_min(time)
    min time
  end

  def min(*args)
    @min = Field.new(*args)
  end

  def hour(*args)
    @hour = Field.new(*args)
  end

  def day(*args)
    @day = Field.new(*args)
  end

  def month(*args)
    @month = Field.new(*args)
  end

  def day_w(*args)
    @day_w = Field.new(*args)
  end

  class Field
    def initialize(*args)
      @opts = args.last.is_a?(Hash) ? args.pop : {}

      case args.length
        when 0
          @string = "*"
          @string = "H/#{@opts[:every]}" if @opts.has_key? :every
        when 1
          case args[0]
            when Range
              @string = "H(#{args[0].first}-#{args[0].last})"
              @string += "/#{@opts[:every]}" if @opts.has_key? :every
            when :once
              @string = "H"
              @string += "/#{@opts[:every]}" if @opts.has_key? :every
            else
              @string = "#{args[0]}"
          end
        else
          @string = args.join(",")
      end
    end

    def to_s
      @string
    end
  end
end
