# 算法,DDQN,1.16改成hard replacement
import torch
import torch.nn as nn
import torch.nn.functional as F
from torch.autograd import Variable

import numpy as np
import math

from alg import utils
from alg import model # 导入神经网络文件
import os


class Trainer:
    def __init__(self, state_dim, action_dim,  ram, e_greedy=0.1, batch_size=128, learning_rate=0.001, replace = 100, reward_decay = 0.9):
        # 初始化变量
        self.state_dim = state_dim
        self.action_dim = action_dim # 在DQN里是离散动作数
        self.ram = ram # buffer
        self.e_greedy = e_greedy # 这个是随机选动作的概率,一般是0.1
        self.batch_size = batch_size
        self.lr = learning_rate
        self.replace = replace        # target更新的间隔
        self.gamma = reward_decay
        self.learn_counter = 0 # 记录target net 该不该replace

        # 搭建网络
        self.eval_net = model.NET(state_dim = self.state_dim, action_dim = self.action_dim)
        self.target_net = model.NET(state_dim = self.state_dim, action_dim = self.action_dim)
        utils.hard_update(self.target_net, self.eval_net)
        self.optimizer = torch.optim.Adam(self.eval_net.parameters(), lr = self.lr, ) # 只更新eval_net


    def get_exploitation_action(self, state):
        # exploitation: 动作不随机选, 给demo用的
        # 吃state(numpy),转成tensor送入网络,再转回numpy,吐action(numpy)
        state = Variable(torch.from_numpy(state)) # numpy -> tensor
        # state送入神经网络算出所有a的q
        action_values = self.eval_net.forward(state) # .detach(): 取出一个分支来, 不反向更新
        action_values = torch.reshape(action_values, (-1, self.action_dim))
        action = torch.max(action_values, 1)[1].numpy()  # 第一个1: 按行求最大值, 第二个1: 只返回idx不返回最大值
        action = action[0]
        return action

    def get_exploration_action(self, state):
        if np.random.uniform() < self.e_greedy:
            action = np.random.randint(0, self.action_dim)

        else:
            state = Variable(torch.from_numpy(state))
            action_values = self.eval_net.forward(state)
            action_values = torch.reshape(action_values, (-1, self.action_dim))
            # print(action_values.shape)
            # print(action_values)
            action = torch.max(action_values, 1)[1].numpy()  # 第一个1: 按行求最大值, 第二个1: 只返回idx不返回最大值
            action = action[0]
        # print(action)
        return action


    def optimize(self):
        if self.learn_counter % self.replace == 0:
            utils.hard_update(self.target_net, self.eval_net)

        # 抽样更新网络参数
        s1,a1,r1,s2 = self.ram.sample(self.batch_size)
        # 转成tensor
        s1 = Variable(torch.from_numpy(s1))
        a1 = torch.LongTensor(a1)
        a1 = torch.reshape(a1, (-1, 1))
        # a1 用32位会报错: RuntimeError: index 2602750181376 is out of bounds for dimension 1 with size 2
        r1 = Variable(torch.from_numpy(r1))
        s2 = Variable(torch.from_numpy(s2))


        ###################################### 更新网络 ######################################
        q_eval = torch.squeeze(self.eval_net.forward(s1).gather(1, a1)) # 这已经是一列了
        q_eval_next = self.eval_net.forward(s2)
        q_target_next = self.target_net.forward(s2).detach()
        q_next = torch.squeeze(q_target_next.gather(1, torch.max(q_eval_next, 1)[1].unsqueeze(1))) # eval挑动作,target算分数


        q_target = r1 + self.gamma * q_next

        # 反向传递更新参数

        loss = F.mse_loss(q_eval, q_target)
        self.optimizer.zero_grad()
        loss.backward()
        self.optimizer.step()

        self.learn_counter += 1


    def save_models(self, episode, env, lr, gamma, batch_size, date): # 加个日期选项
        # 按环境和eps存模型,保存eval_net
        PATH = './Models_of_%s_%s_%s_%s_%s' % (str(env), str(lr), str(gamma), str(batch_size), date)
        if not os.path.exists(PATH):
            os.mkdir(PATH)
        torch.save(self.eval_net.state_dict(), PATH + '/' + str(episode) + '_hard.pt')

        print('Models saved successfully!!!')

    def load_models(self, episode, env, lr, gamma, batch_size, date):
        # 加载保存好的模型
        PATH = './Models_of_%s_%s_%s_%s_%s' % (str(env), str(lr), str(gamma), str(batch_size), date)
        self.eval_net.load_state_dict(torch.load(PATH + '/' + str(episode) + '_hard.pt'))
        print('Models loaded successfully!!!')


