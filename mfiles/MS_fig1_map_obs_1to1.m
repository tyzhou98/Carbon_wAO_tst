% Create Figure 1 of
%    "Beyond Long-Term Changes: Interannual Variability 
%     of Carbon Uptake due to Sea Ice Loss in the Western 
%     Arctic Ocean"
% by Zhou et al.
%
% The figure includes the following subpanels:
%   - (a) map of underway pCO2 observations
%   - (b) yearly data number and RF model evaluation
%   - (c) 1:1 plot for training
%   - (d) 1:1 plot for testing
%
%             Author: Tianyu Zhou and Yun Li, UDel, 11/23/2025

clc; clear; close all; info_params
%=======================================================
% edit the following based on the user's needs
isfig = 1; ffig = [fdir_MSfig 'fig1_obs_map_1to1'];
%=======================================================
%#####################
%## figure settings ##
%#####################
fsize = 7;
% pCO2 obs map
fgxm =-0.09; fgwm = 0.73;
fgym = 0.29; fghm = fgwm;
pclims = [100 450]; pcticks = 100:50:500;
% hist & R2/RMSD
fgx = 0.08; fgw = 0.44; fgdx = 0.05;
fgy = 0.13; fgh = 0.18;
color_hist = [1 1 1].*0.9;       % histogram color
hlims = [1.5 4.5]; hticks = 2:4; % histogram lims and ticks
cff = 0.1;                       % streching cff for the additional y-axis
% 1:1 plots
fgxp = 0.60; fgwp = 0.35; fgdh2 = fgwp+0.03;
fgyp = 0.50; fghp = fgwp;
plims = [50 650];                % lims of the 1:1 plot
% colors
load(fcmap_bathy); bcmap = cmap; % color scheme of bathymetry
load(fcmap_pCO2);  pcmap = cmap; % color scheme of pCO2
load(fcmap_pCO2dens)             % color scheme of 1:1 density

