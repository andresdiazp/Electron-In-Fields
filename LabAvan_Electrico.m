clearvars;
clc;

e = 1.60217e-19;  % C 
q = e;            % C
m = 9.189e-31;    % Kg
V_salida = 4e3;     % V


V_placas = 2.5e3;  %Voltios
d = 0.05086; %metros

E0 = (3/4)*V_placas/d;      %V/m

E = E0*[0,1,0];
%******************

a = @(v,E,m) (q/m) * (E);

v0x = sqrt(2*q*V_salida/m);

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

    v(i+1,:) = v(i,:) + h*a(v(i,:),E,m); 
    r(i+1,:) = r(i,:) + h*v(i,:);

     if (r(i,1)>=0.09)
         break;
     end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Experimental

Exp_points_x = [2.00e-2, 2.1094e-2, 2.701e-2, 3.068e-2, 3.312e-2, 3.546e-2, 3.789e-2, 4.042e-2, 4.163e-2, 4.375e-2, 4.577e-2, 4.717e-2, 4.859e-2, 5.009e-2, 5.220e-2, 5.370e-2, 5.531e-2, 5.711e-2, 5.850e-2, 6.001e-2, 6.180e-2, 6.380e-2, 6.600e-2, 6.789e-2, 7.000e-2]'; 
Exp_points_y = [7.502e-4, 7.9522e-4, 2.085e-3, 3.173e-3, 3.795e-3, 4.619e-3, 5.550e-3, 6.588e-3, 7.156e-3, 8.177e-3, 9.193e-3, 9.976e-3, 1.066e-2, 1.155e-2, 1.287e-2, 1.387e-2, 1.487e-2, 1.608e-2, 1.717e-2, 1.816e-2, 1.948e-2, 2.101e-2, 2.255e-2, 2.397e-2, 2.571e-2]';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interpolacion
xt = (2.06e-2:1e-3:6.99e-2)';
y_Simulacion = zeros(size(xt));

x = r(65:333,1);
y = r(65:333,2);

for j=1:size(xt,1)

    y_Simulacion(j) = Spline_method(x, y, xt(j));

end


%%%%%%%%%%%%%%

y_Exp_Inter = zeros(size(xt));

for j=1:size(xt,1)

    y_Exp_Inter(j) = Spline_method(Exp_points_x, Exp_points_y, xt(j));

end


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



