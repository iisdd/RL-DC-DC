%% 1.打开simulink文件,展开成环境

open_system('Env_cpl_i')
obsInfo = rlNumericSpec([4 1],...
    'LowerLimit',[-inf -inf -inf  -inf]',...
    'UpperLimit',[inf inf inf inf ]');
obsInfo.Name = 'observations';
obsInfo.Description = 'integrated error, error, and measured Vo';
numObservations = obsInfo.Dimension(1);

% actInfo = rlFiniteSetSpec([0.45,0.46,0.47,0.48,0.49,0.50,0.51,0.52,0.53,0.54,0.55]);
% actInfo = rlFiniteSetSpec([0.44 0.47 0.50 0.52 0.55])
actInfo = rlFiniteSetSpec([0.44 0.55])
% 正版是0.44 ~ 0.55
actInfo.Name = 'action';
numActions = 2;
% numActions = 5;

env = rlSimulinkEnv('Env_cpl_i','Env_cpl_i/RL Agent',...
    obsInfo,actInfo);
env.ResetFcn = @(in)localResetFcn(in);

Ts = 0.0001;
Tf = 0.7;           % 前0.4s:150W -> 后0.3s:250W
rng(0)


%% 2.搭建神经网络
dnn = [
    imageInputLayer([obsInfo.Dimension(1) 1 1],...
    'Normalization', 'none', 'Name', 'State')
    fullyConnectedLayer(4, 'Name', 'CriticStateFC1')
    reluLayer('Name', 'CriticRelu1')
    fullyConnectedLayer(4, 'Name', 'CriticStateFC2')
    reluLayer('Name','CriticCommonRelu')
    fullyConnectedLayer(numActions, 'Name', 'output')];

criticOptions = rlRepresentationOptions('LearnRate',1e-3,'GradientThreshold',1);

critic = rlQValueRepresentation(dnn,obsInfo,actInfo, ...
    'Observation',{'State'},'Action',{'output'},criticOptions);


%% 3.设置训练参数
agentOptions = rlDQNAgentOptions(...
    'SampleTime',Ts,...
    'UseDoubleDQN',true,... %     'TargetSmoothFactor',1e-3,...'TargetUpdateFrequency',500,...
    'ResetExperienceBufferBeforeTraining',true,...
    'DiscountFactor',0.9,...
    'ExperienceBufferLength',2e5,...
    'MiniBatchSize',256);
opt.EpsilonGreedyExploration.Epsilon = 1;
opt.EpsilonGreedyExploration.EpsilonDecay = 0.001;
opt.EpsilonGreedyExploration.EpsilonMin = 0.1;


agent = rlDQNAgent(critic,agentOptions);
maxepisodes = 200;
maxsteps = ceil(Tf/Ts);
trainOpts = rlTrainingOptions(...
    'MaxEpisodes',maxepisodes, ...
    'MaxStepsPerEpisode',maxsteps, ...
    'ScoreAveragingWindowLength',20, ...
    'Verbose', false, ...
    'Plots','training-progress',...
    'StopTrainingCriteria','EpisodeReward',...
    'StopTrainingValue',65000,...
    'SaveAgentCriteria','EpisodeReward',...
    'SaveAgentValue',65000);

%% 4.训练&加载模型
doTraining = true;
% doTraining = false;
if doTraining
    % Train the agent.
    trainingStats = train(agent,env,trainOpts);
    save('4_20.mat','agent');
end

if doTraining==false
    % Load pretrained agent for the example.
    load('4_20.mat','agent');
end
   

rlSimulationOptions('MaxSteps',maxsteps,'StopOnError','on');
experiences = sim(env,agent,rlSimulationOptions);

%% 5.reset部分,重置Vref
function in = localResetFcn(in)
blk = sprintf('Env_cpl_i/Desired Voltage');
V = 80;
while V <= 0 || V >= 300
   V = 80;
end
in = setBlockParameter(in,blk,'Value',num2str(V));

end
