function hh = set_wAO_map(islontick,islattick)
% add a map frame of the western AO
% Usage:
%   hh = set_wAO_map(islontick,islattick)
% Input:
%   islontick    0 = turn off longitude ticks, otherwise = turn on
%   islattick    0 = turn off latitude ticks, otherwise = turn on
% Output:
%   hh           handles of figure objects, including
%   |- hp        handle of the land patch
%   |- hf        handle of frame lines
%   |- hlg, hlt  handle of longitude, latitude contours
%   |- tlg, tlt  handle of longitude, latitude tick labels 
%
%                        Yun Li, UDel, 04/09/2025

info_params;
fsize = 6;
% map frame and contours
mfram.reflon = pltlon;
mfram.latc = [lat_str  lat_end*ones(1,51)  lat_str*ones(1,51)];
mfram.lonc = [lon_str linspace(lon_str,lon_end,51) linspace(lon_end,lon_str,51)];
[mfram.latg,mfram.long] = meshgrid([latticks lat_end],[lon_str lonticks lon_end]);
[mfram.xc,mfram.yc] = fun_lglt2xy_arc(mfram.lonc,mfram.latc,pltlon);
[mfram.xg,mfram.yg] = fun_lglt2xy_arc(mfram.long,mfram.latg,pltlon);

% add a patch to the southeast corner
id = find(mfram.xc>266 & mfram.yc<-2200);
hh.hp = patch([906 mfram.xc(id) 906],[-2200 mfram.yc(id) -2200],'m');
set(hh.hp,'facecolor',color_land,'edgecolor','none');

% add a map frame
hh.hf  = plot(mfram.xc ,mfram.yc ,'-','color',[1 1 1]*0.75,'linewidth',1.2);

% add latitude and longtitude grid lines
hh.hlt = plot(mfram.xg(:,2:end-1) ,mfram.yg(:,2:end-1) ,'--');
hh.hlg = plot(mfram.xg(2:end-1,:)',mfram.yg(2:end-1,:)','--');
set([hh.hlt;hh.hlg],'color',color_mesh,'linewidth',0.5);

% add latitude ticklabels
if islattick
  mrot = angle(complex(diff(mfram.xc([1 2])),diff(mfram.yc([1 2])) ))./pi*180-90;
  for k = 1:length(latticks);
    mtxt{k} = [num2str(latticks(k),'%2.0f'),'\circN'];
    [xx(k),yy(k)] = fun_lglt2xy_arc(lon_str-(lon_end-lon_str)./30, latticks(k),pltlon);
  end
  hh.tlt = text(xx,yy,mtxt,'fontsize',fsize,'hori','right','vert','mid','rotation',mrot);
end

% add longitude ticklabels
if islontick
  for k = 1:length(lonticks);
    mrot = angle(complex(diff(mfram.xg(k+1,[1 2])),diff(mfram.yg(k+1,[1 2])) ))./pi*180-90;
    mtxt = [num2str(360-lonticks(k),'%2.0f'),'\circW'];
    [xx,yy] = fun_lglt2xy_arc(lonticks(k),lat_str-(lat_end-lat_str)./50,pltlon);
    hh.tlg(k) = text(xx,yy,mtxt,'fontsize',fsize,'hori','cen','vert','top','rotation',mrot);
  end
  hh.tlg=hh.tlg(:);
end
return;
