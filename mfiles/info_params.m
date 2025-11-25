% Info and parameters used in the package
%
%         Tianyu Zhou and Yun Li, UDel, 11/24/2025

%###########
%## paths ##
%###########
fdir_MSdata = '../MSdata/';   %   data folder
fdir_MSfig  = '../MSfig/';    % figure folder

%###############
%## File info ##
%###############
% grid and data
fgrd  = [fdir_MSdata 'grid_DB06.mat'];               % western AO grid
fmch  = [fdir_MSdata 'RF_matchup.csv'];              % pCO2-predictor matchups
feva  = [fdir_MSdata 'R100_RF_eval.csv'];            % ML modeled pCO2 evaluation
fdiag = [fdir_MSdata 'R100_RF_WArc_cdiag.mat'];      % CO2 diags
fPCA  = [fdir_MSdata 'R100_RF_WArc_PCA.mat'];        % CO2 and environmental factors PCA 
fOUY  = [fdir_MSdata 'Tseries_regavg_6kmOUYgrd.mat'];% averaged by Ouyang et al. (2020) subregions
fsens = [fdir_MSdata 'eval_SensRuns_300to700.mat'];  % sensitivity runs data compilation
fwnd  = [fdir_MSdata 'Uwnd_03to22_trend.mat'];       % wind trend analysis
% colormap
fcmap_bathy   = [fdir_MSdata 'cmap_bathy5.mat'];     % colormap for bathymetry
fcmap_pCO2    = [fdir_MSdata 'cmap_pCO2.mat'];       % colormap for underway pCO2
fcmap_pCO2dens= [fdir_MSdata 'cmap_pCO2dens.mat'];   % colormap for ML pCO2 density plot
fcmap_FCO2    = [fdir_MSdata 'cmap_FCO2.mat'];       % colormap for FCO2
fcmap_r1r2    = [fdir_MSdata 'cmap_r1r2BR.mat'];     % colormap for corr. of UCO2 w/ Pow
fcmap_r1r2dens= [fdir_MSdata 'cmap_r1r2dens.mat'];   % colormap for r1 r2 density plot
fcmap_corr    = [fdir_MSdata 'cmap_gr.mat'];         % colormap for corr. of kCO2 and bbp w/ Pow
fcmap_wind    = [fdir_MSdata 'cmap_WindBR'];         % colormap for wind trend

%###############
%## grid info ##
%###############
% grid config params
load(fgrd); [NX,NY] = size(mgrid.mask);           % load grd
lat_str = mgrid.lat_str; lat_end = mgrid.lat_end; % south-/north-most lat
lon_str = mgrid.lon_str; lon_end = mgrid.lon_end; % west-/east-most lon
% mask IDs
idw = find(mgrid.mask==1);                        % IDs of water pixels
idl = find(mgrid.mask==0      ...                 % IDs of land or coastal pixels
         & mgrid.lonr>=lon_str & mgrid.lonr<=lon_end ...
         & mgrid.latr>=lat_str & mgrid.latr<=lat_end);
id0 = find(mgrid.mask==0);                        % IDs of transparent pixels
% visualization
pltlon  = mean([lon_str lon_end])+90-360;         % positive x-dir of the map plot
[px,py] = fun_lglt2xy_arc(mgrid.lonr,mgrid.latr,pltlon);
lonticks = (360-170):15:(360-135);                % lon ticks on maps
latticks = 60:4:78;                               % lat ticks on maps

%###############
%## Time info ##
%###############
% observations
obs_yrs = 2003:2022;  Nyrs_obs = length(obs_yrs);  % base years of study period
% input environmental data
yrs_VAR = 1998:2022;  Nyrs_VAR = length(yrs_VAR);  % years and number of years
t8d_clm = 1:8:365;    N8d_clm = length(t8d_clm);   % time and number of climato. 8-day bins
% pCO2 analysis
b8d_str = datenum(0,5,1);                          % 8day bin start date for kriging
b8d_end = datenum(0,9,30);                         % 8day bin end date for kriging
bid_krig= ceil(b8d_str./8)+1:ceil(b8d_end./8);     % 8day bin indices for kriging
                      NB_krig = length(bid_krig);  % number of bins for kriging		      
