% Create Figure S5 of
%    "Beyond Long-Term Changes: Interannual Variability 
%     of Carbon Uptake due to Sea Ice Loss in the Western 
%     Arctic Ocean"
% by Zhou et al.
%
% The figure includes the following subpanels:
%   - (a) corr. coeff. between Pow and kCO2
%   - (b) corr. coeff. between Pow and bbp
%
%             Author: Tianyu Zhou and Yun Li, UDel, 11/23/2025

clc; clear; close all; info_params
%===================================================
% Edit the following based on user's purpose
isfig=1; ffig=[fdir_MSfig 'figS5_map_env_corr'];
%===================================================
%#####################
%## figure settings ##
%#####################
fsize = 8;
fgx =-0.05; fgw = 0.53; fgdw = 0.38;
fgy = 0.40; fgh = 0.53;
clims = [-1 1]; load(fcmap_corr)    % color scheme of corr. coeff.
color_land = color_landS;           % land color in Supplementary
vinfo = {'Pow_vs_kCO2avg',['$r\,(' label_Pow{1}(2:end-1) ',\:' label_kCO2{1}(2:end-1) ')$'];...
         'Pow_vs_bbpavg' ,['$r\,(' label_Pow{1}(2:end-1) ',\:' label_bbp{1}(2:end-1) ')$']};

%##########
%## maps ##
%##########
load(fPCA)
for kp = 1:2
  ax=axes('pos',[fgx+fgdw*(kp-1) fgy fgw fgh],'visible','off');  hold on; axis equal
  wrk=nan(NX,NY); wrk(idw) = ClsPCA.(vinfo{kp,1})(:,1);
  wrk(isnan(wrk)&mgrid.mask_pCO2==1)=0;              % turn numerical NaN corr. coeff. to 0
  [cmap_adj,clims_adj,wrk] = fun_adj_pcolor(cmap,clims,wrk,color_land,color_ice);
  wrk(mgrid.mask==1 & mgrid.mask_pCO2==0) = -9999;   % turn shallow water to color_land  
  pcolor(px,py,wrk); shading flat; caxis(clims_adj); colormap(cmap_adj)
  contour(px,py,mgrid.mask,[1 1]*0.9,'k')
  hh = set_wAO_map(1,1); set(hh.hp,'facecolor',color_land)
  text(-1300,-1300,plabels{kp},'fontsize',fsize,'fontweight','bold')
  text( 400 ,-2800,['\boldmath' vinfo{kp,2}],'fontsize',fsize+2,'hor','cen','interpreter','latex');
end
hco = colorbar('horizontal','position',[fgx+0.55*fgw fgy+0.88*fgh 0.70*fgw 0.02]);
set(hco,'xlim',clims); title(hco,'Pearson Correlation Coeff.')

%#################
%## save figure ##
%#################
if isfig; print('-dpng','-r400',ffig); print('-dpng','-r400',ffig); end
