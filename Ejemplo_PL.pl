% Catálogo de vehículos
vehiculo(toyota, rav4, suv, 28000, 2022).
vehiculo(toyota, rav5, suv, 42000, 2022).
vehiculo(toyota, corolla, sedan, 22000, 2023).
vehiculo(toyota, tacoma, pickup, 35000, 2022).
vehiculo(ford, mustang, deportivo, 45000, 2023).
vehiculo(ford, explorer, pickup, 38000, 2021).
vehiculo(ford, fiesta, sedan, 20000, 2020).
vehiculo(ford, f150, pickup, 44000, 2022).
vehiculo(bmw, x5, suv, 60000, 2021).
vehiculo(bmw, m3, sport, 65000, 2023).
vehiculo(bmw, serie3, sedan, 48000, 2022).
vehiculo(honda, civic, sedan, 24000, 2023).
vehiculo(honda, hrv, suv, 9000, 2021).
vehiculo(honda, crv, suv, 29000, 2022).
vehiculo(chevrolet, silverado, pickup, 40000, 2022).

% Filtrar por tipo y presupuesto
meet_budget(Referencia, BudgetMax) :-
    vehiculo(_, Referencia, _, Precio, _), 
    Precio =< BudgetMax.

% Filtrar por marca
vehiculo_por_marca(Marca, ListaReferencias) :- 
    findall(Referencia, vehiculo(Marca,Referencia,_,_,_), ListaReferencias).

% Generar reporte
% Predicado para separar referencias y precios
separar([], [], []).
separar([[R, P] | T], [R | RT], [P | PT]) :- separar(T, RT, PT).

generar_reporte(Marca, Tipo, Presupuesto, ResultadoFinal) :-
% Se obtienen los vehículos que cumplen con el presupuesto y la marca
    findall([Referencia, Precio], 
            (vehiculo(Marca, Referencia, Tipo, Precio, _), 
            Precio =< Presupuesto),
            VehiculosCompletos),
% paso intermedio
    write('Lista completa de vehiculos: '), writeln(VehiculosCompletos), 

    % Separamos las referencias y precios
    separar(VehiculosCompletos, Referencias, Precios), 
    sumlist(Precios, TotalPrecio),
    (TotalPrecio =< 1000000 ->  % Verificamos el límite de 1 millón
        ResultadoFinal = [Referencias, TotalPrecio]
    ;
        write('Advertencia: Total excede 1 millón'), nl,
        fail
    ).
    
% Casos de test
% Caso 1: Listrar todos los SUV
test_caso_1(Resultado) :-
    findall(Referencia, 
        (vehiculo(toyota, Referencia, suv, Precio, _), Precio < 30000),
        Resultado).

% Caso 2
test_caso_2(Resultado) :-
    bagof((Type, Year, Reference), 
        Price^vehiculo(ford, Reference, Type, Price, Year), 
        Resultado).

% Caso 3
test_caso_3(Resultado, ValorTotal) :-
    findall((Marca, Referencia, Precio), 
            vehiculo(Marca, Referencia, sedan, Precio, _), 
            Sedans),
    sum_sedan_precios(Sedans, 0, ValorTotal, Resultado, 500000).

% Función auxiliar para el caso 3
sum_sedan_precios([], ActualTotal, ActualTotal, [], _).
sum_sedan_precios([(Marca, Referencia, Precio)|Rest], ActualTotal, FinalTotal, [(Marca, Referencia, Precio)|ResultadoRest], MaxBudget) :-
    NuevoTotal is ActualTotal + Precio,
    NuevoTotal =< MaxBudget,
    sum_sedan_precios(Rest, NuevoTotal, FinalTotal, ResultadoRest, MaxBudget).
sum_sedan_precios([(_, _, _)|Rest], ActualTotal, FinalTotal, Resultado, MaxBudget) :-
    sum_sedan_precios(Rest, ActualTotal, FinalTotal, Resultado, MaxBudget).