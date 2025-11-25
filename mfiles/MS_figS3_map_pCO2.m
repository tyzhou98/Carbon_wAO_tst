% Create Figure S3 of
%    "Beyond Long-Term Changes: Interannual Variability 
%     of Carbon Uptake due to Sea Ice Loss in the Western 
%     Arctic Ocean"
% by Zhou et al.
%
% The figure includes the following subpanels:
%   - (a) observation and model pCO2 maps for June 2019
%   - (b) the same as (a) but for August 2019
%
%             Author: Tianyu Zhou and Yun Li, UDel, 11/23/2025

clc; clear; close all; info_params
%============================================================
% Edit the following based on user's purpose
times = datenum(2019,[6 8],15);  % two representative months
isfig=1; ffig=[fdir_MSfig 'figS3_map_pCO2'];
%============================================================
load(fOUY); [opx,opy]=fun_lglt2xy_arc(OUY.lonr,OUY.latr,pltlon);
%#####################
%## figure settings ##
%#####################
fsize = 9; ssize = 1;
fgxm =-0.08; fgwm = 0.58; fgdwm = fgwm-0.35;
fgym = 0.40; fghm = 0.58; fgdhm = fghm-0.14;
load(fcmap_pCO2); clims = [100 450]; cticks=100:50:500;
color_land = color_landS;  % land color in Supplementary
color_ice  = color_iceS;   % ice  color in Supplementary

%##########
%## maps ##
%##########
idd_6km2OUY = sub2ind(size(OUY.A),OUY.xid_6km2OUY,OUY.yid_6km2OUY); % each 6-km pixel's ID in OUY grid
for kp = 1:length(times); twrk=times(kp);
  tid = find(abs(OUY.time-twrk)<5); tnow = OUY.time(tid);
  for kv = 1:2
    if kv==1; var = 'pCO2_obs'; end
    if kv==2; var = 'pCO2_mod'; end
    pos = [fgxm+fgdwm*(kv-1) fgym-(kp-1)*fgdhm fgwm fghm];

    % background layer based on 6-km grid
    % (land and shallow region in yellow, ice-cover in gray, open-water in white)
    ax=axes('pos',pos,'visible','off'); hold on; axis equal
    pcolor(opx,opy,nan(size(opy))); shading flat         % dummy coordinate to align size among maps
    mask = 1.*squeeze(~isnan(OUY.pCO2_mod(:,:,tid)));    % open-water in OUY grid
    mask(mask==0) = NaN;
    wrk = nan(NX,NY); wrk(idw) = mask(idd_6km2OUY);      % convert mask from OUY to 6-km grid
    [cmap_adj,clims_adj,wrk] = fun_adj_pcolor([1 1 1],clims,wrk,color_land,color_ice);
    wrk(mgrid.mask==1 & mgrid.mask_pCO2==0) = -9999;     % turn shallow water to color_land
    pcolor( px,py,wrk); shading flat; colormap(ax,cmap_adj); caxis(clims_adj)
    contour(px,py,mgrid.mask,[1 1]*0.99,'k')
    if kv==1; hh=set_wAO_map(1,1); set([hh.tlg;hh.tlt],'fontsize',5);
    else;     hh=set_wAO_map(0,0); end
    set(hh.hf,'linewidth',0.6); set([hh.hlt;hh.hlg],'linewidth',0.2)
    set(hh.hp,'facecolor',color_land)

    % pCO2 layer based on OUY grid
    ax=axes('pos',pos,'visible','off','color','none'); hold on; axis equal
    pcolor(opx,opy,nan(size(opy))); shading flat         % dummy coordinate to align size among maps
    pcolor(px,py,nan(NX,NY)); shading flat               % dummy coordinate to align size among maps
    wrk = squeeze(OUY.(var)(:,:,tid));                   % pCO2 from OUY data (value: pCO2; otherwise: NaN)
    if strcmp(var,'pCO2_obs'); idd = find(~isnan(wrk)); 
      scatter(opx(idd),opy(idd),ssize,wrk(idd),'filled') % use scatter to control point size
    else; pcolor(opx,opy,wrk); shading flat; end
    colormap(ax,cmap); caxis(clims)
    hh=set_wAO_map(0,0); set(hh.hp,'facecolor','none');
    set(hh.hf,'linewidth',0.6); set([hh.hlt;hh.hlg],'linewidth',0.2)

    % mark date
    if kv==1; text( 200 ,-2700,{datestr(tnow,'mmmm'),datestr(tnow,'yyyy')},...
                    'fontsize',fsize+3.5,'fontweight','bold','hor','cen');
    end
    if kv==1; text(-1300,-1300,plabels{kp},'fontsize',fsize,'fontweight','bold'); end
    % mark OUY subregion boundaries
    OUY.mask = nan(NX,NY); OUY.mask(mgrid.mask==1) = OUY.sflag_6km;
    for kr=1:3; contour(px,py,OUY.mask,[1 1]*kr,'color',[1 1 1]*0.5,'linewidth',0.5); end
    if kp==1&kv==1
      text( 712,-1850,OUY.srnms{1},'fontsize',fsize-4,'rotation',110,'hor','left','vert','bot','color',[1 1 1]*0.15)
      text( 220,-2180,OUY.srnms{2},'fontsize',fsize-4,'rotation',  9,'hor','left','vert','bot','color',[1 1 1]*0.15)
      text(-792,-2362,OUY.srnms{3},'fontsize',fsize-4,'rotation', 70,'hor','left','vert','bot','color',[1 1 1]*0.15)
      text(-812,-2922,'Bering Strait','fontsize',fsize-6,'rotation', 70,'hor','left','vert','bot','color',[1 1 1]*0.15)
    end
  end; clear kv
end; clear kp
% colorbar
hco=colorbar('position',[fgxm+3.25*fgdwm fgym-fgdhm+0.30 0.015 0.7*fghm]);
set(hco,'xlim',clims,'xtick',cticks)
title(hco,label_pCO2,'Interpreter','latex')

%#################
%## save figure ##
%#################
if isfig; print('-dpng','-r400',ffig); print('-dpng','-r400',ffig); end
