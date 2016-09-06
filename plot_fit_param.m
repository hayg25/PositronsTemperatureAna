function plot_out = plot_fit_param(tau1,a1,tau2,a2)


figure 

 subplot = @(m,n,p) subtightplot (m, n, p, [0.14 0.08 0.05], [0.14 0.04 0.04], [0.14 0.04 0.04]);


subplot(2,2,1);
plot(1000./tau1,'--o','linewidth',3)
ytitle1='Fitting time constant \tau_{1}';
options(ytitle1);
subplot(2,2,2);
plot(1000./tau2,'--o','linewidth',3)
ytitle2='Fitting time constant \tau_{2}';
options(ytitle2);
subplot(2,2,3);
plot(a1,'--o','linewidth',3)
ytitle3='Fitting parameter a_{1}';
options(ytitle3);
subplot(2,2,4);
plot(a2,'--o','linewidth',3)
ytitle4='Fitting parameter a_{2}';
options(ytitle4);



function y = options(ytitle)

set(gca,'FontSize',20)
set(gcf, 'color', 'w');
xlhand = get(gca,'xlabel');
% set(xlhand,'string','Sphere ID','fontsize',20);
set(xlhand,'string','Beam period ID','fontsize',20);
ylhand = get(gca,'ylabel');
set(ylhand,'string',ytitle,'fontsize',20);
