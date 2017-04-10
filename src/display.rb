digits = [        
    "DIG_0", "DIG_1", "DIG_2", "DIG_3", "DIG_4",
    "DIG_5", "DIG_6", "DIG_7", "DIG_8", "DIG_9"];

# Ones place
for i in 0..255
    print digits[i%10],", ";
    if ((i%8) == 7)
        puts ""
    end
end

# Tens place
for i in 0..255
    if i<10
        print "BLANK, ";
    else
        print digits[(i/10)%10],", ";
    end;
    if ((i%8) == 7)
        puts ""
    end
end

# Hundreds place
for i in 0..255
    if i<100
        print "BLANK, ";
    else
        print digits[(i/100)%10],", ";
    end;
    if ((i%8) == 7)
        puts ""
    end
end

# Thousands place
for i in 0..255
    print "BLANK, ";
    if ((i%8) == 7)
        puts ""
    end
end

###### TWO's complement

# Ones place
for i in 0..255
    value = i < 128 ? i : i-256
    print digits[value.abs%10],", ";
    if ((i%8) == 7)
        puts ""
    end
end

# Tens place
for i in 0..255
    value = i < 128 ? i : i-256
    if value.abs < 10 then
        print "BLANK, ";
    else
        print digits[(value.abs/10)%10],", ";
    end
    if ((i%8) == 7)
        puts ""
    end
end

# Hundreds place
for i in 0..255
    value = i < 128 ? i : i-256
    if value.abs < 100 then
        print "BLANK, ";
    else
        print digits[(value.abs/100)%10],", ";
    end
    if ((i%8) == 7)
        puts ""
    end
end

# Thousands place
for i in 0..255
    value = i < 128 ? i : i-256
    print value >= 0 ? "BLANK, " : "NEGAT, " ;
    if ((i%8) == 7)
        puts ""
    end
end



