%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��һ֡����%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;
%%%%%%%%%%%%%%%%%%��һ֡�ɼ�����%%%%%%%%%%%%%%%%%%%%%%%
obj = VideoReader('test_2.mp4'); %��ȡ��Ƶ
I= read(obj, 1);%����Ƶ��һ֡
I = rgb2gray(I);
figure(1);%����
imshow(I);%��ʾ��һ֡
[image_data_first,rect]=imcrop(I);%��ѡĿ�꣬temp�ǿ�ѡ�����ؾ���rect�������ο�����ͱ߳�
[a,b,c]=size(image_data_first);%a�Ǿ��ο��������ظ�����b�Ǿ��ο�������ظ�����c=1(1����Ҷ�ͼ)

%%%%%%%%%%%%%%%%% �õ����ε�Ȩֵ����weight�͹�һ��ϵ��C %%%%%%%%%%%%%%%%%%%%%
a2=a/2;%aΪ���ο�����߳�
b2=b/2;%bΪ���ο����߳�
tic_x=rect(1)+rect(3)/2;%1Ϊ�������꣬3Ϊ����߳����ó�����x���е�
tic_y=rect(2)+rect(4)/2;%2Ϊ�ϲ������꣬4Ϊ����߳����ó�����y���е�
weight=zeros(a,b);%����һ��a��b�е��������ΪȨֵ����
diag=a2^2+b2^2;%h���ھ��ζԽ���һ���ƽ��

%��1�α������õ�������Ȩ��ͼ�񣨺˺�����
for i=1:a%y����ѭ��
    for j=1:b%x����ѭ��
        dist=(i-a2)^2+(j-b2)^2;%�ó�ÿ�����ؾ���������ľ����ƽ��
        weight(i,j)=1-dist/diag; %��Ȩֵ����ֵ��������ԽԶ��ȨֵԽС
        %�����ĸ�����ȨֵΪ0������ȨֵΪ1,�ذ뾶����Ȩֵ����
    end
end

%��1ϵ��,sumÿ������͵õ�һ�У�Ȼ��һ������ͣ���ȡ����
C=1/sum(sum(weight));%C=1/����Ȩֵ�ĺ�

RANGE=256;
%%%%%%%%%%%%%%%%%��þ��������ص�RGBֱ��ͼhist1 %%%%%%%%%%%%%%%%%%%%%
hist1=zeros(1,RANGE);%����һ��1��a*b�е��������Ϊֱ��ͼ

%��2�α������õ������ڵ�һ֡��ֱ��ͼ
for i=1:a
    for j=1:b
        data_first = image_data_first(i,j,1);
        hist1(data_first+1)= hist1(data_first+1)+weight(i,j);%����ֱ��ͼ��ÿ��ɫ��ռ��Ȩ��
        %ֱ��ͼ������q_temp+1�ڴӺڵ���1-4096֮��
        %����Խ�����ɫ����Ӧ��ֱ��ͼԽ�ߣ�Խ��������ȨֵԽ�ߵ���ɫ����Ӧ��ֱ��ͼҲԽ��
    end
end

hist1=hist1*C;%��ֱ��ͼ��������Ȩֵ�ܺͣ��õ���ֱ��ͼ���и߶ȼ���������1
sad=imread('tyty.bmp');
% sad=rgb2gray(sad);
a=13;
b=13;
rect(3)=a;
rect(4)=b;
weight=zeros(a,b);
diag=6.5^2+6.5^2;%h���ھ��ζԽ���һ���ƽ��

for i=1:a%y����ѭ��
    for j=1:b%x����ѭ��
        dist=(i-6.5)^2+(j-6.5)^2;%�ó�ÿ�����ؾ���������ľ����ƽ��
        weight(i,j)=1-dist/diag; %��Ȩֵ����ֵ��������ԽԶ��ȨֵԽС
        %�����ĸ�����ȨֵΪ0������ȨֵΪ1,�ذ뾶����Ȩֵ����
    end
