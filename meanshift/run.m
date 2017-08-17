%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%第一帧处理%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;
%%%%%%%%%%%%%%%%%%第一帧采集部分%%%%%%%%%%%%%%%%%%%%%%%
obj = VideoReader('test_2.mp4'); %读取视频
I= read(obj, 1);%读视频第一帧
I = rgb2gray(I);
figure(1);%标题
imshow(I);%显示第一帧
[image_data_first,rect]=imcrop(I);%框选目标，temp是框选的像素矩阵，rect包含矩形框坐标和边长
[a,b,c]=size(image_data_first);%a是矩形框纵向像素个数，b是矩形框横向像素个数，c=1(1代表灰度图)

%%%%%%%%%%%%%%%%% 得到矩形的权值矩阵weight和归一化系数C %%%%%%%%%%%%%%%%%%%%%
a2=a/2;%a为矩形框纵向边长
b2=b/2;%b为矩形框横向边长
tic_x=rect(1)+rect(3)/2;%1为左侧横坐标，3为横向边长，得出矩形x轴中点
tic_y=rect(2)+rect(4)/2;%2为上侧纵坐标，4为纵向边长，得出矩形y轴中点
weight=zeros(a,b);%创建一个a行b列的零矩阵作为权值矩阵
diag=a2^2+b2^2;%h等于矩形对角线一半的平方

%第1次遍历：得到矩形内权重图像（核函数）
for i=1:a%y轴外循环
    for j=1:b%x轴内循环
        dist=(i-a2)^2+(j-b2)^2;%得出每个像素距离矩形中心距离的平方
        weight(i,j)=1-dist/diag; %给权值矩阵赋值，离中心越远，权值越小
        %矩形四个顶点权值为0，中心权值为1,沿半径方向权值降低
    end
end

%归1系数,sum每列先求和得到一行，然后一整行求和，再取倒数
C=1/sum(sum(weight));%C=1/所有权值的和

RANGE=256;
%%%%%%%%%%%%%%%%%获得矩形内像素的RGB直方图hist1 %%%%%%%%%%%%%%%%%%%%%
hist1=zeros(1,RANGE);%创建一个1行a*b列的零矩阵作为直方图

%第2次遍历：得到矩形内第一帧的直方图
for i=1:a
    for j=1:b
        data_first = image_data_first(i,j,1);
        hist1(data_first+1)= hist1(data_first+1)+weight(i,j);%计算直方图中每种色彩占的权重
        %直方图横坐标q_temp+1在从黑到白1-4096之间
        %出现越多的颜色，对应的直方图越高，越靠近中心权值越高的颜色，对应的直方图也越高
    end
end

hist1=hist1*C;%给直方图除以所有权值总和，得到的直方图所有高度加起来等于1
sad=imread('tyty.bmp');
% sad=rgb2gray(sad);
a=13;
b=13;
rect(3)=a;
rect(4)=b;
weight=zeros(a,b);
diag=6.5^2+6.5^2;%h等于矩形对角线一半的平方

for i=1:a%y轴外循环
    for j=1:b%x轴内循环
        dist=(i-6.5)^2+(j-6.5)^2;%得出每个像素距离矩形中心距离的平方
        weight(i,j)=1-dist/diag; %给权值矩阵赋值，离中心越远，权值越小
        %矩形四个顶点权值为0，中心权值为1,沿半径方向权值降低
    end
