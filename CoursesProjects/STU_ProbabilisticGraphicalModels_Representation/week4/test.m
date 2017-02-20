%quiz 1
SimpleCalcExpectedUtility(FullI)

% quiz 2
E = [3,2];
Full2 = struct();
Full2.RandomFactors = ObserveEvidence(FullI.RandomFactors, E, 1);
Full2.DecisionFactors = ObserveEvidence(FullI.DecisionFactors, E, 1);
Full2.UtilityFactors = ObserveEvidence(FullI.UtilityFactors, E, 1);
SimpleCalcExpectedUtility(FullI)
SimpleCalcExpectedUtility(Full2)


% quiz 3
Testl1 = TestI0;
Testl2 = TestI0;
Testl3 = TestI0;
[meu0 optdr0] = OptimizeWithJointUtility(TestI0);




sensitivity = 0.999; special = 0.75;
sensitivity = 0.75; special = 0.999;
sensitivity = 0.999; special = 0.999;

% new_factor = struct();
% new_factor.var = [11,1];
% new_factor.card = [2,2];
new_factorval = [special,1-special,1-sensitivity,sensitivity];

Testl1.RandomFactors(10).val = new_factorval;
Testl1.DecisionFactors = struct();
Testl1.DecisionFactors(1).var = [9,11];
Testl1.DecisionFactors(1).card = [2,2];
Testl1.DecisionFactors(1).val = [0 0 0 0 ];
[meu1 optdr1] = OptimizeWithJointUtility(Testl1);


Testl2.RandomFactors(10).val = new_factorval;
Testl2.DecisionFactors = struct();
Testl2.DecisionFactors(1).var = [9,11];
Testl2.DecisionFactors(1).card = [2,2];
Testl2.DecisionFactors(1).val = [0 0 0 0];
[meu2 optdr2] = OptimizeWithJointUtility(Testl2);

Testl3.RandomFactors(10).val = new_factorval;
Testl3.DecisionFactors = struct();
Testl3.DecisionFactors(1).var = [9,11];
Testl3.DecisionFactors(1).card = [2,2];
Testl3.DecisionFactors(1).val = [0 0 0 0];
[meu3 optdr3] = OptimizeWithJointUtility(Testl3);

VPI1 = meu1-meu0
VPI2 = meu2-meu0
VPI3 = meu3-meu0

f = @(x) exp(x/100)-1;
f(VPI1)
f(VPI2)
f(VPI3)
