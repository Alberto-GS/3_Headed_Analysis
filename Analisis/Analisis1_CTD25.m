Limpia
%Reading 3 HEADED Argo files
figout='/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Plots/Basicos/versusCTD25/';
%Read CTD Files st 25
fid25 = importdata('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/CTD/ra2012_25.cnv',' ',317);
x=find(fid25.data(:,1)==max(fid25.data));
CTD25.pres=fid25.data(1:x,1); %pres
med=(fid25.data(:,2)+fid25.data(:,4))/2; %temp
CTD25.temp=med(1:x,1);
CTD25.sal=fid25.data(1:x,10); %sal
clear fid24 fid25

fid24 = importdata('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/CTD/ra2012_24.cnv',' ',317);
x=find(fid24.data(:,1)==max(fid24.data));
CTD24.pres=fid24.data(1:x,1); %pres
med=(fid24.data(:,2)+fid24.data(:,4))/2; %temp
CTD24.temp=med(1:x,1);
CTD24.sal=fid24.data(1:x,10); %sal
clear fid24 fid25


OFFSET = xlsread('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3headed_NAOS_CY2_to_CY16.xlsx',1);


for ii=[3:17];  %number of float cycles
    
NAOS=xlsread('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3headed_NAOS_CY2_to_CY16.xlsx',ii);
%save datos.mat NAOS; clear NAOS; load datos.mat;

%Data SBE41
data.sbe41.press=NAOS(2:end,4);
data.sbe41.temp=NAOS(2:end,5)/1000;
data.sbe41.sal=NAOS(2:end,6)/1000;
fn=find(data.sbe41.temp==0);
if fn~=0
   data.sbe41.press=data.sbe41.press(1:fn(1)-1);
   data.sbe41.temp=data.sbe41.temp(1:fn(1)-1);
   data.sbe41.sal=data.sbe41.sal(1:fn(1)-1);
end
x=find(data.sbe41.press<6); xx= find(data.sbe41.press>3965);
idt = find(data.sbe41.temp==0); ids = find(data.sbe41.sal==0); idp = find(data.sbe41.press==0);
data.sbe41.temp(idt)=NaN; data.sbe41.sal(ids)=NaN; data.sbe41.press(idp)=NaN; clear idt ids idp x fn

%Data SBE61
data.sbe61.press=NAOS(2:end,7);
data.sbe61.temp=NAOS(2:end,8)/1000;
data.sbe61.sal=NAOS(2:end,9)/1000;
fn=find(data.sbe61.temp==0);
if fn~=0
   data.sbe61.press=data.sbe61.press(1:fn(1)-1);
   data.sbe61.temp=data.sbe61.temp(1:fn(1)-1);
   data.sbe61.sal=data.sbe61.sal(1:fn(1)-1);
end
x=find(data.sbe61.press<6); xx= find(data.sbe61.press>3965);
idt = find(data.sbe61.temp==0); ids = find(data.sbe61.sal==0); idp = find(data.sbe61.press==0);
data.sbe61.temp(idt)=NaN; data.sbe61.sal(ids)=NaN; data.sbe61.press(idp)=NaN; clear idt ids idp x fn

%Data RBR
data.rbr.press=NAOS(2:end,10);
data.rbr.temp=NAOS(2:end,11)/1000;
data.rbr.sal=NAOS(2:end,12)/1000;
fn=find(data.rbr.temp==0);
if fn~=0
   data.rbr.press=data.rbr.press(1:fn(1)-1);
   data.rbr.temp=data.rbr.temp(1:fn(1)-1);
   data.rbr.sal=data.rbr.sal(1:fn(1)-1);
end
x=find(data.rbr.press<6); xx= find(data.rbr.press>3965);
idt = find(data.rbr.temp==0); ids = find(data.rbr.sal==0); idp = find(data.rbr.press==0);
data.rbr.temp(idt)=NaN; data.rbr.sal(ids)=NaN; data.rbr.press(idp)=NaN; clear idt ids idp x fn

