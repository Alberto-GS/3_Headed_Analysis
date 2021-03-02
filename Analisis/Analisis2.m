Limpia
%Read data from netCDF previously created
load 'Dataset_tri.mat'; %load RAW and Potential Temperature for st 24 & 25 computation

% Interpolate onto isotherms 

%Station 25
for theta = [15 5];  

[out25, idx25] = sort(temp25,'ascend'); [out24, idx24] = sort(temp24,'ascend');

Sth25 = interp1(temp25(idx25),SA25(idx25),theta,'linear');
Sth24 = interp1(temp25(idx24),SA24(idx24),theta,'linear');
Pt = ones(size(prof,1),size(sen,1),size(pre,3))*NaN;
Sa = ones(size(prof,1),size(sen,1),size(pre,3))*NaN;

Salt_th = zeros(size(prof,1),size(sen,1),size(sen,2));
for iprofile = 1:size(prof,1);
    for isensor = [1,2,3];
        Pt(iprofile,isensor,:) = Ptemi(iprofile,isensor,:);
        Sa(iprofile,isensor,:) = sal(iprofile,isensor,:);

        [out, ind25_Pt] = sort(Pt(iprofile,isensor,:)); clear out
        [out, ind25_Sa] = sort(Sa(iprofile,isensor,:));
        
        Ptth = Pt(iprofile,isensor,ind25_Pt(1,1,:));
        enan1=find(isnan(Ptth)==1);
        [x, Ptth_u] = unique(Ptth(1,1,1:enan1(1)-1)); clear enan
        
        Sath = Sa(iprofile,isensor,ind25_Sa(1,1,:));
      
        ss=Sath(1,1,Ptth_u); ss=squeeze(ss(1,:,:)); ss=ss';
        tt=Ptth(1,1,Ptth_u); tt=squeeze(tt(1,:,:)); tt=tt';

        Salt_th(iprofile,isensor,1) = interp1(tt,ss,theta)    
    end
    
end

%Plot results

iprofile = 1:1:16; %cycles

figure('units','inch','position',[0,8,6,4]);
colors = [0 0.45 0.74
          0.85 0.33 0.1 
          0.93 0.69 0.13];

    for isensor = [1 2 3];
        plot(iprofile,Salt_th(:,isensor),'-o','color',colors(isensor,:),'MarkerFaceColor',colors(isensor,:));
        title(strcat('Salinity over',{' '},num2str(theta),'C isotherm')); xlabel('Cycle'); ylabel('Salinity (PSU)');
        hold on
    end
        plot(iprofile,Sth25*ones(size(iprofile,1),size(iprofile,2)));  
        plot(iprofile,Sth24*ones(size(iprofile,1),size(iprofile,2)));
        legend('SBE41','SBE61','RBR','Station25','Station24');

clear out25 idx25 out24 idx24 Pt Sa Sal_th out ind25_Pt...
    ind25_Sa Ptth enan1 x Ptth_u Sath ss tt Salt_th
end

