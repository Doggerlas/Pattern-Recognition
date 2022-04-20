% 三维感知器算法 d(X)=w(1)*x1+w(2)*x2+w(3)*x3+w(4); 带旋转
clc;clear;
%%%%%%%%%%%%%%%预处理%%%%%%%%%%%%%%%
%样本8*3矩阵
X=[0,0,0;1,0,0;1,0,1;1,1,0;0,0,1;0,1,1;0,1,0;1,1,1];
%类别
class=[1,1,1,1,-1,-1,-1,-1];
%修改权重c
c=1;
% 初始化权重
w=[-1,-2,-2,0];
%判别准则是<=0的次数
err_count=1;
%M=3，N=8
[N,M]=size(X);
%增广X,同时负例乘-1
X=[X,ones(N,1)];
std=zeros(N,M+1);
for i=1:N
    std(i,:)=X(i,:)*class(i);
end

%%%%%%%%%%%%%%%迭代%%%%%%%%%%%%%%%
% 当错误次数为0时，即全部分类正确时停止
count=0;
fprintf('初始权重值为:w1=%d w2=%d w3=%d,w4=%d\n',w);
while(err_count>=1)
    err_count=0;
    for i=1:N
        if dot(w,std(i,:))<=0   %分类错误，惩罚，更改权重
            w=w+c*std(i,:);
            err_count=err_count+1;
            count=count+1;
            fprintf('第%d次更新权重值为:w1=%d w2=%d w3=%d,w4=%d\n',count,w);
            
            % %%%%%%%%%%%%%%画图%%%%%%%%%%%%%%%
            xmin=-2;xmax=2;ymin=-2;ymax=2;zmin=-2;zmax=2;
            axis([xmin xmax ymin ymax zmin zmax]);
        
            %散点图
            figure(1);
            plot3(X(1:4,1),X(1:4,2),X(1:4,3),'ro','MarkerFaceColor','r');%正例
            hold on
            plot3(X(5:8,1),X(5:8,2),X(5:8,3),'ro','MarkerFaceColor','g');%反例
            hold on
            fimplicit3(@(x1,x2,x3) w(1)*x1+w(2)*x2+w(3)*x3+w(4))
            hold off
            title(sprintf("第%d次迭代超平面", count));
            xlabel('x1');
            ylabel('x2');
            zlabel('x3');
            
            %绘制GIF
            drawnow;
            for i=1:36%旋转
                camorbit(10,0,'data',[0,0,1])%[0 0 1]表示按z轴旋转。36*10=360表示旋转一周
                drawnow
                F=getframe(gcf);
                I=frame2im(F);
                [I,map]=rgb2ind(I,256);
                if count == 1
                    imwrite(I,map,'感知器.gif','gif', 'Loopcount',inf,'DelayTime',0.1);
                else
                    imwrite(I,map,'感知器.gif','gif','WriteMode','append','DelayTime',0.1);
                end
            end
            F=getframe(gcf);
            I=frame2im(F);
            [I,map]=rgb2ind(I,256);
            if count == 1
                imwrite(I,map,'感知器.gif','gif', 'Loopcount',inf,'DelayTime',1);
            else
                imwrite(I,map,'感知器.gif','gif','WriteMode','append','DelayTime',1);
            end
            
        else                    %分类正确，奖励，不更改
            w=w;
        end
    end
end
