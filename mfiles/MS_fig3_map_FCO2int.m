% Create Figure 3 of
%    "Beyond Long-Term Changes: Interannual Variability 
%     of Carbon Uptake due to Sea Ice Loss in the Western 
%     Arctic Ocean"
% by Zhou et al.
%
% The figure includes the following subpanels:
%   - integrated carbon uptake maps for each year
%
%             Author: Tianyu Zhou and Yun Li, UDel, 11/23/2025

clc; clear; close all; info_params
%==================================================
% Edit the following based on user's needs
isfig = 1; ffig = [fdir_MSfig 'fig3_map_UCO2'];
%==================================================
%#####################
%## figure settings ##
%#####################
ncol= 5; fsize = 8; 
fgx =-0.02; fgw = 0.345; fgdw = 0.15;
fgy = 0.70; fgh = 0.345; fgdh = 0.23;
cmap = jet(20); clims = [0 1.1];
ccut = 0.1; clims_scl = [0 ccut*2];    % the scaled clims
cff = (clims(2)-ccut)/(ccut-0);        % scaling coefficient
cticklabels = [0:0.02:0.1 0.3:0.2:2];
% adjust colorbar ticks
%           Cmax - Ccut       C - Ccut
%   cff = --------------- = ------------
%            Ccut - 0         X - Ccut
cticks = cticklabels; idd = find(cticks>ccut);
cticks(idd) = (cticks(idd)-ccut)/cff + ccut;

%###############
%## load data ##
%###############
load(fdiag)
FCO2int = diag.FCO2int.*cff_g2Gg;         % [gC -> GgC]
FCO2int(diag.Pow==0|diag.icet>900) = NaN; % ice cover
Pow = diag.Pow;

%#############
%## mapping ##
%#############
for kp = 1:length(obs_yrs); yrnow = obs_yrs(kp); yid = find(diag.years==yrnow);
  pos = [fgx+fgdw*mod(kp-1,ncol) fgy-fgdh*(ceil(kp/ncol)-1) fgw fgh];
  axes('pos',pos,'visible','off'); hold on; axis equal
  % adjust FCO2int scale
  wrk = nan(NX,NY); wrk(idw) = FCO2int(:,yid); wrk(mgrid.mask_pCO2==0) = NaN;
  idd = find(wrk>ccut); wrk(idd) = (wrk(idd)-ccut)/cff + ccut;
  [cmap_adj,clims_adj,wrk] = fun_adj_pcolor(cmap,clims_scl,wrk,color_land,color_ice);
  wrk(mgrid.mask==1 & mgrid.mask_pCO2==0) = -9999;   % turn shallow water to color_land
  pcolor(px,py,wrk); shading flat; colormap(cmap_adj); caxis(clims_adj)
  % add Pow contour
  wrk = nan(NX,NY); wrk(idw) = Pow(:,yid); wrk(mgrid.mask_pCO2==0) = NaN;
  [C,h]=contour(px,py,wrk,[30 60 90],'color',[1 1 1],'linewidth',0.75);
  clabel(C,h,'color','w','fontsize',fsize-4.5,'fontweight','bold');
  contour(px,py,mgrid.mask,[1 1]*0.99,'color','k')
  % add map
  hh=set_wAO_map(0,0); if kp==16; hh=set_wAO_map(1,1); end
  set(hh.hp,'facecolor',color_land)
  text(-300,-2700,num2str(yrnow),'color','k','fontsize',fsize+2,'fontweight','bold')
end
pos = [fgx+fgdw*ncol+0.15 fgy-fgdh*2.7 0.02 fgh+fgdh*2];
hco = colorbar('position',pos);
title(hco,{['\boldmath' label_UCO2_GgC{1}],...
           ['\boldmath' label_UCO2_GgC{2}]},'fontsize',fsize,'interpreter','latex')
set(hco,'xlim',clims_scl,'xtick',cticks,'xticklabel',cticklabels)
% broken axis on colorbar
axes('pos',pos,'visible','off','color','none');
xlims = [0 pos(3)]; ylims = [0 pos(4)];
x0 = mean(xlims); y0 = mean(ylims)+0.02*diff(ylims);
cffx = [-1 1]*0.8*diff(xlims);
cffy = [-1 1]*0.1/size(cmap,1)*diff(ylims);
line(x0+cffx,y0+cffy          ,'color','k','linewidth',0.6,'Clipping','off');
line(x0+cffx,y0+cffy+2*cffy(2),'color','k','linewidth',0.6,'Clipping','off');
line(x0+cffx,y0+cffy+1*cffy(2),'color','w','linewidth',1.8,'Clipping','off');
set(gca,'xlim',xlims,'ylim',ylims)

if isfig
%#################
%## save figure ##
%#################
set(gcf,'color','w','InvertHardCopy','off');
print('-dpng','-r400',ffig)
print('-dpng','-r400',ffig)
end