end
for i=1:a
    for j=1:b
        data_first = sad(i,j);
        hist1(data_first+1)= hist1(data_first+1)+weight(i,j);%����ֱ��ͼ��ÿ��ɫ��ռ��Ȩ��
        %ֱ��ͼ������q_temp+1�ڴӺڵ���1-4096֮��
        %����Խ�����ɫ����Ӧ��ֱ��ͼԽ�ߣ�Խ��������ȨֵԽ�ߵ���ɫ����Ӧ��ֱ��ͼҲԽ��
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��һ֡�Ժ�ͼ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lengthfile = obj.NumberOfFrames; % lengthfile=֡������
height = obj.Height; %m=�ߣ��У�
width = obj.Width; %n=���У�
col_bias=zeros(300,1);
row_bias=zeros(300,1);
%%%%%%%%%%%%%%%%%%%%%%%%%��ѭ����ʼһ֡һ֡��ʾ�ʹ���%%%%%%%%%%%%%%%%%%%%%%%%
for length=1:lengthfile%һ����ѭ������һ֡
    Im= read(obj, length);%ѭ����ͼ
    Im = rgb2gray(Im);
    subplot(1,2,1);
    imshow(uint8(Im));%��ʾ��֡ͼ��
    hold on%����Ŀǰ��ͼ������꣬�ȴ���һ������
    
    num=0;%����������0
    move_w=1;
    move_h=1;
    sum_move_w=0;
    sum_move_h=0;
    sum_distance=0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ֵƽ�Ƶ�����ѭ�������µľ���λ��%%%%%%%%%
    while((move_w^2+move_h^2>0.5) & num<20 & (rect(2)+rect(4)<height) & (rect(1)+rect(3)<width))
        %��������:����Ľ����ģ��ƫ�����һ��ֵ��ƫ���С��Ϊͼ���غ����ټ��㣩��whileѭ������С��20
        num=num+1;%��������++
        image_data=imcrop(Im,rect);%����һ���õ��ľ���rectȥ���ó���ǰ����Ϊimage_data
        hist2=zeros(1,RANGE);%������һ��ֱ��ͼ�����
        
        %��3�α������õ������ڵ�n֡��ֱ��ͼ
        for i=1:a
            for j=1:b
                 data(i,j) =image_data(i,j,1);
                hist2(data(i,j)+1)= hist2(data(i,j)+1)+weight(i,j);%��ֱ��ͼ�ۼ�Ȩ��
            end
        end
        
        hist2=hist2*C;%�õ������µ�֡��ֱ��ͼhist2
        
        %%%%%%%%%%%%%%%%����ֱ��ͼ����õ����ο������صı仯w%%%%%%%%%%%%%%%%%%
        rate=zeros(1,RANGE);%(1,a*b)%�½�һ�бȽϾ���
        
        for i=1:RANGE
            if(hist2(i)~=0)%�������ֱ��ͼ�в�����0
                rate(i)=(hist1(i)/hist2(i));%compare(i)=������ ��һֱ֡��ͼ/Ŀǰֱ��ͼ
                %�����ȫһ��w(i)=1,,,,,,�˴�֮ǰ�п�����sqrt
            else
                rate(i)=0;%�������ɫ����Ϊ0,��ȽϽ��Ϊ0
            end
        end
        
        %������ʼ��
        sum_rate=0;%sum_rate����ֵ0
        sum_h=0;
        sum_w=0;
        
        %��4�α������õ����ε�n֡��Ҫƫ�Ƶľ���
        for i=1:a
            for j=1:b
                sum_rate = sum_rate + rate(uint32(data(i,j))+1); %��ֵ�ۼ�
                sum_h = sum_h + rate( uint32(data(i,j)) +1 )  * (i- a2-0.5 );%��ֵ��������ƫ�����ľ����ۼ�
                sum_w = sum_w + rate( uint32(data(i,j)) +1 ) * (j- b2-0.5 );%��ֵ���Ժ���ƫ�����ľ����ۼ�
            end
        end
        
        move_w = sum_w / sum_rate;
        move_h = sum_h / sum_rate;
         hist1_aver=sum(hist1)/256;%����ֱ��ͼ
    hist2_aver=sum(hist2)/256;%Ŀ��ֱ��ͼ
    h12=0;
    h1=0;
    h2=0;
    xiangsidu=0;
    for e=1:256
       xiangsidu=xiangsidu+sqrt(hist1(e)*hist2(e));
    end
    
%     if xiangsidu>0.6 
    %���ĵ�λ�ø���
        rect(1)=rect(1) + move_w;%rect(1)�������Ϻ�����
        rect(2)=rect(2) + move_h;%rect(2)��������������
        x=rect(1);
        y=rect(2);
       
%     else
%         rect(1)=rect(1) + move_w/2;%rect(1)�������Ϻ�����
%         rect(2)=rect(2) + move_h/2;%rect(2)��������������
%         x=rect(1);
%         y=rect(2);
%     end
    col_bias(length,1)=x-24;
    row_bias(length,1)=y-40;
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end%whileѭ������
    
    num
    % ��һ��ʱ�����ģ��,���Ƿ��ָ����׸���
    %     if(rem(length,20)==0)%����
    %      hist1=hist2;
    %     end
    %%�Ա����ƶ�
   
 
    %%%��ʾ���ٽ��
    tic_x=[tic_x;rect(1)+rect(3)/2];
    tic_y=[tic_y;rect(2)+rect(4)/2];
    v1=rect(1);
    v2=rect(2);
    v3=rect(3);
    v4=rect(4);
    if((rect(2)+rect(4)<height) & (rect(1)+rect(3)<width))
        plot([v1,v1+v3],[v2,v2],[v1,v1],[v2,v2+v4],[v1,v1+v3],[v2+v4,v2+v4],[v1+v3,v1+v3],[v2,v2+v4],'LineWidth',2,'Color','g');
        %plot(tic_x,tic_y,'LineWidth',2,'Color','g');
    end
    drawnow;
    hold off
    %     subplot(2,2,2);%��ͼ��Ϊһ�����еĵ�һ��λ��
    %     plot(hist1);%���µ�ֱ��ͼ
    %     axis([0 256 0 0.06]); % ������������ָ��������
    %     %xmin��xmax��ymin��ymax
    %     hold off
    subplot(1,2,2);%��ͼ��Ϊһ�����еĵ�һ��λ��
    plot(hist2);%���µ�ֱ��ͼ
    axis([0 256 0 0.06]); % ������������ָ��������
    %xmin��xmax��ymin��ymax
    hold off
    %     subplot(2,2,4);%��ͼ��Ϊһ�����еĵ�һ��λ��
    %     plot(rate);%���µ�ֱ��ͼ
    %     axis([0 256 0 6]); % ������������ָ��������
    %     hold off%�����ͷ���ʾ���֣����ٻ���
   
end
figure;
plot(col_bias(1:238,1));
figure;
plot(row_bias(1:238,1));