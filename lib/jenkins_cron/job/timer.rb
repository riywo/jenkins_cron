class JenkinsCron::Job::Timer
  def initialize(&block)
    @min   = Field.new
    @hour  = Field.new
    @day   = Field.new
    @month = Field.new
    @day_w = Field.new
    instance_eval(&block) if block_given?
  end

  def to_s
    "#{@min} #{@hour} #{@day} #{@month} #{@day_w}"
  end
  alias :inspect :to_s

  private

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
      @opts = {}
      if args.last.is_a? Hash
        @opts = args.pop
      end

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
