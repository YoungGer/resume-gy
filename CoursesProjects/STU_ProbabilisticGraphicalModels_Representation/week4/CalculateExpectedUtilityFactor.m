% Copyright (C) Daphne Koller, Stanford University, 2012

function EUF = CalculateExpectedUtilityFactor( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: A factor over the scope of the decision rule D from I that
  % gives the conditional utility given each assignment for D.var
  %
  % Note - We assume I has a single decision node and utility node.
  EUF = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

  % Factor Product
  F = I.RandomFactors;
  if size(F,2)<2
      factors_product = F(1);
  else
      factors_product = FactorProduct(F(1), F(2));
      for i=3:size(F,2)
          factors_product = FactorProduct(factors_product, F(i));
      end
  end
  
  % Multi with utility
  factors_product = FactorProduct(factors_product, I.UtilityFactors);
  
  % Factor marginization and elimination
  Z1 = unique([factors_product.var]);
  Z2 = I.DecisionFactors.var;
  Z  = setdiff(Z1,Z2);
  EUF = VariableElimination(factors_product,[Z]);
  %EUF = NormalizeCPDFactors(factors_elimination);
  
  %EUF需要decision在前面
  old_euf = EUF;
  decision_var = I.DecisionFactors.var(1);
  decision_index_EUF = find(old_euf.var == decision_var);
  
  old_euf.var([decision_index_EUF]) = [];
  old_euf.card([decision_index_EUF]) = [];
  new_var = [decision_var,old_euf.var];
  new_card = [EUF.card(decision_index_EUF),old_euf.card];
  
  N = prod(new_card);
  new_assign = IndexToAssignment(1:N,new_card);
  map_new2old_assign = [];
  for i=1:length(EUF.var)
      curr_var = EUF.var(i);
      new_var_index = find(new_var==curr_var);
      map_new2old_assign = [map_new2old_assign,new_var_index];
  end
  old_assign = new_assign(:,map_new2old_assign);
  old_index = AssignmentToIndex(old_assign,EUF.card);
  
  new_val = EUF.val(old_index);
  
  EUF.var = new_var;
  EUF.card = new_card;
  EUF.val = new_val;
  
end  
