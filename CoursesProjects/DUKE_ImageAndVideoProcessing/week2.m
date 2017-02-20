%% 定义DCT(discreate cosine transform)变换
X=round(rand(4)*100);%随机生成的数据
% 自己定义的DCT函数
A=zeros(4);%变换矩阵
for i=0:3
    for j=0:3
        if i==0
            a=sqrt(1/4);
        else
            a=sqrt(2/4);
        end            
        A(i+1,j+1)=a*cos(pi*(j+0.5)*i/4);
    end
end
Y=A*X*A';%DCT变换
% matlab自带的DCT函数
YY=dct2(X);%用matlab中的函数进行DCT变换
%自己定义的DCT的反函数
X=[
    61    19    50    20
    82    26    61    45
    89    90    82    43
    93    59    53    97];
A=zeros(4);
for i=0:3
    for j=0:3
        if i==0
            a=sqrt(1/4);
        else
            a=sqrt(2/4);
        end            
        A(i+1,j+1)=a*cos(pi*(j+0.5)*i/4);
    end
end
Y=A*X*A';
X1=A'*Y*A;