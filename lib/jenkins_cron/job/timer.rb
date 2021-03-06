require "active_support/all"
require "chronic"

class JenkinsCron::Job::Timer
  OPTS = [:every, :at, :min, :hour, :day, :month, :day_w, :once_an_hour, :once_a_day, :once_a_month, :once_a_day_w]
  DAYS_W = [:Sunday, :Monday, :Tuesday, :Wednesday, :Thursday, :Friday, :Saturday]
  WEEKDAY = [:Monday, :Tuesday, :Wednesday, :Thursday, :Friday]
  WEEKEND = [:Sunday, :Saturday]
  def initialize(opts = {}, &block)
    initialize_with_opts(opts) if opts.size > 0
    instance_eval(&block)      if block_given?
  end

  def to_s
    "#{min} #{hour} #{day} #{month} #{day_w}"
  end
  alias :inspect :to_s

  private

  def initialize_with_opts(opts)
    opts.each do |opt, value|
      next unless OPTS.include?(opt)
      send("initialize_#{opt}", value)
    end
  end

  def initialize_every(time)
    case time
      when 0.seconds...1.minute
        raise ArgumentError, "Must be in minutes or higher"
      when 1.minute...1.hour
        min   every: time/60
      when 1.hour...1.day
        min   :once
        hour  every: (time/60/60).round
      when 1.day...1.month
        min   :once
        hour  :once
        day   every: (time/60/60/24).round
      when 1.month..12.months
        min   :once
        hour  :once
        day   :once
        month every: (time/60/60/24/30).round
      when *DAYS_W
        min   :once
        hour  :once
        day_w DAYS_W.index(time)
      when :Weekday
        min   :once
        hour  :once
        day_w WEEKDAY.map {|d| DAYS_W.index(d) }
      when :Weekend
        min   :once
        hour  :once
        day_w WEEKEND.map {|d| DAYS_W.index(d) }
      else
        raise ArgumentError, "Invalid every option '#{time}'"
    end
  end

  def initialize_at(time)
    at = time.is_a?(String) ? Chronic.parse(time) : time
    raise ArgumentError, "Invalid at option '#{time}'" if at.nil?
    hour at.hour
    min  at.min
  end

  def initialize_min(time)
    min time
  end

  def initialize_hour(time)
    hour time
  end

  def initialize_day(time)
    day time
  end

  def initialize_month(time)
    month time
  end

  def initialize_day_w(time)
    day_w time
  end

  def initialize_once_an_hour(time)
    min   :once
    hour  time
  end

  def initialize_once_a_day(time)
    min   :once
    hour  :once
    day   time
  end

  def initialize_once_a_month(time)
    min   :once
    hour  :once
    day   :once
    month time
  end

  def initialize_once_a_day_w(time)
    min   :once
    hour  :once
    time = case time
      when Array
        time.map { |d| DAYS_W.include?(d) ? DAYS_W.index(d) : d }
      else
        DAYS_W.include?(time) ? DAYS_W.index(time) : time
    end
    day_w time
  end

  def min(*args)
    @min = Field.new(*args) if(@min.nil? or args.length > 0)
    @min
  end

  def hour(*args)
    @hour = Field.new(*args) if(@hour.nil? or args.length > 0)
    @hour
  end

  def day(*args)
    @day = Field.new(*args) if(@day.nil? or args.length > 0)
    @day
  end

  def month(*args)
    @month = Field.new(*args) if(@month.nil? or args.length > 0)
    @month
  end

  def day_w(*args)
    @day_w = Field.new(*args) if(@day_w.nil? or args.length > 0)
    @day_w
  end

  class Field
    def initialize(*args)
      @opts = args.last.is_a?(Hash) ? args.pop : {}
      @every = @opts[:every] if @opts.has_key? :every

      case args.length
        when 0
          @value = (@every.nil? or @every == 1) ? "*" : "H"
        when 1
          @value = args[0] == :once ? "H" : args[0]
        else
          @value = args
      end
    end

    def to_s
      unless @string
        @string = case @value
          when Range
            "H(#{@value.first}-#{@value.last})"
          when Array
            @value.join(",")
          when Fixnum
            @value.to_s
          when "H","*"
            @value
        end
        @string += "/#{@every}" if (!@every.nil? and @every != 1)
      end
      @string
    end
  end
end
