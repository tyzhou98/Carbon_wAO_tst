% Create Figure S2 of
%    "Beyond Long-Term Changes: Interannual Variability 
%     of Carbon Uptake due to Sea Ice Loss in the Western 
%     Arctic Ocean"
% by Zhou et al.
%
% The figure includes the following subpanels:
%   - (a) Relative importance of predictors ranked by RF
%   - (b) Map of dominant predictors from perturbation analysis
%
%             Author: Tianyu Zhou and Yun Li, UDel, 11/23/2025

clc; clear; close all; info_params
%===============================================================================
% Edit the following based on user's purpose
isfig=1; ffig=[fdir_MSfig 'figS2_map_var_impot'];
isSST=0; if ~isSST; ffig=[ffig '_NoSST']; end     % isSST=1: w/ SST in ranking
%===============================================================================
%#####################
%## figure settings ##
%#####################
fsize = 8;
fgx = 0.10; fgw = 0.40; fgxm = 0.42; fgwm = 0.64;
fgy = 0.25; fgh = 0.41; fgym = 0.13; fghm = 0.64;
blims = [0 0.28]; bticks = 0:0.05:0.55;
color_land = color_landS;  % land color in Supplementary

%##############
%## var info ##
%##############
% vinfo: {name, color, symbol}
vinfo = {
  'SST'     ,[0.70 0.70 0.70], '$SST$'
  'SSS'     ,[0.44 0.64 0.99], '$SSS$'
  'DSR0422' ,[0.44 0.02 0.68], '$DSR$'
  'U2'      ,[0.68 0.40 0.07], '$U\mathrm{^{2}}$'
  'bbp'     ,[0.47 0.67 0.19], label_bbp{1}
  'bbph16'  ,[0.60 0.83 0.27], strrep(label_bbp{1},'_{bp}','_{bp}^{16d}')
  'bbph24'  ,[0.68 0.86 0.55], strrep(label_bbp{1},'_{bp}','_{bp}^{24d}')
  'k08'     ,[0.82 0.58 0.01], label_kCO2{1}
  'k24'     ,[0.93 0.69 0.13], strrep(label_kCO2{1},'8d','24d')
        };

%###############
%## load data ##
%###############
load(fsens);
xticks = sens.xticks; NV = length(xticks);
feature_import = sens.feature_imp(:,1);              % baseline  run feature importance
fea_std = std(sens.feature_imp');                    % shuffling run feature importance
idd = find(sens.rids1>300 & sens.rids1<400);         % perturb   run ID
tmp = sens.desc1(idd);                               % perturb   run description
% based on xticks, create colormap and sort runid
for kv = 1:NV;  
  xvars{kv} = strtrim(xticks(kv,:));                 % convert xtick to cells
  id4vinfo(kv) = find(strcmp(vinfo(:,1),xvars{kv})); % sort id of vinfo following xticks
  id4runs(kv)  = idd(strcmp(tmp,['adj ' xvars{kv}]));% sort id of  runs following xticks
end
cmap = cell2mat(vinfo(id4vinfo,2));                  % match xtick with color
xticklabels = vinfo(id4vinfo,3);                     % match xtick with labels
xlims = [1 NV]+0.5*[-1 1]; clims = xlims([1 end]);
% calculate std differences
stddif = abs( sens.pCO2avg_std(:,id4runs) ...        % match xtick with run
     - repmat(sens.pCO2avg_std(:,1),[1 NV]) );       % diff of std between run and baseline
if ~isSST; stddif(:,strcmp(xvars,'SST')) = NaN; end  % remove SST
[~,idx] = nanmax(stddif,[],2);                       % dominant var
var_map = nan(NX,NY); var_map(idw)=idx;
var_map(mgrid.mask_pCO2==0)=NaN;

%##################################
%## (a) RF predictor importance  ##
%##################################
ax=axes('Position',[fgx fgy fgw fgh]); hold on; box on
for kv = 1:NV
  hb = bar(kv,feature_import(kv),'facecolor',cmap(kv,:));
  errorbar(kv,feature_import(kv),fea_std(kv),'color','k')
end
text(xlims(1)+0.03*diff(xlims),blims(2)-0.03*diff(blims),plabels{1},...
     'FontSize',fsize,'FontWeight','bold','hor','lef','ver','top')
set(gca,'fontsize',fsize, ...
    'xlim',xlims,'xtick',1:NV,'xticklabel',xticklabels,...
    'ylim',blims,'ytick',bticks,'YGrid','on')
set(ax.XAxis,'TickLabelInterpreter','latex')
xtickangle(0); ytickformat('%.2f')
ylabel('Relative importance','FontSize',fsize+1)

%##########################################
%## (b) map of most important predictors ##
%##########################################
axes('position',[fgxm fgym fgwm fghm],'visible','off'); hold on; axis equal
[cmap_adj,clims_adj,wrk] = fun_adj_pcolor(cmap,clims,var_map,color_land,color_ice);
wrk(mgrid.mask==1 & mgrid.mask_pCO2==0) = -9999;   % turn shallow water to color_land
pcolor(px,py,wrk); shading flat; colormap(cmap_adj); caxis(clims_adj)
contour(px,py,mgrid.mask,[1 1]*0.99,'color','k','linewidth',1)
hh = set_wAO_map(1,1); set(hh.hp,'facecolor',color_land)
text(-1300,-1300,plabels{2},'fontsize',fsize,'fontweight','bold')

%###################
%##  save figure  ##
%###################
if isfig
set(gcf,'color',[1 1 1],'InvertHardCopy','off');
print('-dpng','-r400',ffig); print('-dpng','-r400',ffig)
end
