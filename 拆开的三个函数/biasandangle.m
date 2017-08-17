function [Out_bias,Out_angle,Out_last_bias,Out_last_angle]=biasandangle(edge1,In_last_bias,In_last_angle,test_flag)
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
    negative_number=0;
    if (sum(bias_array)-1903.5)*(sum(bias_array1)-1903.5)<0
        negative_number=1;
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
    %     %����ֱ��ƫ�ƣ�������ֱ�ߵĵ��ƽ��-�е㣩
    
    yubei=0;
    for i=1:47
        if bias_array(i,1)==0
            yubei=yubei+1;
        end
    end
    
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
    angle=atan(gradien);
    angle=angle*180/pi;%��Ϊ�ɻ�ͷ��ת����Ϊ�ɻ�ͷ��ת
    Out_angle=angle;
    Out_last_angle=angle;
    
    Out_last_angle=Out_angle;
    bias=(sum_Xsquare*sum_Y-sum_X*sum_XY)/(sum_Xsquare-sum_X^2);
    bias=gradien*24.5+bias-40.5;
    if negative_number==1
        bias=0;
    end
    Out_bias=bias;
    Out_last_bias=bias;
    if Out_bias>=40
        Out_bias=100;
    elseif Out_bias<=-40
        Out_bias=-100;
    end
    
    %������0�����30����Ϊֻ�б�־�ߵı�Ե��ֱ�ӿ�ʼ�ж�
    if  yubei>37
        if In_last_bias>20
            Out_bias=100; %���ұ߳�ȥ��
            Out_last_bias=In_last_bias;
            Out_last_angle=In_last_angle;
            Out_angle=In_last_angle;
        elseif In_last_bias<-20
            Out_bias=-100;%����߳�ȥ��
            Out_last_bias=In_last_bias;
            Out_last_angle=In_last_angle;
            Out_angle=In_last_angle;
        end
    end
    
else
    if In_last_bias>20
        Out_bias=100; %���ұ߳�ȥ��
        Out_last_bias=In_last_bias;
        Out_angle=In_last_angle;
        Out_last_angle=In_last_angle;
        
    elseif In_last_bias<-20
        Out_bias=-100;%����߳�ȥ��
        Out_last_bias=In_last_bias;
        Out_angle=In_last_angle;
        Out_last_angle=In_last_angle;
        
    else Out_last_bias=In_last_bias;
        Out_angle=In_last_angle;
        Out_last_angle=In_last_angle;
        Out_bias=In_last_bias;
        
    end
end
end