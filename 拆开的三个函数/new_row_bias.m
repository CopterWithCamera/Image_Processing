function [Out_row_bias,Out_last_row_bias]=new_row_bias(edge1,In_last_row_bias,test_flag) 
if test_flag==0
        bias_array=zeros(80,1);
        bias_array1=zeros(80,1);
        for j=2:79
            for i=2:47
                if edge1(i,j)-edge1(i-1,j)==255;
                    bias_array(j,1)=i;
                    break;
                end
            end
        end
        
        for j=2:79
            for i=47:-1:2
                if edge1(i,j)-edge1(i+1,j)==255;
                    bias_array1(j,1)=i;
                    break;
                end
            end
        end
        negative_number=0;
        if (sum(bias_array)-1911)*(sum(bias_array1)-1911)<0
            negative_number=1;
        end
        if abs(sum(bias_array)-1911)>abs(sum(bias_array1)-1911)
            bias_array(:)=bias_array1(:);
        else bias_array1(:)=bias_array(:);
        end
        yubei1=0;
        for i=2:79
            if bias_array(i,1)==0
                yubei1=yubei1+1;
            end
        end
        positive_number=0;
        if yubei1>=58
            positive_number=1;
        end
        bias_aver=sum(bias_array)/(78-yubei1);
        biaozhuncha=0;
        for i=2:79
            if bias_array(i,1)~=0
                biaozhuncha=biaozhuncha+(bias_array(i,1)-bias_aver)^2;
            end
        end
        biaozhuncha=sqrt(biaozhuncha/(78-yubei1));
        for i=2:79
            if abs(bias_array(i,1)-bias_aver)>biaozhuncha
                bias_array(i,1)=0;
            end
        end
        yubei1=0;
        for i=2:79
            if bias_array(i,1)==0;
                yubei1=yubei1+1;
            end
        end
        sum_X=0;
        sum_Y=0;
        sum_XY=0;
        sum_Xsquare=0;
        for i=2:79
            if bias_array(i,1)~=0
                sum_X=sum_X+i;
                sum_Y=sum_Y+bias_array(i,1);
                sum_XY=sum_XY+i*bias_array(i,1);
                sum_Xsquare=sum_Xsquare+i*i;
            end
        end
        sum_X=sum_X/(78-yubei1);
        sum_Y=sum_Y/(78-yubei1);
        sum_XY=sum_XY/(78-yubei1);
        sum_Xsquare=sum_Xsquare/(78-yubei1);
        gradien=(sum_XY-sum_X*sum_Y)/(sum_Xsquare-sum_X^2);
        angle=atan(gradien);
        angle=angle*180/pi;%负为飞机头左转，正为飞机头右转
        bias=(sum_Xsquare*sum_Y-sum_X*sum_XY)/(sum_Xsquare-sum_X^2);
        bias=gradien*40+bias-24.5;
        if abs(angle)>45
            bias=In_last_row_bias;
        end
        if bias>24.5
            bias=100;
        elseif bias<-24.5
            bias=-100;
        end
        if negative_number==1
            bias=0;
        end
        Out_row_bias=bias;
        Out_last_row_bias=bias;
        
        if positive_number==1
            if In_last_row_bias>10
                Out_row_bias=100;
                Out_last_row_bias=In_last_row_bias;
            elseif In_last_row_bias<-10
                Out_row_bias=-100;
                Out_last_row_bias=In_last_row_bias;
            else Out_row_bias=In_last_row_bias;
                Out_last_row_bias=In_last_row_bias;
            end
        end
        
    elseif In_last_row_bias>10
        Out_row_bias=100;
        Out_last_row_bias=In_last_row_bias;
    elseif In_last_row_bias<-10
        Out_row_bias=-100;
        Out_last_row_bias=In_last_row_bias;
    else Out_row_bias=In_last_row_bias;
        Out_last_row_bias=In_last_row_bias;
end
end