% Create Figure 7 of
%    "Beyond Long-Term Changes: Interannual Variability 
%     of Carbon Uptake due to Sea Ice Loss in the Western 
%     Arctic Ocean"
% by Zhou et al.
%
% The figure includes the following subpanels:
%   - cluster-averaged variables
%
%             Author: Tianyu Zhou and Yun Li, UDel, 11/25/2025

clc; clear; close all; info_params
%=====================================================
% Edit the following based on user's purpose
isfig = 1; ffig = [fdir_MSfig 'fig7_cluster_8var'];
%=====================================================
%#####################
%## figure settings ##
%#####################
ncol = 2; fsize = 7;
fgxp = 0.05; fgwp = 0.44; fgdw = fgwp+0.05;
fgyp = 0.74; fghp = 0.19; fgdh = fghp+0.03;
xticks = obs_yrs; xlims = obs_yrs([1 end]);
yrtxt = datestr(datenum(xticks,1,1),'yy');

%###############
%## load data ##
%###############
load(fPCA); PCAVARS = ClsPCA.PCAVARS;
load(fsens);
idd(1) = find(~cellfun('isempty',strfind(string(sens.desc3),'25'))); % run of 25% quantile error added
idd(2) = find(~cellfun('isempty',strfind(string(sens.desc3),'75'))); % run of 75% quantile error added

%#############
%## Tseries ##
%#############
for kv = 1:length(PCAVARS); var = PCAVARS{kv,1};
  ylims = PCAVARS{kv,2};
  axes('pos',[fgxp+mod(kv-1,ncol)*fgdw fgyp-(ceil(kv/ncol)-1)*fgdh fgwp fghp]); hold on; box on
  for kc = 1:3
    % region average curve
    tmp = squeeze(ClsPCA.input(:,kv,kc));        % baseline region average
    plot(ClsPCA.years',tmp,'linewidth',1,'color',clscolor(kc,:))
    % error shading for carbon-related variables
    vid = find(strcmp(sens.PCAVARS(:,1),var));   % variable index in sens runs
    if isempty(vid); continue; end               % skip variables other than carbon
    err = squeeze(sens.input(:,vid,kc,idd));     % pCO2+err region average
    patch(ClsPCA.years([1:end end:-1:1]),[err(:,1);err(end:-1:1,2)],...
          clscolor(kc,:),'linestyle','none','facealpha',0.1)
  end
  set(gca,'fontsize',fsize-1,...
          'xlim',xlims,'xtick',xticks,'xticklabel',yrtxt,...
          'ylim',ylims); xtickangle(0)
  yticks = get(gca,'ytick'); yticklabels = yticks;
% if strcmp(var,'FCO2eff')|strcmp(var,'dpCO2avg');
%   yticklabels = -yticklabels; end              % negative means C uptake
  set(gca,'ytick',yticks,'yticklabel',yticklabels)
  if kv<7; set(gca,'xticklabel','');
  else; xlabel('year','fontsize',fsize); end
  text(xlims(1)+0.12*diff(xlims),ylims(2)-0.05*diff(ylims),['\boldmath' strjoin(PCAVARS{kv,3})],...
       'hor','lef','ver','top','fontsize',fsize,'interpreter','latex')
  text(xlims(1)+0.03*diff(xlims),ylims(2)-0.05*diff(ylims),plabels{kv},...
       'hor','lef','ver','top','fontsize',fsize,'fontweight','bold')
end
legend({'subregion 1','subregion 2','subregion 3'},...
        'fontsize',fsize+2,'fontweight','bold','NumColumns',3,...
        'box','off','position',[0.35,0.95,0.33,0.04])

%#################
%## save figure ##
%#################
if isfig; print('-dpng','-r400',ffig); print('-dpng','-r400',ffig); end
