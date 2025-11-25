% Create Figure S4 of
%    "Beyond Long-Term Changes: Interannual Variability 
%     of Carbon Uptake due to Sea Ice Loss in the Western 
%     Arctic Ocean"
% by Zhou et al.
%
% The figure includes the following subpanels:
%   - (a-c) ML- and box-model-derived Feff against Pow for each subregion
%
%             Author: Tianyu Zhou and Yun Li, UDel, 11/25/2025

clc; clear; close all; info_params
%==========================================================
% Edit the following based on user's purpose
isfig=1; ffig = [fdir_MSfig 'figS4_plt_FeffPow'];
%==========================================================
%#####################
%## figure settings ##
%#####################
fsize = 7; msize = 3;                % marker size
fgx = 0.10; fgw = 0.275; fgdw = 0.295;
fgy = 0.40; fgh = fgw*1.25;
Flims = [0 0.18]; Fticks = 0:0.04:1; % Feff lims
Fticklabels = Fticks;
%Fticklabels = [0 -Fticks(2:end)];    % negative means C uptake

%###############
%## load data ##
%###############
load(fsens); PCAVARS = sens.PCAVARS;
pid = find(strcmp(PCAVARS(:,1),'Pow'));
eid = find(strcmp(PCAVARS(:,1),'FCO2eff'));
rids = [2 1];                                 % 2=R700 Baseline; 1=R601 Box Model
for kc = 1:3
  Pow  = squeeze(sens.input(:,pid,kc,rids));  % extract two runs: ML, Box
  Feff = squeeze(sens.input(:,eid,kc,rids));  % extract two runs: ML, Box
  if kc==1; plims = [98 122]; pticks = 90: 5:140; end 
  if kc==2; plims = [20 105]; pticks = 25:20:120; end
  if kc==3; plims = [ 0 105]; pticks =  5:25:120; end

  %##############
  %## plotting ##
  %##############
  axes('pos',[fgx+fgdw*(kc-1) fgy fgw fgh]); hold on; box on;
  for kK = 1:2                                % 1: ML; 2: Box Model
    if kK==1; lcolor = [1 1 1]*0;   mcolor = clscolor(kc,:);
    else;     lcolor = [1 1 1]*0.4; mcolor = 'none'; end
    aa = Pow(:,kK); bb = Feff(:,kK);
    [r,p] = corr(aa(:),bb(:));
    rgrs = polyfit(aa,bb,1);                  % fit a linear line
    plot(aa,bb,'o','color',clscolor(kc,:),'linewidth',1,'markerfacecolor',mcolor,'markersize',msize)
    % plot linear line
    cc = [min(aa) max(aa)] + 0.20*(max(aa)-min(aa))*[-1 1]; % X-range to plot the linear line
    dd = polyval(rgrs,cc);
    plot(cc,dd,'-','color',clscolor(kc,:),'linewidth',0.5)
    text(cc(2)+0.04*diff(plims),dd(2)+diff(dd)*0.1, ...
         {['\itr\rm=' num2str(r,'%.2f')];[ '\itp\rm' fun_pdesc(p)]},...
         'hor','lef','ver','bot','fontsize',fsize-1.5,'color',clscolor(kc,:))
  end
  % labels
  set(gca,'fontsize',fsize,...
          'xlim',plims,'xtick',pticks,'ylim',Flims,'ytick',Fticks,'yticklabel',Fticklabels)
  if kc==1; ylabel(['\boldmath' strjoin(PCAVARS{eid,3})],'fontsize',fsize+2,'interpreter','latex'); end
  if kc==2; xlabel(['\boldmath' strjoin(PCAVARS{pid,3})],'fontsize',fsize+2,'interpreter','latex'); end
  if kc>1; set(gca,'yticklabel',''); end
  line(plims,[1 1]*(Flims(2)+0.07*diff(Flims)),'color',clscolor(kc,:),'linewidth',15,'Clipping','off');
  text(mean(plims),Flims(2)+0.005*diff(Flims),num2str(kc,'subregion %.i'),...
     'fontsize',fsize+3,'color','w','fontweight','bold','hor','cen','ver','bot')
  text(plims(1)+0.03*diff(plims),Flims(2)-0.05*diff(Flims),plabels{kc},...
       'hor','lef','ver','top','fontsize',fsize+1,'fontweight','bold')
end

%#################
%## save figure ##
%#################
if isfig; print('-dpng','-r400',ffig); print('-dpng','-r400',ffig); end
