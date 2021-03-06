%%%  ylf in USYD  2016.10.1
%%%  对Applied energy文章修改，验证机组处理上下界约束更好了。
function H_ADMM(pathAndFilename)

%%
clc
% build data for UC
% pathAndFilename='UC_AF/10_std.mod';
pathAndFilename='UC_AF/50_0_1_w.mod';
time = 1;   t_time = 1;
dataUC = readdataUC(pathAndFilename);
dataUC = expend(dataUC, time, t_time);
% dataUC = sub_system(dataUC, 5, 4);

proj_dataUC = project(dataUC);
N = dataUC.N;
T = dataUC.T;


[proj_miqp_i, proj_miqp] = miqpUC(proj_dataUC);

% Use arrays to populate the model
cplex_miqp = Cplex('MIQP for UC');
cplex_miqp.Model.sense = 'minimize';
cplex_miqp.Model.obj   = proj_miqp.c_UC;  %%%%%
cplex_miqp.Model.Q = proj_miqp.Q_UC;
cplex_miqp.Model.lb    = proj_miqp.x_L;
cplex_miqp.Model.ub    = proj_miqp.x_U;
cplex_miqp.Model.A =   proj_miqp.A_all;
cplex_miqp.Model.lhs = proj_miqp.lhs_all;
cplex_miqp.Model.rhs = proj_miqp.rhs_all;
cplex_miqp.Model.ctype = proj_miqp.ctype;

% cplex_miqp.Param.mip.tolerances.mipgap.Cur = 1e-5;
cplex_miqp.Param.threads.Cur = 1;

% cplex_miqp.Param.preprocessing.aggregator.Cur = 0;
% cplex_miqp.Param.preprocessing.boundstrength.Cur = 0;
% cplex_miqp.Param.preprocessing.coeffreduce.Cur = 0;
% cplex_miqp.Param.preprocessing.dependency.Cur = 0;
% cplex_miqp.Param.preprocessing.dual.Cur = 0;
% cplex_miqp.Param.preprocessing.fill.Cur = 0;
% cplex_miqp.Param.preprocessing.linear.Cur = 0;
% cplex_miqp.Param.preprocessing.numpass.Cur = 0;
% cplex_miqp.Param.preprocessing.presolve.Cur = 0;
% cplex_miqp.Param.preprocessing.qcpduals.Cur = 0;
% cplex_miqp.Param.preprocessing.qpmakepsd.Cur = 0;
% cplex_miqp.Param.preprocessing.qtolin.Cur = 0;
% cplex_miqp.Param.preprocessing.reduce.Cur = 0;
% cplex_miqp.Param.preprocessing.relax.Cur = 0;
% cplex_miqp.Param.preprocessing.repeatpresolve.Cur = 0;
% cplex_miqp.Param.preprocessing.symmetry.Cur = 0;


% cplex_miqp.Param.mip.display.Cur = 4;

cplex_miqp.writeModel('myprob.lp');

cplex_miqp.solve();




end