bid_M2A = 17:31;      NB_M2A  = length(bid_M2A);   % 8day bin indices of May-11 to Sep-01 for analysis

%##################
%## station info ##
%##################
stninfo = {36727, 'Canada Basin', 'CB', [-0.1 0.4] ; ...
           13770, 'Chukchi Sea' , 'CS', [-0.1 0.8]};

%#####################
%## unit conversion ##
%#####################
cff_g2Gg   = 1e-9;    % 1 milligram to Gigagram

%############
%## Labels ##
%############
label_UCO2_GgC = {'$U\mathrm{_{CO_2}}$';'$\mathrm{(Gg\;C)}$'};
label_UCO2_TgC = {'$U\mathrm{_{CO_2}}$';'$\mathrm{(Tg\;C)}$'};
label_Pow      = {'$P\mathrm{_{OW}}$'  ;'$\mathrm{(days)}$'};
label_Aow      = {'$A\mathrm{_{OW}}$'  ;'$\mathrm{(10^{5}\;km^{2})}$'};
label_fCO2     = {'$F\mathrm{_{CO_2}}$';'$\mathrm{(g\;C\;m^{-2}\;day^{-1})}$'};
label_fCO2_eff = {'$F\mathrm{_{CO_2}^{eff}}$';'$\mathrm{(g\;C\;m^{-2}\;day^{-1})}$'};
label_kCO2     = {'$k\mathrm{_{CO_2}^{8d} }$';'$\mathrm{(m\;day^{-1})}$'};
label_bbp      = {'$b\mathrm{_{bp}}$'  ;'$\mathrm{(\log_{10}m^{-1})}$'};
label_Is       = {'$I\mathrm{_{surf}}$';'$\mathrm{(hours)}$'};
label_Rmelt    = {'$R\mathrm{_{melt}}$';'$\mathrm{(\%\;day^{-1})}$'};
label_SIC      = {'$SIC$'              ;'$\mathrm{(\%)}$'};
label_dpCO2    = {'$\Delta p\mathrm{CO_2}$';'$\mathrm{(\mu atm)}$'};
label_pCO2     = {'$       p\mathrm{CO_2}$';'$\mathrm{(\mu atm)}$'};
label_r1       = ['$r_1$\,(' label_Pow{1}(1:end-1)      ',\:' label_UCO2_TgC{1}(2:end-1) ')$'];
label_r2       = ['$r_2$\,(' label_fCO2_eff{1}(1:end-1) ',\:' label_UCO2_TgC{1}(2:end-1) ')$'];
plabels = {'(a)', '(b)', '(c)', '(d)', ...
           '(e)', '(f)', '(g)', '(h)', ...
           '(i)', '(j)', '(k)', '(l)', ...
           '(m)', '(n)', '(o)', '(p)'};

%#####################
% PCA variable info ##
%#####################
PCAVARS = {...
        'FCO2int' , [0 8]      , label_UCO2_TgC;
        'Pow'     , [0 150]    , label_Pow;
        'FCO2eff' , [0.03 0.18], label_fCO2_eff;
        'dpCO2avg', [30 150]   , label_dpCO2;
        'kCO2avg' , [0.6 2.2]  , label_kCO2;
        'bbpavg'  ,-[2.7 1.9]  , label_bbp;
        'Isavg'   , [18 24]    , label_Is;
        'Rmelt'   , [0 3]      , label_Rmelt;
         };

%###########################
%## line and patch colors ##
%###########################
color_mesh = [50 99 99]/256;               % color of grid mesh
color_land = [1 1 1]*0.9;                  % color of land patch
color_landS= [245 239 194]/256;            % color of land patch in Supplementary
color_ice  = [1 1 1];                      % color of ice  patch
color_iceS = [1 1 1]*0.9;                  % color of ice  patch in Supplementary
color_pCO2 = [0.96 0.52 0.52];             % color of pCO2
color_FCO2 = [0.96 0.52 0.52];             % color of air-sea CO2 flux
color_Aow  = [0.2 0.5 1.0];                % color of open water area
color_air  = [1 1 1]*0.8;                  % color of atmo pCO2
clscolor   = [0.50 0.70 0.20;
              0.90 0.70 0.20;
              0.70 0.40 0.80];             % color of regime clusters
