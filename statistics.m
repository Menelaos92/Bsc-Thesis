len=length(y);
[b,bint]=regress(y',[ones(len,1) (1:len)'],0.05);
Result=b(2)*len;
if sign(bint(2,1))==sign(bint(2,2))
    disp('TRUE')
else 
    disp('FALSE')
end
[b1,bint1]=regress(y1',[ones(len,1) (1:len)'],0.05);
Result1=b1(2)*len;
if sign(bint1(2,1))==sign(bint1(2,2))
    disp('TRUE')
else 
    disp('FALSE')
end
[b2,bint2]=regress(y2',[ones(len,1) (1:len)'],0.05);
Result2=b2(2)*len;
if sign(bint2(2,1))==sign(bint2(2,2))
disp('TRUE')
else 
    disp('FALSE')
end
[b3,bint3]=regress(y3',[ones(len,1) (1:len)'],0.05);
Result3=b3(2)*len;
if sign(bint3(2,1))==sign(bint3(2,2))
disp('TRUE')
else 
    disp('FALSE')
end
[b4,bint4]=regress(y4',[ones(len,1) (1:len)'],0.05);
Result4=b4(2)*len;
if sign(bint4(2,1))==sign(bint4(2,2))
disp('TRUE')
else 
    disp('FALSE')
end
[b5,bint5]=regress(y5',[ones(len,1) (1:len)'],0.05);
Result5=b5(2)*len;
if sign(bint5(2,1))==sign(bint5(2,2))
disp('TRUE')
else 
    disp('FALSE')
end