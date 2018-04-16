f = open("test.txt", "r")
sum = 0
for line in f:
	if "insert" in line:
		s = line.split(" ")
		if int(s[4]) < 500:
			sum += int(s[4])

print(sum)