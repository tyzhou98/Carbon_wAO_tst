% Create Figure 8 of
%    "Beyond Long-Term Changes: Interannual Variability 
%     of Carbon Uptake due to Sea Ice Loss in the Western 
%     Arctic Ocean"
% by Zhou et al.
%
% The figure includes the following subpanels:
%   - (a-c) PCA results for each subregion
%
%             Author: Tianyu Zhou and Yun Li, UDel, 11/23/2025

clc; clear; close all; info_params
%================================================
% Edit the following based on user's purpose
isfig=1; ffig = [fdir_MSfig 'fig8_PCA_8var'];
%================================================
%#####################
%## figure settings ##
%#####################
fgx = 0.00; fgw = 0.37; fgdw = fgw-0.04;
fgy = 0.40; fgh = fgw;
radj = 1.15; cff_sc = 4; fsize = 8;
lims = [-1 1]*6.5; ticks = -10:2:10;

%###############
%## load data ##
%###############
load(fPCA);
for kv = 1:length(ClsPCA.PCAVARS)
  wrk = ClsPCA.PCAVARS{kv,3};
  vlabels{kv} = ['$\,\,$ ' wrk{1}];                     % get variable symbol only
end
colors = repmat([1 1 1]*0.6,[length(ClsPCA.PCAVARS) 1]);% all variables in gray
colors(1:3,:) = [[0 0 0]; color_Aow; color_FCO2];       % adjust top three major variables

%#######################
%## biplot PC1 vs PC2 ##
%#######################
for kc = 1:3
  mCOEFF = squeeze(ClsPCA.mCOEFF(:,:,kc));
  mSCORE = squeeze(ClsPCA.mSCORE(:,:,kc));
  EXPLAINED = squeeze(ClsPCA.EXPLAINED(:,kc));

  % biplot
  axes('pos',[fgx+fgdw*(kc-1) fgy fgw fgh]); hold on
  plot([0 0],lims,'k:','linewidth',0.5);
  plot(lims,[0 0],'k:','linewidth',0.5);
  plot(mSCORE(:,1)*cff_sc,mSCORE(:,2)*cff_sc,'o',...
       'color',[1 1 1]*0.6,'markerfacecolor',[1 1 1]*0.9,'markersize',3)
  for kv = 1:length(ClsPCA.PCAVARS); VAR = ClsPCA.PCAVARS{kv,1};
    % plot settings
    mfsize = fsize-1.5; mlabel = vlabels{kv}; mlinew = 1;  % baseline for all
    switch VAR; case{'FCO2int','FCO2eff','Pow'};           % alternative for major vectors 
      mlinew = 2.5; mfsize = fsize+1; mlabel = ['\boldmath' vlabels{kv}]; end
    % feature vectors projected onto PC1-PC2 space
    xx = mCOEFF(kv,1); yy = mCOEFF(kv,2);
    quiver(xx*0,yy*0,xx,yy,0,'color',colors(kv,:),'linewidth',mlinew)
    text(xx.*radj,yy.*radj,mlabel,'color',colors(kv,:),'fontsize',mfsize,...
         'hor','center','ver','middle','interpreter','latex')
  end
  % additional settings
  axis equal; box on
  line(lims,[1 1]*(lims(2)+0.064*diff(lims)),'color',clscolor(kc,:),'linewidth',15,'Clipping','off');
  text(mean(lims),lims(2)+0.005*diff(lims),num2str(kc,'subregion %.i'),'fontsize',fsize+2,'color','w',...
       'fontweight','bold','hor','cen','ver','bot')
  text(lims(1)+0.03*diff(lims),lims(2)-0.05*diff(lims),plabels{kc},...
       'hor','lef','ver','top','fontsize',fsize,'fontweight','bold')
  set(gca,'fontsize',fsize,'xlim',lims,'xtick',ticks,'ylim',lims,'ytick',ticks); xtickangle(0)
  xlabel([num2str(EXPLAINED(1),'PC1 (%.1f'),'% of variance)'],'fontsize',fsize)
  ylabel([num2str(EXPLAINED(2),'PC2 (%.1f'),'% of variance)'],'fontsize',fsize)
end

%#################
%## save figure ##
%#################
if isfig; print('-dpng','-r400',ffig); print('-dpng','-r400',ffig); end
