
# coding: utf-8

# # Kernel Ridge Regression 

# In[1]:

import numpy as np
import scipy as sp
import random
import copy


# In[2]:

cd Desktop/


# In[4]:

#读取数据
data = []
with open(r'hw2_lssvm_all.dat') as f1:
    for line in f1:
        data.append(map(float,line.split()))
data = np.array(data)
train = data[0:400,:]
test = data[400:,:]


# In[21]:

def gauss(x1,x2,r):
    '''
    定义高斯核函数
    '''
    return np.exp(-r*np.sum((x1-x2)**2))

def getB(data,r,lamb):
    '''
    根据输入的训练数据，得到参数B值
    data: 数组,包含x和y
    r,lamb: 实数
    '''
    X = data[:,0:-1]
    Y = data[:,-1]
    N = len(data)
    K = np.zeros((N,N))
    for i in range(N):
        for j in range(N):
            K[i,j] = gauss(X[i,:],X[j,:],r)
    B = np.dot(np.linalg.inv(K+lamb*np.diag(np.ones(N))) ,Y)
    return (B,X)

def getY(train,testX,r,lamb):
    '''
    利用训练集train去训练，得到测试集x上的结果
    train：训练集数组，包含x和y
    testX: 测试集数组，只包含x
    r,lamb: 实数
    '''
    (B,X)=getB(train,r,lamb)
    Y = []
    for x in testX:
        K = []
        for xn in X:
            K.append(gauss(xn,x,r))
        Y.append(np.dot(K,B))
    return Y

def test1(train,test):
     '''
    利用训练集train去训练，得到测试集x上的结果并返回测试集上面的精度
    需要预先定义参数R,LAMB的范围
    train：训练集数组，包含x和y
    test : 测试集数组，包含x和y
    '''
    R = [32,2,0.125]
    LAMB = [0.001,1,1000]
    bestrate = 0
    for r in R:
        for lamb in LAMB:
            yp = getY(train,test[:,0:-1],r,lamb)
            rate = (np.array(yp)>0) == (test[:,-1]==1)
            rate2 = np.mean(rate)
            if rate2>bestrate:
                bestrate=rate2
    return bestrate

