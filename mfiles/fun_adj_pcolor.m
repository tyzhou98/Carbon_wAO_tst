function [cmap_adj,clims_adj,wrk_adj] = fun_adj_pcolor(cmap,clims,wrk,color1,color2)

% Usage: adjust the color scheme and working matrix for pcolor
%  - default land and ice color:
%      [cmap_adj,clims_adj,wrk_adj] = fun_adj_pcolor(cmap,clims,wrk)
%  - specify land and ice color:
%      [cmap_adj,clims_adj,wrk_adj] = fun_adj_pcolor(cmap,clims,wrk,color1,color2)
%
% Input:
%      cmap        original colormap
%      clims       original colorbar range
%      wrk         original working array or matrix for pcolor
%      color1      padded land color
%      color2      padded  ice color
% Output:
%      cmap_adj    adjusted colormap
%      clims_adj   adjusted colorbar range
%      wrk_adj     adjusted working array or matrix for pcolor
%

info_params;
% default color for land and ice
if nargin==3; color1 = color_land; color2 = color_ice; end
% adjust color scheme to append colors
dc = diff(clims)./length(cmap);
cmap_adj = [color1; cmap([1 1:end end],:); color2];
clims_adj = clims + [-2 2].*dc;
% adjust wrk
wrk_adj = wrk;
wrk_adj(wrk_adj<clims(1))=clims(1);
wrk_adj(wrk_adj>clims(2))=clims(2);
if length(wrk_adj(:))==NX*NY
  wrk_adj(isnan(wrk_adj)) = 9999;  % sea ice pixel
  wrk_adj(id0) = NaN;              % coastal pixel
  wrk_adj(idl) = -9999;            % land    pixel
end
