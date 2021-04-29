function action1 = evaluatePolicy(observation1)
%#codegen

% Reinforcement Learning Toolbox
% Generated on: 17-Mar-2021 14:32:00

actionSet = [0.4;0.41;0.42;0.43;0.44;0.45;0.46;0.47;0.48;0.49;0.5;0.51;0.52;0.53;0.54;0.55;0.56;0.57;0.58;0.59;0.6];
q = localEvaluate(observation1);
[~,actionIndex] = max(q);
action1 = actionSet(actionIndex);
end
%% Local Functions
function q = localEvaluate(observation1)
persistent policy
if isempty(policy)
	policy = coder.loadDeepLearningNetwork('agentData.mat','policy');
end
q = predict(policy, observation1);
end