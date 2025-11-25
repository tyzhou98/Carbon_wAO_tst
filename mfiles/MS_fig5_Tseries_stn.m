% Create Figure 5 of
%    "Beyond Long-Term Changes: Interannual Variability 
%     of Carbon Uptake due to Sea Ice Loss in the Western 
%     Arctic Ocean"
% by Zhou et al.
%
% The figure includes the following subpanels:
%   - (a) yearly UCO2 and seasonal FCO2 at Canada Basin station
%   - (b) the same as (a) but for Chukchi Sea station
%
%             Author: Tianyu Zhou and Yun Li, UDel, 11/25/2025

clc; clear; close all; info_params
%=====================================================
% edit the following based on the user's needs
isfig = 1; ffig = [fdir_MSfig 'fig5_stn_contrast'];
%=====================================================
%#####################
%## figure settings ##
%#####################
fsize = 8;
fgx = 0.10; fgw = 0.60; fgdw = fgw+0.03;
fgy = 0.45; fgh = 0.32; fgdh = fgh+0.03;
xticks= obs_yrs; xlims = xticks([1 end])+0.53*[-1 1]; % year lims
xticklabels = datestr(datenum(xticks,1,1),'yy');
Uticks = 0:0.1:30;                                    % UCO2 lims
mlims= t8d_clm(bid_M2A([1 end])+[-1 1]);              % month lims
mticks= datenum(0,1:12,1); mticklabels = datestr(mticks,'mmm');
clims = [0 0.25]; cticks = 0:0.05:0.4;                % cflux lims
cticklabels = cticks;
%cticklabels = [0 -cticks(2:end)];                     % negative means C uptake
load(fcmap_FCO2); colormap(cmap);                     % color scheme of FCO2

%###############
%## load data ##
%###############
load(fdiag)
doys = unique(diag.stn.doy)';  Ndoy=length(doys);     % doy of year for 8-day time series
years= unique(diag.stn.year)'; Nyrs=length(years);    % years from 2003-2022

%####################
%## month-year map ##
%####################
for ks = 1:size(stninfo,1)
  % read data
  FCO2 = diag.stn.FCO2(ks,:);                % extract air-sea CO2 flux [gC/m2/day]
  FCO2 = reshape(FCO2,[Ndoy Nyrs]);
  sid = [stninfo{ks,1}];                     % grid ID of the station
  UCO2 = diag.FCO2int(sid,:).*cff_g2Gg;      % extract i2A integrated C uptake [Gg C]
  Pow  = diag.Pow(sid,:);                    % extract i2A open water duration [days]
  Ulims = stninfo{ks,4};
  % correlation
  idd = find(~isnan(Pow+UCO2) & years>=obs_yrs(1));
  [r,p] = corr(Pow(idd)',UCO2(idd)');
  desc = ['\itr\rm=' num2str(r,'%.2f') ', \itp\rm' fun_pdesc(p)];

  % CO2 flux axis
  pos = [fgx fgy-(ks-1)*fgdh fgw fgh];
  ax1 = axes('pos',pos,'yaxisloc','right'); hold on
  pcolor([years years(end)+1]-0.5,doys,squeeze(FCO2(:,[1:end end]))); shading flat; caxis(clims)
  set(gca,'fontsize',fsize-1, ...
          'xcolor',[1 1 1]*0.30,'xlim',xlims,'xtick',xticks,'xticklabel','',...
          'ycolor',[1 1 1]*0.30,'ylim',mlims,'ytick',mticks,'yticklabel',mticklabels); xtickangle(0)
  text(xlims(1)+0.02*diff(xlims),mlims(1)+0.04*diff(mlims),[plabels{ks} ' ' stninfo{ks,2}],...
       'fontsize',fsize,'fontweight','bold','hor','lef','ver','bot')  % panel labels
  text(xlims(1)+0.34*diff(xlims),mlims(1)+0.04*diff(mlims),desc,...
      'fontsize',fsize-1,'hor','lef','ver','bot')

  % integrated CO2 flux axis
  ax2 = axes('pos',pos,'color','none','yaxisloc','left','xaxisloc','top'); hold on
  plot(years,UCO2,'-','linewidth',1.5,'color','k'); caxis(clims)
  set(gca,'fontsize',fsize,'ydir','reverse','fontweight','bold',...
          'xlim',xlims,'xtick',xticks,'xticklabel','',...
          'ylim',Ulims,'ytick',Uticks); xtickangle(0)
end
set(ax2,'ytick',Uticks(1:2:end)); 
% colorbar
hco=colorbar('horizontal','position',[fgx+0.10*fgw fgy+fgdh 0.8*fgw 0.025]);
set(hco,'xtick',cticks,'xticklabel',cticklabels)
title(hco,['\boldmath' strjoin(label_fCO2)],'fontsize',fsize,'interpreter','latex')
% labels
xlabel(ax1,'year','fontsize',fsize);
ylabel(ax2,['\boldmath' strjoin(label_UCO2_GgC)],'interpreter','latex','position',...
           [xlims(1)-0.07*diff(xlims) Ulims(1)-0.1*diff(Ulims)],'fontsize',fsize)
set(ax1,'xticklabel',xticklabels)

%#################
%## save figure ##
%#################
if isfig; print('-dpng','-r400',ffig); print('-dpng','-r400',ffig); end
