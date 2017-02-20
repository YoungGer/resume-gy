% part1
p1 = ComputeSingletonFactors(Part1SampleImagesInput,imageModel);

% part2
ComputeWordPredictions 
ScorePredictions 
 
imageModel.ignoreSimilarity = true; 
factors = BuildOCRNetwork(allWords{i}, imageModel, [], tripletList);

[charAcc, wordAcc] = ScoreModel(allWords, imageModel, [], []);

p2 = ComputeEqualPairwiseFactors (Part2SampleImagesInput, 26);
p2 = ComputePairwiseFactors (Part2SampleImagesInput, pairwiseModel, 26);

% part3
p3 = ComputeTripletFactors(Part3SampleImagesInput ,tripletList, 26);

% part4
p4 = ComputeSimilarityFactor(Part4SampleImagesInput, 26, 1, 2);

% part5
p5 = ComputeAllSimilarityFactors (Part5SampleImagesInput, 26);

% part6
p6 = ChooseTopSimilarityFactors(Part6SampleFactorsInput,2);

