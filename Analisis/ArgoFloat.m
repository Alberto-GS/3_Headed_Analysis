Limpia
%Reading 3 HEADED Argo files

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
for ii=3:17 %number of float cycles
    
NAOS=xlsread('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3headed_NAOS_CY2_to_CY16.xlsx',ii);
    
%Data SBE41
data.sbe41.press=NAOS(2:end,4);
data.sbe41.temp=NAOS(2:end,5)/1000;
data.sbe41.sal=NAOS(2:end,6)/1000;
x=find(data.sbe41.press<6); xx= find(data.sbe41.press>3965);
idt = find(data.sbe41.temp==0); ids = find(data.sbe41.sal==0); idp = find(data.sbe41.press==0);
data.sbe41.temp(idt)=NaN; data.sbe41.sal(ids)=NaN; data.sbe41.press(idp)=NaN; clear idt ids idp


%Data SBE61
data.sbe61.press=NAOS(2:end,7);
data.sbe61.temp=NAOS(2:end,8)/1000;
data.sbe61.sal=NAOS(2:end,9)/1000;
idt = find(data.sbe61.temp==0); ids = find(data.sbe61.sal==0); idp = find(data.sbe61.press==0);
data.sbe61.temp(idt)=NaN; data.sbe61.sal(ids)=NaN; data.sbe61.press(idp)=NaN; clear idt ids idp


%Data RBR
data.rbr.press=NAOS(2:end,10);
data.rbr.temp=NAOS(2:end,11)/1000;
data.rbr.sal=NAOS(2:end,12)/1000;
idt = find(data.rbr.temp==0); ids = find(data.rbr.sal==0); idp = find(data.rbr.press==0);
data.rbr.temp(idt)=NaN; data.rbr.sal(ids)=NaN; data.rbr.press(idp)=NaN; clear idt ids idp


%Offset pres RBR 
iOFF=ii-1;
Patmosphere = OFFSET(iOFF,3); 
Pabsolute = OFFSET(iOFF,2);
Poffset = Patmosphere - Pabsolute;
data.rbr.press=NAOS(2:end,10)-Poffset;

%Interpolation

%SBE41
%Remove NaN for interp1
    nan_id=isnan(data.sbe41.temp); k=find(nan_id==1);
if (k)~=0
    for jj = 1:size(k,1);
        if (k)~=0;
            data.sbe41.press = smooth(data.sbe41.press,2);
            data.sbe41.temp = smooth(data.sbe41.temp,2);
            data.sbe41.sal = smooth(data.sbe41.sal,2);
            pp=find(data.sbe41.temp==0);
            data.sbe41.temp(pp)=NaN;data.sbe41.sal(pp)=NaN;data.sbe41.press(pp)=NaN;
         clear nan_id
        end
    end; 
end
[x, ind41_temp] = unique(data.sbe41.temp); [x, ind41_sal] = unique(data.sbe41.sal);
sbe41tempi=interp1(data.sbe41.press(ind41_temp),data.sbe41.temp(ind41_temp),CTD25.pres);
sbe41sali=interp1(data.sbe41.press(ind41_sal),data.sbe41.sal(ind41_sal),CTD25.pres);clear x
idt = find(sbe41tempi==0); ids = find(sbe41sali==0);
sbe41tempi(idt)=NaN; sbe41sali(ids)=NaN; clear idt ids k jj pp

%SBE61

    %Remove NaN for interp1
    nan_id=isnan(data.sbe61.temp); k=find(nan_id==1);
if (k)~=0
    for jj = 1:size(k,1);
        if (k)~=0;
            data.sbe61.press = smooth(data.sbe61.press,2);
            data.sbe61.temp = smooth(data.sbe61.temp,2);
            data.sbe61.sal = smooth(data.sbe61.sal,2);
            pp=find(data.sbe61.temp==0);
            data.sbe61.temp(pp)=NaN;data.sbe61.sal(pp)=NaN;data.sbe61.press(pp)=NaN;
         clear nan_id
        end
    end; 
end  
[x, ind61_temp] = unique(data.sbe61.temp); [x, ind61_sal] = unique(data.sbe61.sal); [x, ind61_press] = unique(data.sbe61.press);
sbe61tempi=interp1(data.sbe61.press(ind61_press),data.sbe61.temp(ind61_temp),CTD25.pres);
sbe61sali=interp1(data.sbe61.press(ind61_sal),data.sbe61.sal(ind61_sal),CTD25.pres);clear x
idt = find(sbe61tempi==0); ids = find(sbe61sali==0);
sbe61tempi(idt)=NaN; sbe61sali(ids)=NaN; clear idt ids k jj pp

