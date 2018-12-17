function [data_structure] =  ch_hgf_analysis_nu2(data_structure)

for sess = 1:size(data_structure.behavioral.raw.auditory_train_test,2)
    
y2 = nansum([data_structure.behavioral.summary.accuracy.train_test(sess).test0( : ), data_structure.behavioral.summary.accuracy.train_test(sess).test25( : ), data_structure.behavioral.summary.accuracy.train_test(sess).test50( : ), data_structure.behavioral.summary.accuracy.train_test(sess).test75( : )],2);
y1 = y2;
y1(isnan(y2))=0;

inputs = data_structure.behavioral.summary.train_test_conditions_non_nan( : ).*0.01;  %  To translate 75, 50, etc to 0-to-1 range.
data_structure.behavioral.hgf_nu2(sess).est = tapas_fitModel(y2, [y1,inputs],  'tapas_hgf_binary_config_startpoints', 'tapas_condhalluc_obs2_config');
% tapas_hgf_binary_condhalluc_plotTraj(data_structure.behavioral.hgf_nu2.est)

%  data_structure.behavioral.hgf.est.traj.muhat(:,2) gives trajectory of
%  plots:  first column x1, second x2, third x3.

for ii = 1:3
    data_structure.behavioral.summary.hgf_nu2(sess).traj(ii,:) = mean(reshape(data_structure.behavioral.hgf_nu2(sess).est.traj.muhat(:,ii),30,12),1);
end

end

[data_structure] = ch_hgf_calcx_nu2(data_structure);



end