Limpia
%Load RAW data
pre = ncread('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','Presi');
tem = ncread('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','Tempi');
sal = ncread('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','Salti');
sen = h5read('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','/Sensors');
prof = h5read('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','/Profiles');
figout='/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Plots/Basicos/versusCTD24/';
CTD25.tem = ncread('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','Tem25');
CTD25.sal = ncread('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','Sal25');
CTD25.pre = ncread('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','Pre25');
CTD24.tem = ncread('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','Tem24');
CTD24.sal = ncread('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','Sal24');
CTD24.pre = ncread('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3-Headed_NAOS_Data.nc','Pre24');

% %Read CTD Files st 25
% fid25 = importdata('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/CTD/Station25.csv');
% CTD25.pre=fid25.data(:,1); %pres
% CTD25.tem=fid25.data(:,3); %temp
% CTD25.sal=fid25.data(:,2); %sal
% clear fid25
% 
% %Read CTD Files st 24
% fid24 = importdata('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/CTD/Station24.csv');
% CTD24.pre=fid24.data(:,1); %pres
% CTD24.tem=fid24.data(:,3); %temp
% CTD24.sal=fid24.data(:,2); %sal
% clear fid24
% 
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