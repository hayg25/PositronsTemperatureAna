function[fit_mu,fit_sigma] =  PlotGranular(Data,Nmin,Nbins)


figure(33)
I_Axis_limits=[0,0.2];  
%I_Axis_limits=[0,3];  
I_Axis_limits=[0,4];  


V_Axis_limits=[100,120];  
 
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02 0.01], [0.02 0.02 0.01], [0.02 0.02 0.01]);

 	
%-----------------------------------------------
 Granular_sensor_positions=[13,8,14,18,12,3,15,23,11];
 xtitle_pos=[11,12,14,15];
 for i=1:9
    subplot(5,5,Granular_sensor_positions(i))
    hist(Data(i,Nmin:Nbins));

    xlim(I_Axis_limits);
    legend(sprintf('S(%d)',i),'FontSize',12);
    % set(handle,'Position',[0.5,0.5,0.5]);
    set(gca,'FontSize',12)

    rr=Data(i,Nmin:Nbins);
    pd=fitdist(rr(:),'normal');
    fit_mu(i) 	  = pd.mu;
    fit_sigma(i)  = pd.sigma;  
    fprintf('mu %g  sigma %g \n',pd.mu,pd.sigma);
 end

 for i=1:4
    subplot(5,5,xtitle_pos(i))
    xlabel(' Rise Time [sec]')
 end


figure(122)
hold on
% now plot the rise time mean and sigma 
errorbar(fit_mu([9 5 1 3 7]),fit_sigma([9 5 1 3 7]));
xlabel(' Sensor ID','FontSize',18)
ylabel('Rise time [s]','FontSize',18)

% set the proper label (to get the sensor id)
ax=gca;
set(ax,'XTickLabel',{'' '9' '' '5' '' '1' '' '3' '' '7' ''})
set(ax,'FontSize',18)
p = polyfit(fit_mu([9 5 1 3 7]),fit_sigma([9 5 1 3 7]),2);
% x1 = linspace(0,5);
% y1 = polyval(p,x1);
% plot(x1,y1)
