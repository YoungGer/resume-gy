%% ����DCT(discreate cosine transform)�任
X=round(rand(4)*100);%������ɵ�����
% �Լ������DCT����
A=zeros(4);%�任����
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
Y=A*X*A';%DCT�任
% matlab�Դ���DCT����
YY=dct2(X);%��matlab�еĺ�������DCT�任
%�Լ������DCT�ķ�����
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