% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeWithJointUtility( I )
  % Inputs: An influence diagram I with a single decision node and one or more utility nodes.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  % You may assume that there is a unique optimal decision.
    
  % This is similar to OptimizeMEU except that we must find a way to 
  % combine the multiple utility factors.  Note: This can be done with very
  % little code.
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % combine the multiple utility factors
  size_utility = length(I.UtilityFactors);
  if size_utility>1
      factors_sum = FactorSum(I.UtilityFactors(1), I.UtilityFactors(2));
      for i=3:size_utility
          factors_sum = FactorSum(factors_sum, I.UtilityFactors(i));
      end
      I.UtilityFactors = factors_sum;
  end
  
  % OptimizaMEU
  [MEU OptimalDecisionRule] = OptimizeMEU(I);
  
end
