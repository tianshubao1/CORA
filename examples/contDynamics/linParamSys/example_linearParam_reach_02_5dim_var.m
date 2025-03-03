function completed = example_linearParam_reach_02_5dim_var()
% example_linearParam_reach_02_5dim_var - example of linear parametric 
%                                         reachability analysis with 
%                                         time-varying
%
% This example is taken from [1]. 
%
% Syntax:  
%    completed - example_linearParam_reach_02_5dim_var()
%
% Inputs:
%    none
%
% Outputs:
%    completed - boolean 
%
% References:
%    [1] Althoff, M.; Le Guernic, C. & Krogh, B. H. "Reachable Set
%        Computation for Uncertain Time-Varying Linear Systems", HSCC 2011
% 
% Author:       Matthias Althoff
% Written:      03-October-2017
% Last update:  23-April-2020 (restructure params/options)
% Last revision:---

%------------- BEGIN CODE --------------


% Parameter ---------------------------------------------------------------

dim_x = 5;
params.tFinal = 5;
params.R0 = zonotope([ones(dim_x,1),0.1*eye(dim_x)]);   % initial set
params.U = zonotope([zeros(dim_x,1),0.1*eye(dim_x)]);   % uncertain inputs


% Reachability Settings ---------------------------------------------------

options.timeStep = 0.05;
options.taylorTerms = 4;
options.intermediateTerms = 2;
options.zonotopeOrder = 20;


% System Dynamics ---------------------------------------------------------

Acenter = [-1 -4 0 0 0; 4 -1 0 0 0; 0 0 -3 1 0; 0 0 -1 -3 0; 0 0 0 0 -2];
Arad{1} = [0.1 0.1 0 0 0; 0.1 0.1 0 0 0; 0 0 0.1 0.1 0; 0 0 0.1 0.1 0; 0 0 0 0 0.1];
matZ_A = matZonotope(Acenter,Arad);
matI_A = intervalMatrix(matZ_A);

sys_zono = linParamSys(matZ_A, 1, 'varParam'); 
sys_int  = linParamSys(matI_A, 1, 'varParam');


% Reachability Analysis ---------------------------------------------------

% compute reachable set using matrix zonotopes
tic
Rzono = reach(sys_zono, params, options);
tComp = toc;
disp(['computation time of reachable set for zonotopic matrix: ',num2str(tComp)]);

% compute reachable set using interval matrices
tic
Rint = reach(sys_int, params, options);
tComp = toc;
disp(['computation time of reachable set for interval matrix: ',num2str(tComp)]);


% Simulation --------------------------------------------------------------

simOpt.points = 60;
simOpt.fracVert = 0.5;
simOpt.fracInpVert = 0.5;
simOpt.inpChanges = 6;

simRes = simulateRandom(sys_zono, params, simOpt);


% Visualization -----------------------------------------------------------

dims = {[2 3],[4 5]};

% plot different projections
for k = 1:length(dims)
    
    figure; hold on;
    projDims = dims{k};
    
    % plot reachable sets
    hanInt = plot(Rint,projDims,'FaceColor',[.6 .6 .6],'EdgeColor','none');
    hanZono = plot(Rzono,projDims,'FaceColor',[.8 .8 .8],'EdgeColor','none');
    
    % plot initial set
    plot(params.R0,projDims,'w-','lineWidth',2);
    
    % plot simulation results      
    plot(simRes,projDims);

    % label plot
    xlabel(['x_{',num2str(projDims(1)),'}']);
    ylabel(['x_{',num2str(projDims(2)),'}']);
    legend([hanInt,hanZono],'Interval matrix','Matrix zonotopes');
end

% example completed
completed = 1;

%------------- END OF CODE --------------