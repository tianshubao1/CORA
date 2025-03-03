function res = test_ellipsoid_cartProd
% test_ellipsoid_cartProd - unit test function of cartProd
%
% Syntax:  
%    res = test_ellipsoid_cartProd
%
% Inputs:
%    -
%
% Outputs:
%    res - boolean 
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: -

% Author:       Victor Gassmann
% Written:      26-July-2021
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------
res = true;
load cases.mat E_c
for i=1:length(E_c)
    E1 = E_c{i}.E1; % non-deg
    E2 = E_c{i}.E2; % non-deg
    Ed1 = E_c{i}.Ed1; % deg
    E0 = E_c{i}.E0; % all zero
    
    % test non-deg
    Eres_nd = cartProd(E1,E2);
    Y_nd = combineVec(randPoint(E1,2*i),randPoint(E2,2*i));
    if ~in(Eres_nd,Y_nd)
        res = false;
        break;
    end
    
    % test deg
    Eres_d = cartProd(E1,Ed1);
    Y_d = combineVec(randPoint(E1,2*i),randPoint(Ed1,2*i));
    if ~in(Eres_d,Y_d)
        res = false;
        break;
    end
    
    % test zero rank ellipsoid
    Eres_0 = cartProd(E1,E0);
    Y_0 = combineVec(randPoint(E1,2*i),randPoint(E0,2*i));
    if ~in(Eres_0,Y_0)
        res = false;
        break;
    end
    
    
end


if res
    disp([mfilename,' successful']);
else
    disp([mfilename,' failed']);
end
%------------- END OF CODE --------------
