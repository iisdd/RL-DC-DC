# 一些接口工具,方法
import numpy as np
import torch

def hard_update(target, source):
	# 更新target net
	for target_param, param in zip(target.parameters(), source.parameters()):
		target_param.data.copy_(param.data)


def soft_update(target, source, tau):
	# soft replacement : 用source(新)更新target(旧),注意要用.data来进行值更新
	for target_param, param in zip(target.parameters(), source.parameters()):
		target_param.data.copy_(
			target_param.data * (1.0 - tau) + param.data * tau
		)