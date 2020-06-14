function []=worldformat(filename,month,smooth,titlestring,...
    units,cmin,cmax,zoom,discreet,figno)
%WORLDFORMAT('FILENAME',MONTH,'SMOOTH','TITLESTRING','UNITS',...
%CMIN,CMAX,'ZOOM','DISCREET','FIGNO') projects the data of 'FILENAME' on the globe.
%
%   MONTH is an integer from 1 to 12. If 'SMOOTH' is set to 'SMOOTH' smoothing is applied
%   to the graph. CMIN and CMAX give the limits of the colormap. Setting
%   'ZOOM' to 'EUROPE', worldformat zooms to europe. Setting 'DISCREET' to
%   'DISC' instead of 'CONT', forces the use of a colormap with only 12 colors.
%   'FIGNO' is the figure number.
%
%   'FILENAME' must have 14 columns, of which 1st and 2nd should be the latitude
%   and longitude, respectively and the remaining 12 should be the monthly
%   values, starting from JAN and ending in DEC.
%
%   Example: worldformat('TOAOutgoing',1,[],'smooth')

%Assign inputs
if nargin==2
    smooth='nosmooth';
    titlestring='';
    units='';
    cmin='';
    cmax='';
    zoom='';
    discreet='cont';
    figno=1;
elseif nargin==3
    titlestring='';
    units='';
    cmin='';
    cmax='';
    zoom='';
    discreet='cont';
    figno=1;
elseif nargin==4
    units='';
    cmin='';
    cmax='';
    zoom='';
    discreet='cont';
    figno=1;
elseif nargin==5
    cmin='';
    cmax='';
    zoom='';
    discreet='cont';
    figno=1;
elseif nargin==6
    cmax='';
    zoom='';
    discreet='cont';
    figno=1;
elseif nargin==7
    zoom='';
    discreet='cont';
    figno=1;
elseif nargin==8
    discreet='cont';
    figno=1;
elseif nargin==9
    figno=1;
end

%Check for binary or text file
fid=fopen(filename,'rt');
column_map=fscanf(fid,'%f',[14,inf]);
fclose(fid);
column_map=column_map';
if isempty(column_map)
    fid=fopen(filename,'r','b');
    [column_map]=fread(fid,[64800 4],'single');
    fclose(fid);
    column_map=[zeros([length(column_map),2]), column_map(:,1)];
    disp('Binary file read; NASA Langely format assumed')
    % Binary data come by month, so the variable month is meaningless.
    month=1;
    for i=1:180
        for j=1:360
            lat=90-(i-1/2);
            lon=-180+(j-1/2);
            column_map((i-1)*360+j,1:2)=[lat lon];
        end
    end
end


%Check for resolution of the dataset
lonresolution=column_map(2,2)-column_map(1,2);
maxlon=360/abs(lonresolution);
%latresolution=column_map(maxlon+1,1)-column_map(1,1);
%maxlat=180/abs(latresolution);
maxlat=length(column_map)/maxlon;

%Generate 2D map
latm=column_map(1:maxlon:maxlat*maxlon,1);
lonm=column_map(1:maxlon,2);
column_map_month=column_map(:,month+2);
map=zeros(maxlat,maxlon);
for row=1:maxlat
    for col=1:maxlon
        index=(row-1)*maxlon+col;
        if (column_map_month(index)==-1000||column_map_month(index)==-999)
            map(row,col)=NaN;
        else
            map(row,col)=column_map_month(index);
        end
    end
end


%Generates the globe map
figure(figno)
%hold on;subplot(3,1,3);cla
clf
if isequal(zoom,'europe')
    %    h=worldmap([33,43],[17,30]);      % Greece
    %    h=worldmap([27,55],[-10,43]);     % Mediterranean
    %     h=worldmap([27,55],[-10,43]);     % test
    %    h=worldmap([-30,30],[-180,180]);  % Tropics
    %    h=worldmap([26.99,43],[10.99,44]);     % Eastern Mediterranean
    %    h=worldmap([29.99,50],[-10,42.5]);     % Eastern Mediterranean
    %     h=worldmap([27.99,49.1],[15.99,39.1]);     %Paper comecap
    h=worldmap([4.99,70],[-24.99,60.1]);     % Sahara-Arabia
    setm(h,'mapprojection','eqdcylin')
    %    setm(h,'mapprojection','stereo')
elseif isequal(zoom,'npole')
    worldmap([54.99,90],[-180,180]);
    %     h=worldmap([-90,90],[-180,180]);
    hidem('Political Names')
else
    worldmap('world');
end
gridm on;framem off
load coast
plotm(lat,long,'Color',[0.4 0.4 0.4])


