% Create Figure 2 of
%    "Beyond Long-Term Changes: Interannual Variability 
%     of Carbon Uptake due to Sea Ice Loss in the Western 
%     Arctic Ocean"
% by Zhou et al.
%
% The figure includes the following subpanels:
%   - (a-c) monthly pCO2 obs vs mod for subregions
%   - (d-f) yearly modeled delta pCO2, carbon uptake, open water area 
%
%             Author: Tianyu Zhou and Yun Li, UDel, 11/25/2025

clc; clear; close all; info_params
%=============================================================
% Edit the following based on user's purpose
mons = [4 8];  % selected data months on the plot
isfig = 1; ffig = [fdir_MSfig 'fig2_Tseries_subreg_avg'];
%=============================================================
%#####################
%## figure settings ##
%#####################
fsize = 5.5;
fgx = 0.06; fgw = 0.40; fgdw = 0.45; cff = 0.09; % cff of extended xaxis
fgy = 0.64; fgh = 0.27; fgdh = 0.29;

%########################################
%## load OUY monthly data and set axes ##
%########################################
% left column - monthly data
load(fOUY); mm = month(OUY.time);
tid = find(mm>=mons(1) & mm<=mons(2));           % selected months only
xm2m = 1:length(tid);                            % use indices for plotting x-axis
xlims = xm2m([1 end]) + [-4 2];                  % use indices for x-limits
xticks =[xm2m(1:(diff(mons)+1):end) xm2m(end)+1];% use first month of mons to tick each year (add 2023)
tm2m = [OUY.time(tid) datenum(2023,mons(1),15)]; % use corresponding time for x-ticks (add 2023)
xticklabels = datestr(tm2m(xticks),'yy');        % use corresponding year to xtick labels
% right column - yearly data
yrid = find(OUY.y2y.years>=obs_yrs(1));          % 2003-2022 
ty2y = OUY.y2y.years(yrid);                      % selected years only
tlims = obs_yrs([1 end])+[-1 1]*0.5;             % apply year range
tticks = obs_yrs;                                % use years for x-ticks
tticklabels = datestr(datenum(obs_yrs,1,1),'yy');% use 2-dig year for x-tick labels
OUY.y2y.Aow = OUY.y2y.Aow/1e5;                   % km^2 -> 10^5 km^2
% yaxis settings
plims = [130 430]; pticks = 100:50:600;          % pCO2 axis
dlims = [  0 190]; dticks =   0:30:200;          % delta pCO2 axis
vinfo = {'dpCO2avg','dlims','dticks',label_dpCO2   , color_pCO2 , 0.0 ;...
         'Aow'     ,'alims','aticks',label_Aow     , color_Aow , 0.95 ;...
         'FCO2int' ,'flims','fticks',label_UCO2_TgC, [0 0 0], 1.1};

for kr = 1:3  % three subregions
  %##################
  %## pCO2 Tseries ##
  %##################
  mylabel = {['\boldmath' label_pCO2{1}]; ...
             ['\boldmath' label_pCO2{2}]};                       % y-axis labels  
  axes('pos',[fgx fgy-(kr-1)*fgdh fgw fgh]); hold on; box on
  plot(xm2m,OUY.pCO2_obsR(OUY.cls==kr,tid),'ko','markerfacecolor','none','markersize',2)
  plot(xm2m,OUY.pCO2_modR(OUY.cls==kr,tid),'k-','linewidth',1)
  plot(xticks(1:end-1),OUY.y2y.pCO2airavg(OUY.cls==kr,yrid),'--','linewidth',1,'color',color_air)
  text(xlims(1)+0.70*diff(xlims),plims(2)-0.12*diff(plims),'atmospheric \itp\rmCO_2',...
       'hor','lef','ver','top','fontsize',fsize-1,'rot',4,'color',color_air)
  text(xlims(1)+0.03*diff(xlims),plims(2)-0.04*diff(plims),[plabels{kr} ' ' OUY.srnms{kr}],...
       'hor','lef','ver','top','fontsize',fsize,'fontweight','bold')
  if kr==1; text(xlims(1),plims(2)+0.05*diff(plims),mylabel,...  % variable label
                 'hor','cen','ver','bot','fontsize',fsize,'interpreter','latex'); end
  % settings
  set(gca,'fontsize',fsize,...
          'xlim',xlims,'xtick',xticks(1:1:end),'xticklabel',xticklabels(1:1:end,:),...
          'ylim',plims,'ytick',pticks); xtickangle(0)
  if kr<3; set(gca,'xticklabel',''); else; xlabel('year','fontsize',fsize+1); end

  %###########################
  %## Carbon uptake Tseries ##
  %###########################
  % set variable and subregional ranges
  if kr==1; flims=[0  8]; fticks=0:2:10; alims=[0  10]; aticks=0:2:80; end
  if kr==2; flims=[0  5]; fticks=0:1:10; alims=[0 3.5]; aticks=0:1:80; end
  if kr==3; flims=[0 15]; fticks=0:3:20; alims=[0 6.0]; aticks=0:2:80; end
  % plot each variable
  for kv = 1:3;
    wrk = OUY.y2y.(vinfo{kv,1})(OUY.y2y.cls==kr,yrid);  % yearly time series
    eval(['ylims  = ' vinfo{kv,2} ';']);                % y-axis limits
    eval(['yticks = ' vinfo{kv,3} ';']);                % y-axis ticks
    yticklabels = yticks;
