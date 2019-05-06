SPACE = " "
TAB = "\t"
NL = "\n"

EOF = "$"

# Commands
C_STACK_PUSH        = 1
C_STACK_DUP         = 2
C_STACK_SWAP        = 3
C_STACK_POP         = 4

C_CALC_ADD          = 5
C_CALC_SUB          = 6
C_CALC_MULTI        = 7
C_CALC_DIV          = 8
C_CALC_MOD          = 9

C_HEAP_SAVE         = 10
C_HEAP_LOAD         = 11

C_FLOW_DEF          = 12
C_FLOW_CALL         = 13
C_FLOW_JUMP         = 14
C_FLOW_JUMP_IF_ZERO = 15
C_FLOW_JUMP_IF_NEG  = 16
C_FLOW_END          = 17
C_FLOW_EXIT         = 18

C_IO_WRITE_CH       = 19
C_IO_WRITE_NUM      = 20
C_IO_READ_CH        = 21
C_IO_READ_NUM       = 22


# Parser

def parse
  commands = []
  eof = false

  while !eof
    ch = nextc

    if ch == SPACE
      commands.push parse_stack
    elsif ch == NL
      commands.push parse_flow
    elsif ch == TAB
      ch = nextc
      if ch == SPACE
        commands.push parse_calc
      elsif ch == TAB
        commands.push parse_heap
      elsif ch == NL
        commands.push parse_io
      else
        raise "err"
      end
    else
      eof = true
    end
  end

  commands
end

def parse_stack
  ch = nextc

  if ch == SPACE
    [C_STACK_PUSH, nextint]
  elsif ch == NL
    ch2 = nextc
    if ch2 == SPACE
      [C_STACK_DUP]
    elsif ch2 == TAB
      [C_STACK_SWAP]
    elsif ch2 == NL
      [C_STACK_POP]
    else
      raise "err"
    end
  else
    raise "err"
  end
end

def parse_flow
  ch1 = nextc
  ch2 = nextc
  if ch1 == SPACE
    if ch2 == SPACE
      [C_FLOW_DEF, nextlabel]
    elsif ch2 == TAB
      [C_FLOW_CALL, nextlabel]
    elsif ch2 == NL
      [C_FLOW_JUMP, nextlabel]
    else
      raise 'err'
    end
  elsif ch1 == TAB
    if ch2 == SPACE
      [C_FLOW_JUMP_IF_ZERO, nextlabel]
    elsif ch2 == TAB
      [C_FLOW_JUMP_IF_NEG, nextlabel]
    elsif ch2 == NL
      [C_FLOW_END]
    else
      raise 'err'
    end
  elsif ch1 == NL
    if ch2 == NL
      [C_FLOW_EXIT]
    else
      raise 'err'
    end
  else
    raise 'err'
  end
end

def parse_calc
  ch1 = nextc
  ch2 = nextc
  if ch1 == SPACE
    if ch2 == SPACE
      [C_CALC_ADD]
    elsif ch2 == TAB
      [C_CALC_SUB]
    elsif ch2 == NL
      [C_CALC_MULTI]
    else
      raise "err"
    end
  elsif ch1 == TAB
    if ch2 == SPACE
      [C_CALC_DIV]
    elsif ch2 == TAB
      [C_CALC_MOD]
    else
      raise "err"
    end
  else
    raise "err"
  end
end

def parse_heap
  ch = nextc
  if ch == SPACE
    [C_HEAP_SAVE]
  elsif ch == TAB
    [C_HEAP_LOAD]
  else
    raise "err"
  end
end

def parse_io
  ch1 = nextc
  ch2 = nextc
  if ch1 == SPACE
    if ch2 == SPACE
      [C_IO_WRITE_CH]
    elsif ch2 == TAB
      [C_IO_WRITE_NUM]
    else
      raise "err"
    end
  elsif ch1 == TAB
    if ch2 == SPACE
      [C_IO_READ_CH]
    elsif ch2 == TAB
      [C_IO_READ_NUM]
    else
      raise "err"
    end
  else
    raise "err"
  end
end

def nextc
  ch = get_as_char
  if ch == SPACE
    ch
  elsif ch == TAB
    ch
  elsif ch == NL
    ch
  elsif ch == EOF
    ch
  else
    nextc
  end
end

def nextint
  sign = nextc
  int = 0
  while (ch = nextc) != NL
    if ch == SPACE
      # plus 0
    elsif ch == TAB
      int = int + 1
    else
      raise "err"
    end
    int = int * 2
  end
  int = int / 2
  int = 0 - int if sign == TAB
  int
end

def nextlabel
  label = 0
  while (ch = nextc) != NL
    if ch == TAB
      label = label + 1
    end
    label = label * 2
  end
  label
end

# VM

def prepare_label(commands, labels)
  idx = 0
  size = commands.size
  while idx < size
    c = commands[idx]
    if c[0] == C_FLOW_DEF
      labels[c[1]] = idx
    end

    idx = idx + 1
  end
end

def eval_ws(commands)
  stack = []
  heap = {}
  call_stack = []
  index = 0
  labels = {}

  prepare_label(commands, labels)

  while true
    c = commands[index]
    c0 = c[0]

    if c0 == C_STACK_PUSH
      stack.push c[1]
    elsif c0 == C_STACK_DUP
      stack.push stack[stack.size - 1]
    elsif c0 == C_STACK_SWAP
      s1 = stack.pop
      s2 = stack.pop
      stack.push s1
      stack.push s2
    elsif c0 == C_STACK_POP
      stack.pop
    elsif c0 == C_CALC_ADD
      r = stack.pop
      l = stack.pop
      stack.push(l + r)
    elsif c0 == C_CALC_SUB
      r = stack.pop
      l = stack.pop
      stack.push(l - r)
    elsif c0 == C_CALC_MULTI
      r = stack.pop
      l = stack.pop
      stack.push(l * r)
    elsif c0 == C_CALC_DIV
      r = stack.pop
      l = stack.pop
      stack.push(l / r)
    elsif c0 == C_CALC_MOD
      r = stack.pop
      l = stack.pop
      stack.push(l % r)
    elsif c0 == C_HEAP_SAVE
      val = stack.pop
      addr = stack.pop
      heap[addr] = val
    elsif c0 == C_HEAP_LOAD
      addr = stack.pop
      val = heap[addr]
      raise "Heap uninitialized" unless val
      stack.push val
    elsif c0 == C_FLOW_DEF
      # skip
    elsif c0 == C_FLOW_CALL
      call_stack.push index
      index = labels[c[1]]
    elsif c0 == C_FLOW_JUMP
      index = labels[c[1]]
    elsif c0 == C_FLOW_JUMP_IF_ZERO
      index = labels[c[1]] if stack.pop == 0
    elsif c0 == C_FLOW_JUMP_IF_NEG
      index = labels[c[1]] if stack.pop < 0
    elsif c0 == C_FLOW_END
      index = call_stack.pop
    elsif c0 == C_FLOW_EXIT
      exit
    elsif c0 == C_IO_WRITE_CH
      put_as_char stack.pop
    elsif c0 == C_IO_WRITE_NUM
      put_as_number stack.pop
    elsif c0 == C_IO_READ_CH
      addr = stack.pop
      heap[addr] = get_as_char
    elsif c0 == C_IO_READ_NUM
      addr = stack.pop
      heap[addr] = get_as_number
    else
      raise 'err'
    end

    index = index + 1
  end
end

# main

commands = parse
# commands = [[C_FLOW_EXIT], [C_IO_WRITE_NUM], [C_STACK_PUSH, 42]]
eval_ws commands
