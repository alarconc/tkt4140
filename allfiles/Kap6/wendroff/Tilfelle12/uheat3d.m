% program uheat3d
% Motstr�msvarmeveksler
% Tilfelle 1 og 2 i avsnitt 6.7 og appendiks 11
% Som uheat2d, men plotter i 3D
clear; close
clearvars -global b1 b4 c4 ;
global b1 b4 c4;
N = 50; % antall xskritt
nmax = 50; % antall tidskritt

nstep = 5; % Antall skritt for �kning av u0
       % nstep = 0 setter direkte u0 = 1        
if nstep >= nmax
    disp('-- nmax m� v�re > enn nstep ! --');
    return
end
% stepcase = 1 : Line�r �kning av u0 
% stepcase = 2 : �kning etter 2.gradspolynom
% stepcase = 3 : �kning etter 3.gradspolynom
% Verdien av stepcase vilk�rlig for nstep = 0
stepcase = 1;
dx = 1/N;
dt = dx; % For st�rst n�yaktighet
tend = dt*nmax;
u = zeros(N,1); d1 = u; d2 = u;
v = zeros(N,1); U = zeros(N+1,1);
T = zeros(nmax+1,N+1);
Tyr = 100; Tir = 30;
Tdiff = Tyr - Tir;
T(1,1:N+1) = Tir;
alfy = 0.9;
alfi = 0.2;
 % b = wi/wy;
% Tilfelle 1 : b = 1
% Tilfelle 2: b = 1.5
b = 1.0;
b1 = 1 + 4*N/alfy;
b5 = 4*N/alfy - 1;
b4 = -(1 + 2*N*(b + 1)/alfi);
c6 = 1 - 2*N*(b + 1)/alfi;
c4 = 2*N*(b - 1)/alfi - 1;
b6 = 2*N*(b - 1)/alfi + 1;
for n = 1: nmax
    if n <= nstep
        f1 = n/nstep;
        f2 = (n+1)/nstep;
        % === Line�r �kning av u0 ===
        if stepcase == 1
            u0n   = f1;
            u0np1 = f2;
        end
        % === �kning etter 2.gradspolynom ===
        if stepcase == 2
            u0n   = f1*(2 - f1);
            u0np1 = f2*(2 - f2);
        end
        % === �kning etter 3.gradspolynom ===
        if stepcase == 3
            u0n   = f1*(3 - f1^2)/2;
            u0np1 = f2*(3 - f2^2)/2; 
        end
    else
        u0n = 1;
        u0np1 = 1;
    end
    d1(1) = -u0np1 + b5*u0n - u(1) + v(2) + v(1);
    d2(1) = - (u0n + u0np1) - u(1) + b6*v(1) + c6*v(2);
    for i = 2:N - 1
        d1(i) = b5*u(i-1) - u(i) + v(i+1) + v(i);
        d2(i) = -u(i) - u(i-1) + b6*v(i) + c6*v(i+1);
    end
     d1(N) = b5*u(N - 1) - u(N) + v(N);
     d2(N) = -u(N) - u(N - 1) + b6*v(N);
    [u,v] = bitris2(d1,d2);
    U = [u0n;u];
    U = Tdiff*U + Tir;
    T(n+1,1:N+1) = U;
end
x = (0:dx:1)';
t = (0:dt:tend)';
mesh (x,t,T);
svart = zeros(64,3);
colormap(svart);
title('Temperatur T{_y}','FontSize',14);
xlabel('x','FontSize',14);
ylabel('t','FontSize',14);