%   if strcmp(vinfo{kv,1},'dpCO2avg');
%     yticklabels(2:end)=-yticklabels(2:end); end       % negative means C uptake
    mylabel = {['\boldmath' vinfo{kv,4}{1}]; ...
               ['\boldmath' vinfo{kv,4}{2}]};           % y-axis labels
    colors = vinfo{kv,5};                               % y-axis color

    % set axis position for overlay
    axes('pos',[fgx+fgdw fgy-(kr-1)*fgdh fgw*(1+cff*(kv==3)) fgh],...
         'xcolor','k','ycolor',colors); hold on         % each offset to form multi axes
    if strcmp(vinfo{kv,1},'FCO2int')                    % bar plot for Fint
      hb = bar(ty2y,wrk,0.7);
      set(hb,'FaceColor', colors,'Edgecolor','none','facealpha',0.2,'showbaseline','off')
    else                                                % line plot for others
      plot(ty2y,wrk,'-','color',colors,'linewidth',1); end

    % mark trend and std
    cffp = polyfit(ty2y,wrk,1);
    anom = wrk-polyval(cffp,ty2y);
    [~,pv] = corr(ty2y(:),wrk(:));
    text(tlims(1)+2.5,ylims(2)+(-0.02-0.09*(kv-1))*diff(ylims),...
         [num2str(std(anom),'std=%.2f') ...                     % std of residual
          num2str(cffp(1)  ,', trend=%.2f') ' year^{-1}' ...    % linear trend
          ' (\itp\rm' fun_pdesc(pv) ')'],...                    % p-value
         'hor','lef','ver','top','fontsize',fsize-0.5,'color',colors)

    % settings
    set(gca,'fontsize',fsize,...
            'xlim',tlims+[0 1]*diff(tlims)*cff*(kv==3),'xtick',tticks,'xticklabel',tticklabels,...
            'ylim',ylims,'ytick',yticks,'yticklabel',yticklabels); xtickangle(0)
    if kv>1; set(gca,'xaxisloc','top','yaxisloc','right','color','none'); end
    if kv==3; set(gca,'xcolor','none'); end
    if kr<3 | kv>1; set(gca,'xticklabel',''); end
    if kr==1; text(tlims(1)+diff(tlims)*vinfo{kv,6},ylims(2)+0.05*diff(ylims),mylabel,...
              'hor','cen','ver','bot','fontsize',fsize+0.5,'color',colors,'interpreter','latex'); end
    if kr==3&kv==1; xlabel('year'); end
  end
  text(tlims(1)+0.03*diff(tlims),ylims(2)-0.04*diff(ylims),plabels{kr+3},...
       'hor','lef','ver','top','fontsize',fsize+1,'fontweight','bold')
end

%#################
%## save figure ##
%#################
if isfig; print('-dpng','-r400',ffig); print('-dpng','-r400',ffig); end
