% Create Figure 4 of
%    "Beyond Long-Term Changes: Interannual Variability 
%     of Carbon Uptake due to Sea Ice Loss in the Western 
%     Arctic Ocean"
% by Zhou et al.
%
% The figure includes the following subpanels:
%   - (a) map of carbon uptake UCO2 CV
%   - (b) map of open-water duration Pow CV
%
%             Author: Tianyu Zhou and Yun Li, UDel, 11/23/2025

clc; clear; close all; info_params
%============================================================
% edit the following based on the user's needs
isfig = 1; ffig = [fdir_MSfig 'fig4_CV_FCO2_int_mask'];
%============================================================
%#####################
%## figure settings ##
%#####################
fsize = 8;
fgx =-0.05; fgw = 0.53; fgdw = 0.38;
fgy = 0.40; fgh = 0.53;
cmap = jet; clims = [0.0 0.8]; cticks = 0:0.2:1;

%###############
%## load data ##
%###############
load(fdiag);
yrid = find(diag.years>=obs_yrs(1));
mskice= diag.mskice(:,yrid);         % 1 = permenant ice cover; 0 = otherwise
vinfo = {'FCO2absint', ['\boldmath' label_UCO2_TgC{1}]; ...
         'Pow',        ['\boldmath' label_Pow{1}]};

%#############
%## CV maps ##
%#############
for kp = 1:size(vinfo,1); VAR=vinfo{kp,1};
  wrk = diag.(VAR)(:,yrid); 
  wrk(mskice==1)=NaN;                % remove ice-covered years
  % cal CV
  tmp = nan(NX,NY);
  tmp(idw) = nanstd(wrk')./abs(nanmean(wrk'));
  tmp(mgrid.mask_pCO2==0) = NaN;

  % mapping
  ax=axes('pos',[fgx+fgdw*(kp-1) fgy fgw fgh],'visible','off'); hold on; axis equal
  [cmap_adj,clims_adj,tmp_adj] = fun_adj_pcolor(cmap,clims,tmp);
  tmp_adj(mgrid.mask==1 & mgrid.mask_pCO2==0) = -9999;   % turn shallow water to color_land
  pcolor(px,py,tmp_adj); shading flat; colormap(cmap_adj); caxis(clims_adj)
  contour(px,py,mgrid.mask,[1 1]*0.99,'color','k')
  hh=set_wAO_map(1,1);
  text(-1300,-1300,plabels{kp},'fontsize',fsize,'fontweight','bold')
  text(200,-2800,vinfo{kp,2},'fontsize',fsize+4,'interpreter','latex','hor','cen')
end
% mark station
idx = idw([stninfo{:,1}]);
plot(px(idx),py(idx),'ok','markerfacecolor','w','markersize',fsize+0.5)
text(px(idx),py(idx),stninfo(:,3),'fontsize',fsize-4,'fontweight','bold',...
     'horiz','cen','vert','mid','color','k');
% colorbar
hco = colorbar('horizontal','position',[fgx+0.55*fgw fgy+0.88*fgh 0.70*fgw 0.02]);
set(hco,'xlim',clims,'xtick',cticks,'fontsize',fsize)
hco.Ruler.TickLabelRotation = 0;
title(hco,'Coefficient of Variation','fontsize',fsize)

%#################
%## save figure ##
%#################
if isfig; print('-dpng','-r400',ffig); print('-dpng','-r400',ffig); end
