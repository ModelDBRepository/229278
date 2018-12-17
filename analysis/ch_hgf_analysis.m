function [data_structure] =  ch_hgf_analysis(data_structure)

y2 = nansum([data_structure.behavioral.summary.accuracy.train_test.test0( : ), data_structure.behavioral.summary.accuracy.train_test.test25( : ), data_structure.behavioral.summary.accuracy.train_test.test50( : ), data_structure.behavioral.summary.accuracy.train_test.test75( : )],2);
y1 = y2;
y1(isnan(y2))=0;

inputs = data_structure.behavioral.summary.train_test_conditions_non_nan( : ).*0.01;  %  To translate 75, 50, etc to 0-to-1 range.
data_structure.behavioral.hgf.est = tapas_fitModel(y2, [y1,inputs],  'tapas_hgf_binary_config', 'tapas_condhalluc_obs_config');
tapas_hgf_binary_condhalluc_plotTraj(data_structure.behavioral.hgf.est)

%  data_structure.behavioral.hgf.est.traj.muhat(:,2) gives trajectory of
%  plots:  first column x1, second x2, third x3.

for ii = 1:3
    data_structure.behavioral.summary.hgf.traj(ii,:) = mean(reshape(data_structure.behavioral.hgf.est.traj.muhat(:,ii),30,12),1);
end

end