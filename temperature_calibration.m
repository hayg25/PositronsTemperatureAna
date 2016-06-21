function [coefs] = temperature_calibration()


% 4 Layer target 
coefs_0deg=[0.046,0.065,0.043,0.002,0.050,0.034,0.010,0.040,0.012];
coefs_100deg=[6.664,6.665,6.663,6.66,6.664,6.665,6.663,6.664,6.662];
coefs_200deg=[13.324,13.326,13.325,13.326,13.326,13.327,13.327,13.323,13.326];
coefs_300deg=[19.999,19.999,19.999,20,19.999,20,19.999,20,19.999];



temp=[0,100,200,300];
for i=1:9
coefs_droite(1)=coefs_0deg(i);    
coefs_droite(2)=coefs_100deg(i);    
coefs_droite(3)=coefs_200deg(i);    
coefs_droite(4)=coefs_300deg(i);    
    
p = polyfit(temp,coefs_droite,1);

coefs(i)=1/p(1);


end

