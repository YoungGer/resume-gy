% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeMEU( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  
  % We assume I has a single decision node.
  % You may assume that there is a unique optimal decision.
  D = I.DecisionFactors(1);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  % 
  % Some other information that might be useful for some implementations
  % (note that there are multiple ways to implement this):
  % 1.  It is probably easiest to think of two cases - D has parents and D 
  %     has no parents.
  % 2.  You may find the Matlab/Octave function setdiff useful.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
  
  %  the maximum expected utility of I and an optimal decision rule
  euf = CalculateExpectedUtilityFactor(I);
  
  if length(euf.var)==1
      % D has no parents
          I.DecisionFactors.val = zeros(1,length(euf.val));
          [C,INDEX]  = max(euf.val);
          I.DecisionFactors.val(INDEX) = 1;
          EU = SimpleCalcExpectedUtility(I);
          % return
          MEU = EU;
          OptimalDecisionRule = I.DecisionFactors;
  else
      % D has parents
%   assignMat = IndexToAssignment(1:prod([3,2,2]),[3,2,2]);
%   assignMat = IndexToAssignment(1:prod(euf.card),euf.card);
%   assignMat_val = [assignMat,euf.val];
  
      decision_rule = zeros(1,length(euf.val));
      stack_num = length(euf.val)/euf.card(1);
      for stack_i=1:stack_num
          row_start_index =  euf.card(1)*(stack_i-1)+1;
          row_end_index = euf.card(1)*stack_i;
          [C,INDEX]  = max(euf.val(row_start_index:row_end_index));
          decision_rule(INDEX+row_start_index-1) = 1;
      end
      I.DecisionFactors.val = decision_rule;
      EU = SimpleCalcExpectedUtility(I);
      % return
      MEU = EU;
      OptimalDecisionRule = I.DecisionFactors;

  end

    

end
