function[R_r, R_t, R_n, V_r, V_t, V_n] = ECEF2RTN(X, Y, Z, Vx, Vy, Vz)
% Transform position and velocity vectors from ECEF to RTN frame
% R : radial
% T : transverse(forward, along-track)
% N : normal


omega_E = [0; 0;  deg2rad(360)/24/60/60]; %Rotational angular velocity of earth

% r_cart = sqrt( X.^2 +  Y.^2 +  Z.^2);
% v_cart = sqrt(Vx.^2 + Vy_cart.^2 + Vz_cart.^2);

%Initialize vectors
len = length(X);
v_prime = zeros(length(len),3); % v' = v + cross(omega_E,r_i)
e_r = zeros(length(len),3); % unit vector in R direction
e_t = zeros(length(len),3); % unit vector in T direction
e_n = zeros(length(len),3); % unit vector in N direction
R_r = zeros(length(len),3); % pos vector in R direction 
R_t = zeros(length(len),3); % pos vector in T direction
R_n = zeros(length(len),3); % pos vector in N direction
V_r = zeros(length(len),3); % vel vector in R direction
V_t = zeros(length(len),3); % vel vector in T direction
V_n = zeros(length(len),3); % vel vector in N direction

for i = 1:len
    r_i = [X(i), Y(i), Z(i)];
    v_i = [Vx(i), Vy(i), Vy(i)];
    v_prime_i = v_i + cross(omega_E, r_i);
    v_prime(i,:) = v_prime_i;
    e_r_i = r_i/norm(r_i);
    e_r(i,:) = e_r_i;
    e_n_i = cross(r_i,v_prime_i)./norm(cross(r_i,v_prime_i));
    e_n(i,:) = e_n_i;
    e_t_i = cross(e_n_i,e_r_i);
    e_t(i,:) = e_t_i;

    R_r_i = r_i.*e_r_i;
    R_n_i = r_i.*e_n_i;
    R_t_i = r_i.*e_t_i;

    R_r(i,:) = R_r_i;
    R_t(i,:) = R_t_i;
    R_n(i,:) = R_n_i;
   
    V_r_i = v_i.*e_r_i;
    V_t_i = v_i.*e_t_i;
    V_n_i = v_i.*e_n_i;

    V_r(i,:) = V_r_i;
    V_t(i,:) = V_t_i;
    V_n(i,:) = V_n_i;
  
end
% size(R_r)

end
