
# coding: utf-8

# In[27]:

import numpy as np
import scipy as sp
import random
import copy


# In[2]:

cd Desktop/


# In[7]:

#读取数据
train = []
test = []
with open(r'hw2_adaboost_train.dat') as f1:
    for line in f1:
        train.append(map(float,line.split()))
with open(r'hw2_adaboost_test.dat') as f2:
    for line in f2:
        test.append(map(float,line.split()))
        
#将数据转化成ndarray格式
train = np.array(train)
test = np.array(test)
print train.shape
print test.shape

#将数据分割成X和Y
trainX =  train[:,0:2]
trainY =  train[:,2]
testX = test[:,0:2]
testY = test[:,2]


# In[240]:

#ufunc函数，将参数逻辑值求反
flogical = np.frompyfunc(lambda x: not x,1,1)

#定义符号函数及其ufunc函数
def sign(x):
    if x>=0:
        return 1
    else:
        return -1
fsign = np.frompyfunc(sign,1,1)


#定义stump函数及其ufunc函数
#计算s*sign(x_i-theta)
def f1(s,theta,x):
    assert s==1 or s==-1
    return s*sign(x-theta)
f2 = np.frompyfunc(f1,3,1)


#Decision Stump的函数
#根据单个feature排序找到最佳值
#模型参数包括s,theta
def decisionStump(feature,Y,U):
    '''
    feature: n*1
    Y:       n*1
    U:       n*1
    '''
    N = len(feature)
    assert len(U)==N
    fsort=np.sort(feature)
    #keys中指定分割的值，
    keys = [-1]
    for i in range(N-1):
        keys.append( (fsort[i]+fsort[i+1])/2 )
    #遍历keys中指定的分割值，找到最优的模型参数
    bestEin = 1000
    besttheta = -10
    bests = -10
    besterr = 10
    for theta in keys:
        #这里应该根据theta，并且结合s有两个模型
        Einm1 = np.dot(f2(1,theta,feature)!=Y,U)/float(N)
        Einm2 = np.dot(f2(-1,theta,feature)!=Y,U)/float(N)
        #这里存储错误率
        err1 = np.mean(f2(1,theta,feature)!=Y)
        err2 = np.mean(f2(-1,theta,feature)!=Y)
        if Einm1<=Einm2 and Einm1<bestEin:
            bestEin = Einm1
            besttheta=theta
            bests = 1
            besterr = err1
        if Einm1>Einm2 and Einm2<bestEin:
            bestEin = Einm2
            besttheta=theta
            bests = -1
            besterr = err2
    return (bestEin,besttheta,bests,besterr)

#加上了特征的寻优,这里只考虑了两个特征
def decisionStump2(features,Y,U):
    '''
    features: n*2
    Y:       n*1
    U:       n*1
    '''
    feature1 = features[:,0]
    feature2 = features[:,1]
    (bestEin1,besttheta1,bests1,besterr1) = decisionStump(feature1,Y,U)
    (bestEin2,besttheta2,bests2,besterr2) = decisionStump(feature2,Y,U)
#     print (bestacc1,besttheta1,bests1)
#     print (bestacc2,besttheta2,bests2)
    if bestEin1<bestEin2:
        return (bestEin1,besttheta1,bests1,besterr1,1)
    else:
        return (bestEin2,besttheta2,bests2,besterr2,2)


#主函数，一共得到T个g子函数，然后根据对应的a值进行组合
def AdaBoost(features,Y,T=300):
    N = len(Y)
    U = np.ones(N)/float(N)
    A = []
    THETA = []
    S = []
    NUMF = []
    UALL = []
    ET = []
    for i in range(T):
        (bestEin,besttheta,bests,besterr,numF) = decisionStump2(features,Y,U)
        THETA.append(besttheta)
        S.append(bests)
        NUMF.append(numF)
        UALL.append(copy.copy(U))
        #下面的步骤为了得到N上面的正确与否的索引
        if numF==1:
            index = f2(bests,besttheta,features[:,0])==Y
        elif numF==2:
            index = f2(bests,besttheta,features[:,1])==Y
        else:
            print '出错啦！！！'
            return 0
        #s = np.sqrt((1-besterr)/besterr)
        et = bestEin*N/sum(U)
        ET.append(et)
        s = np.sqrt((1-et)/et)
        #更新U值，对于不正确的乘s，对于正确的除以s
        U[index] = U[index]/s
        U[flogical(index).astype(np.bool)] = U[flogical(index).astype(np.bool)]*s
        A.append(np.log(s))
    return (A,THETA,S,NUMF,UALL,ET)

#计算总体函数G
def G(A,THETA,S,NUMF,X):
    N = len(A)
    assert len(A)==len(THETA)==len(S)==len(NUMF)
    #计算各个小g的和
    Gx = np.zeros(len(X))
    K = 0
    for i in range(N):
        a = A[i]
        theta = THETA[i]
        s = S[i]
        numf = NUMF[i]
        assert numf==1 or numf==2
        if numf==1:
            Gx += a*f2(s,theta,X[:,0])
            K+=1
        else:
            Gx += a*f2(s,theta,X[:,1])
            K+=1
    return fsign(Gx)


# In[241]:

#调试
print decisionStump2(trainX,trainY,U)
(A,THETA,S,NUMF,UALL,ET)=AdaBoost(trainX,trainY,T=300)
np.mean(G(A,THETA,S,NUMF,testX)==testY)

