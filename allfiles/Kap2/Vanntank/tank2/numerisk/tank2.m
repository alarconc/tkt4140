% Program tank2
% Section 2.4.2 : Cylinrical water tank
% wit a linear varying wall thickness.
% The computation is based on given dimensions.
% Compute the displacement, shearforce and bending moment using
% a shooting technique.
% Equation med y = 1-a*x, a = alfa :
% w''''(x) -(6*a/y)*w'''(x)+ (6*a^2/y^2)*w''(x)
%       + (4*beta^4/y^2)*w(x)= -4*beta^4*(1-x)/y^3
% Boundary conditions : w(0) = 0, w'(0) = 0, w''(1)=0, w'''(1) = 0
% The equation is linear but stiff when beta is large.
%
clear; clear global beta4 alfa;
global beta4 alfa;
% === Data ===
R = 8.5;   % Radius[m]
H = 7.95;  % Height[m]
t0 = 0.35; % Thickness (bottom)[m]
t1 = 0.1;  % Thickness (top)[m]
ny = 0.2;  % Poisson's ratio
beta = H*(3*(1-ny^2)/(R*t0)^2)^0.25;
alfa = (t0 - t1)/t0;
fprintf('     beta = %7.4f\n',beta);
fprintf('     alfa = %7.4f\n',alfa);
beta4 = beta^4;
xspan = [0 1.0];
s = [0 0 1];  r = [0 1 0];
options = odeset('Reltol',1.0e-7,'AbsTol', 1.0e-7);
phi = zeros(3,1); psi = phi;
% ===== Shooting three times to find s* and r* =====
for k = 1:3   
   y0 = [0.0; 0.0 ; s(k) ; r(k)]; 
   [x,y] = ode45(@fcntank2,xspan,y0,options);
   phi(k) = y(end,3);
   psi(k) = y(end,4);
end
nev = (psi(3)-psi(1))*(phi(2)-phi(1)) - (phi(3) - phi(1))*(psi(2)-psi(1));
rstar= (phi(3)*psi(1) - psi(3)*phi(1))/nev;
sstar = (psi(2)*phi(1) - phi(2)*psi(1))/nev;
fprintf('     r* = %12.5e  s* = %12.5e \n\n',rstar,sstar);
% ===== Table of displacement w ,slope dw/dx etc. =====
xspan = (0: 0.1 :1.0);
y0 = [0.0 ;0.0 ;sstar; rstar];
[x,y] = ode45(@fcntank2,xspan,y0,options);
z = 1 - alfa*x;
mx = - z.^3.*y(:,3);
vx = 3*alfa*z.^2.*y(:,3) -z.^3.*y(:,4);
fprintf('       x         w             dw/dx           m(x)            v(x)\n\n');
fprintf( '%10.3f  %13.5e  %13.5e   %13.5e  %13.5e \n',[x y(:,1),y(:,2),mx,vx]');
m = -y(:,3)/beta; v = -y(:,4)/beta^2;
% ====== Plotting m(x)/beta and v(x)/beta^2 =====
clf
plot(x,m,'k-',x,v,'k-.','LineWidth',1.25);
grid on
xlabel('x','FontSize',14)
st = sprintf('Water tank. \\beta = %5.4f',beta);
title(st,'Fontsize',14)
legend('m(x)/\beta','v(x)/\beta^2')
shg



  
 