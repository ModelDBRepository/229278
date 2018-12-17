function [data] = ch_hgf_sim_nu(data)

% Data variable is data structure with est structure from initial hgf
% calculation stored in data.behavioral.hgf_startpoints.est.
conditions = data.behavioral.summary.train_test_conditions( : );
observed_responses = data.behavioral.hgf_nu.est.y;

for i = 1:10000
    inputs = data.behavioral.summary.train_test_conditions_non_nan( : ).*0.01;
    y2 = nansum([data.behavioral.summary.accuracy.train_test.test0( : ), data.behavioral.summary.accuracy.train_test.test25( : ), data.behavioral.summary.accuracy.train_test.test50( : ), data.behavioral.summary.accuracy.train_test.test75( : )],2);
    y1 = y2;
    y1(isnan(y2))=0;
    
    % Use same configuration as ch_hgf_analysis_nu, which created
    % these models in the first place.  Also note: tapas_hgf_binary_config
    % was altered to reflect new priors and loosened assumptions regarding
    % startpoints that were used to create these models. Also,
    % tapas_condhalluc_obs2 is used to reflect nu, a parameter meant to
    % capture a priori tendency toward priors or sensory evidence.
    sim = tapas_simModel([y2, [y1,inputs]], 'tapas_hgf_binary', data.behavioral.hgf_nu.est.p_prc.p, 'tapas_condhalluc_obs2', data.behavioral.hgf_nu.est.p_obs.be);
    
    sim_struct.raw(i) = sim;
    
    responses = sim.y;
    
    
    % Create percentages of simulated "yes" responses for each trial type.
    yes_75 = nanmean(responses(conditions==75));
    yes_50 = nanmean(responses(conditions==50));
    yes_25 = nanmean(responses(conditions==25));
    yes_0 = nanmean(responses(conditions==0));
    
    sim_struct.summary.raw.percent_responses(1:4,i) = [yes_0; yes_25; yes_50; yes_75];
    
    % Create measures of how well simulated responses correspond to actual
    % responses:  both correlation and how identical each response is to its
    % real counterpart.
    
    sim_responses = sim.y;
    sim_struct.summary.raw.corr.percent_identical(1,i) = mean(observed_responses==sim_responses);
    [sim_struct.summary.raw.corr.correlation.rho(1,i), sim_struct.summary.raw.corr.correlation.p(1,i)] = corr(observed_responses(~isnan(observed_responses)),sim_responses(~isnan(observed_responses)));
    
end

    sim_struct.summary.summary.percent_responses = nanmean(sim_struct.summary.raw.percent_responses,2);
    
    sim_struct.summary.summary.corr.percent_identical = nanmean(sim_struct.summary.raw.corr.percent_identical);
    
    sim_struct.summary.summary.corr.correlation.rho = nanmean(sim_struct.summary.raw.corr.correlation.rho);
    sim_struct.summary.summary.corr.correlation.p = nanmean(sim_struct.summary.raw.corr.correlation.p);
    
    % Find the instance that best exemplifies the mean value and use it to
    % store full structure info.
    index = find(abs(sim_struct.summary.raw.corr.percent_identical-sim_struct.summary.summary.corr.percent_identical)==min(abs(sim_struct.summary.raw.corr.percent_identical-sim_struct.summary.summary.corr.percent_identical)), 1 );
    sim_struct.summary.raw.percent_responses = sim_struct.summary.raw.percent_responses(1:4,index);
    sim_struct.summary.raw.corr.percent_identical = sim_struct.summary.raw.corr.percent_identical(1,index);
    sim_struct.summary.raw.corr.correlation.rho  = sim_struct.summary.raw.corr.correlation.rho(1,index);
    sim_struct.raw = sim_struct.raw(index);
    
    data.behavioral.summary.hgf_nu.sim = sim_struct;
    
end