end
for i=1:a
    for j=1:b
        data_first = sad(i,j);
        hist1(data_first+1)= hist1(data_first+1)+weight(i,j);%计算直方图中每种色彩占的权重
        %直方图横坐标q_temp+1在从黑到白1-4096之间
        %出现越多的颜色，对应的直方图越高，越靠近中心权值越高的颜色，对应的直方图也越高
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%第一帧以后图像处理%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lengthfile = obj.NumberOfFrames; % lengthfile=帧的总数
height = obj.Height; %m=高（行）
width = obj.Width; %n=宽（列）
col_bias=zeros(300,1);
row_bias=zeros(300,1);
%%%%%%%%%%%%%%%%%%%%%%%%%主循环开始一帧一帧显示和处理%%%%%%%%%%%%%%%%%%%%%%%%
for length=1:lengthfile%一次主循环处理一帧
    Im= read(obj, length);%循环读图
    Im = rgb2gray(Im);
    subplot(1,2,1);
    imshow(uint8(Im));%显示此帧图像
    hold on%保持目前的图像和坐标，等待下一步画框
    
    num=0;%迭代次数清0
    move_w=1;
    move_h=1;
    sum_move_w=0;
    sum_move_h=0;
    sum_distance=0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%均值平移迭代，循环计算新的矩形位置%%%%%%%%%
    while((move_w^2+move_h^2>0.5) & num<20 & (rect(2)+rect(4)<height) & (rect(1)+rect(3)<width))
        %迭代条件:算出的结果和模版偏差大于一定值（偏差过小认为图像重合则不再计算）且while循环次数小于20
        num=num+1;%迭代次数++
        image_data=imcrop(Im,rect);%用上一步得到的矩形rect去剪裁出当前矩形为image_data
        hist2=zeros(1,RANGE);%创建另一个直方图零矩阵
        
        %第3次遍历：得到矩形内第n帧的直方图
        for i=1:a
            for j=1:b
                 data(i,j) =image_data(i,j,1);
                hist2(data(i,j)+1)= hist2(data(i,j)+1)+weight(i,j);%给直方图累加权重
            end
        end
        
        hist2=hist2*C;%得到现在新的帧的直方图hist2
        
        %%%%%%%%%%%%%%%%新老直方图相除得到矩形框内像素的变化w%%%%%%%%%%%%%%%%%%
        rate=zeros(1,RANGE);%(1,a*b)%新建一行比较矩阵
        
        for i=1:RANGE
            if(hist2(i)~=0)%如果现在直方图列不等于0
                rate(i)=(hist1(i)/hist2(i));%compare(i)=根号下 第一帧直方图/目前直方图
                %如果完全一样w(i)=1,,,,,,此处之前有开根号sqrt
            else
                rate(i)=0;%如果此颜色含量为0,则比较结果为0
            end
        end
        
        %变量初始化
        sum_rate=0;%sum_rate赋初值0
        sum_h=0;
        sum_w=0;
        
        %第4次遍历：得到矩形第n帧需要偏移的距离
        for i=1:a
            for j=1:b
                sum_rate = sum_rate + rate(uint32(data(i,j))+1); %比值累加
                sum_h = sum_h + rate( uint32(data(i,j)) +1 )  * (i- a2-0.5 );%比值乘以纵向偏离中心距离累加
                sum_w = sum_w + rate( uint32(data(i,j)) +1 ) * (j- b2-0.5 );%比值乘以横向偏离中心距离累加
            end
        end
        
        move_w = sum_w / sum_rate;
        move_h = sum_h / sum_rate;
         hist1_aver=sum(hist1)/256;%基本直方图
    hist2_aver=sum(hist2)/256;%目标直方图
    h12=0;
    h1=0;
    h2=0;
    xiangsidu=0;
    for e=1:256
       xiangsidu=xiangsidu+sqrt(hist1(e)*hist2(e));
    end
    
%     if xiangsidu>0.6 
    %中心点位置更新
        rect(1)=rect(1) + move_w;%rect(1)矩形左上横坐标
        rect(2)=rect(2) + move_h;%rect(2)矩形左上纵坐标
        x=rect(1);
        y=rect(2);
       
%     else
%         rect(1)=rect(1) + move_w/2;%rect(1)矩形左上横坐标
%         rect(2)=rect(2) + move_h/2;%rect(2)矩形左上纵坐标
%         x=rect(1);
%         y=rect(2);
%     end
    col_bias(length,1)=x-24;
    row_bias(length,1)=y-40;
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end%while循环结束
    
    num
    % 过一段时间更新模板,但是发现更容易跟丢
    %     if(rem(length,20)==0)%求余
    %      hist1=hist2;
    %     end
    %%对比相似度
   
 
    %%%显示跟踪结果
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
    %     subplot(2,2,2);%把图分为一行两列的第一个位置
    %     plot(hist1);%画新的直方图
    %     axis([0 256 0 0.06]); % 设置坐标轴在指定的区间
    %     %xmin、xmax、ymin、ymax
    %     hold off
    subplot(1,2,2);%把图分为一行两列的第一个位置
    plot(hist2);%画新的直方图
    axis([0 256 0 0.06]); % 设置坐标轴在指定的区间
    %xmin、xmax、ymin、ymax
    hold off
    %     subplot(2,2,4);%把图分为一行两列的第一个位置
    %     plot(rate);%画新的直方图
    %     axis([0 256 0 6]); % 设置坐标轴在指定的区间
    %     hold off%可以释放显示保持，减少缓存
   
end
figure;
plot(col_bias(1:238,1));
figure;
plot(row_bias(1:238,1));