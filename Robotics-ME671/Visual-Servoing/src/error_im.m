% Plot Error
function []=error_im(time,err)

fh1=figure(2);
set(fh1, 'color', 'white'); % sets the color to white 
plot(time,err,'linewidth',2);
set (gca,'fontsize',10,'fontweight','n','fontname','times new romans','linewidth',1,'Box', 'off','TickDir','out' );
title(' Error in image coordinates ','FontSize',10);
xlabel('time (s)','FontSize',10);
ylabel('Error (m)','FontSize',10);
h=legend('Error');
set(h,'Orientation','v','Color', 'none','Box', 'off','Location','best','fontsize',10,'fontweight','n','fontname','times new romans','linewidth',0.5, 'Location', 'SouthEast')

