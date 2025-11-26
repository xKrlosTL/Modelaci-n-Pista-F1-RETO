function v_max = calcularVelocidadMaxima(R, theta, mu_s)
    g = 9.81;

    % v_max por punto
    v_max = sqrt(R .* g .* (mu_s + tan(theta)));

    % Reemplazar velocidades imaginarias si R=0 o valores raros
    v_max(~isfinite(v_max)) = 0;
end