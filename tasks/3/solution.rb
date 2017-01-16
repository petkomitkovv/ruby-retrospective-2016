class Option
  attr_reader :name, :short_name

  def initialize(short_name, name, description, block, pholder = "")
    @short_name = short_name
    @name = name
    @description = description
    @block = block
    @pholder = pholder
  end

  def parse(command_runner, param = true)
    @block.call(command_runner, param)
  end

  def contains_option?(options)
    options.keys.any? { |key| @short_name == key || @name == key }
  end

  def to_s
    phl = "=" + @pholder
    "    -#{@short_name}, --#{@name}#{phl unless phl == "="} #{@description}"
  end

  def self.parse_options(options)
    options.each { |option| option.insert(2, '=') if option.match(/^-\w/) }
    options = Hash[ options.flat_map { |s| s.scan(/--?([^=\s]+)(?:=(\S+))?/) } ]
    options.each { |k, v| options[k] = true if v.nil? }
  end
end

class Argument
  def initialize(arg, block)
    @arg = arg
    @block = block
  end

  def parse(command_runner, arg)
    @block.call(command_runner, arg)
  end

  def to_s
    "[#{@arg}]"
  end

  def self.argument?(arg)
    arg.chars.first != '-'
  end
end

class CommandParser
  def initialize(command_name)
    @command_name = command_name
    @arguments = []
    @options = []
  end

  def argument(arg, &block)
    @arguments.push(Argument.new(arg, block))
  end

  def option(short_name, name, description, &block)
    @options.push(Option.new(short_name, name, description, block))
  end

  def option_with_parameter(short_name, name, description, placeholder, &block)
    @options.push(Option.new(short_name, name, description, block, placeholder))
  end

  def parse(command_runner, argv)
    arguments = argv.select { |arg| Argument.argument?(arg) }
    @arguments.zip(arguments)
        .each { |argument, val| argument.parse(command_runner, val) }
    options = Option.parse_options(argv - arguments)
    @options.each do |opt|
      param = options[opt.name] || options[opt.short_name]
      opt.parse(command_runner, param) unless param.nil?
    end
  end

  def help
    help_str = "Usage: #{@command_name}"
    @arguments.each { |arg| help_str << " #{arg}" }
    @options.each { |opt| help_str << "\n#{opt}" }
    help_str
  end
end