%% 1.打开simulink文件,展开成环境

open_system('Env_cpl')
obsInfo = rlNumericSpec([6 1],...
    'LowerLimit',[-inf -inf  -inf -inf -inf  -inf]',...
    'UpperLimit',[ inf  inf inf inf inf inf ]');
obsInfo.Name = 'observations';
obsInfo.Description = 'integrated error, error, and measured Vo';
numObservations = obsInfo.Dimension(1);

actInfo = rlFiniteSetSpec([0.40: 0.01: 0.60]);
actInfo.Name = 'action';
numActions = length(actInfo.Elements);

env = rlSimulinkEnv('Env_cpl','Env_cpl/RL Agent',...
    obsInfo,actInfo);
env.ResetFcn = @(in)localResetFcn(in);

Ts = 0.0001;
Tf = 0.4;       % 全程150W
% Tf = 0.7;           % 前0.4s:150W -> 后0.3s:250W
rng(0)


%% 2.搭建神经网络
dnn = [
    imageInputLayer([obsInfo.Dimension(1) 1 1],...
    'Normalization', 'none', 'Name', 'State')
    fullyConnectedLayer(64, 'Name', 'CriticStateFC1')
    reluLayer('Name', 'CriticRelu1')
    fullyConnectedLayer(64, 'Name', 'CriticStateFC2')
    reluLayer('Name','CriticCommonRelu')
    fullyConnectedLayer(numActions, 'Name', 'output')];

criticOptions = rlRepresentationOptions('LearnRate',1e-3,'GradientThreshold',1);

critic = rlQValueRepresentation(dnn,obsInfo,actInfo, ...
    'Observation',{'State'},'Action',{'output'},criticOptions);


%% 3.设置训练参数
agentOptions = rlDQNAgentOptions(...
    'SampleTime',Ts,...
    'UseDoubleDQN',true,...
    'TargetSmoothFactor',1e-3,... 'TargetUpdateFrequency',500,...     % 要显现出区别才好train
    'ResetExperienceBufferBeforeTraining',true,...
    'DiscountFactor',0.95,...
    'ExperienceBufferLength',2e5,...
    'MiniBatchSize',256);
opt.EpsilonGreedyExploration.Epsilon = 1;
opt.EpsilonGreedyExploration.EpsilonDecay = 0.001;
opt.EpsilonGreedyExploration.EpsilonMin = 0.1;


agent = rlDQNAgent(critic,agentOptions);
maxepisodes = 100;
maxsteps = ceil(Tf/Ts);
trainOpts = rlTrainingOptions(...
    'MaxEpisodes',maxepisodes, ...
    'MaxStepsPerEpisode',maxsteps, ...
    'ScoreAveragingWindowLength',20, ...
    'Verbose', false, ...
    'Plots','training-progress',...
    'StopTrainingCriteria','EpisodeReward',...
    'StopTrainingValue',35000,...
    'SaveAgentCriteria','EpisodeReward',...
    'SaveAgentValue',35000);

%% 4.训练&加载模型
doTraining = true;
% doTraining = false;
if doTraining
    % Train the agent.
    trainingStats = train(agent,env,trainOpts);
    save('150W_4_21.mat','agent');
end

if doTraining==false
    % Load pretrained agent for the example.
    load('150W_4_21.mat','agent');
end
   

rlSimulationOptions('MaxSteps',maxsteps,'StopOnError','on');
experiences = sim(env,agent,rlSimulationOptions);

%% 5.reset部分,重置Vref
function in = localResetFcn(in)
blk = sprintf('Env_cpl/Desired Voltage');
V = 80;
while V <= 0 || V >= 200
   V =  80;
end
in = setBlockParameter(in,blk,'Value',num2str(V));

end
