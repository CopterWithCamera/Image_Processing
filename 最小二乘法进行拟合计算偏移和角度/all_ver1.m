function [quxian,angle]=all_ver1(a,last_place)
% tic
place=0;
quxian=0;
angle=0;
% clear all;
last_place=25;
%% ��ͼ���Ҷȴ�����ת��Ϊ��������
% a=imread('9.bmp');
% a=rgb2gray(a);
a=double(a);
% figure;
% imshow(a,[]);
% title('ԭͼ');
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

max=0;
%%�����ж�test_flag�Ƿ�Ϊ0������Ϊ0 ����ƫ��ͽǶȣ�Ϊ200���ж����������ҳ���

if test_flag==0
    
    
    bias_array=zeros(80,1);
    bias_array1=zeros(80,1);
    
    
    yubei=0;
    for i=47:-1:2
        for j=2:1:79
            if edge1(i,j)-edge1(i,j+1)==255
                bias_array(i,1)=j;
                break;
            end
        end
    end
    
    for i=47:-1:2
        for j=79:-1:2
            if edge1(i,j)-edge1(i,j-1)==255
                bias_array1(i,1)=j;
                break;
            end
        end
    end
    if abs(sum(bias_array)-1903.5)>abs(sum(bias_array1)-1903.5)
        bias_array(:)=bias_array1(:);
    else bias_array1(:)=bias_array(:);
    end
    for i=1:47
        if bias_array(i,1)==0
            yubei=yubei+1;
        end
    end
    %�������������������ϴ�ļ�Ϊ���ߣ�Ϊ0�޳���ʣ�µ�Ϊ���ߣ�
    bias_aver=sum(bias_array)/(47- yubei);
    biaozhuncha=0;
    for i=2:47
        biaozhuncha=biaozhuncha+(bias_array(i,1)-bias_aver)^2;
    end
    biaozhuncha=sqrt(biaozhuncha/(47- yubei));
    for i=2:47
        if abs(bias_array(i,1)-bias_aver)>biaozhuncha
            bias_array(i,1)=0;
        end
    end
    %����ֱ��ƫ�ƣ�������ֱ�ߵĵ��ƽ��-�е㣩
    
    yubei=0;
    for i=1:47
        if bias_array(i,1)==0
            yubei=yubei+1;
        end
    end
    bias=sum(bias_array)/(47-yubei)-40.5;
    
    %�趨ƫ������
    if abs(bias)<1
        bias=0;
    end
    Out_last_bias=bias;
    Out_bias(p,1)=bias;
    In_last_bias=Out_last_bias;
    %����Ƕȣ��������ε��������������С���˷���ֱ����ϣ�����б�ʼ���ƫ��
    sum_X=0;
    sum_Y=0;
    sum_XY=0;
    sum_Xsquare=0;
    for i=1:47
        if bias_array(i,1)~=0
            sum_X=sum_X+i;
            sum_Y=sum_Y+bias_array(i,1);
            sum_XY=sum_XY+i*bias_array(i,1);
            sum_Xsquare=sum_Xsquare+i*i;
        end
    end
    sum_X=sum_X/(47-yubei);
    sum_Y=sum_Y/(47-yubei);
    sum_XY=sum_XY/(47-yubei);
    sum_Xsquare=sum_Xsquare/(47-yubei);
    gradien=(sum_XY-sum_X*sum_Y)/(sum_Xsquare-sum_X^2);
    Out_angle(p,1)=atan(gradien);
    Out_angle(p,1)=Out_angle(p,1)*180/pi;%��Ϊ�ɻ�ͷ��ת����Ϊ�ɻ�ͷ��ת
    %�趨+-2������Ϊ����
    if abs(Out_angle(p,1))<=2
        Out_angle(p,1)=0;
    end
    In_last_angle=Out_angle(p,1);
    Out_last_angle=Out_angle(p,1);
    %������0�����30����Ϊֻ�б�־�ߵı�Ե��ֱ�ӿ�ʼ�ж�
    if  yubei>37
        if In_last_bias>20
            Out_bias(p,1)=-100; %���ұ߳�ȥ��
            Out_last_bias=In_last_bias;
            Out_last_angle(p,1)=In_last_angle;
            Out_last_angle=In_last_angle;
        elseif In_last_bias<-20
            Out_bias(p,1)=100;%����߳�ȥ��
            Out_last_bias=In_last_bias;
            Out_last_angle(p,1)=In_last_angle;
            Out_last_Out_angle(p,1)=In_last_angle;
        end
    end
    %          for i=2:47
    %             if abs(bias_array1(i,1)-bias_aver)>2*biaozhuncha
    %                 bias_array1(i,1)=0;
    %             end
    %          end
    %          yubei=0;
    %         for i=1:47
    %             if bias_array1(i,1)==0
    %                 yubei=yubei+1;
    %             end
    %         end
    
    % ������0�����5 ��Ϊ�к��ߣ�������ߵ�ƫ�����ģʽ�����Ϊrow_bias
    %         if yubei>=5
    %             bias_array=zeros(80,1);
    %             bias_array1=zeros(80,1);
    %             for j=2:79
    %                 for i=2:48
    %                     if edge1(i,j)-edge1(i-1,j)==255;
    %                         bias_array(j,1)=i;
    %                         break;
    %                     end
    %                 end
    %             end
    
    %             for j=2:79
    %                 for i=48:2
    %                     if edge1(i,j)-edge1(i-1,j)==255;
    %                         bias_array(j,1)=i;
    %                         break;
    %                     end
    %                 end
    %             end
    %
    %             if abs(sum(bias_array)-1560)>abs(sum(bias_array1)-1560)
    %                 bias_array(:)=bias_array1(:);
    %             end
    
    %�������������������ϴ�ļ�Ϊ���ߣ�Ϊ0�޳���ʣ�µ�Ϊ���ߣ�
    %             yubei1=0;
    %             for i=1:80
    %                 if bias_array(i,1)==0
    %                     yubei1=yubei1+1;
    %                 end
    %             end
    %             bias_aver=sum(bias_array)/(78-yubei1);
    %             biaozhuncha=0;
    %             for i=2:79
    %                 biaozhuncha=biaozhuncha+(bias_array(i,1)-bias_aver)^2;
    %             end
    %             biaozhuncha=sqrt(biaozhuncha/(78-yubei1));
    %             for i=2:78
    %                 if abs(bias_array(i,1)-bias_aver)>biaozhuncha
    %                     bias_array(i,1)=0;
    %                 end
    %             end
    %����ֱ��ƫ�ƣ�������ֱ�ߵĵ��ƽ��-�е㣩
    %             yubei1=0;
    %             for i=1:80
    %                 if bias_array(i,1)==0
    %                     yubei1=yubei1+1;
    %                 end
    %             end
    %             row_bias=sum(bias_array)/(78-yubei1)-20;
    
    %�趨ƫ������
    %             if abs(row_bias)<1
    %                 row_bias=0;
    %             end
    %���������ȫ��������ֱ�ӹ۲�֮ǰ���ŵ�last_place���Աȵó�����߷ɳ������ұ߷ɳ���
    
    %         end
else
    if In_last_bias>20
        Out_bias(p,1)=-100; %���ұ߳�ȥ��
        Out_last_bias=In_last_bias;
        Out_angle(p,1)=In_last_angle;
        Out_last_angle(p,1)=In_last_angle;
    elseif In_last_bias<-20
        Out_bias(p,1)=100;%����߳�ȥ��
        Out_last_bias=In_last_bias;
        Out_angle(p,1)=In_last_angle;
        Out_last_angle(p,1)=In_last_angle;
    else Out_last_bias=In_last_bias;
        Out_angle(p,1)=In_last_angle;
        Out_last_angle(p,1)=In_last_angle;
        Out_bias(p,1)=In_last_bias;
    end
end
% toc
end