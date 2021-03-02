%Load RAW data
pre = ncread('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','Presi');
tem = ncread('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','Tempi');
sal = ncread('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','Salti');
% CTD24.pre = ncread('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','Pre24');
% CTD24.tem = ncread('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','Tem24');
% CTD24.sal = ncread('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','Sal24');
% CTD25.pre = ncread('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','Pre25');
% CTD25.tem = ncread('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','Tem25');
% CTD25.sal = ncread('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','Sal25');
sen = h5read('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','/Sensors');
prof = h5read('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','/Profiles');

figout='/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Plots/Basicos/versusCTD24/';
%Read CTD Files st 25
fid25 = importdata('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/CTD/ra2012_25.cnv',' ',317);
x=find(fid25.data(:,1)==max(fid25.data));
CTD25.pres=fid25.data(1:x,1); %pres
med=(fid25.data(:,2)+fid25.data(:,4))/2; %temp
CTD25.tem=med(1:x,1);
CTD25.sal=fid25.data(1:x,10); %sal
clear fid24 fid25

fid24 = importdata('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/CTD/ra2012_24.cnv',' ',317);
x=find(fid24.data(:,1)==max(fid24.data));
CTD24.pres=fid24.data(1:x,1); %pres
med=(fid24.data(:,2)+fid24.data(:,4))/2; %temp
CTD24.tem=med(1:x,1);
CTD24.sal=fid24.data(1:x,10); %sal
clear fid24 fid25

% Compute Potential Temperature for st 24 & 25
 SA24 = []; temp24 = []; SA25 = []; temp25 = []; SAi = [];
for ii = 1:size(CTD24.pre,1); %For CTD24
        SA24(ii,1) = gsw_ASal(CTD24.sal(ii),CTD24.pre(ii),340,29);
        temp24(ii,1) = gsw_ptmp(SA24(ii),CTD24.tem(ii),CTD24.pre(ii),0);
end

for ii = 1:size(CTD25.pre,1); %For CTD25
        SA25(ii,1) = gsw_ASal(CTD25.sal(ii),CTD25.pre(ii),340,29);
        temp25(ii,1) = gsw_ptmp(SA25(ii),CTD25.tem(ii),CTD25.pre(ii),0);
end

Ptemi = zeros(size(prof,1),size(sen,1),size(pre,3));
SAi = zeros(size(prof,1),size(sen,1),size(pre,3)); 

for iprofile = 1:size(prof,1); disp(strcat('Perfil_',string(iprofile)))
    for isensor = [1,2,3];
        for loc = 1:size(CTD25.pre,1);
        SAi(iprofile,isensor,loc) = gsw_ASal(sal(iprofile,isensor,loc),pre(iprofile,isensor,loc),340,29);
        Ptemi(iprofile,isensor,loc) = gsw_ptmp(SAi(iprofile,isensor,loc),tem(iprofile,isensor,loc),pre(iprofile,isensor,loc),0);
        end
    end
end

save('Dataset_tri','SA24','temp24','SA25','temp25','Ptemi','SAi',...
    'pre','tem','sal','CTD24','CTD25','sen','prof')