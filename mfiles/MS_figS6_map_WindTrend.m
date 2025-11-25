% Create Figure S6 of
%    "Beyond Long-Term Changes: Interannual Variability 
%     of Carbon Uptake due to Sea Ice Loss in the Western 
%     Arctic Ocean"
% by Zhou et al.
%
% The figure includes the following subpanels:
%   - (a-d) wind speed trend for each month
%
%             Author: Tianyu Zhou and Yun Li, UDel, 11/23/2025

clc; clear; close all; info_params
%====================================================
% Edit the following based on user's purpose
months = 5:8;
isfig=1; ffig=[fdir_MSfig 'figS6_map_WindTrend'];
%====================================================
%#####################
%## figure settings ##
%#####################
fsize = 8; ncol = 2;
fgx =-0.09; fgw = 0.55; fgdw = fgw-0.190;
fgy = 0.45; fgh = 0.55; fgdh = fgh-0.115;
clims = [-1 1]*0.15; cticks = -0.15:0.05:0.15;
% colors
load(fcmap_wind)          % color scheme of trend
color_land = color_landS; % land color in Supplementary
% coordinates for p-value dots
dgp =  6;                 % coordinate spacing
msize = 4.5;              % marker size
iid = 1:dgp:NX; jid = 1:dgp:NY;
ppx = px(iid,jid); ppy = py(iid,jid);

%##########
%## maps ##
%##########
load(fwnd);
for kp = 1:4
  pos = [fgx+fgdw*mod(kp-1,ncol) fgy-fgdh*(ceil(kp/ncol)-1) fgw fgh];
  ax=axes('pos',pos,'visible','off'); hold on; axis equal
  % wind trend
  wrk=nan(NX,NY); wrk(idw) = Uwnd.Tred(:,months(kp));
  [cmap_adj,clims_adj,wrk] = fun_adj_pcolor(cmap,clims,wrk,color_land,color_ice);
  pcolor(px,py,wrk); shading flat; caxis(clims_adj); colormap(cmap_adj)
  % p-value < 0.05
  wrk=nan(NX,NY); wrk(idw) = Uwnd.pval(:,months(kp));
  wrk = wrk(iid,jid); idd = find(wrk<0.05);
  plot(ppx(idd),ppy(idd),'.','markersize',msize,'color',[1 1 1]*0.35)
  % settings
  contour(px,py,mgrid.mask,[1 1]*0.9,'k')
  hh = set_wAO_map(1,1); set(hh.hp,'facecolor',color_land)
  set([hh.tlt;hh.tlg],'fontsize',4)
  text(-1300,-1300,plabels{kp},'fontsize',fsize,'fontweight','bold')
  text( 400 ,-2800,datestr(datenum(0,months(kp),1),'mmmm'),...
       'fontsize',fsize+6,'hor','cen','fontweight','bold')
end
hco = colorbar('position',[fgx+2.35*fgdw fgy-fgdh+0.28 0.016 0.8*fgw]);
set(hco,'xlim',clims,'xtick',cticks)
title(hco,{'wind speed trend','(m s^{-1} year^{-1})'})

%#################
%## save figure ##
%#################
if isfig; print('-dpng','-r400',ffig); print('-dpng','-r400',ffig); end
