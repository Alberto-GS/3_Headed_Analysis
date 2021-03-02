Limpia
load 'Dataset_tri'
figout='/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Plots/Basicos/versusCTD24/';
for  isensor = [1 2 3];
figure('units','inch','position',[0,8,6,4]);
plot(CTD25.sal(:),CTD25.tem(:),'k','LineWidth',1.2);hold on
plot(CTD24.sal(:),CTD24.tem(:),'color',[0.5 0.5 0.5],'LineWidth',1.2);hold on
tr = [0:0.5:28];sr = [34.5:.1:37.5];[S,T]=meshgrid(sr,tr); sg = sw_dens(S,T,zeros(size(T))) - 1000;

[C,h]=contour(sr,tr,sg,[22.5:1:29.5],':');set(h,'EdgeColor',[1 1 1].*0.5);hold on; clabel(C,h,'color',[1 1 1].*0.5,'labelspacing',300,'fontsize',7);
[C,h]=contour(sr,tr,sg,[22:1:30]);set(h,'EdgeColor',[1 1 1].*0.5);hold on; clabel(C,h,'color',[1 1 1].*0.5,'labelspacing',300,'fontsize',8);

    for iprofile = 1:size(prof,1);
    s = sal(iprofile,isensor,:); t = tem(iprofile,isensor,:);  
    su = squeeze(s(1,1,:)); tu = squeeze(t(1,1,:));
    hold on; 
    winSizes = [1:100:2000]; nWins = numel(winSizes); 
    lineColors = parula(nWins);
    hold on
    
    plot(su,tu,'LineWidth',1.2,'Color',lineColors(iprofile,:));hold on
    clear su tu
    end
    hold on 
hAxes = gca;
hc = colorbar( hAxes );
hc.TickLabels = {'1',' ',' ',' ',' ',' ',' ',iprofile}';
legend('CTD25','CTD24','Location','SouthEast'); 
title(strcat('TS Diagram for all cycles',{' '},strcat(sen(isensor))));
ylabel('Temperature [ITS-90, deg C]')
xlabel('Salinity, Practical [PSU]')
%CreaFigura(gcf,strcat(figout,string(sen(isensor))),5)
end
