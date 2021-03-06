clear; clc;

[file, path] = uigetfile({'*.*'},'Select limits yaml file');
limitsTxt = fileread(strcat(path,file)); % get the yaml file for limits
limitsStr=split(limitsTxt);
limits=[str2double(limitsStr{2}),str2double(limitsStr{4}),str2double(limitsStr{6}),str2double(limitsStr{8})];

global xGrid yGrid

step=input('specifiy smallest grid size ');
xGrid=limits(1):step:limits(2);
yGrid=limits(3):step:limits(4);


d = uigetdir(pwd, 'Select a folder');
folders=dir(d);
dirFlags = [folders.isdir];
subFolders = folders(dirFlags);
subFolders(1:2)=[];
numSubFolders=size(subFolders,1);

for s=1:numSubFolders

    files = dir(fullfile(strcat(d,'/',subFolders(s).name), '*.bag'));
    Nf=size(files,1);
    coverage=cell(1,Nf);
    carry=[];

    for run=1:Nf
       
        bag=rosbag(strcat(d,'/',subFolders(s).name,'/',files(run).name));
        msg=select(bag,'Topic',strcat('/SwarmState'));
        Time=(msg.EndTime-msg.StartTime);
        msgCell=readMessages(msg,'DataFormat','struct');

        if isempty(carry)
        else
            msgCell=[carry;msgCell];
        end
        
        while msgCell{1}.Run>10 || msgCell{1}.Run==0
            msgCell(1)=[];
        end
        
        a=[msgCell{:,1}];
        b=([a.Run]);
        msgCell(find(b==0))=[];
        
        Nposes=size(msgCell{1,1}.Poses,2);
        Area=zeros(size(xGrid,2)-1,size(yGrid,2)-1);
        
        for t=1:size(msgCell,1)  
        [run t]
            if msgCell{t}.Run<=10 && t>100                
                carry={msgCell{t:size(msgCell,1)}}';
                break
            else
                carry=[];
                for u=1:Nposes
                    [Xplace, Yplace, xpos, ypos, qx, qy, qz, qw]=getXYQ(msgCell{t,1},u);
                    poses.position{run,u}(t,:)=[xpos, ypos];
                    poses.orientation{run,u}(t,:)=[qx, qy, qz, qw];
                    if (limits(1)<xpos && xpos<limits(2) && limits(3)<ypos && ypos<limits(4))
                        if (Area(Xplace,Yplace)==0)
                            Area(Xplace,Yplace)=1;
                        end
                    end            
                end
                coverage{1,run}(t,1)=sum(sum(Area))/(size(Area,1)*size(Area,2)); 
            end
        end   
    end
    Len = cellfun(@length, coverage, 'UniformOutput', false);
    finalLength=min([Len{:}]);

    for rr=1:Nf
        coverage{rr}=coverage{rr}(1:finalLength);
        coverage{rr}(1:5)=[];
        for pp=1:Nposes
            poses.position{rr,pp}=poses.position{rr,pp}(1:finalLength,:); % clean up the end
            poses.position{rr,pp}(1:5,:)=[];                     % clean up the begining

            poses.orientation{rr,pp}=poses.orientation{rr,pp}(1:finalLength,:); % clean up the end
            poses.orientation{rr,pp}(1:5,:)=[];                     % clean up the begining
        end
    end

    %bars=find(d=='/');
    %filename=strcat(d(bars(size(bars,2))+1:length(d)),'.mat');
    filename=strcat(subFolders(s).name,'.mat');
    save(filename,'coverage','poses','Time','limits','-v7.3');

    data.coverage=coverage;
    data.poses=poses;
    data.Time=Time;
    data.limits=limits;

    %plotPersistCoverage(data,filename);

end

function [Xplace, Yplace, xpos, ypos, qx, qy, qz, qw]=getXYQ(msg,n)
global xGrid yGrid
        tmpX=xGrid;
        tmpX=[xGrid,msg.Poses(n).Position.X];
        tmpX=sort(tmpX);
        Xplace = find(tmpX==msg.Poses(n).Position.X)-1;
        
        tmpY=yGrid;
        tmpY=[yGrid,msg.Poses(n).Position.Y];
        tmpY=sort(tmpY);
        Yplace = find(tmpY==msg.Poses(n).Position.Y)-1;
        
        xpos=msg.Poses(n).Position.X;
        ypos=msg.Poses(n).Position.Y;
        
        qx=msg.Poses(n).Orientation.X;
        qy=msg.Poses(n).Orientation.Y;
        qz=msg.Poses(n).Orientation.Z;
        qw=msg.Poses(n).Orientation.W;
end




