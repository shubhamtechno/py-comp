# Comment 1
# Comment 2
# Factorial:

def fact(x):
  if x < 0:
    return 1
  elif x == 0:
    return 1
  else:
    return x * fact(x - 1)

print(fact(4))
