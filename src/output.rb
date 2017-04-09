digits = [        
    "11000000", "11111001", "10100100", "10110000", "10011001",
    "10010010", "10000010", "11111000", "10000000", "10010000"];

# Ones place
for i in 0..255
    print "\"",digits[i%10],"\", ";
    if ((i%8) == 7)
        puts ""
    end
end

# Tens place
for i in 0..255
    print "\"",digits[(i/10)%10],"\", ";
    if ((i%8) == 7)
        puts ""
    end
end

# Hundreds place
for i in 0..255
    print "\"",digits[(i/100)%10],"\", ";
    if ((i%8) == 7)
        puts ""
    end
end

# Thousands place
for i in 0..255
    print "\"11111111\", ";
    if ((i%8) == 7)
        puts ""
    end
end

###### TWO's complement

# Ones place
for i in 0..255
    value = i < 128 ? i : i-256
    print "\"",digits[value.abs%10],"\", ";
    if ((i%8) == 7)
        puts ""
    end
end

# Tens place
for i in 0..255
    value = i < 128 ? i : i-256
    print "\"",digits[(value.abs/10)%10],"\", ";
    if ((i%8) == 7)
        puts ""
    end
end

# Hundreds place
for i in 0..255
    value = i < 128 ? i : i-256
    print "\"",digits[(value.abs/100)%10],"\", ";
    if ((i%8) == 7)
        puts ""
    end
end

# Thousands place
for i in 0..255
    value = i < 128 ? i : i-256
    print value >= 0 ? "\"11111111\", " : "\"10111111\", " ;
    if ((i%8) == 7)
        puts ""
    end
end



