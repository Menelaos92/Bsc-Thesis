function vector=mat2vec(lat, lon, matrix,yr)
%lat must be a 1-d vector with size rows
%lon must be a 1-d vector with size cols
%matrix must be a 3-d vector with size rows x cols x months
%lat must progress from the S. pole to the N. pole
 
[rows, cols, months]=size(matrix);
 
%Cutting matrix in 2 halves (top and bottom) and exchanging their position
%top half initially contains longitudes 0 - 180 deg and bottom 180-360 deg
halfmatrix=matrix(1:rows/2,:,:);
matrix(1:rows/2,:,:)=matrix(rows/2+1:rows,:,:);
matrix(rows/2+1:rows,:,:)=halfmatrix;
 
%Cutting lon in 2 halves (top and bottom) and exchanging their position
%top half initially contains longitudes 0 - 180 deg and bottom 180-360 deg
halflon=lon(1:rows/2);
lon(1:rows/2)=lon(rows/2+1:rows);
lon(rows/2+1:rows)=halflon;
 
 
if (lat(1)==-90)
%matrix contains data on the edges of the pixels. E.g. it contains data at
%-90 deg and 90 deg. Newmatrix contains data in the centers of the pixels.
%It averages values from the two edges and places them in the pixel center.
newlat=nan(cols-1,1);
newmatrix=zeros(rows,cols-1,months);
 
for i=1:cols-1
    newlat(i)=(lat(i)+lat(i+1))/2;
    for j=1:rows
        for k=1:months
            count=0;
            if (~isnan(matrix(j,i,k)))
                count=count+1;
                newmatrix(j,i,k)=newmatrix(j,i,k)+matrix(j,i,k);
            end
            if (~isnan(matrix(j,i+1,k)))
                count=count+1;
                newmatrix(j,i,k)=newmatrix(j,i,k)+matrix(j,i+1,k);
            end
            if count~=0
                newmatrix(j,i,k)=newmatrix(j,i,k)/count;
            else
                newmatrix(j,i,k)=-1000;
            end
        end
    end
end
numbercols=cols-1;
 
else %the latitudes don’t start at exactly -90 deg. Change nothing
numbercols=cols;
newlat=lat;
newmatrix=matrix;
end
 
 
vector=zeros(rows*numbercols,months+2);
 
for i=1:numbercols
    for j=1:rows
        index=(i-1)*rows+j;
        vector(index,1)=newlat(i);
        vector(index,2)=lon(j);
        for k=1:months
            vector(index,k+2)=newmatrix(j,i,k);
        end
    end
end
 
fid=fopen(['rlds' num2str(yr) '.txt'],'w');
fprintf(fid,'%7.3f %9.3f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f\n',vector');
fclose(fid);