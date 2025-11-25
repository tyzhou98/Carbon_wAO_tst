% Create Figure 9 of
%    "Beyond Long-Term Changes: Interannual Variability 
%     of Carbon Uptake due to Sea Ice Loss in the Western 
%     Arctic Ocean"
% by Zhou et al.
%
% The figure includes the following subpanels:
%   - (a-c) UCO2 std ratio between sensitivity and baseline runs
%   - (d-f) UCO2 RMSD normalized against std of baseline run
%
%             Author: Tianyu Zhou and Yun Li, UDel, 11/23/2025

clc; clear; close all; info_params
%======================================================
% edit the following based on the user's needs
isfig=1; ffig = [fdir_MSfig 'fig9_map_UCO2_cmp'];
%======================================================
%#####################
%## figure settings ##
%#####################
fsize = 8;
fgx = 0.00; fgw = 0.45; fgdw = fgw-0.14;
fgy = 0.50; fgh = 0.45; fgdh = fgh-0.12;
% colorbar info (dim: label, colormap, range, tick)
load(fcmap_r1r2);     cmap1=cmap(41:end-40,:);
load(fcmap_pCO2dens); cmap2=flipud(cmap(1:end-10,:));
cbarinfo = {'std ratio', cmap1, 1+0.2*[-1 1], 0.85:0.1:1.15;...
           'nRMSD'     , cmap2, [0 0.45]    , 0:0.1:0.4};

%###############
%## load data ##
%###############
load(fsens);
id0=find(sens.rids1==400);                 % ID of baseline
idd=find(sens.rids1>400 & sens.rids1<500); % ID of sens for ice/history variables

%##############
%## std maps ##
%##############
for kr = 1:length(idd)
  % run info
  desc = sens.desc1{idd(kr)};
  if strfind(desc,'DSR')
    desc = 'no ice-related predictors';
  elseif strfind(desc,'bbp')
    desc = 'no \itb\rm_{bp} history';
  else
    desc = 'no wind history';
  end

  % mapping
  for kp = 1:2                             % 1: std ratio; 2: nRMSD
    wrk = nan(NX,NY);
    if kp==1; wrk(idw)=sens.FCO2int_std( :,idd(kr))./sens.FCO2int_std(:,id0); end
    if kp==2; wrk(idw)=sens.FCO2int_rmse(:,idd(kr))./sens.FCO2int_std(:,id0); end
    wrk(mgrid.mask_pCO2==0) = NaN;
    pos = [fgx+fgdw*(kr-1) fgy-fgdh*(kp-1) fgw fgh];
    ax = axes('pos',pos,'visible','off'); hold on; axis equal
    [cmap_adj,clims_adj,wrk] = fun_adj_pcolor(cbarinfo{kp,2},cbarinfo{kp,3},wrk);
    wrk(mgrid.mask==1 & mgrid.mask_pCO2==0) = -9999;   % turn shallow water to color_land
    pcolor(px,py,wrk); shading flat; colormap(ax,cmap_adj); caxis(clims_adj)
    contour(px,py,mgrid.mask,[1 1]*0.99,'color','k')
    hh=set_wAO_map(1,1); set(hh.hp,'facecolor',color_land)
    set([hh.tlg;hh.tlt],'fontsize',fsize-4)
    text(-1300,-1300,plabels{kr+(kp-1)*length(idd)},'fontsize',fsize,'fontweight','bold')
    if kp==1
      text(0,-650,['Run' num2str(kr,'%.i')],...
           'fontsize',fsize+4,'fontweight','bold','hor','cen')
      text(0,-980,desc,...
           'fontsize',fsize+1,'hor','cen'); end
    % colorbar
    if kr==1
      hco = colorbar('position',pos.*[1 1 0 0]+[0.13*fgw 0.24*fgh 0.015 0.55*fgh]);
      set(hco,'xlim',cbarinfo{kp,3},'xtick',cbarinfo{kp,4},'fontsize',fsize-1)
      ht(kp)=title(hco,cbarinfo{kp,1},'fontsize',fsize,'fontweight','bold');
    end
  end
end

if isfig
%#################
%## save figure ##
%#################
set(gcf,'color',[1 1 1],'InvertHardCopy','off');
print('-dpng','-r400',ffig)
print('-dpng','-r400',ffig)
set(ht(1),'Position',get(ht(1),'Position')-[3 0 0])
set(ht(2),'Position',get(ht(2),'Position')-[3 0 0])
print('-dpng','-r400',ffig)
end