%Drapes the data over the globe
%maplegend=[1/resolution northernlatitude westernlongitude];
if isequal(zoom,'europe')
    %    [europesouth,europewest]=setpostn(map,maplegend,25,-35);
    %    [europesouth,europewest]=setpostn(map,maplegend,30,-10);
    %    [europesouth,europewest]=setpostn(map,maplegend,28,16);   %paper comecap
    %    [europesouth,europewest]=setpostn(map,maplegend,27,-10);
    [europesouth,europewest]=setpostn(map,maplegend,5,-25); % Sahara-Arabia
    %    [europesouth,europewest]=setpostn(map,maplegend,-30,70);
    europesouth=europesouth+1;
    europewest=europewest+1;
    %   [europenorth,europeeast]=setpostn(map,maplegend,49,39);  %%paper comecap
    [europenorth,~]=setpostn(map,maplegend,38,60); % Sahara-Arabia
    %    [europenorth,europeeast]=setpostn(map,maplegend,30,-70);
    if (europeeast<europewest)
        temp=europeeast;
        europeeast=europewest;
        europewest=temp;
    end
elseif isequal(zoom,'npole')
    [npolesouth,npolewest]=setpostn(map,maplegend,50,-180);
    npolesouth=npolesouth+1;
    npolewest=npolewest+1;
    [npolenorth,npoleeast]=setpostn(map,maplegend,90,180);
end
if isequal(discreet,'disc')
    colormap([
        0         0    0.6667;
        0         0    0.9000;
        0    0.3333    1.0000;
        0    0.6667    1.0000;
        0    1.0000    1.0000;
        0.3333    1.0000    0.6667;
        0.6667    1.0000    0.3333;
        1.0000    1.0000         0;
        1.0000    0.6667         0;
        1.0000    0.3333         0;
        0.9000         0         0;
        0.6667         0         0]);
    %    colormap([0 0 0.8333;0 0.3333 1;0 0.6667 1;0 1 1;...
    %      0.0168 0.8393 0.5298;0.02 1 0.0207;0.7329 1 0.02;1 1 0;...
    %      1 0.6667 0;1 0.3333 0;0.8333 0 0;0.8393 0.0168 0.7139])
else
    %colormap(gray(10))
    %colormap(jet(64))
    if isequal(cmin,'') && isequal(cmax,'')
        colormap(jet(64))
    else
        %colormap(jet((cmax-cmin)/2.5))
        colormap(jet(64))
    end
end
%h=meshm(map,maplegend,[maxlat,maxlon]);
%Removed it because of problems with different lat-lon resolutions
h=surfm(latm,lonm,map); %Both surfm pcolorm seem to work!
%h=pcolorm(latm,lonm,map); 

load coast
plotm(lat,long,'Color',[0.4 0.4 0.4])

if isequal(cmin,'')
    if isequal(zoom,'europe')
        cmin=min(min(map(europesouth:europenorth,europewest:europeeast)));
    elseif isequal(zoom,'npole')
        cmin=min(min(map(npolesouth:npolenorth,npolewest:npoleeast)));
    else
        cmin=min(min(map));
    end
end
if isequal(cmax,'')
    if isequal(zoom,'europe')
        cmax=max(max(map(europesouth:europenorth,europewest:europeeast)));
    elseif isequal(zoom,'npole')
        cmax=max(max(map(npolesouth:npolenorth,npolewest:npoleeast)));
    else
        cmax=max(max(map));
    end
end
caxis([cmin cmax]);
if isequal(smooth,'smooth')
    set(h,'facecolor','interp')
end

%Image formatting commands
h=title(titlestring);
set(h,'fontsize',12);
setm(gca,'maplonlimit',[-179 179])
setm(gca,'fontsize',12)
if isequal(zoom,'europe')
    setm(gca,'mlabellocation',20)
    setm(gca,'mlinelocation',10)
    setm(gca,'plabellocation',15)
    setm(gca,'plinelocation',10)
else
    setm(gca,'mlabellocation',0)
    setm(gca,'plabellocation',0)
end

h=colorbar('horiz');
set(h,'Xlim',[cmin cmax])
set(h,'fontsize',12)
set(get(h,'Title'),'String',units,'fontsize',12)
%if isequal(zoom,'europe')
%    h1=get(h,'pos');
%    h1(1)=h1(1)+(1-0.8)/2*h1(3);
%    h1(3)=0.8*h1(3);
%    set(h,'XTick',[60:20:140])
%    set(h,'Position',h1)
%    hidem('Political Names')
%    hidem('Place names')
%    hidem('Populated place names')
%end
hidem(gca)
showm(get(gca,'Title'))

