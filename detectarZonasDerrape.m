function zonas = detectarZonasDerrape(R, x_track)
    % Regiones donde el radio es menor a 50 m (condición de derrape)
    idx = find(R < 50);

    zonas = [];

    if isempty(idx)
        disp('No hay zonas de derrape (R < 50 m).');
        return;
    end

    % Detectar rupturas entre índices consecutivos
    saltos = find(diff(idx) > 1);

    inicios = idx([1, saltos + 1]);
    finales = idx([saltos, end]);

    fprintf('\n=== ZONAS DE DERRAPE (R < 50 m) ===\n');

    for k = 1:length(inicios)
        i_start = inicios(k);
        i_end = finales(k);

        x_start = x_track(i_start);
        x_end   = x_track(i_end);

        % Radio mínimo dentro del intervalo
        [Rmin, local_idx] = min(R(i_start:i_end));
        x_minimo = x_track(i_start + local_idx - 1);

        fprintf('Zona %d: [%.2f m  - %.2f m],  Rmin = %.2f m\n', ...
                k, x_start, x_end, Rmin);

        zonas = [zonas; x_start, x_end, x_minimo, Rmin];
    end
end
