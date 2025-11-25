function [X,Y]=fun_lglt2xy_arc(LON,LAT,XLON)
% Returns vectors of X and Y from latitudes and longitudes 
% (as distance in km from north pole). using XLON as positive
% x-axis, and XLON+90 as y-axis.
%
% Usage:
%    [X,Y]=fun_lglt2xy_arc(LON,LAT)
% Input:
%   LON    longitude (degree)
%   LAT    latitude (degree)
%   XLON   defined longitude of positive x-dir (degree)
% Output:
%   X      distance (unit:km) from the north pole, positive in XLON dir
%   Y      distance (unit:km) from the north pole, positive in XLON+90deg dir
%
% Original from G. Gao., and developed by H. Song
% modified by Yun Li, UDEL, Mar-24-2025

%###############
%## constants ##
%###############
r = 6.371E+3;     % earth radius [unit: km]
DEG_2_RAD = .017453292519943;  % degree to radian
RAD_2_DEG = 57.2957795130823;  % radian to degree

%############################################
%## determine the arc length to North Pole ##
%############################################
MAP_FACTOR = 2.0./(1.+1.*sin(LAT.*DEG_2_RAD));
RHO = r .* MAP_FACTOR .* cos(LAT.*DEG_2_RAD);

%######################################
%## Project to x- and y-dir distance ##
%######################################
%  XLON as x-axis, XLON+90 as y-axis
%
%                 0 degE
%         LON  __  /|\
%             |\    |
%               \   |
%                \  |
%                 \ |
%    XLON <---------@
%              North Pole
%
%    angle(LON_wrt_XLON)
%  = angle(LON_wrt_0deg) + angle(0deg_wrt_XLON)
%  = angle(LON_wrt_0deg) - angle(XLON_wrt_0deg)
%  = LON - XLON
%
Y = RHO .* sin((LON-XLON).*DEG_2_RAD);
X = RHO .* cos((LON-XLON).*DEG_2_RAD);
