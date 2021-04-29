# 训练主程序
from alg import DDQN_hard
# from alg import DQN
from alg import buffer
import gym
import numpy as np
import math
import time
import matplotlib.pyplot as plt
import os
from sklearn.metrics import mean_squared_error # 性能指标

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
MAX_STEPS = 10000 # 仿真1s,0.3s,0.7s时跳变
MAX_BUFFER = 200000
LR = 0.001
BATCH_SIZE = 256
GAMMA = 0.9
DATE = '3-20'

################################## 超参 #####################################

# 定义几个仿真中用的方法
def plot_v(): # 训练过程中画输出电压的图,粗画看个趋势即可
    total_v = []
    total_d = []
    total_a = {}  # 观察整体动作分布
    ep_r = 0
    s = env.reset()
    for step in range(MAX_STEPS):
        s = np.float32(s)
        total_v.append(s[0])
        a = trainer.get_exploitation_action(s) # 选确定动作
        total_a[a] = total_a.get(a, 0) + 1 # 统计动作选择分布
        D = action_list[a]
        total_d.append(D)

        print('占空比: ', D)
        s_, r  = env.step(D)

        s = s_
        ep_r += r

        if step == MAX_STEPS - 1:
            print('saved model reward: %.2f' % ep_r)

            break
    print(total_a)
    X = np.linspace(0, 1, 10000)
    plt.figure()
    plt.plot(X, total_v)
    plt.title('V change--saved model' )
    plt.savefig("./demo.png", format="png", dpi=1000)       # 先save在show

    plt.show()


    plt.figure()
    plt.plot(total_d)
    plt.title('duty--saved model')
    plt.show()

    plt.figure()
    plt.bar(total_a.keys(), total_a.values()) # 画个柱状图
    plt.title('action_choosed')
    plt.show()

    # 计算MSE作为评价指标
    MSE = mean_squared_error([170]*len(total_v), total_v)
    print('该模型MSE为: ', MSE)



S_DIM = env.observation_space.shape[0]
A_DIM = env.action_space.n
action_list = np.linspace(0.23, 0.47, A_DIM)
# 右边两个没用到过

print(' Env: ', ENV)
print(' State Dimension: ', S_DIM)
print(' Number of Action(discrete) : ', A_DIM)


ram = buffer.ReplayBuffer(MAX_BUFFER)

trainer = DDQN_hard.Trainer(S_DIM, A_DIM, ram, learning_rate=LR, batch_size=BATCH_SIZE, reward_decay=GAMMA) # 11.16

trainer.load_models(episode=19, env=ENV, lr=LR, gamma=GAMMA, batch_size=BATCH_SIZE, date=DATE)


if __name__ == '__main__':
    plot_v()

del gym.envs.registry.env_specs[ENV] # 删除环境