%Offset pres RBR 
iOFF=ii-1;
Patmosphere = OFFSET(iOFF,3); 
Pabsolute = OFFSET(iOFF,2);
Poffset = Patmosphere - Pabsolute;
data.rbr.press=NAOS(2:end,10)-Poffset;

%Interpolation

%SBE41
[x, i41_temp] = unique(data.sbe41.temp); 
sbe41tempi=interp1(data.sbe41.press(i41_temp),x,CTD25.pres); clear x
[x, i41_sal] = unique(data.sbe41.sal); 
sbe41sali=interp1(data.sbe41.press(i41_sal),data.sbe41.sal,CTD25.pres);clear x

%SBE61

[x, i61_temp] = unique(data.sbe61.temp,'rows','stable');

    try
    sbe61tempi=interp1(data.sbe61.press(i61_temp),x,CTD25.pres); 
    catch ME 
    sbe61tempi=interp1((smooth(data.sbe61.press(i61_temp))),x,CTD25.pres); clear x
    end; clear x
[x, i61_sal] = unique(data.sbe61.sal);
    try
    sbe61sali=interp1(data.sbe61.press(i61_sal),data.sbe61.sal,CTD25.pres);clear x
    catch ME
    sbe61sali=interp1((smooth(data.sbe61.press(i61_sal))),data.sbe61.sal,CTD25.pres);clear x
    end
%RBR
[x, irbr_temp] = unique(data.rbr.temp); 
rbrtempi=interp1(data.rbr.press(irbr_temp),data.rbr.temp,CTD25.pres); clear x
[x, irbr_sal] = unique(data.rbr.sal); 
rbrsali=interp1(data.rbr.press(irbr_sal),data.rbr.sal,CTD25.pres); clear x

%Plot Sensors vs. CTD25 Temp.
figure('units','inch','position',[0,8,12,8]);
subplot(1,2,1); plot(sbe41tempi-CTD25.temp,-CTD25.pres,'LineWidth',1.2);hold on
plot(sbe61tempi-CTD25.temp,-CTD25.pres,'LineWidth',1.2);
plot(rbrtempi(6:end)-CTD25.temp(6:end),-CTD25.pres(6:end),'LineWidth',1.2);
title(strcat('Temperature differences for cycle',num2str(ii-1)))
ylabel('Pressure(m)')
xlabel('Dif. Temperature [ITS-90, deg C]')
legend('SBE41','SBE61','RBR','location','west')

%Plot Sensors vs. CTD25 Sal.
subplot(1,2,2); plot(sbe41sali-CTD25.sal,-CTD25.pres,'LineWidth',1.2);hold on
plot(sbe61sali-CTD25.sal,-CTD25.pres,'LineWidth',1.2);
plot(rbrsali(6:end)-CTD25.sal(6:end),-CTD25.pres(6:end),'LineWidth',1.2);
title(strcat('Salinity differences for cycle',num2str(ii-1)))
ylabel('Pressure(m)')
xlabel('Dif. Salinity, Practical [PSU]')
legend('SBE41','SBE61','RBR','location','west')
CreaFigura(gcf,strcat(figout,'Diff_temp_sal for cycle',num2str(ii-1)),5)

%TS Diagram
figure('units','inch','position',[0,8,6,4]);
plot(CTD25.sal(:),CTD25.temp(:),'k','LineWidth',1.2);hold on
plot(CTD24.sal(:),CTD24.temp(:),'color',[0.5 0.5 0.5],'LineWidth',1.2);hold on
tr = [0:0.5:28];sr = [34.5:.1:37.5];[S,T]=meshgrid(sr,tr); sg = sw_dens(S,T,zeros(size(T))) - 1000;
plot(data.sbe41.sal(:),data.sbe41.temp(:),'LineWidth',1.2,'color',[0 0.45 0.74]);hold on
plot(data.sbe61.sal(:),data.sbe61.temp(:),'LineWidth',1.2,'color',[0.85 0.33 0.1]);hold on
plot(data.rbr.sal(2:end),data.rbr.temp(2:end),'LineWidth',1.2,'color',[0.93 0.69 0.13]);hold on

