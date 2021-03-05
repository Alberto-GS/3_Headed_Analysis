Limpia
load 'Dataset_tri.mat'; %load RAW and Potential Temperature for st 24 & 25 computation
theta = 2.25;
or_pre = ones(16,3,708)*NaN; or_tem = ones(16,3,708)*NaN; or_sal = ones(16,3,708)*NaN;
for iprofile = 2:16; %Pressure matrix
    dir = strcat('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3headed_NAOS_CY',num2str(iprofile),'_REM.csv');
    fid = importdata(dir,',');
    or_pre(iprofile,1,1:size(fid.data(:,1))) = fid.data(:,1); %SBE41 = 1
    or_pre(iprofile,2,1:size(fid.data(:,4))) = fid.data(:,4); %SBE61 = 2
    or_pre(iprofile,3,1:size(fid.data(:,7))) = fid.data(:,7); %RBR = 3

    or_tem(iprofile,1,1:size(fid.data(:,2))) = fid.data(:,2); %SBE41 = 1
    or_tem(iprofile,2,1:size(fid.data(:,5))) = fid.data(:,5); %SBE61 = 2
    or_tem(iprofile,3,1:size(fid.data(:,8))) = fid.data(:,8); %RBR = 3

    or_sal(iprofile,1,1:size(fid.data(:,2))) = fid.data(:,3); %SBE41 = 1
    or_sal(iprofile,2,1:size(fid.data(:,5))) = fid.data(:,6); %SBE61 = 2
    or_sal(iprofile,3,1:size(fid.data(:,8))) = fid.data(:,9); %RBR = 3
end


    theta = [2.25];

    [out25, idx25] = sort(CTD25.pre,'ascend'); [out24, idx24] = sort(CTD24.pre,'ascend');
    
    %ipre25 = interp1(CTD25.tem(idx25),CTD25.pre(idx25),theta);
    ipre24 = interp1(CTD24.pre(idx24),CTD24.tem(idx24),theta);


    iPre25 = interp1(temp24(idx24),CTD24.pre,theta);

    
    
    y2_interp = or_pre(16,1,:),or_tem(16,1,:),CTD25.tem)

    Salt_th(iprofile,isensor,1) = interp1(tt,ss,theta) 
     







    [outCTD24, iCTD24_pres] = sort(var(iprofile,isensor,:),'ascend'); clear out
    
    [outnew_pre24, inew_pre24] = sort(new_pre24,'ascend'); clear out
    
    x = unique(outCTD24(1,1,1:436));
    y = unique(CTD24.pre);
    
    iPre25 = interp1(CTD24.pre,x,theta,'nearest');

    Presvar = var(iprofile,isensor,ind25_Pt(1,1,:));
    enan2=find(isnan(Presvar)==1);
    [x, Ptth_u] = unique(Ptth(1,1,1:enan1(1)-1)); clear enan



theta = 2.25;
or_pre = ones(16,3,708)*NaN; or_tem = ones(16,3,708)*NaN; or_sal = ones(16,3,708)*NaN;
for iprofile = 2:16; %Pressure matrix
    dir = strcat('/Users/alberto/Desktop/20201218_Data_3Headed/Analisis/Data/NAOS/3headed_NAOS_CY',num2str(iprofile),'_REM.csv');
    fid = importdata(dir,',');
    or_pre(iprofile,1,1:size(fid.data(:,1))) = fid.data(:,1); %SBE41 = 1
    or_pre(iprofile,2,1:size(fid.data(:,4))) = fid.data(:,4); %SBE61 = 2
    or_pre(iprofile,3,1:size(fid.data(:,7))) = fid.data(:,7); %RBR = 3

    or_tem(iprofile,1,1:size(fid.data(:,2))) = fid.data(:,2); %SBE41 = 1
    or_tem(iprofile,2,1:size(fid.data(:,5))) = fid.data(:,5); %SBE61 = 2
    or_tem(iprofile,3,1:size(fid.data(:,8))) = fid.data(:,8); %RBR = 3

    or_sal(iprofile,1,1:size(fid.data(:,2))) = fid.data(:,3); %SBE41 = 1
    or_sal(iprofile,2,1:size(fid.data(:,5))) = fid.data(:,6); %SBE61 = 2
    or_sal(iprofile,3,1:size(fid.data(:,8))) = fid.data(:,9); %RBR = 3
end



