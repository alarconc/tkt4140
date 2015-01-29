% program ftanalyt
% Avsnitt 2.4.1
% Beregner analytisk l�sning av en sirkul�r 
% vanntank der veggtykkelsen er konstant.
% Lager tabeller for fysiske verdier
% basert p� data nedenfor.
clear
R = 8.5;   % Tankradius(m)
H = 7.95;  % H�yde(m)
t = 0.35;  % Veggtykkelse (m)
ny = 0.2;  % Poissons tall
E = 2.0e10;  % E-modul MPa
ga = 9810;  % Egenvekt (N/m^3)

b4 = 3*(1 - ny^2)*H^4/(R*t)^2;
b = b4^0.25;
K1 = ga*H*R^2/(E*t); K2 = 0.25*ga*H^3/b4;
fprintf('beta = %12.5e \n',b);
s2b =sin(2*b); cb = cos(b); cb2 = cb^2;

J = 4*b*(cb2 + cosh(b)^2);
C1 = (2*cb2*(b-1) - s2b*b + b*(1+exp(-2*b)))/J;
C2 = (2*cb2*b + s2b*(b-1) - (1+b)*(1+exp(-2*b)))/J;
C3 = (2*cb2*(1+ b) + s2b*b + b*(1+exp(2*b)))/J;
C4 = -(2*cb2*b -s2b*(1+ b) + (1-b)*(1+exp(2*b)))/J;

% --- Beregner og skriver ut w, w' w'' og w''' ---
%     wp og dwp er bidraget fra partikul�rl�sningen

dx = 0.05; kmax = 1 + round(1/dx);
w = zeros(kmax,1); dw = w; d2w = w; d3w = w;
% dimensjoner : utb�yningen i meter
%               moment i Nm/m
%               skj�rkraft i N/m
for k = 1:kmax 
    x = (k - 1)*dx;
    wp = -(1 - x);
    sbx = sin(b*x); cbx = cos(b*x);
    wh = exp(b*x)*(C1*cbx + C2*sbx) + exp(-b*x)*(C3*cbx + C4*sbx);
    w(k) = K1*(wh + wp);
    t1 = exp(b*x)*((cbx - sbx)*C1 + (sbx + cbx)*C2);
    t2 = exp(-b*x)*(-(cbx + sbx)*C3 + (cbx - sbx)*C4);
    dwp = 1;
    dw(k) = K1*(b*(t1 + t2) + dwp)/H;
    t1 = exp(b*x)*(-C1*sbx + C2*cbx);
    t2 = exp(-b*x)*(C3*sbx - C4*cbx);
    d2w(k) = K2*(2*b^2*(t1 + t2));
    t1 = exp(b*x)*(-C1*(sbx + cbx) + C2*(cbx - sbx));
    t2 = exp(-b*x)*(C3*(cbx - sbx) + C4*(cbx + sbx));
    d3w(k) = K2*(2*b^3*(t1 + t2))/H;
end
x = (0 : dx :1.0)';
% s1 = '    x         w            w''(x)';
% s2 = '            w''''(x)         w''''''(x)\n \n';
s1 = '    x         W            W''(x)';
s2 = '           M(x))          V(x)  \n \n';
fprintf([s1,s2]);
fprintf('%6.3f  %13.5e  %13.5e   %13.5e  %13.5e \n',[x w dw -d2w -d3w]');
