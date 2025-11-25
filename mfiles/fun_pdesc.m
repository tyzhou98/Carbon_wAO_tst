function pdesc = fun_pdesc(pval)

% display pval in different categories
% Usage:
%   pdesc = fun_pdesc(pval)
% Input:
%   pval   a numerical p-value
% Output:
%   pdesc  string that contains p-value description
%
%                 Yun Li, UDel, 11/13/2025

pdesc = num2str(pval,'=%.2f');
if     pval<0.001;  pdesc = '<0.001'; 
elseif pval<0.01 ;  pdesc = '<0.01' ; 
elseif pval<0.05 ;  pdesc = '<0.05' ; end
return;