%###############
%## load data ##
%###############
% model bathymetry 
wrk = mgrid.Bathy; wrk(wrk>=0) = NaN;
wrk(wrk>= -500 & wrk<-100 ) = -120;
wrk(wrk>=-1500 & wrk<-500 ) = -140;
wrk(wrk>=-2500 & wrk<-1500) = -160;
wrk(wrk>=-3500 & wrk<-2500) = -180; mgrid.Bathy = wrk;     % remap bathymetry <-100 m
bclims = [-180 0]; bcticks= -180:20:0;                     % remapped ticks
bcticklabels = num2str([-3500:1000:-500 -100:20:0]','%i'); % bathy labels
% Ouyang subregion mask
load(fOUY); OUY.mask = nan(NX,NY); OUY.mask(mgrid.mask==1) = OUY.sflag_6km; 
% RF model eval stats
dt = readtable(feva);
[dt.px,dt.py] = fun_lglt2xy_arc(dt.lon,dt.lat,pltlon);
mstat = nan(Nyrs_obs,2,3);      % initialization with nans (yrs,train-test,n-RMSD-R2)
for ky = 1:length(obs_yrs)
for kK = 1:2
  tmp = dt(dt.flag==kK-1 & year(dt.date)==obs_yrs(ky),:);
  mstat(ky,kK,1) = size(tmp,1); % # of train or testing data in a given year
  if size(tmp,1)>0              % calculate R2 and RMSD
    mstat(ky,kK,2) = std(tmp.pCO2_obs-tmp.pCO2_mod); 
    [r,p] = corr(tmp.pCO2_obs,tmp.pCO2_mod); mstat(ky,kK,3) = r.^2; end
end
end
N = sum(mstat(:,:,1),2); idx = find(N>1); mstat=mstat(idx,:,:); % remove years with no data
x = 1:length(idx); xlims = x([1 end])+[-1 1]*0.6;               % only plot years w/ data

%#################
%## spatial map ##
%#################
% bathymetry
ax=axes('pos',[fgxm fgym fgwm fghm],'visible','off','color','none'); hold on; axis equal
[cmap_adj,clims_adj,mgrid.Bathy] = fun_adj_pcolor(bcmap,bclims,mgrid.Bathy);
pcolor( px,py,mgrid.Bathy); shading flat         % color bathymetry
contour(px,py,mgrid.mask,[1 1]*0.99,'color','k') % coastal lines
colormap(ax,cmap_adj); caxis(clims_adj)          % adjusted colorbar and colormap for bathymetry
hh = set_wAO_map(1,1); set([hh.tlt;hh.tlg],'fontsize',fsize-1.5)
set(hh.hp,'facecolor',color_land)
text(-200,-2800,['\itn\rm\bf = ' num2str(size(dt,1),'%.i')],'fontsize',fsize+4,'fontweight','bold')
text(-1100,-1300,plabels{1},'fontsize',fsize+2,'fontweight','bold')
hco = colorbar('position',[fgxm+0.15 fgym+0.31 0.015 0.25]);
title(hco,'Depth (m)','fontsize',fsize-1)
set(hco,'xlim',bclims,'xtick',bcticks,'xticklabel',bcticklabels,'fontsize',fsize-1)
hco.Ruler.TickLabelRotation = 0;
hco.Label.HorizontalAlignment = 'right'; 
% broken axis of bathymetry
axes('pos',[fgxm+0.15 fgym+0.31 0.015 0.25],'color','none',...
     'xcolor','none','ycolor','none','xlim',[0 1],'ylim',bclims); hold on
yy = -115 + [5 6 7 NaN; 3 4 5 NaN]; 
xx = 0.5+[-1 -1 -1 NaN; 1 1 1 NaN]*0.65;
idd = [1 3 4]; plot(xx(:,idd),yy(:,idd),'k','linewidth',1.2,'Clipping','off');
idd = [  2 4]; plot(xx(:,idd),yy(:,idd),'color',get(gcf,'color'),'linewidth',1.5,'Clipping','off')
% pCO2
ax=axes('pos',[fgxm fgym fgwm fghm],'visible','off'); hold on; axis equal
pcolor( px,py,mgrid.Bathy+NaN); shading flat     % a blank layer to control the subplot size
scatter(dt.px,dt.py,0.5,dt.pCO2_obs,'filled'); colormap(ax,pcmap); caxis(pclims)
hco = colorbar('position',[fgxm+0.58 fgym+0.31 0.015 0.25]);
title(hco,strjoin(label_pCO2),'fontsize',fsize-1,'interpreter','latex')
set(hco,'xlim',pclims,'xtick',pcticks,'fontsize',fsize-1)
hco.Ruler.TickLabelRotation = 0;
% OUY subregion boundaries
for kr=1:3; contour(px,py,OUY.mask,[1 1]*kr,'color',[1 1 1]*0.15,'linewidth',0.5); end
text( 712,-1850,OUY.srnms{1},'fontsize',fsize-1,'rotation',110,'hor','left','vert','bot','color',[1 1 1]*0.15)
text( 220,-2180,OUY.srnms{2},'fontsize',fsize-1,'rotation',  9,'hor','left','vert','bot','color',[1 1 1]*0.15)
text(-792,-2362,OUY.srnms{3},'fontsize',fsize-1,'rotation', 70,'hor','left','vert','bot','color',[1 1 1]*0.15)
text(-812,-2922,'Bering Strait','fontsize',fsize-3,'rotation', 70,'hor','left','vert','bot','color',[1 1 1]*0.15)

%###############
%## R2 & hist ##
%###############
% histogram
axes('pos',[fgx fgy fgw fgh*0.6],'yaxisloc','right'); hold on
hb = bar(x,log10(N(idx)+1),'facecolor',color_hist,'edgecolor','none');
set(gca,'fontsize',fsize-1,'layer','top',...
    'xlim',xlims,'xtick',x     ,'xticklabel',num2str(obs_yrs(idx)'-2000,'%.2i'),...
    'ylim',hlims,'ytick',hticks,'yticklabel',num2str(hticks','10^%.i')); xtickangle(0);
xlabel('year','fontsize',fsize)
ylabel('No. of data','position',[xlims(2)+0.08*diff(xlims) hlims(1)+0.5*diff(hlims)],'fontsize',fsize-1)
text(xlims(1)+0.11*diff(xlims),hlims(2)+0.85*diff(hlims),plabels{2},...
     'hor','lef','ver','bot','fontsize',fsize+2,'fontweight','bold')
% broken axis
axes('pos',[fgx fgy fgw fgh*0.6],'color','none','xcolor','none','ycolor','none','xlim',xlims,'ylim',hlims); hold on
xx = [3 4 5 NaN; 5 6 7 NaN]*0.1; xx = [x(4)+xx x(5)+xx];
yy = hlims(1)+diff(hlims)*[-1 -1 -1 NaN; 1 1 1 NaN]*0.05; yy = [yy yy];
idd = [1 3 4 5 7 8]; plot(xx(:,idd),yy(:,idd),'k','linewidth',0.5,'Clipping','off');
idd = [  2 4   6 8]; plot(xx(:,idd),yy(:,idd),'color',get(gcf,'color'),'linewidth',1.5,'Clipping','off');
% RMSD and R2
for kK = 1:2
  wrk = squeeze(mstat(:,:,kK+1));
  xlimsa = xlims+[-diff(xlims) 0]*cff*(kK-1);
  pos = [fgx-fgw*cff*(kK-1) fgy+fgh*0.4 fgw+fgw*cff*(kK-1) fgh*0.6];
  if kK==1; ylims = [11     37]; yticks = 0:5:55;    ycolor = [0.23 0.58 0.53];
            ydpos = ylims(1); ydesc = {'RMSD' '(\muatm)'}; end
  if kK==2; ylims = [0.65 1.05]; yticks = 0.7:0.1:1; ycolor = [0.18 0.11 0.58]; 
            ydpos = ylims(2); ydesc = '\itR\rm^2'; end
  axes('pos',pos,'layer','top','yaxisloc','left','xcolor','none','color','none'); hold on
  plot(x+1000,wrk(:,1),'o-','linewidth',1,'color','k','markerfacecolor','k','markersize',2)  % dummy for legend
  plot(x+1000,wrk(:,2),':' ,'linewidth',1,'color','k')                                       % dummy for legend
  plot(x,wrk(:,1),'o-','linewidth',1,'color',ycolor,'markerfacecolor',ycolor,'markersize',2)
  plot(x,wrk(:,2),':' ,'linewidth',1,'color',ycolor)
  set(gca,'fontsize',fsize-1,...
      'xlim',xlimsa,'xtick',x,'xticklabel','',...
      'ylim',ylims,'ytick',yticks,'ycolor',ycolor)
  if kK==1; set(gca,'ydir','reverse'); end   % reverse the y-axis for RMSD
  text(xlimsa(1),ydpos,ydesc,'fontsize',fsize-1,'hor','cen','ver','bot','color',ycolor)
end
legend({'training','testing'},'box','off','NumColumns',2,...
       'position',[fgx+0.18 fgy+fgh-0.02 0.20 0.10],'fontsize',fsize-1)

%###############
%## 1:1 plots ##
%###############
% create data density bins
blims = [50 750]; bticks = 100:100:600;
bins = linspace(blims(1),blims(2),141);
for kK = 1:2; tmp = dt(dt.flag==kK-1,:);
  if kK==1; stxt='(c) training'; clims=[1 3]; cticks=1:3; end
  if kK==2; stxt='(d) testing '; clims=[0 2]; cticks=0:2; end
  cticklabels = num2str(cticks(:),'10^%.1i');
  % data density
  [XI,YI,N] = fun_diag11_dens(tmp.pCO2_obs,tmp.pCO2_mod,bins);
  N(N==0)=NaN; N=log10(N);
  % stats
  [r,p] = corr(tmp.pCO2_obs,tmp.pCO2_mod);
  RMSD = std(tmp.pCO2_obs-tmp.pCO2_mod);
  stats = {['\itn\rm=' num2str(size(tmp,1),'%.i')],...
           ['\itR\rm^2=' num2str(r.^2     ,'%.2f')],...
           num2str(RMSD       ,'RMSD=%.2f')};
  % mod-obs 1:1 plot
  pos = [fgxp fgyp-fgdh2*(kK-1) fgwp fghp];
  ax=axes('pos',pos); hold on; axis equal; box on; grid on
  pcolor(XI,YI,N); shading flat; colormap(ax,cmap); caxis(clims)
  plot(blims,blims,'k-','linewidth',0.5)
  plot(blims,blims+std(dt.pCO2_obs),'k:','linewidth',0.5)
  plot(blims,blims-std(dt.pCO2_obs),'k:','linewidth',0.5)
  % plot settings
  set(gca,'fontsize',fsize,...
      'xlim',plims,'xtick',bticks,...
      'ylim',plims,'ytick',bticks); xtickangle(0)
  text(plims(1)+0.03*diff(plims),plims(2)-0.03*diff(plims),...
       stxt,'fontsize',fsize+2,'fontweight','bold','hor','lef','ver','top')
  text(plims(2)-0.03*diff(plims),plims(1)+0.03*diff(plims),...
       stats,'fontsize',fsize,'hor','rig','ver','bot')
  hco = colorbar('vertical','position',[fgxp+fgwp-0.03 fgyp-fgdh2*(kK-1) 0.017 fghp],...
                 'ytick',cticks,'yticklabel',cticklabels,'fontsize',fsize);
  if kK==1; ht = title(hco,{'# of data' num2str([1 1]*diff(bins(1:2)),'per %.ix%.i bin')},'fontsize',fsize-2); 
            set(ax,'xticklabel',''); end
end
text(plims(1)-0.21*diff(plims),plims(2)-0.35*diff(plims),'RF Model','fontsize',fsize+1,'rot',90)
text(plims(1)-0.21*diff(plims),plims(2)+0.01*diff(plims),strjoin(label_pCO2),'Interpreter','latex','fontsize',fsize+1,'rot',90)
text(plims(1)+0.08*diff(plims),plims(1)-0.15*diff(plims),'Observation','fontsize',fsize+1)
text(plims(1)+0.55*diff(plims),plims(1)-0.16*diff(plims),strjoin(label_pCO2),'Interpreter','latex','fontsize',fsize+1)

%##########################
%## display extreme data ##
%##########################
cut1 = 100; cut2 = 500; % define extreme data
ncut = sum(dt.pCO2_obs<=cut1 | dt.pCO2_obs>=cut2);
npct = 100*ncut/size(dt,1);
disp(num2str([ncut npct],'extreme n = %.i, %.2f percent of total'))

%#################
%## save figure ##
%#################
if isfig; print('-dpng','-r400',ffig); print('-dpng','-r400',ffig);end
