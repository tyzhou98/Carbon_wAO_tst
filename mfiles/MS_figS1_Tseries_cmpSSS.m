% Create Figure S1 of
%    "Beyond Long-Term Changes: Interannual Variability 
%     of Carbon Uptake due to Sea Ice Loss in the Western 
%     Arctic Ocean"
% by Zhou et al.
%
% The figure includes the following subpanels:
%   - ECCO2 SSS validated against SOCAT for each year
%
%             Author: Tianyu Zhou and Yun Li, UDel, 11/23/2025

clc; clear; close all; info_params
%=====================================================
% Edit the following based on user's purpose
isfig=1; ffig=[fdir_MSfig 'figS1_cmpSSS_Tseries'];
%=====================================================
%#####################
%## figure settings ##
%#####################
fsize = 4.5; msize = 1; ncol = 4;
fgx = 0.03; fgw = 0.23; fgdw = fgw+0.01;
fgy = 0.80; fgh = 0.16; fgdh = fgh+0.03;
ylims = [16 35]; yticks = [16:3:40];
ylims = ylims + 0.08*diff(ylims)*[-1 1];
load(fcmap_pCO2dens); cmap = cmap([140:70:end 1 50],:); % color scheme of lines

%###############
%## load data ##
%###############
dt = readtable(fmch);
dt.year = year(dt.time);
dt.doy  = dt.time-datenum(dt.year,1,0);
tmp = char(dt.Expocode);
dt.Expocode = string(tmp(:,1:8)); clear tmp             % trim Expocode to combine different legs
% linearly transform ECCO2 SSS
idd = find(~isnan(dt.uSSS+dt.SSS));
m = polyfit(dt.SSS(idd),dt.uSSS(idd),1);
dt.SSS = polyval(m,dt.SSS);
disp(num2str(m,'Relation: SSSmod = %.2f*SSSmod %.2f'))
% split cruises in some years
years=[2003 2004 2005 2006 ...
       2008 2010 2012 2013 ...
       2014 2015 9915 2016 ...
       2017 9917 2018 9918 ...
       2019 2020 2021 2022];  % dummy 99xx aims to split cruise in the same year
idd=find(dt.year==2015 & (dt.Expocode=="33RO2015"                        )); dt.year(idd)=9915;
idd=find(dt.year==2017 & (dt.Expocode=="32DB2017"|dt.Expocode=="49NZ2017")); dt.year(idd)=9917;
idd=find(dt.year==2018 & (dt.Expocode=="33BI2018"|dt.Expocode=="76XL2018")); dt.year(idd)=9918;
yrlabels = num2str(years(:));
yrlabels(10,1:5) = '2015a';
yrlabels(11,1:5) = '2015b';
yrlabels(13,1:5) = '2017a';
yrlabels(14,1:5) = '2017b';
yrlabels(15,1:5) = '2018a';
yrlabels(16,1:5) = '2018b';

%######################
%## plot time series ##
%######################
for kp = 1:length(years)
  % time window
  ywrk = years(kp); tid = find(dt.year==ywrk);      % extract the current year
  yref = datenum(ywrk,1,0);                         % time offset for xaxis
  if ywrk>9e3; yref=datenum(ywrk-7e3-9e2,1,0); end  % convert 99xx back
  tmp = dt(tid,:); ewrk = unique(tmp.Expocode);     % all cruise IDs in the year
  xlims = t8d_clm(ceil([min(tmp.doy) max(tmp.doy)]/8)+[0 1])+4*[-1 1]+yref;
  xticks = t8d_clm+yref; xticklabels = datestr(xticks,'mm-dd');
  if diff(xlims)>70; xticklabels(2:2:end) = ' '; end
  % plot data
  axes('pos',[fgx+fgdw*mod(kp-1,ncol) fgy-fgdh*(ceil(kp/ncol)-1) fgw fgh])
  hold on; grid on; box on
  for ke = 1:length(ewrk); txt = char(ewrk(ke)); txt = [txt(1:end-4) '*'];
    idd = find(tmp.Expocode==ewrk(ke));
    ctxt=cmap(ke,:); istxt=1;
    if ismember(ywrk,[2003:2014 9915 2016 9917 9918 2020:2022]);
      ctxt=cmap(1,:); istxt=0; end                           % use single color
    if sum(~isnan(tmp.uSSS(idd)))==0; ctxt=[1 1 1]*0.7; end  % missing SSS
    plot(tmp.time(idd),tmp.SSS( idd),'.','markersize',msize,'color','k')
    plot(tmp.time(idd),tmp.uSSS(idd),'.','markersize',msize,'color',ctxt)
    if istxt                                                 % mark cruise ID
      text(xlims(1)+(0.31+0.17*(ke-1))*diff(xlims),ylims(1)+0.04*diff(ylims),...
           txt,'color',ctxt,'fontsize',fsize,'hor','lef','ver','bot'); end
  end
  set(gca,'fontsize',fsize,...
      'xlim',xlims,'xtick',xticks,'xticklabel',xticklabels(:,2:end),...
      'ylim',ylims,'ytick',yticks); xtickangle(0)
  if kp==9; ylabel('SSS','fontsize',fsize); end
  if mod(kp-1,ncol)>0; set(gca,'yticklabel',''); end
  % mark text
  text(xlims(1)+0.02*diff(xlims),ylims(2)-0.02*diff(ylims),...
       ['(' char('a'+kp-1) ') ' yrlabels(kp,:)],...
       'fontsize',fsize+1,'fontweight','bold','hor','left','ver','top')
  text(xlims(1)+0.03*diff(xlims),ylims(1)+0.04*diff(ylims),...
       ['\itn\rm = ' num2str(size(tmp,1))],...
       'fontsize',fsize,'hor','lef','ver','bot')
end

%###################
%##  save figure  ##
%###################
if isfig; print('-dpng','-r400',ffig); print('-dpng','-r400',ffig); end
