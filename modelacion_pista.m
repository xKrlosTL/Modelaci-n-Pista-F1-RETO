function modelacion_pista()
    % nuestros puntos inciales
    points = [10 290;0 0; 0 0; 280 120];
    
    % Los ingresamos a nuestra matriz de puntos
    points(2, :) = [80, 350];
    points(3, :) = [200, 180];

    % Obtenemos Incognitas realizando una matriz de 4x4
    [a,b,c,d] = calcularIncognitas(points);
    coefs = [a b c d];

    % Primer filtro verificar que nuestra funcion si pase por pi, pf.
    if (pasaPorPiPf(points,coefs))
        disp("Si pasan por Pi y Pf");
    else
        disp("No pasan por Pi y Pf");
    end

    % Segundo filtro nuestra funcion debe tener una longitud de curva entre [300m,500m]
    if (calcularLongitudCurva(coefs))
        fprintf("La longitud de Curva esta dentro del rango \n");
    else
        disp("La longitud de Curva no esta dentro del rango");
    end
    
    % Calcular Puntos Min y Max
    [puntosMin, puntosMax] = calcularMinMax(coefs);
    disp("Punto Max");
    disp(puntosMax);
    disp("Punto Min")
    disp(puntosMin);

    % Determinamos zonas criticas
    x_track = 10:1:280;
    [R] = calcularRadioCurvatura(coefs, x_track);
    disp(R);

    zonas_derr = detectarZonasDerrape(R, x_track);
    disp("Zonas de derrape (R < 50 m):");
    disp(zonas_derr);

    % Analizar Seguridad
    puntos_riesgo = analizarZonasCriticas(R, x_track, coefs);

    % --- CALCULAR VELOCIDAD MÁXIMA DE DERRAPE ---
    mu_s = 0.9;      % fricción estática (puedes cambiar)
    theta = 0;       % pista plana
    if ~isempty(puntos_riesgo)
        R_derrape = puntos_riesgo(:,3); % radio mínimo de cada zona de derrape
        v_max = calcularVelocidadMaxima(R_derrape, theta, mu_s);
        for i = 1:length(v_max)
            fprintf('Velocidad máxima de derrape en Zona %d: %.2f m/s\n', i, v_max(i));
        end
    else
        disp('No hay zonas de derrape para calcular velocidad máxima.');
    end

    % Generar gráficos
    generarPlanosFinales(coefs, x_track, puntos_riesgo, ...
                         10, 50, ...    % Zona 1 (inicio, fin)
                         241, 280);     % Zona 2 (inicio, fin)
    disp("Reporte y Gráficas Generados Exitosamente.");
end

function [p2,p3] = propuestaPuntos()
   % hagamos que el usuario sea quien meta los puntos por ahora, despues
   % estaria bueno automatizarlo.
   % FALTA AGREGAR QUE NO SE REPITAN PUNTOS MANEJO DE ERROES BASICAMENTE
   disp("nuestros puntos actuales son pi = (10,290) y pf = (280,120) \n");
   p2x = input("ingresa coordenada x para fn3: ");
   p2y = input("ingresa coordenada y para fn3: ");
   p3x = input("ingresa coordenada x para fn4: ");
   p3y = input("ingresa coordenada y para fn4: ");
   p2 = [p2x,p2y];
   p3 = [p3x, p3y];
end
