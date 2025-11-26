function generarPlanosFinales(coefs, x_track, puntos_riesgo, x_min_zona1, x_max_zona1, x_min_zona2, x_max_zona2)
    fig = figure('Name', 'Plano de Ingeniería de Pista F1', ...
                 'Color', 'k', 'Position', [100 100 1200 800], 'Visible', 'on');  
    movegui(fig,'center');            
    set(0, 'CurrentFigure', fig);

    % --- PANEL 1: VISTA GENERAL ---
    subplot(2, 2, [1 2]); 
    hold on; grid on; axis equal; 
    title('Plano General: Trazo, Puntos Críticos y Gradas');
    xlabel('Distancia x (m)'); ylabel('Distancia y (m)');
    
    y_track = polyval(coefs, x_track);
    plot(x_track, y_track, 'b-', 'LineWidth', 2);

    if ~isempty(puntos_riesgo)
        for k = 1:size(puntos_riesgo,1)
            x_derrape = puntos_riesgo(k,1);
            idx = find(x_track >= (x_derrape - 10) & x_track <= (x_derrape + 10));
            plot(x_track(idx), y_track(idx), 'y-', 'LineWidth', 3);
        end
    end

    dibujarElementosZona(coefs, x_min_zona1, x_max_zona1, 'Zona 1');
    dibujarElementosZona(coefs, x_min_zona2, x_max_zona2, 'Zona 2');

    if ~isempty(puntos_riesgo)
        plot(puntos_riesgo(:,1), puntos_riesgo(:,2), 'rh', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
    end

    % --- Leyenda PANEL 1 ---
    h_pista = plot(NaN,NaN,'b-','LineWidth',2);
    h_derrape = plot(NaN,NaN,'y-','LineWidth',3);
    h_gradas = plot(NaN,NaN,'c-','LineWidth',8);
    h_riesgo = plot(NaN,NaN,'rh','MarkerFaceColor','r');
    legend([h_pista, h_derrape, h_gradas, h_riesgo], ...
           {'Pista','Zona de Derrape','Gradas','Punto Crítico'}, ...
           'TextColor','w', 'Location','best');
    hold off;

    % --- PANEL 2: ZOOM ZONA 1 ---
    subplot(2, 2, 3);
    hold on; grid on; axis equal;
    title('Ampliación: Zona Crítica 1');
    plot(x_track, y_track, 'b-', 'LineWidth', 1.5);
    dibujarElementosZona(coefs, x_min_zona1, x_max_zona1, '');
    
    idx_p1 = find(puntos_riesgo(:,1) >= x_min_zona1 & puntos_riesgo(:,1) <= x_max_zona1);
    if ~isempty(idx_p1)
        plot(puntos_riesgo(idx_p1,1), puntos_riesgo(idx_p1,2), 'rh', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
        for k = 1:length(idx_p1)
            tramo = find(x_track >= puntos_riesgo(idx_p1(k),1)-10 & x_track <= puntos_riesgo(idx_p1(k),1)+10);
            plot(x_track(tramo), y_track(tramo), 'y-', 'LineWidth', 3);
        end
    end
    xlim([x_min_zona1 - 20, x_max_zona1 + 20]);
    y_local = y_track(x_track >= x_min_zona1 & x_track <= x_max_zona1);
    ylim([min(y_local) - 30, max(y_local) + 30]);

    % --- Leyenda PANEL 2 ---
    h_pista_z1 = plot(NaN,NaN,'b-','LineWidth',1.5);
    h_derrape_z1 = plot(NaN,NaN,'y-','LineWidth',3);
    legend([h_pista_z1,h_derrape_z1],{'Pista','Zona de Derrape'},'TextColor','w','Location','best');
    hold off;

    % --- PANEL 3: ZOOM ZONA 2 ---
    subplot(2, 2, 4);
    hold on; grid on; axis equal; 
    title('Ampliación: Zona Crítica 2');
    plot(x_track, y_track, 'b-', 'LineWidth', 1.5);
    dibujarElementosZona(coefs, x_min_zona2, x_max_zona2, '');
    
    idx_p2 = find(puntos_riesgo(:,1) >= x_min_zona2 & puntos_riesgo(:,1) <= x_max_zona2);
    if ~isempty(idx_p2)
        plot(puntos_riesgo(idx_p2,1), puntos_riesgo(idx_p2,2), 'rh', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
        for k = 1:length(idx_p2)
            tramo = find(x_track >= puntos_riesgo(idx_p2(k),1)-10 & x_track <= puntos_riesgo(idx_p2(k),1)+10);
            plot(x_track(tramo), y_track(tramo), 'y-', 'LineWidth', 3);
        end
    end
    xlim([x_min_zona2 - 20, x_max_zona2 + 20]);
    y_local2 = y_track(x_track >= x_min_zona2 & x_track <= x_max_zona2);
    ylim([min(y_local2) - 30, max(y_local2) + 30]);

    % --- Leyenda PANEL 3 ---
    h_pista_z2 = plot(NaN,NaN,'b-','LineWidth',1.5);
    h_derrape_z2 = plot(NaN,NaN,'y-','LineWidth',3);
    legend([h_pista_z2,h_derrape_z2],{'Pista','Zona de Derrape'},'TextColor','w','Location','best');
    hold off;
end

% --- FUNCIÓN AUXILIAR INTELIGENTE ---
function h_line = dibujarElementosZona(coefs, x_start, x_end, etiqueta)
    distancia_seguridad = 20;
    x_centro = (x_start + x_end)/2;
    d2_coefs = polyder(polyder(coefs));
    concavidad = polyval(d2_coefs, x_centro);

    if concavidad < 0
        dir_factor = 1;  
    else
        dir_factor = -1; 
    end

    x_vec = [x_centro-40, x_centro+40];
    y_pista = polyval(coefs, x_vec);
    dydx = polyval(polyder(coefs), x_vec);
    theta = atan(dydx);

    x_grada = x_vec - (distancia_seguridad*dir_factor)*sin(theta);
    y_grada = y_pista + (distancia_seguridad*dir_factor)*cos(theta);

    h_line = line(x_grada, y_grada, 'Color', 'c', 'LineWidth', 8);
    line(x_grada, y_grada, 'Color', 'b', 'LineWidth', 1, 'LineStyle', '--');

    if ~isempty(etiqueta)
        text(x_grada(1), y_grada(1), etiqueta, 'FontWeight', 'bold', 'BackgroundColor', 'k');
    end

    m = polyval(polyder(coefs), x_centro);
    y_c = polyval(coefs, x_centro);
    b = y_c - m*x_centro;
    x_tan = [x_centro-15, x_centro+15];
    y_tan = m*x_tan + b;
    plot(x_tan, y_tan, 'g--', 'LineWidth', 1.5);
end