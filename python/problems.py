# 1. Convert minutes to readable format

def convert_minutes(n):
  hours = n // 60
  minutes = n % 60

  if hours > 0:
      return str(hours) + " hr " + str(minutes) + " minutes"
  else:
      return str(minutes) + " minutes"


print(convert_minutes(130))
print(convert_minutes(110))


# 2. Remove duplicates using loop

def remove_duplicates(s):
  result = ""
  
  for ch in s:
      if ch not in result:
          result += ch
  
  return result


print(remove_duplicates("programming"))
