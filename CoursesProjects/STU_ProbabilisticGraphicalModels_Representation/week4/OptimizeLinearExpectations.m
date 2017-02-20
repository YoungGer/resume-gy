% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeLinearExpectations( I )
  % Inputs: An influence diagram I with a single decision node and one or more utility nodes.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  % You may assume that there is a unique optimal decision.
  %
  % This is similar to OptimizeMEU except that we will have to account for
  % multiple utility factors.  We will do this by calculating the expected
  % utility factors and combining them, then optimizing with respect to that
  % combined expected utility factor.  
  MEU = [];
  OptimalDecisionRule = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  % A decision rule for D assigns, for each joint assignment to D's parents, 
  % probability 1 to the best option from the EUF for that joint assignment 
  % to D's parents, and 0 otherwise.  Note that when D has no parents, it is
  % a degenerate case we can handle separately for convenience.
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
  %  the maximum expected utility of I and an optimal decision rule
  utility_lists = I.UtilityFactors;
  if length(utility_lists)==1
      [MEU OptimalDecisionRule] = OptimizeMEU( I )
  else
      [MEU OptimalDecisionRule] = OptimizeWithJointUtility( I );
%       % each utility has its own euf function
%       I_copy = I;
%       I_copy.UtilityFactors = utility_lists(1);
%       euf_reduce = CalculateExpectedUtilityFactor(I_copy);
%       euf_reduce.val = zeros(1,length(euf_reduce.val));
%       for i=1:length(utility_lists)
%           I_copy = I;
%           I_copy.UtilityFactors = utility_lists(i);
%           euf = CalculateExpectedUtilityFactor(I_copy);
%           euf_reduce.val = euf_reduce.val + euf.val;
%       end
%       % ordinary
%       euf = euf_reduce;  % substitude
%       decision_rule = zeros(1,length(euf.val));
%       stack_num = length(euf.val)/euf.card(1);
%       for stack_i=1:stack_num
%           row_start_index =  euf.card(1)*(stack_i-1)+1;
%           row_end_index = euf.card(1)*stack_i;
%           [C,INDEX]  = max(euf.val(row_start_index:row_end_index));
%           decision_rule(INDEX+row_start_index-1) = 1;
%       end
%       I.DecisionFactors.val = decision_rule;
%       EU = SimpleCalcExpectedUtility(I);
%       % return
%       MEU = EU;
%       OptimalDecisionRule = I.DecisionFactors;
%       
%   end
 
end
