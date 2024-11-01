clearvars;
clc;



e = 1.602e-19; %C
m = 9.189e-31; %Kg
q = -e;
u0 = (4*pi)*1e-7;
I = 0.29;

deltaV = 4e3;     % V

B0 = u0 * ((4/5)^(3/2)) * 320*I/0.067; %Teslas

B = B0*[0,0,1];
%******************

a = @(v,B,m) (q/m) * (cross(v,B));

v0x = sqrt(abs(2*q*deltaV/m));
v0 = [v0x,0,0];

r0 = [0.008,0,0];


ti = 0;
tf = 50e-10;

N = 1e3;
h = (tf-ti)/N;

t = zeros(N,1);
r = zeros(N,3);
v = zeros(N,3);

t(1) = ti;
r(1,:) = r0;
v(1,:) = v0;

for i=1:N

    t(i+1) = t(i) + h;

    v(i+1,:) = v(i,:) + h*a(v(i,:),B,m); 
    r(i+1,:) = r(i,:) + h*v(i,:);

     if (r(i,1)>=0.07)
         break;
     end
end

% figure(1)
% plot(r(:,1)*100,r(:,2)*100, 'ob')
% xlabel('Eje x (cm)')
% ylabel('Eje y (cm)')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Experimental

Exp_points_x = [2.000e-2, 2.220e-2, 2.639e-2, 3.062e-2, 3.318e-2, 3.544e-2, 3.790e-2, 4.087e-2, 4.200e-2, 4.374e-2, 4.588e-2, 4.722e-2, 4.855e-2, 5.009e-2, 5.220e-2, 5.370e-2, 5.531e-2, 5.711e-2, 5.850e-2, 6.001e-2, 6.180e-2, 6.380e-2, 6.600e-2, 6.789e-2, 7.000e-2]'; 
Exp_points_y = [2.660e-3, 3.134e-3, 3.974e-3, 5.025e-3, 5.614e-3, 6.091e-3, 6.781e-3, 7.691e-3, 8.033e-3, 8.598e-3, 9.382e-3, 9.730e-3, 1.018e-2, 1.074e-2, 1.163e-2, 1.229e-2, 1.295e-2, 1.373e-2, 1.439e-2, 1.505e-2, 1.593e-2, 1.701e-2, 1.811e-2, 1.920e-2, 2.029e-2]';

% figure(2)
% plot(Exp_points_x*100, Exp_points_y*100)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interpolacion

xt = (2.06e-2:1e-3:6.99e-2)';
y_Simulacion = zeros(size(xt));

x = r(66:341,1);
y = r(66:341,2);

for j=1:size(xt,1)

    y_Simulacion(j) = Spline_method(x, y, xt(j));

end

% figure(3)
% plot(xt*100, y_Simulacion*100, '-b')
% hold on;
% plot(r(108:376,1)*100,r(108:376,2)*100, 'or')
% hold off;

%%%%%%%%%%%%%%

y_Exp_Inter = zeros(size(xt));

for j=1:size(xt,1)

    y_Exp_Inter(j) = Spline_method(Exp_points_x, Exp_points_y, xt(j));

end

% figure(4)
% plot(xt*100, y_Exp_Inter*100, '-b')
% hold on;
% plot(Exp_points_x*100,Exp_points_y*100, 'or')
% hold off;


figure(5)
plot(xt*100, y_Exp_Inter*100, '-b', LineWidth=3)
hold on;
plot(xt*100,y_Simulacion*100, '-r', LineWidth=3)
hold off;
legend('Experimental', 'Simulación')
xlabel('x(cm)')
ylabel('y(cm)')

D = 0;

for i=size(xt,1)

    D = D + abs(y_Simulacion(i) - y_Exp_Inter(i));

end

error = (1 - 1/(1+D))*100;