%RBR
[x, indrbr_temp] = unique(data.rbr.temp); [x, indrbr_sal] = unique(data.rbr.sal);
rbrtempi=interp1(data.rbr.press(indrbr_temp),data.rbr.temp(indrbr_temp),CTD25.pres);
%Remove NaN for interp1
    nan_id=isnan(data.rbr.temp); k=find(nan_id==1);
    if (k)~=0;
        data.rbr.press = smooth(data.rbr.press,2);
        data.rbr.temp = smooth(data.rbr.temp,2);
        data.rbr.sal = smooth(data.rbr.sal,2);
    end; clear nan_id
rbrsali=interp1(data.rbr.press(indrbr_sal),data.rbr.sal(indrbr_sal),CTD25.pres); clear x
idt = find(rbrtempi==0); ids = find(rbrsali==0);
rbrtempi(idt)=NaN; rbrsali(ids)=NaN; clear idt ids

%Plot Sensors vs. CTD25 Temp.
figure('units','inch','position',[0,8,6,4]);
CTD25.pres
subplot(1,2,1); plot(sbe41tempi-CTD25.temp,-CTD25.pres,'LineWidth',1.2);hold on
plot(sbe61tempi-CTD25.temp,-CTD25.pres,'LineWidth',1.2);
plot(rbrtempi(6:end)-CTD25.temp(6:end),-CTD25.pres(6:end),'LineWidth',1.2);
title(strcat('Temperature differences for cycle',num2str(ii)))
ylabel('Pressure(m)')
xlabel('Dif. Temperature [ITS-90, deg C]')
legend('SBE41','SBE61','RBR','location','SouthEast')

%Plot Sensors vs. CTD25 Sal.
subplot(1,2,2); plot(sbe41sali-CTD25.sal,-CTD25.pres,'LineWidth',1.2);hold on
plot(sbe61sali-CTD25.sal,-CTD25.pres,'LineWidth',1.2);
plot(rbrsali(6:end)-CTD25.sal(6:end),-CTD25.pres(6:end),'LineWidth',1.2);
title(strcat('Salinity differences for cycle',num2str(ii)))
ylabel('Pressure(m)')
xlabel('Dif. Salinity, Practical [PSU]')
legend('SBE41','SBE61','RBR','location','SouthEast')
CreaFigura(gcf,strcat('Diff_temp_sal for cycle',num2str(ii)),5)







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
title(strcat('TS Diagram for cycle ',num2str(ii)))
ylabel('Temperature [ITS-90, deg C]')
xlabel('Salinity, Practical [PSU]')
legend('CTD25','CTD24','SBE41','SBE61','RBR','location','SouthEast')
CreaFigura(gcf,strcat('TS Diagram for cycle',num2str(ii)),5)
clear NAOS

%Plot temperatures
figure('units','inch','position',[0,8,6,4]);
subplot(1,2,1);
plot(CTD25.temp,CTD25.pres,'k','LineWidth',1.2),hold on
plot(CTD24.temp,CTD24.pres,'color',[0.5 0.5 0.5],'LineWidth',1.2)
plot(data.sbe41.temp(2:end),data.sbe41.press(2:end),'r','LineWidth',1.2);
plot(data.sbe61.temp(2:end-2),data.sbe61.press(2:end-2),'b','LineWidth',1.2);
plot(data.rbr.temp,data.rbr.press,'g','LineWidth',1.2);
axis ij 
set(h,'EdgeColor',[1 1 1].*0.5);hold on; clabel(C,h,'color',[1 1 1].*0.5,'labelspacing',300,'fontsize',7);
legend('CTD25','CTD24','SBE41','SBE61','RBR','location','SouthEast');
title(strcat('Temp. profiles for cycle ',num2str(ii)))
xlabel('Temperature (C)','FontSize', 10.5);
ylabel('Pressure (m)','FontSize', 10.5);

%Plot salinities
subplot(1,2,2);
plot(CTD25.sal,CTD25.pres,'k','LineWidth',1.2);hold on
plot(CTD24.sal,CTD24.pres,'color',[0.5 0.5 0.5],'LineWidth',1.2)
plot(data.sbe41.sal(2:end),data.sbe41.press(2:end),'r','LineWidth',1.2);
plot(data.sbe61.sal(2:end-2),data.sbe61.press(2:end-2),'b','LineWidth',1.2);
plot(data.rbr.sal(2:end),data.rbr.press(2:end),'g','LineWidth',1.2);
axis ij
legend('CTD25','CTD25','SBE41','SBE61','RBR','location','SouthEast');
title(strcat('Sal. profiles for cycle ',num2str(ii)))
xlabel('Salinity (PSU)','FontSize', 10.5);
ylabel('Pressure (m)','FontSize', 10.5);
CreaFigura(gcf,strcat('Profiles_Cycle',num2str(ii)),5)
end
