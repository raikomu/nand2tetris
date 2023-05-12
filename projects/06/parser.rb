class Parser
  attr_reader :current_address

  A_INSTRUCTION = 'A_INSTRUCTION'.freeze
  C_INSTRUCTION = 'C_INSTRUCTION'.freeze
  L_INSTRUCTION = 'L_INSTRUCTION'.freeze

  def initialize(input, current_instruction = '', current_address = 0)
    @input = File.open(input)
    @current_instruction = current_instruction
    @current_address = current_address # ROM address, equal to executable line number
  end

  def hasMoreLines
    !@input.eof?
  end

  def advance
    line = @input.readline

    # skip empty and commented lines
    if !line.strip.empty? && line[0..1] != '//'
      @current_instruction = line.split('//').first.strip # remove comments
      @current_address += 1 unless instructionType == L_INSTRUCTION
    else
      advance
    end
  end

  def instructionType
    return if @current_instruction.empty?
    return A_INSTRUCTION if @current_instruction[0] == '@'
    return C_INSTRUCTION if @current_instruction.include?(';') || @current_instruction.include?('=')

    L_INSTRUCTION
  end

  def symbol
    return unless [A_INSTRUCTION, L_INSTRUCTION].include?(instructionType)

    @current_instruction.strip.tr('@()', '') # remove @ for a instruction, () for l instruction
  end

  def dest
    return unless instructionType == C_INSTRUCTION
    return unless @current_instruction.include?('=')

    @current_instruction.strip.split('=').first
  end

  def comp
    return unless instructionType == C_INSTRUCTION

    @current_instruction.strip.split('=').last.split(';').first
  end

  def jump
    return unless instructionType == C_INSTRUCTION
    return unless @current_instruction.include?(';')

    @current_instruction.strip.split(';').last
  end

  def rewind
    @input.rewind
  end
end
