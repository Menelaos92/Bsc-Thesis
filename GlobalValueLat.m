function y=GlobalValueLat(filename,columns,month,minlat,maxlat,treatNaN)
%Y=GLOBALVALUELAT('FILENAME',COLUMNS,MONTH,MINLAT,MAXLAT,TREATNAN)
%estimates the mean value of the quantity saved in 'filename', having
%COLUMNS+2 columns, averaged between latitudes MINLAT and MAXLAT
%for the months contained in matrix MONTH. If TREATNAN is zero, then -1000s
%are treated as zeros, otherwise they are treated as NaNs
% 
%   'FILENAME' must store a global quantity in columns.  The first two
%   columns must correspond to the pixel latitude and longitude, while the
%   rest must contain the monthly values of the quantity.  This function
%   also has the ability to save the averaged values over the months of
%   variable MONTH in a separate file (see function body).
%
%   For example GlobalValueLat('DATA',12,[1:12],-23,23) returns the annual
%   average value of data file 'DATA' between latitudes -23 and 23 degrees.
  if nargin==1
    columns=12;
    month=(1:12);
    minlat=-90;
    maxlat=90;
    treatNaN=0;
elseif nargin==2
    month=(1:12);
    minlat=-90;
    maxlat=90;
    treatNaN=0;
elseif nargin==3
    minlat=-90;
    maxlat=90;
    treatNaN=0;
elseif nargin==4
    maxlat=90;
    treatNaN=0;
elseif nargin==5
    treatNaN=0;
end
  
fid=fopen(filename,'rt');
data=fscanf(fid,'%f',[columns+2,inf]);
fclose(fid);
data=data';
 
sum=0;
sumw=0;
for i=1:length(data)
    if (data(i,1)>maxlat || data(i,1)<minlat)
        continue
    else
        weight=cos(deg2rad(data(i,1)));
        for n=1:length(month)
           k=month(n);
           if data(i,2+k)==-1000
                if treatNaN==0
                    data(i,2+k)=0;
                else
                    continue
                end
           end    
           sum=sum+data(i,2+k)*weight;
           sumw=sumw+weight;                 
        end
    end
end
if sumw~=0
    y=sum/sumw;
else
    y=-1000;
end
