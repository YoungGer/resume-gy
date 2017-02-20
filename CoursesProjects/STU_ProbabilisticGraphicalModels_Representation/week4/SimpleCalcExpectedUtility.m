% Copyright (C) Daphne Koller, Stanford University, 2012

function EU = SimpleCalcExpectedUtility(I)

  % Inputs: An influence diagram, I (as described in the writeup).
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return Value: the expected utility of I
  % Given a fully instantiated influence diagram with a single utility node and decision node,
  % calculate and return the expected utility.  Note - assumes that the decision rule for the 
  % decision node is fully assigned.

  % In this function, we assume there is only one utility node.
  F = [I.RandomFactors I.DecisionFactors];
  U = I.UtilityFactors(1);
  EU = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % effective CPD
  I.RandomFactors = NormalizeCPDFactors(I.RandomFactors);
  I.DecisionFactors = NormalizeCPDFactors(I.DecisionFactors);
  
  
  % Factor Product
  factors_product = FactorProduct(F(1), F(2));
  for i=3:size(F,2)
      factors_product = FactorProduct(factors_product, F(i));
  end
  
  % Factor marginization and elimination
  Z1 = unique([F.var]);
  Z2 = U.var;
  Z  = setdiff(Z1,Z2);
  factors_elimination = VariableElimination(factors_product,[Z]);
  %factors_elimination = NormalizeCPDFactors(factors_elimination);
 
  % problem
  % factors_elimination的var和U的var是否对应的上
  
  EU = VectorConvert(factors_elimination,U);

  
%   N = length(U.val);
%   old_assignment = IndexToAssignment(1:N, U.card);
%   new_index = AssignmentToIndex()
%   
%   EU = sum(factors_elimination.val .* U.val);

  
end
