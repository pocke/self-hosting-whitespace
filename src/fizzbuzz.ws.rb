def fizz
  put_as_char 'f'
  put_as_char 'i'
  put_as_char 'z'
  put_as_char 'z'
end

def buzz
  put_as_char 'b'
  put_as_char 'u'
  put_as_char 'z'
  put_as_char 'z'
end

max = 16
n = 0 - max
while n < 0
  x = max + n + 1
  if x % 15 == 0
    fizz
    buzz
  elsif x % 3 == 0
    fizz
  elsif x % 5 == 0
    buzz
  else
    put_as_number x
  end
  put_as_char ' '
  n = n + 1
end
