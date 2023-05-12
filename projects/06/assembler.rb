require_relative './parser'
require_relative './code'
require_relative './symbol_table'

class Assembler
  INITIAL_RAM_ADDRESS = 16

  def self.call(...)
    new(...).call
  end

  def initialize(input)
    @input = File.open(input)
    @parser = Parser.new(input)
    @symbols = SymbolTable.new()
    @output = File.new(output_path(input), 'w')
    @current_ram_address = INITIAL_RAM_ADDRESS
  end

  def call
    add_labels_to_symbol_table
    rewind_input
    assemble_input

    @input.close
    @output.close
  end

  private

  def output_path(input)
    File.join(File.dirname(input), File.basename(input, '.asm') + '.hack')
  end

  def add_labels_to_symbol_table
    while @parser.hasMoreLines
      @parser.advance

      @symbols.addEntry(@parser.symbol, @parser.current_address) if @parser.instructionType == Parser::L_INSTRUCTION
    end
  end

  def rewind_input
    @parser.rewind
  end

  def assemble_input
    while @parser.hasMoreLines
      @parser.advance

      binary =
        if @parser.instructionType == Parser::C_INSTRUCTION
          assemble_c_instruction
        elsif @parser.instructionType == Parser::A_INSTRUCTION
          assemble_a_instruction
        end

      return if binary.nil?

      @output.puts binary
    end
  end

  def assemble_c_instruction
    comp = Code.comp(@parser.comp)
    dest = Code.dest(@parser.dest)
    jump = Code.jump(@parser.jump)

    "111#{comp}#{dest}#{jump}"
  end

  def assemble_a_instruction
    symbol = @parser.symbol

    return to_binary(symbol) if is_numeric?(symbol) # convert numeric RAM address to binary as is
    # Fetch RAM address from symbol table and convert to binary for known symbols
    return to_binary(@symbols.getAddress(symbol)) if @symbols.contains(symbol)

    address = @current_ram_address

    # Add new symbol to symbol table
    @symbols.addEntry(symbol, address)
    @current_ram_address += 1 # increment RAM address

    to_binary(address)
  end

  def is_numeric?(string)
    Integer(string) rescue nil
  end

  def to_binary(symbol)
    "%016b" % symbol
  end
end

Assembler.call('path/to/input')
