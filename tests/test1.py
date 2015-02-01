        
#   comment
                #comment
# Factorial  :

def fact(x):

  if x < 0:
            #comment
    return 1
  elif x == 0:

        return 1    #comment
  else:
        #comment
    return x    * fact(x - 1) #comment

print(fact(4))
