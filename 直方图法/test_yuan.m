function [Out_row_bias,Out_last_row_bias,Out_col_bias,Out_last_col_bias]=test_yuan(In_last_row_bias,In_last_col_bias,a)
% clear all;
% a=imread('39.bmp');
% In_last_row_bias=-100;
% In_last_col_bias=-100;
% a=rgb2gray(a);
a=double(a);
% hist=zeros(256,1);
% for i=1:48
%     for j=1:80
%         data_first=a(i,j);
%         hist(data_first+1)=hist(data_first+1)+1;
%     end
% end
% 
%   plot(hist);
    %% 迭代法 求二值化阈值
    %迭代法判断动态阈值
    %只能迭代十次（cicic==0）
    %test_flag 设置为测试场地全白的标志位，test_flag=0为正常，=200为出界，每次test_flag预先置0
    more_value=0;less_value=0;more_counter=0;less_counter=0;flag= false; count=0;pre_threshold=50;delivery_threshold=0;cicici=0;
   test_flag=0;
    if sum(sum(a))/(48*80)>70
       while ~flag
        for i=1:48
            for j=1:80
                if a(i,j)>pre_threshold  %%与预先设置的阈值做对比
                    more_value=more_value+a(i,j); %% 求和
                    more_counter=more_counter+1; %% 数量+1
                else
                    less_value=less_value+a(i,j);
                    less_counter=less_counter+1;
                end
            end
        end
        %判断test_flag标志位环节
        if more_counter>3820
            test_flag=200;
            break;
        end
        
        delivery_threshold=((more_value/more_counter)+(less_value/less_counter))/2; %%求分割后的阈值
        if abs(delivery_threshold-pre_threshold)<0.05 %% 与预先设置的阈值做对比
            flag=true;
        end
        pre_threshold=delivery_threshold;
        %判断次数环节
        cicici=cicici+1;
        if cicici==5
            break;
        end
        
        more_value=0;less_value=0;more_counter=0;less_counter=0;
    end
   else
       delivery_threshold=0;
   end
    
    
    %% edge2 是 盛放二值化后的图像
    %%图像二值化
    if test_flag==0
    for i=1:48
        for j=1:80
            if a(i,j)<=delivery_threshold
                a(i,j)=0;
            else a(i,j)=255;
            end
        end
    end
%     figure;
%     imshow(a,[]);
%  
        col=zeros(80,1);
        row=zeros(48,1);
            for j=1:80
                for i=1:48
                    if a(i,j)==0
                        col(j,1)=col(j,1)+1;
                    end
                end
            end
            
            
            
            for i=1:48
                for j=1:80
                    if a(i,j)==0
                        row(i,1)=row(i,1)+1;
                    end
                end
            end
       
        
        aver=0;
        biaozhuncha=0;
        aver=sum(row)/48;
        for i=1:48
            biaozhuncha=biaozhuncha+(row(i,1)-aver)^2;
        end
        biaozhuncha=sqrt(biaozhuncha/48);
%         figure;
%         plot(col);
%         title('列统计');
%         figure;
%         plot(row)
%         title('行统计');
        col_place=0;
        row_place=0;
        col_max=0;
        col_place1=0;
        col_place2=0;
        row_place1=0;
        row_place2=0;
        for j=1:80
            if col(j,1)>col_max
                col_max=col(j,1);
                col_place=j;
            end
        end
        for j=1:80
            if col(j,1)==col_max
                col_place1=j;
            end
        end
%         save=col_place;
%         save(p,2)=col_place1;
        row_max=0;
        for i=1:48
            if row(i,1)>row_max
                row_max=row(i,1);
                row_place=i;
            end
        end
         for i=1:48
            if row(i,1)==row_max
                row_place1=i;
            end
        end
        if abs(col_place-40.5)<abs(col_place1-40.5)
            col_place2=col_place;
        else col_place2=col_place1;
        end
        if abs(row_place-24.5)<abs(row_place1-24.5)
            row_place2=row_place;
        else row_place2=row_place1;
        end
        Out_row_bias=row_place2-24.5;
        Out_col_bias=col_place2-40.5;
        
      
        
        if (col_place-42.5)*(col_place1-38.5)<=0
            Out_col_bias=0;
        end
        if (row_place-26.5)*(row_place1-20.5)<=0
            Out_row_bias=0;
        end
       
        
        
        %预防最大值
        if (col(1,1)>=(col_max/2) )&& (col(80,1)<(col_max/2))
            Out_col_bias=-100;
        end
        if (col(80,1)>=(col_max/2) )&& (col(1,1)<(col_max/2))
                Out_col_bias=100;
        end
        if (row(1,1)>=(row_max/2)) && (row(48,1)<(row_max/2))
            Out_row_bias=-100;
        end
         if (row(48,1)>=(row_max/2)) && (row(1,1)<(row_max/2))
            Out_row_bias=100;
         end
        Out_last_row_bias=Out_row_bias;
        Out_last_col_bias=Out_col_bias;
        else 
        
         if In_last_col_bias>20
            Out_col_bias=100;
            Out_last_col_bias=In_last_col_bias;
        elseif In_last_col_bias<-20;
            Out_col_bias=-100;
            Out_last_col_bias=In_last_col_bias;
        else
            Out_col_bias=In_last_col_bias;
            Out_last_col_bias=In_last_col_bias;  
        end
        
        if In_last_row_bias>10
            Out_row_bias=100;
            Out_last_row_bias=In_last_row_bias;
        elseif In_last_row_bias<-10;
            Out_row_bias=-100;
            Out_last_row_bias=In_last_row_bias;
        else
            Out_row_bias=In_last_row_bias;
            Out_last_row_bias=In_last_row_bias;
        end
        end
end