function [edge1,test_flag]=RGB222GRAY(a)
a=double(a);
%% ����-��ʴ-��Ե���
b=zeros(9,1);
e=zeros(48,80);%����
edge1=zeros(48,80);
for i=2:47
    for j=2:79
        b(1,1)=-1+a(i-1,j-1);
        b(2,1)=-2+a(i-1,j);
        b(3,1)=-3+a(i-1,j+1);
        b(4,1)=-4+a(i,j-1);
        b(5,1)=-5+a(i,j);
        b(6,1)=-6+a(i,j+1);
        b(7,1)=-7+a(i+1,j-1);
        b(8,1)=-8+a(i+1,j);
        b(9,1)=-9+a(i+1,j+1);
        min=255;
        for k=1:9
            if b(k,1)<min
                min=b(k,1);
            end
        end
        e(i,j)=min;
    end
end
for i=2:47
    for j=2:79
        b(1,1)=1+e(i-1,j-1);
        b(2,1)=2+e(i-1,j);
        b(3,1)=3+e(i-1,j+1);
        b(4,1)=4+e(i,j-1);
        b(5,1)=5+e(i,j);
        b(6,1)=6+e(i,j+1);
        b(7,1)=7+e(i+1,j-1);
        b(8,1)=8+e(i+1,j);
        b(9,1)=9+e(i+1,j+1);
        max=0;
        for k=1:9
            if b(k,1)>max
                max=b(k,1);
            end
        end
        edge1(i,j)=abs(max-e(i,j));
    end
end


% figure;
% imshow(edge1);
% title('��Ե')
%% ������ ���ֵ����ֵ
%�������ж϶�̬��ֵ
%ֻ�ܵ���ʮ�Σ�cicic==0��
%test_flag ����Ϊ���Գ���ȫ�׵ı�־λ��test_flag=0Ϊ������=200Ϊ���磬ÿ��test_flagԤ����0
more_value=0;less_value=0;more_counter=0;less_counter=0;flag= false; count=0;pre_threshold=20;delivery_threshold=0;cicici=0;
test_flag=0;
while ~flag
    for i=2:47
        for j=2:79
            if edge1(i,j)>pre_threshold  %%��Ԥ�����õ���ֵ���Ա�
                more_value=more_value+edge1(i,j); %% ���
                more_counter=more_counter+1; %% ����+1
            else
                less_value=less_value+edge1(i,j);
                less_counter=less_counter+1;
            end
        end
    end
    %�ж�test_flag��־λ����
    if less_counter>3553
        test_flag=200;
        break;
    end
    
    delivery_threshold=((more_value/more_counter)+(less_value/less_counter))/2; %%��ָ�����ֵ
    if abs(delivery_threshold-pre_threshold)<0.05 %% ��Ԥ�����õ���ֵ���Ա�
        flag=true;
    end
    pre_threshold=delivery_threshold;
    %�жϴ�������
    cicici=cicici+1;
    if cicici==5
        break;
    end
    
    more_value=0;less_value=0;more_counter=0;less_counter=0;
end



%% edge2 �� ʢ�Ŷ�ֵ�����ͼ��
%%ͼ���ֵ��
for i=2:47
    for j=2:79
        if edge1(i,j)<=delivery_threshold
            edge1(i,j)=0;
        else edge1(i,j)=255;
        end
    end
end
