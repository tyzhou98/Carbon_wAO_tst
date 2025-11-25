% Create Figure 6 of
%    "Beyond Long-Term Changes: Interannual Variability 
%     of Carbon Uptake due to Sea Ice Loss in the Western 
%     Arctic Ocean"
% by Zhou et al.
%
% The figure includes the following subpanels:
%   - (a) map of r1(Pow ,UCO2)
%   - (b) map of r2(Feff,UCO2)
%   - (c) density plot of r1 vs r2
%   - (d) regime classification 
%
%             Author: Tianyu Zhou and Yun Li, UDel, 11/25/2025

clc; clear; close all; info_params
%==================================================
% Edit the following based on user's purpose
isfig = 1; ffig = [fdir_MSfig 'fig6_r1_r2'];
%==================================================
%#####################
%## figure settings ##
%#####################
fsize = 8;
% density plot
fgxp = 0.47; fgwp = 0.28;
fgyp = 0.53; fghp = 0.28; fgdhp = 0.42;
Ilims = [-1.1 1.1]; dI = 43; % range and res of bins
xlims = [-1 1]; ylims = [-0.5 1]; pticks = -1:0.5:1;
dlims = [1 3]; dticks = 0:4; % colorbar lims and ticks
dticklabels = num2str(dticks(:),'10^%.1i');
% r1 r2 maps
fgxm =-0.05; fgwm = 0.52; fgdwm = fgwm-0.215;
fgym = 0.40; fghm = 0.52; fgdhm = fghm-0.115;
clims = [-0.2 1.0]; cticks = -0.2:0.2:2;
% colors
load(fcmap_r1r2);     cmapm=flip(cmap);  % color scheme of r1 r2 patterns
load(fcmap_r1r2dens); cmapp=cmap;        % color scheme of r1 r2 density plot

%###############
%## load data ##
%###############
load(fPCA)
r1 = ClsPCA.r1; r1(mgrid.mask_pCO2(idw)==0)=NaN;
r2 = ClsPCA.r2; r2(mgrid.mask_pCO2(idw)==0)=NaN;

%################
%## r1 r2 maps ##
%################
for kp = 1:2;
  eval(['r=r' num2str(kp) ';']);
  eval(['ctxt = label_r' num2str(kp) ';']);
  r(isnan(r))=0;                % change subarctic r=NaN to 0
  tmp = nan(NX,NY); tmp(idw)=r;
  tmp(mgrid.mask_pCO2==0)=NaN;  % assign r to [NX,NY] but ensure mask_pCO2
  % map
  pos = [fgxm fgym-fgdhm*(kp-1) fgwm fghm];
  ax=axes('pos',pos,'visible','off'); hold on; axis equal
  [cmap_adj,clims_adj,tmp_adj] = fun_adj_pcolor(cmapm,clims,tmp);
  tmp_adj(mgrid.mask==1 & mgrid.mask_pCO2==0) = -9999;   % turn shallow water to color_land
  pcolor(px,py,tmp_adj); shading flat; colormap(ax,cmap_adj); caxis(clims_adj)
  contour(px,py,mgrid.mask,[1 1]*0.99,'color','black')
  hh=set_wAO_map(1,1); set([hh.tlg;hh.tlt],'fontsize',fsize-2.5,'color',[1 1 1]*0.35);
  text(-1300,-1300,plabels{kp},'fontsize',fsize,'fontweight','bold')
  text( 400 ,-2800,['\boldmath' ctxt],'fontsize',fsize+1,'interpreter','latex','hor','cen');
end
% set colorbar 
hco = colorbar('horizontal','position',[fgxm+0.28*fgwm fgym+0.85*fghm 0.50*fgwm 0.017]);
set(hco,'xlim',clims,'xtick',cticks,'fontsize',fsize-0.5,'tickdir','out')
title(hco,'Pearson Correlation Coeff.','fontsize',fsize)
hco.Ruler.TickLabelRotation = 0;
h = cbarrow; hh = get(h,'children');    % add pointy ends to colorbar 
set(hh(2),'edgecolor',cmapm(1,:)  ,'facecolor',cmapm(1,:))
set(hh(3),'edgecolor',cmapm(end,:),'facecolor',cmapm(end,:))

%#######################
%## data density plot ##
%#######################
% data density
I = linspace(Ilims(1),Ilims(2),dI);     % 1-D psi points
[XI,YI,N] = fun_diag11_dens(r1,r2,I);
N(N<=0) = NaN; N = log10(N);
% plotting
ax=axes('pos',[fgxp fgyp fgwp fghp]);
hold on; box on; grid on; axis equal
pcolor(XI,YI,N); shading flat; caxis(dlims); colormap(ax,cmapp)
plot([ 0 0],Ilims,'k')
plot(Ilims,[ 0 0],'k')
% settings
set(gca,'fontsize',fsize,...
    'xlim',xlims,'xtick',pticks,...
    'ylim',ylims,'ytick',pticks)
xlabel(['\boldmath' label_r1],'fontsize',fsize+1,'Interpreter','latex')
ylabel(['\boldmath' label_r2],'fontsize',fsize+1,'Interpreter','latex')
text(xlims(1)-0.19*diff(xlims),ylims(2)+0.07*diff(ylims),plabels{3},...
     'hor','lef','ver','top','fontsize',fsize,'fontweight','bold')
hco = colorbar('horizontal','position',[fgxp fgyp+1.1*fghp fgwp 0.017]);
set(hco,'xtick',dticks,'xticklabel',dticklabels,'fontsize',fsize)
title(hco,num2str([1 1]*diff(I(1:2)),'# of data per %.2fx%.2f bin'),'fontsize',fsize)
hco.Ruler.TickLabelRotation = 0;

%################
%## regime map ##
%################
tmp = nan(NX,NY); tmp(idw) = ClsPCA.class; clims = [0.5 3.5];
pos = [fgxm+0.39 fgym-fgdhm*(kp-1) fgwm fghm];
ax=axes('pos',pos,'visible','off'); hold on; axis equal
[cmap_adj,clims_adj,tmp_adj] = fun_adj_pcolor(clscolor,clims,tmp);
tmp_adj(mgrid.mask==1 & mgrid.mask_pCO2==0) = -9999;   % turn shallow water to color_land
pcolor(px,py,tmp_adj); shading flat; colormap(ax,cmap_adj); caxis(clims_adj)
contour(px,py,mgrid.mask,[1 1]*0.99,'color','k')
hh=set_wAO_map(1,1); set([hh.tlg;hh.tlt],'fontsize',fsize-2.5,'color',[1 1 1]*0.35);
text(-1780,-1300,plabels{4},'fontsize',fsize,'fontweight','bold')
hp = patch([0 0 250 250 0]-200,[0 120 120 0 0]-2700,'r'); set(hp,'facecolor',clscolor(1,:));
hp = patch([0 0 250 250 0]-200,[0 120 120 0 0]-2950,'r'); set(hp,'facecolor',clscolor(2,:));
hp = patch([0 0 250 250 0]-200,[0 120 120 0 0]-3200,'r'); set(hp,'facecolor',clscolor(3,:));
text([0 0 0]+100,[-2700 -2950 -3200]+90,{'subregion 1';'subregion 2';'subregion 3'},...
        'fontsize',fsize-0.5,'hor','left','vert','mid');

%#################
%## save figure ##
%#################
if isfig; print('-dpng','-r400',ffig); print('-dpng','-r400',ffig); end
