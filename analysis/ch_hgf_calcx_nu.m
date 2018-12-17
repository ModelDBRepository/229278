function [data_structure] = ch_hgf_calcx_nu(data_structure)

tp = data_structure.behavioral.hgf_nu.est.u(:,2);

mu1hat = data_structure.behavioral.hgf_nu.est.traj.muhat(:,1);

% Calculate belief x using Bayes' theorem
x = tp.*mu1hat./(tp.*mu1hat + (1-mu1hat).^2);

% Belief is mu1hat in trials where there is no tone
x(find(tp==0)) = mu1hat(find(tp==0));

data_structure.behavioral.hgf_nu.x = x;



data_structure.behavioral.summary.hgf_nu.x = mean(reshape(data_structure.behavioral.hgf_nu.x,30,12),1);



end