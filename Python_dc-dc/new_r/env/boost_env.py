"""
    01-03: 改回6个状态
"""
import numpy as np
from gym import spaces
import gym
from pyfmi import load_fmu

class BoostEnv(gym.Env): # 继承gym的环境类,否则会报错
    def __init__(self, time_step):
        # 加载模型
        self.model = load_fmu("./fmu/new_r.fmu", kind="CS")
        self.model.reset()
        self.model.setup_experiment(start_time=0)
        self.model.initialize()

        self.dt = time_step # time_step
        self.start = 0 # 仿真开始时间
        self.stop = self.dt # 仿真结束时间

        self.action_space = spaces.Discrete(29)  # 动作个数, 分成多少份
        # self.action_space = spaces.Box(np.array([-np.inf]), np.array([np.inf]), dtype=np.float32) # 连续动作

        #     s = (v0 , v0_delay , dv0 , e , e_delay , de)
        #     母线电压: v0
        #     母线电压延迟信号: v0_delay
        #     母线电压跟踪误差: e = v0 - Vref

        high = np.array([np.inf , np.inf , np.inf ,  np.inf , np.inf , np.inf])
        low = np.array([0 , 0 , -np.inf , -np.inf , -np.inf , -np.inf])
        self.observation_space = spaces.Box(low, high, dtype=np.float32)

        # 初始化状态
        ##################### 初始化一下state #####################
        self.v0 = 170                   # 输出电压
        self.v0_delay = 170             # 上一时刻的输出电压
        self.dv0 = 0                    # 输出电压的差分
        self.e = 0                      # 跟踪误差
        self.e_delay = 0                # 上一时刻跟踪误差
        self.de = 0                     # 跟踪误差的差分
        # self.e_accum = 0                # 累积误差(积分)
        self.state = [self.v0, self.v0_delay, self.dv0,  self.e, self.e_delay, self.de]
        ##################### 初始化一下state #####################


    def reset(self): # 重置状态: s = (e, e_delay, e_accum) = [170, 0, 0, 0]
        self.model = load_fmu("./fmu/new_r.fmu", kind="CS")
        self.model.reset()
        self.model.setup_experiment(start_time=0)
        self.model.initialize()
        self.start = 0
        self.stop = self.dt
        self.v0 = 170                   # 输出电压
        self.v0_delay = 170             # 上一时刻的输出电压
        self.dv0 = 0                    # 输出电压的导数
        self.e = 0                      # 跟踪误差
        self.e_delay = 0                # 上一时刻跟踪误差
        self.de = 0                     # 跟踪误差的导数
        # self.e_accum = 0                # 累积误差(积分)
        self.state = [self.v0, self.v0_delay, self.dv0,  self.e, self.e_delay, self.de]

        return self.state

    # OpenAI Gym API implementation
    def step(self, action): # action就是占空比,去主程序里调整吧
        """
            吃一个动作(index),吐 state, reward,
        """
        self.model.set('d', action)

        opts = self.model.simulate_options()
        opts['ncp'] = 100  # 仿真点数,原为50,相当于粒度,影响v_0的计算精度
        opts['initialize'] = False

        res = self.model.simulate(start_time=self.start, final_time=self.stop, options=opts) # 类似字典

        # 更新状态
        self.v0 = res['v_o'][-1]                                        # 取最后一个点的仿真值为v_t
        self.v0_delay = res['v_o'][0]                                   # 取第一个仿真点为v_delay
        self.dv0 = (self.v0 - self.v0_delay)/self.dt
        self.e = 170 - self.v0                                          # 跟踪目标170v
        self.e_delay = 170 - self.v0_delay
        self.de = (self.e - self.e_delay)/self.dt
        # self.e_accum += self.e * self.dt                                # 离散代替积分,后面的系数是可以调的,让三个状态数量级不差太远
        self.state = [self.v0, self.v0_delay, self.dv0,  self.e, self.e_delay, self.de]

        reward = self.compute_reward(self.e)

        # 更新时间
        self.start = self.stop
        self.stop += self.dt
        print('状态: ', self.state)
        return self.state, reward


    def compute_reward(self, e): # 按现在的电压计算reward
        r1 = -10*np.abs(e)  # 小罚
        r2 = 0  # 奖励
        if abs(e) < 1:
            r2 = 1
        if abs(e) < 0.1:
            r2 = 10
        reward = r1 + r2 # 可以配不同权重
        return reward

