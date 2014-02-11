 function pendcar3
% Som pendcar, men bruker 3 ligninger,
% slik at krafta z i pendelstanga ogs� beregnes.
% z = S/mg , S er den dimensjonelle krafta.
% L�ser bevegelsesligningene for en 
% vanlig pendel med store utslag.
% Bruker kartesiske koordinater
% Ligninger :
%  x'' =   - x*z
%  y'' = 1 - y*z
%  z'  = 3y'
% Ligningene er skrevet p� dimensjonsl�s form

% === Variable ===
% Setter x = y1 , y = y3 , z = y5,
% slik at d(x)/dt = d(y1)/dt = y2
% og d(y)/dt = d(y3)/dt = y4, z' = d(y5)/dt 
%

% === Innlesning av tidsverdier ====
tstopp = input('Simuleringstid = ? ');
antall = input('Antall tidskritt = ? ');
tstart = 0.0; 
tspan = linspace(tstart,tstopp,antall);

% === Innlesning av startvinkel ====
theta0 = input('theta0(grader) = ? ');
theta = theta0*pi/180; % theta0 i radianer
x0 = sin(theta);
y0 = cos(theta);
% === Andre startverdier ===
dx0 = 0; % Starthastighet 
dy0 = 0; % Starthastighet
z0  = y0;  % = cos(theta). Startkraft (statisk)

% ======== Plotting av startverdier =======
clf reset;
xl1 = [0; x0]; yl1 = [0 ; y0];
xl2 = [-1; 1]; yl2 = [0 ; 0];
xl3 = [0; 0]; yl3 = [-1 ; 1];
FS = 'FontSize'; FW = 'FontWeight'; LW = 'LineWidth';
hold on
plot(xl1,yl1,'-o',LW,3);
plot(xl2,yl2,'r',xl3,yl3,'r',LW,2);
grid on
axis([-1 1 -1 1],'ij');
xlabel('x',FW,'Bold',FS,14);
ylabel('y','Rotation',0,FW','Bold',FS',14);
hold off
st = sprintf('Startverdi : \\theta_0 = %4.2f\\circ',theta0);
title(st,FS,13);
pause;

% ==== L�ser diff-ligningene ===
ystart =[x0; dx0; y0; dy0; y0];
options = odeset('RelTol',1.0e-5);
[t,y] = ode45(@fcn,tspan,ystart,options);

% === Test av f�ringsbetingelser ===
n = length(t);
f1 = zeros(n,1); f2 = f1;
f1 = 1 -  sqrt((y(:,1).^2 + y(:,3).^2)); % Geometrisk f�ringsbetingelse
f2 = y(:,1).*y(:,2) + y(:,3).*y(:,4);% Hastighetsf�ringsbetingelse 
plot(t,f1,t,f2,'r',LW,1.5)
grid on
st1 = sprintf('f_1 = 1 - \\surd({x}^{2} + {y}^2) (bl�) ');
st2 = sprintf(', f_2 = x\\cdotx'' + y\\cdoty'' (r�d)');
st = [st1 st2];
title(st,FS,11,FW','Bold');
xlabel('t',FS,14,FW,'Bold');
ylabel('f_1 , f_2 ',FS,14,FW,'Bold');
pause;
if (max(abs(f1)) | max(abs(f1))) < 0.2
    return
end
% === Plotter pendel n�r avviket i pendel-lengden
% === er mer enn 20%
X = y(:,1); Y = y(:,3);
X = [0;X]'; Y = [0;Y]';
xmax = max(1,max(X)); ymax = max(1,max(Y));
xmin = min(-1,min(X)); ymin = min(-1,min(Y));
% === Plotter ===
% gstring = 'Xor'; 
% plotting(X,Y,n,gstring,xmin,xmax,ymin,ymax);
% pause(3);
gstring = 'None'; 
plotting(X,Y,n,gstring,xmin,xmax,ymin,ymax);

% ==============================================
function plotting(X,Y,n,gstring,xmin,xmax,ymin,ymax)
clf reset;
n = length(X) - 1;
axes('DrawMode','Normal','Box','on');
axis([xmin xmax ymin ymax],'ij');
set(gca,'DataAspectRatio',[1 1 1]);
grid on
lhandle = line(X(1:2),Y(1:2));
set(lhandle,'LineWidth',1.5,'EraseMode',gstring,'Color',[1 0 0],...
    'Marker','o','MarkerEdgeColor','b');
for counter = 1: n - 1
    set(lhandle,...
        'XData',[X(1) X(counter +  1)],...
        'YData',[Y(1) Y(counter +  1)]);
        drawnow;
    pause(0.1)
end
%==============================================================
function dydt = fcn(t,y)
% Differential-ligning
dydt = zeros(size(y));
dydt(1) = y(2);
dydt(2) = - y(1)*y(5);
dydt(3) = y(4);
dydt(4) = 1 - y(3)*y(5);
dydt(5) = 3*y(4);