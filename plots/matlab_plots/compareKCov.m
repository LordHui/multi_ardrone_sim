% Alignd = uigetdir(pwd, 'Select a folder with alignment .mat files');
% nAlignd = uigetdir(pwd, 'Select a folder with no_alignment .mat files');
% 
% Afiles = dir(fullfile(strcat(Alignd,'/', '*.mat')));
% NAfiles = dir(fullfile(strcat(nAlignd,'/', '*.mat')));
% 
% if size(Afiles,1)==size(NAfiles,1)
%     KCovCell=cell(2,size(Afiles,1));
%     for f=1:size(Afiles,1)        
%         KCovCell{1,f}=kcoverage(strcat(Alignd,'/',Afiles(f).name));
%         KCovCell{2,f}=kcoverage(strcat(nAlignd,'/',NAfiles(f).name));
%     end
% else
%     disp('Number of parameter files do not match');
% end

T=1800;
%% Plot 1-coverage
figure
hold on
box on


lengths=[];
for f=1:size(Afiles,1)
   for j=1:2
       lengths(length(lengths)+1)=size(KCovCell{j,f},1);
   end  
end

timeStep=(T/min(lengths));
x=0:timeStep:T;

while size(x,2)>min(lengths)
    x(:,size(x,2))=[];
end

for m1=1:size(Afiles,1)
    meanKcov=KCovCell{1,m1}(:,1,:);
    averages{:,m1}=mean(meanKcov,3);
end

vector=[160 200 240];
for aa=1:size(averages,2)
    plot(x,averages{aa}(1:length(x)),'color',vector./255)
    vector(1)=vector(1)-30;
    vector(2)=vector(2)-30;
end


for m1=1:size(NAfiles,1)
    meanKcov=KCovCell{2,m1}(:,1,:);
    averages{:,m1}=mean(meanKcov,3);
end

vector=[246 190 190];
for aa=1:size(averages,2)
    plot(x,averages{aa}(1:length(x)),'color',vector./255)
    vector(2)=vector(2)-40;
    vector(3)=vector(3)-40;
end
legend('mu=2.0 (with alignment)','mu=2.4 (with alignment)','mu=2.0 (without alignment)','mu=2.4 (without alignment)')
xlabel('time [s]')
ylabel('# Cells')
set(gca,'FontSize',20)
title('1-Coverage over time')


axis([0, T,-10, 350])
hold off




%% Plot 2-coverage

figure
hold on
box on
for m1=1:size(Afiles,1)
    meanKcov=KCovCell{1,m1}(:,2,:);
    averages{:,m1}=mean(meanKcov,3);
end

vector=[160 200 240];
for aa=1:size(averages,2)
    plot(x,averages{aa}(1:length(x)),'color',vector./255)
    vector(1)=vector(1)-30;
    vector(2)=vector(2)-30;
end

for m1=1:size(NAfiles,1)
    meanKcov=KCovCell{2,m1}(:,2,:);
    averages{:,m1}=mean(meanKcov,3);
end

vector=[246 190 190];
for aa=1:size(averages,2)
    plot(x,averages{aa}(1:length(x)),'color',vector./255)
    vector(2)=vector(2)-40;
    vector(3)=vector(3)-40;
end
legend('mu=2.0 (with alignment)','mu=2.4 (with alignment)','mu=2.0 (without alignment)','mu=2.4 (without alignment)')
xlabel('time [s]')
ylabel('# Cells')
set(gca,'FontSize',20)
title('2-Coverage over time')

lengths=[];
for f=1:size(Afiles,1)
   for j=1:2
       lengths(length(lengths)+1)=size(KCovCell{j,f},1);
   end  
end
axis([0, T,-10, 200])
hold off



%% Plot 3-coverage
figure
hold on
box on
for m1=1:size(Afiles,1)
    meanKcov=KCovCell{1,m1}(:,3,:);
    averages{:,m1}=mean(meanKcov,3);
end

vector=[160 200 240];
for aa=1:size(averages,2)
    plot(x,averages{aa}(1:length(x)),'color',vector./255)
    vector(1)=vector(1)-30;
    vector(2)=vector(2)-30;
end


for m1=1:size(NAfiles,1)
    meanKcov=KCovCell{2,m1}(:,3,:);
    averages{:,m1}=mean(meanKcov,3);
end

vector=[246 190 190];
for aa=1:size(averages,2)
    plot(x,averages{aa}(1:length(x)),'color',vector./255)
    vector(2)=vector(2)-40;
    vector(3)=vector(3)-40;
end
legend('mu=2.0 (with alignment)','mu=2.4 (with alignment)','mu=2.0 (without alignment)','mu=2.4 (without alignment)')
xlabel('time [s]')
ylabel('# Cells')
set(gca,'FontSize',20)
title('3-Coverage over time')

lengths=[];
for f=1:size(Afiles,1)
   for j=1:2
       lengths(length(lengths)+1)=size(KCovCell{j,f},1);
   end  
end
axis([0,T,-10, 50])
hold off

hold off
















