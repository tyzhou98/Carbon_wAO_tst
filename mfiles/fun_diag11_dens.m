function [XI,YI,DENS] = fun_diag11_dens(X,Y,I)

%=======================================================================
% Caculate the points density in the 1:1 diagram
%
% Usage
%   [DENS] = fun_diag11_dens(X,Y,I)
% Input
%    X    -- observational time series
%    Y    -- model time series
%    I    -- linearly segregated sections in X,Y axis
% Output
%    XI   -- the center x-index of the subregion 
%    YI   -- the center y-index of the subregion 
%    DENS -- points density in the I-I plane
%
% Example (by check) 
%    X = [1.1 2.3 3.2; 0.9 2.4 3.0];
%    Y = [1.0 2.1 3.3; 1.2 2.1 1.9];
%    I = 0.5:1:3.5;
% % show points in x-y plan
%    [xi,yi] = meshgrid(I,I);
%    subplot(121); 
%    plot(xi,yi,'k'); hold on; plot(xi',yi','k'); 
%    plot(X,Y,'r*'); axis equal; 
%    set(gca,'xlim',[0.3 3.8],'xtick',1:3,...
%            'ylim',[0.3 3.8],'ytick',1:3);
% % show point density in x-y plan
%    [XI,YI,DENS] = fun_diag11_dens(X,Y,I);
%    subplot(122); 
%    scatter(XI(:),YI(:),200,DENS(:),'filled'); 
%    colorbar; axis equal
%    set(gca,'xlim',[0.3 3.8],'xtick',1:3,...
%            'ylim',[0.3 3.8],'ytick',1:3);
%                               Yun Li, 2012-Oct-23
%              modified by Tianyu Zhou, 2024-Aug-09
%=======================================================================

%#######################
%## check segregation ##
%#######################
if min([X(:);Y(:)])<min(I) | max([X(:);Y(:)])>max(I)
    disp(['WARNING: points out of range [' num2str(min(I)) ' ' num2str(max(I)) ']'])
end

%###########
%## index ##
%###########
Istr = I(1);
dI = diff(I(1:2));
%II = 0.5*(I(1:end-1)+I(2:end));
II = I(1:end-1);  % modified to meet the use of pcolor
XI = repmat(II(:)',[length(II) 1]);
YI = repmat(II(:) ,[1 length(II)]);

%################
%## projection ##
%################
Xid = ceil((X-Istr)/dI);  % X-axis
Yid = ceil((Y-Istr)/dI);  % Y-axis
Tid = length(II).*(Xid-1)+Yid; % index of if reshape the matrix to a vector
DENS = reshape(hist(Tid(:),1:length(II).^2),...
                   [length(II),length(II)]);
clear Istr dI II Xid Yid Tid;


