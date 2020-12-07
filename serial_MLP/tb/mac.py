data = [4,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0]
weights = [4,
           5,
           6,
           7,
           8,
           9,
           0,
           1,
           2,
           3]

bias = 3

temp = 0
for i in range(len(data)):
    temp = data[i] * weights[i] + temp

temp += bias
print(temp)
