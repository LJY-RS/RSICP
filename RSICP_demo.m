clc;clear;close all;

source_file = 'Depth_0000_ini4.ply';
target_file = 'Depth_0001.ply';
gt = load('gt_ini4.txt');
Tini_gt = gt;

source = pcread(source_file);
target = pcread(target_file);

SP = double(source.Location');    %source points
SN = double(source.Normal');      %source normals
TP = double(target.Location');    %source points
TN = double(target.Normal');      %source normals

scaleS = norm(max(SP,[],2)-min(SP,[],2));
scaleT = norm(max(TP,[],2)-min(TP,[],2));
scale = max(scaleS,scaleT);

SP = SP/scale;
TP = TP/scale;

meanS = mean(SP,2);
meanT = mean(TP,2);

SP = SP-repmat(meanS,1,size(SP,2));
TP = TP-repmat(meanT,1,size(TP,2));

t1 = clock;
[T0, count] = RSICP(SP,TP,SN,TN);
t2 = clock;
time = etime(t2,t1);
trans = T0(1:3,4);
trans = trans + meanT - T0(1:3,1:3) * meanS;
trans = trans*scale;
T0(1:3,4)=trans;

SP = double(source.Location');
P1 = T0(1:3,1:3)*SP+repmat(T0(1:3,4),1,size(SP,2));
P2 = Tini_gt(1:3,1:3)*SP+repmat(Tini_gt(1:3,4),1,size(SP,2));
rmse = sqrt(sum(sum((P1-P2).^2))/size(SP,2))







