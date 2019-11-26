
function []=animation(time,theta,a,image,sd)
fh1=figure('Name','Visual Servoing of 2-link robot','NumberTitle','off');
set(fh1, 'color', 'white','position',[600 100 400 550])

for i=1:size(theta,1)
    %Image
    fprintf('\n%2f\n',time(i));
    subplot(5,1,1:2)
    plot(sd(1),sd(2),'o',...
        'LineWidth',1,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','r',...
        'MarkerSize',10);
    title('Camera image')
    hold on;
    plot(image(i,1),image(i,2),'o',...
        'LineWidth',1,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','g',...
        'MarkerSize',10);
    xlabel('X (m)','FontSize',10);
    ylabel('Y (m)','FontSize',10);
    h=legend('Desired image','Current image');
    set(h,'Orientation','horizontal','Color', 'none','Box', 'off','Location','best','fontsize',10,'fontweight','n','fontname','times new romans','linewidth',0.5);
    axis([-1 1 -1 1]);
    drawnow
    hold off;
    
    %Robot
    th1=theta(i,1); th2=theta(i,2); a1=a(1); a2=a(2);
    xx1=a1*cos(th1); yy1=a1*sin(th1);
    xx2= xx1+a2*cos(th1+th2); yy2=yy1+a2*sin(th1+th2);
    xp=[0; xx1; xx2]; yp=[0; yy1; yy2];
    subplot(5,1,3:5);
    plot(1,0,'o',...
        'LineWidth',1,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','k',...
        'MarkerSize',10);
    h=legend('Point Location (Top view)');
    set(h,'Orientation','horizontal','Color', 'none','Box', 'off','Location','best','fontsize',10,'fontweight','n','fontname','times new romans','linewidth',0.5);
    hold on;

    plot(xp,yp,'b','linewidth',2)
    %     title('Top view of Robot')
    grid on;
    xlabel('X (m)','FontSize',10);
    ylabel('Y (m)','FontSize',10);
    axis([-2 2 -2 2]);
        hold off;
    drawnow
end
% end
