% Plot Joint velocities

function []=joint_vel(time,dtheta)

fh1=figure(3);
set(fh1, 'color', 'white');
title(' Joint Velocities ','FontSize',10); % sets the color to white 
plot(time,dtheta,'linewidth',2);
set (gca,'fontsize',10,'fontweight','n','fontname','times new romans','linewidth',1,'Box', 'off','TickDir','out' );
% title(' Joint Velocities ','FontSize',10);
xlabel('time (s)','FontSize',10);
ylabel('Rates of joint angle (rad/s)','FontSize',10);
l1=legend('$\dot{\theta_1}$','$\dot{\theta_2}$');
set(l1,'interpreter','latex','Orientation','h','Location','northoutside','Color', 'none','Box', 'off','FontAngle','italic','fontsize',10,'fontweight','normal','fontname','times new romans','linewidth',0.5)

