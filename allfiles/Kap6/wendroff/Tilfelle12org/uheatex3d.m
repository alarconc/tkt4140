% program uheatex3d
% Motstr�msvarmeveksler
% Bygger p� eksempel 3-1 i Rosenberg, side 44
% Plotter i 3D
clear; close
clearvars -global b1 b4 ;
global b1 b4 c4;
nx = 20; % antall xskritt
nt = 10; % antall tidskritt

N = 0; % Antall skritt for �kning av u0
       % N = 0 setter direkte u0 = 1        
if N >= nt
    disp('-- nt m� v�re > enn N ! --');
    return
end
% stepcase = 1 : Line�r �kning av u0 
% stepcase = 2 : �kning etter 2.gradspolynom
% stepcase = 3 : �kning etter 3.gradspolynom
% Verdien av stepcase vilk�rlig for N = 0
stepcase = 1;
dx = 1/nx;
dt = dx; % For st�rst n�yaktighet
tend = dt*nt;
u = zeros(nx,1); d1 = u; d2 = u;
v = zeros(nx,1); U = zeros(nx+1,1);
T = zeros(nt+1,nx+1);
Tyr = 100; Tir = 30;
Tdiff = Tyr - Tir;
T(1,1:nx+1) = Tir;
alfy = 0.9;
alfi = 0.2;
b1 = 1 + 4*nx/alfy;
b5 = 4*nx/alfy - 1;
b4 = -(1 + 4*nx/alfi);
c6 = 1 - 4*nx/alfi;
for n = 1: nt
    if n <= N
        f1 = n/N;
        f2 = (n+1)/N;
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
    d2(1) = - (u0n + u0np1) - u(1) + v(1) + c6*v(2);
    for i = 2:nx - 1
        d1(i) = b5*u(i-1) - u(i) + v(i+1) + v(i);
        d2(i) = -u(i) - u(i-1) + v(i) + c6*v(i+1);
    end
     d1(nx) = b5*u(nx - 1) - u(nx) + v(nx);
     d2(nx) = -u(nx) - u(nx - 1) + v(nx);
    [u,v] = bitris2(d1,d2);
    U = [u0n;u];
    U = Tdiff*U + Tir;
    T(n+1,1:nx+1) = U;
end
x = (0:dx:1)';
t = (0:dt:tend)';
mesh (x,t,T);
svart = zeros(64,3);
colormap(svart);

