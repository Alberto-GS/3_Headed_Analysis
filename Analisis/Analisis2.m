Limpia
%Read data from netCDF previously created
load 'Dataset_tri.mat'; %load RAW and Potential Temperature for st 24 & 25 computation

%Station 25
for theta = [2.5];  

[out25, idx25] = sort(temp25,'descend'); [out24, idx24] = sort(temp24,'descend');

Sth25 = interp1(temp25(idx25),CTD25.sal(idx25),theta);
Sth24 = interp1(temp24(idx24),CTD24.sal(idx24),theta);
iPre24 = interp1(temp24(idx24),CTD24.pre(idx24),theta);
iPre25 = interp1(temp25(idx25),CTD25.pre(idx25),theta);

Pt = ones(size(prof,1),size(sen,1),size(pre,3))*NaN;
Sa = ones(size(prof,1),size(sen,1),size(pre,3))*NaN;
Pr = ones(size(prof,1),size(sen,1),size(pre,3))*NaN;


Salt_th = zeros(size(prof,1),size(sen,1),size(sen,2));
Pre_th = zeros(size(prof,1),size(sen,1),size(sen,2));

for iprofile = 1:size(prof,1);
    for isensor = [1,2,3];
        Pt(iprofile,isensor,:) = Ptemi(iprofile,isensor,:);
        Sa(iprofile,isensor,:) = sal(iprofile,isensor,:);
        Pr(iprofile,isensor,:) = pre(iprofile,isensor,:);


        [out, ind25_Pt] = sort(Pt(iprofile,isensor,:)); clear out
        [out, ind25_Sa] = sort(Sa(iprofile,isensor,:));clear out
        [out, ind25_Pr] = sort(Pr(iprofile,isensor,:));clear out

        Ptth = Pt(iprofile,isensor,ind25_Pt(1,1,:));
        enan1=find(isnan(Ptth)==1);
        [x, Ptth_u] = unique(Ptth(1,1,1:enan1(1)-1)); clear enan1

        Ppre = Pr(iprofile,isensor,ind25_Pr(1,1,:));
        enan1=find(isnan(Ppre)==1);
        [x, Ppre_u] = unique(Ppre); 

        
        Sath = Sa(iprofile,isensor,ind25_Sa(1,1,:));
        Prth = Pr(iprofile,isensor,ind25_Pt(1,1,:));
      
        ss=Sath(1,1,Ptth_u); ss=squeeze(ss(1,:,:)); ss=ss';
        tt=Ptth(1,1,Ptth_u); tt=squeeze(tt(1,:,:)); tt=tt';
        pp=Prth(1,1,Ptth_u); pp=squeeze(pp(1,:,:)); pp=pp';

        Salt_th(iprofile,isensor,1) = interp1(tt,ss,theta)
        Pre_th(iprofile,isensor,1) = interp1(tt,pp,theta)
    end
    
end

%Plot results of over 2.25C

iprofile = 1:1:16; %cycles

figure('units','inch','position',[0,8,6,4]);
colors = [0 0.45 0.74
          0.85 0.33 0.1 
          0.93 0.69 0.13];
    %Using sal
    for isensor = [1 2 3];
        plot(iprofile,Salt_th(:,isensor),'-o','color',colors(isensor,:),'MarkerFaceColor',colors(isensor,:));
        title(strcat('Salinity over',{' '},num2str(theta),'C isotherm')); xlabel('Cycle'); ylabel('Salinity (PSU)');
        hold on
    end
        plot(iprofile,Sth25*ones(size(iprofile,1),size(iprofile,2)),'k');  
        plot(iprofile,Sth24*ones(size(iprofile,1),size(iprofile,2)),'Color',[0.5, 0.5, 0.5]);
        legend('SBE41','SBE61','RBR','Station25','Station24','Location','SouthEast');

    %Using pres
    figure('units','inch','position',[0,8,6,4]);
    colors = [0 0.45 0.74
          0.85 0.33 0.1 
          0.93 0.69 0.13];
    for isensor = [1 2 3];
        plot(iprofile,Pre_th(:,isensor),'-o','color',colors(isensor,:),'MarkerFaceColor',colors(isensor,:));
        title(strcat('Pressure over',{' '},num2str(theta),'C isotherm')); xlabel('Cycle'); ylabel('Pressure (dbar)');
        hold on
    end
        plot(iprofile,iPre25*ones(size(iprofile,1),size(iprofile,2)),'k');  
        plot(iprofile,iPre24*ones(size(iprofile,1),size(iprofile,2)),'Color',[0.5, 0.5, 0.5]);
        legend('SBE41','SBE61','RBR','Station25','Station24','Location','SouthEast');

%Plot results of differences

figure('units','inch','position',[0,8,6,4]);
colors = [0 0.45 0.74
          0.85 0.33 0.1 
          0.93 0.69 0.13];
    %Using Salinity over 2.25C - St 25

    for isensor = [1 2 3];
        plot(iprofile,Salt_th(:,isensor)-Sth25,'-o','color',colors(isensor,:),'MarkerFaceColor',colors(isensor,:));
        title(strcat('Salinity over',{' '},num2str(theta),'C isotherm - Salinity St 25')); xlabel('Cycle'); ylabel('Salinity');
        hold on
    end
        legend('SBE41','SBE61','RBR','Location','SouthEast');

    %Using Salinity over 2.25C - St 24
figure('units','inch','position',[0,8,6,4]);
colors = [0 0.45 0.74
          0.85 0.33 0.1 
          0.93 0.69 0.13];

    for isensor = [1 2 3];
        plot(iprofile,Salt_th(:,isensor)-Sth24,'-o','color',colors(isensor,:),'MarkerFaceColor',colors(isensor,:));
        title(strcat('Salinity over',{' '},num2str(theta),'C isotherm - Salinity St 24')); xlabel('Cycle'); ylabel('Salinity');
        hold on
    end
        legend('SBE41','SBE61','RBR','Location','SouthEast');


    %Using Pressure over 2.25C - St 25

figure('units','inch','position',[0,8,6,4]);
colors = [0 0.45 0.74
          0.85 0.33 0.1 
          0.93 0.69 0.13];

    for isensor = [1 2 3];
        plot(iprofile,Pre_th(:,isensor)-iPre25,'-o','color',colors(isensor,:),'MarkerFaceColor',colors(isensor,:));
        title(strcat('Pressure over',{' '},num2str(theta),'C isotherm - Pressure St 25')); xlabel('Cycle'); ylabel('Pressure');
        hold on
    end
        legend('SBE41','SBE61','RBR','Location','SouthEast');

    %Using Pressure over 2.25C - St 24
    
figure('units','inch','position',[0,8,6,4]);
colors = [0 0.45 0.74
          0.85 0.33 0.1 
          0.93 0.69 0.13];

    for isensor = [1 2 3];
        plot(iprofile,Pre_th(:,isensor)-iPre24,'-o','color',colors(isensor,:),'MarkerFaceColor',colors(isensor,:));
        title(strcat('Pressure over',{' '},num2str(theta),'C isotherm - Pressure St 24')); xlabel('Cycle'); ylabel('Pressure');
        hold on
    end
        legend('SBE41','SBE61','RBR','Location','SouthEast');

%clear out25 idx25 out24 idx24 Pt Sa Sal_th out ind25_Pt...
    %ind25_Sa Ptth enan1 x Ptth_u Sath ss tt Salt_th


end