[C,h]=contour(sr,tr,sg,[22.5:1:29.5],':');set(h,'EdgeColor',[1 1 1].*0.5);hold on; clabel(C,h,'color',[1 1 1].*0.5,'labelspacing',300,'fontsize',7);
[C,h]=contour(sr,tr,sg,[22:1:30]);set(h,'EdgeColor',[1 1 1].*0.5);hold on; clabel(C,h,'color',[1 1 1].*0.5,'labelspacing',300,'fontsize',8);
set(h,'EdgeColor',[1 1 1].*0.5);hold on; clabel(C,h,'color',[1 1 1].*0.5,'labelspacing',300,'fontsize',7);
axis([min(data.sbe41.sal(:))-0.2 max(data.sbe41.sal(:))+0.2 min(data.sbe41.temp(:))-2 max(data.sbe41.temp(:))+2])
title(strcat('TS Diagram for cycle ',num2str(ii-1)))
ylabel('Temperature [ITS-90, deg C]')
xlabel('Salinity, Practical [PSU]')
legend('CTD25','CTD24','SBE41','SBE61','RBR','location','southeast')
CreaFigura(gcf,strcat(figout,'TS Diagram for cycle',num2str(ii-1)),5)
clear NAOS

%Plot temperatures
figure('units','inch','position',[0,8,6,4]);
subplot(1,2,1);
plot(CTD25.temp,CTD25.pres,'k','LineWidth',1.2),hold on
plot(CTD24.temp,CTD24.pres,'color',[0.5 0.5 0.5],'LineWidth',1.2)
plot(data.sbe41.temp(2:end),data.sbe41.press(2:end),'LineWidth',1.2,'color',[0 0.45 0.74]);
plot(data.sbe61.temp(2:end-2),data.sbe61.press(2:end-2),'LineWidth',1.2,'color',[0.85 0.33 0.1]);
plot(data.rbr.temp,data.rbr.press,'LineWidth',1.2,'color',[0.93 0.69 0.13]);
axis ij 
set(h,'EdgeColor',[1 1 1].*0.5);hold on; clabel(C,h,'color',[1 1 1].*0.5,'labelspacing',300,'fontsize',7);
legend('CTD25','CTD24','SBE41','SBE61','RBR','location','southeast');
title(strcat('Temp. profiles for cycle ',num2str(ii-1)))
xlabel('Temperature (C)','FontSize', 10.5);
ylabel('Pressure (m)','FontSize', 10.5);

%Plot salinities
subplot(1,2,2);
plot(CTD25.sal,CTD25.pres,'k','LineWidth',1.2);hold on
plot(CTD24.sal,CTD24.pres,'color',[0.5 0.5 0.5],'LineWidth',1.2)
plot(data.sbe41.sal(2:end),data.sbe41.press(2:end),'LineWidth',1.2,'color',[0 0.45 0.74]);
plot(data.sbe61.sal(2:end-2),data.sbe61.press(2:end-2),'LineWidth',1.2,'color',[0.85 0.33 0.1]);
plot(data.rbr.sal(2:end),data.rbr.press(2:end),'LineWidth',1.2,'color',[0.93 0.69 0.13]);
axis ij
legend('CTD25','CTD24','SBE41','SBE61','RBR','location','southeast');
title(strcat('Sal. profiles for cycle ',num2str(ii-1)))
xlabel('Salinity (PSU)','FontSize', 10.5);
ylabel('Pressure (m)','FontSize', 10.5);
CreaFigura(gcf,strcat(figout,'Profiles_Cycle',num2str(ii-1)),5)
close all
clear NAOS data sbe61tempi
end 