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

C_OPT_HEAP_LOAD_ADDR = 100


# Parser

def parse
  commands = []
  eof = false

  while !eof
    case nextc
    when SPACE
      parse_stack(commands)
    when NL
      parse_flow(commands)
    when TAB
      case nextc
      when SPACE
        parse_calc(commands)
      when TAB
        parse_heap(commands)
      when NL
        parse_io(commands)
      else
        raise "err"
      end
    else
      eof = true
    end
  end

  commands
end

def parse_stack(commands)
  case nextc
  when SPACE
    commands.push [C_STACK_PUSH, nextint]
  when NL
    case nextc
    when SPACE
      commands.push [C_STACK_DUP]
    when TAB
      commands.push [C_STACK_SWAP]
    when NL
      last_idx = commands.size - 1
      case commands[last_idx][0]
      when C_STACK_PUSH, C_OPT_HEAP_LOAD_ADDR
        commands.pop
      else
        commands.push [C_STACK_POP]
      end
    else
      raise "err"
    end
  else
    raise "err"
  end
end

def parse_flow(commands)
  commands.push(case nextc
  when SPACE
    case nextc
    when SPACE
      [C_FLOW_DEF, nextlabel]
    when TAB
      [C_FLOW_CALL, nextlabel]
    when NL
      [C_FLOW_JUMP, nextlabel]
    else
      raise 'err'
    end
  when TAB
    case nextc
    when SPACE
      [C_FLOW_JUMP_IF_ZERO, nextlabel]
    when TAB
      [C_FLOW_JUMP_IF_NEG, nextlabel]
    when NL
      [C_FLOW_END]
    else
      raise 'err'
    end
  when NL
    if nextc == NL
      [C_FLOW_EXIT]
    else
      raise 'err'
    end
  else
    raise 'err'
  end)
end

def parse_calc(commands)
  commands.push(case nextc
  when SPACE
    case nextc
    when SPACE
      [C_CALC_ADD]
    when TAB
      [C_CALC_SUB]
    when NL
      [C_CALC_MULTI]
    else
      raise "err"
    end
  when TAB
    case nextc
    when SPACE
      [C_CALC_DIV]
    when TAB
      [C_CALC_MOD]
    else
      raise "err"
    end
  else
    raise "err"
  end)
end

def parse_heap(commands)
  case nextc
  when SPACE
    commands.push [C_HEAP_SAVE]
  when TAB
    last_idx = commands.size - 1
    if commands[last_idx][0] == C_STACK_PUSH
      commands[last_idx][0] = C_OPT_HEAP_LOAD_ADDR
    else
      commands.push [C_HEAP_LOAD]
    end
  else
    raise "err"
  end
end

def parse_io(commands)
  commands.push(case nextc
  when SPACE
    case nextc
    when SPACE
      [C_IO_WRITE_CH]
    when TAB
      [C_IO_WRITE_NUM]
    else
      raise "err"
    end
  when TAB
    case nextc
    when SPACE
      [C_IO_READ_CH]
    when TAB
      [C_IO_READ_NUM]
    else
      raise "err"
    end
  else
    raise "err"
  end)
end

def nextc
  case ch = get_as_char
  when SPACE, TAB, NL, EOF
    ch
  else
    nextc
  end
end

def nextint
  sign = nextc
  int = 0
  while (ch = nextc) != NL
    case ch
    when SPACE
      # plus 0
    when TAB
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

    case c[0]
    when C_OPT_HEAP_LOAD_ADDR
      val = heap[c[1]]
      raise "Heap uninitialized" unless val
      stack.push val
    when C_STACK_PUSH
      stack.push c[1]
    when C_STACK_DUP
      stack.push stack[stack.size - 1]
    when C_STACK_SWAP
      s1 = stack.pop
      s2 = stack.pop
      stack.push s1
      stack.push s2
    when C_STACK_POP
      stack.pop
    when C_CALC_ADD
      r = stack.pop
      l = stack.pop
      stack.push(l + r)
    when C_CALC_SUB
      r = stack.pop
      l = stack.pop
      stack.push(l - r)
    when C_CALC_MULTI
      r = stack.pop
      l = stack.pop
      stack.push(l * r)
    when C_CALC_DIV
      r = stack.pop
      l = stack.pop
      stack.push(l / r)
    when C_CALC_MOD
      r = stack.pop
      l = stack.pop
      stack.push(l % r)
    when C_HEAP_SAVE
      val = stack.pop
      addr = stack.pop
      heap[addr] = val
    when C_HEAP_LOAD
      addr = stack.pop
      val = heap[addr]
      raise "Heap uninitialized" unless val
      stack.push val
    when C_FLOW_DEF
      # skip
    when C_FLOW_CALL
      call_stack.push index
      index = labels[c[1]]
    when C_FLOW_JUMP
      index = labels[c[1]]
    when C_FLOW_JUMP_IF_ZERO
      index = labels[c[1]] if stack.pop == 0
    when C_FLOW_JUMP_IF_NEG
      index = labels[c[1]] if stack.pop < 0
    when C_FLOW_END
      index = call_stack.pop
    when C_FLOW_EXIT
      exit
    when C_IO_WRITE_CH
      put_as_char stack.pop
    when C_IO_WRITE_NUM
      put_as_number stack.pop
    when C_IO_READ_CH
      addr = stack.pop
      heap[addr] = get_as_char
    when C_IO_READ_NUM
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
