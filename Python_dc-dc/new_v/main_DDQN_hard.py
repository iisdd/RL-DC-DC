# 01-05: 增量型占空比

from alg import DDQN_hard
from alg import buffer
import gym
import numpy as np
import math
import time
import matplotlib.pyplot as plt
import os


import gc # 清理内存的
from gym.envs.registration import register
from env.boost_env import BoostEnv

# 创建环境
ENV = "boost-v0" # 没有-v0会报错

config = {
    'time_step': 0.0001,
}
register(
    id=ENV,
    entry_point='env.boost_env:BoostEnv',  # env文件夹里的一个叫BuckEnv的类(在buck_env.py里)
    kwargs=config
)

env = gym.make(ENV) # 最后要删掉这个环境

################################## 超参 #####################################
MAX_EPISODES = 101 # 训练的eps数
MAX_STEPS = 10000 # 仿真1s, 0.3s,0.7s时跳变
MAX_BUFFER = 200000
LR = 0.001
BATCH_SIZE = 256
GAMMA = 0.9
REPLACE = 100
DATE = '3-20' # 日期在这改,保存模型用的
################################## 超参 #####################################
S_DIM = env.observation_space.shape[0]
A_DIM = env.action_space.n

action_list = np.linspace(0.23, 0.47, A_DIM)

print(' Env: ', ENV)
print(' State Dimension: ', S_DIM)
print(' Number of Action(discrete) : ', A_DIM)


ram = buffer.ReplayBuffer(MAX_BUFFER)
trainer = DDQN_hard.Trainer(S_DIM, A_DIM, ram, learning_rate=LR, batch_size=BATCH_SIZE, reward_decay=GAMMA, replace=100)

# 定义几个训练中用的方法
def plot_v(ep): # 训练过程中画输出电压的图,粗画看个趋势即可
    total_v = []
    s = env.reset()
    for step in range(MAX_STEPS):
        s = np.float32(s)
        total_v.append(s[0])
        a = trainer.get_exploitation_action(s) # 选确定动作
        D = action_list[a]
        print('占空比: ', D)
        s_, r  = env.step(D)
        s = s_

    plt.figure()
    plt.plot(total_v)
    plt.title('v_load--ep:%d' %ep)
    plt.show()

def plot_r(ep): # 训练中画total_reward的变化图,及时止损
    plt.figure()
    plt.plot(total_reward)
    plt.title('reward--ep:%d' % ep)
    plt.show()


# 训练部分
total_reward = []
best_r = 80000
for ep in range(1, MAX_EPISODES):
    ep_r = 0
    s = env.reset()
    for step in range(MAX_STEPS):
        s = np.float32(s)
        a = trainer.get_exploration_action(s)
        D = action_list[a]
        print('占空比: ', D)
        s_, r  = env.step(D)

        ram.add(s, a, r, s_)

        s = s_
        ep_r += r
        trainer.optimize()
        if step == MAX_STEPS - 1:
            if ep_r < 80000:
                ep_r = 80000                # 画图太难看了
            total_reward.append(ep_r-80000)
            break

    gc.collect() # 清内存
    if ep_r > best_r: # 有进步就保存模型,起点是0
        best_r = ep_r
        trainer.save_models(episode=ep, env=ENV, lr=LR, gamma=GAMMA, batch_size=BATCH_SIZE, date=DATE)
    if ep_r > 98000:    # ep_r训练终止条件
        break

    if ep % 20 == 0: # 每20个eps画个电压图
        plot_v(ep)
        plot_r(ep)




print('training completed')


plt.plot(total_reward)
plt.show()
print('后10个eps的reward平均值: ', np.mean(total_reward[-10: ]))


del gym.envs.registry.env_specs[ENV] # 删除环境

