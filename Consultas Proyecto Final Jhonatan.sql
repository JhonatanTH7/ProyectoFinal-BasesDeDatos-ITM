
--------------------------- CONSULTAS A LA BASE DE DATOS - PROYECTO FINAL JHONATAN TORO --------------------------

USE ClinicaVeterinariaProyectoFinal;



/* D.	Hacer 4 consultas útiles para el usuario, que implementen los 4 tipos de Joins que hay. 
Cada consulta debe ir con su respectivo enunciado, y debe generar algún resultado. */

/* INNER JOIN
ENUNCIADO -> Mostrar la información de los propietarios, cuantas mascotas tienen registradas, 
cuantas Domesticas y cuantas Silvestres en caso de tener alguna registrada.
*/

SELECT
	P.nombre_propietario AS NombrePropietario, P.cedula AS CedulaPropietario, P.direccion AS DireccionPropietario, P.telefono AS TelefonoPropietario,
	SUM(CASE WHEN TF.nombre_fauna  = 'domestica' THEN 1 ELSE 0 END) AS TotalMascotasDomesticas,
    SUM(CASE WHEN TF.nombre_fauna = 'silvestre' THEN 1 ELSE 0 END) AS TotalMascotasSilvestres,
	COUNT(M.id_mascota) AS TotalMascotas
FROM
	Propietario P
INNER JOIN 
	Mascota M ON P.id_propietario = M.id_propietario
INNER JOIN 
	TipoFauna TF ON M.id_tipofauna = TF.id_tipofauna
GROUP BY P.nombre_propietario, P.cedula, P.direccion, P.telefono
ORDER BY TotalMascotas DESC;


/* LEFT JOIN 
ENUNCIADO -> Mostrar todas las citas del salon de belleza y sus servicios (en caso de tenerlos) proximos a la fecha actual, se debe mostrar la información 
del usuario, la mascota, la cita y el servicio prestado.
*/

SELECT 
	P.nombre_propietario AS NombrePropietario, P.telefono AS TelefonoPropietario,
	M.nombre AS NombreMascota,
	E.nombre_especie AS EspecieMascota,
    C.fecha AS FechaCita, C.hora_inicio AS HoraCita, C.estado AS EstadoCita,
    TS.nombre_tipo_serviciobelleza AS TipoServicio,
    S.estado_serviciobelleza AS EstadoServicio
FROM 
	Propietario P
INNER JOIN 
	Mascota M ON P.id_propietario = M.id_propietario
INNER JOIN 
	Especie E ON M.id_especie = E.id_especie
INNER JOIN
    CitaBelleza C ON M.id_mascota = C.id_mascota
LEFT JOIN 
    ServicioBelleza S ON C.id_citabelleza = S.id_citabelleza
LEFT JOIN 
    TipoServicioBelleza TS ON S.id_tipo_serviciobelleza = TS.id_tipo_serviciobelleza
WHERE C.fecha >= GETDATE()
ORDER BY C.fecha ASC;

/* RIGHT JOIN 
ENUNCIADO -> Mostrar todas las estancias en la guarderia proximas a la fecha actual junto con el empleado que se asigno y su información, 
en caso de no haber un empleado asignado igualmente se debe mostrar la estancia
*/

SELECT 
	ES.id_estanciaguarderia AS IdEstancia, ES.fecha_ingreso AS FechaEstancia, ES.duracion_dias AS DiasDeEstancia, Es.cuidado_especial AS CuidadosAdicionales,
	EM.nombre_empleadoguarderia AS NombreEmpleadoResponsable,
	C.nombre_cargo AS CargoDelEmpleado
FROM
	Cargo C
RIGHT JOIN
	EmpleadoGuarderia EM ON C.id_cargo = EM.id_cargo
RIGHT JOIN 
	EstanciaGuarderia ES ON EM.id_empleadoguarderia = ES.id_empleadoguarderia
WHERE ES.fecha_ingreso >= GETDATE()
ORDER BY ES.fecha_ingreso ASC;

/* FULL JOIN 
ENUNCIADO -> Mostrar todos los pedidos y proveedores de la tienda de mascotas,con el fin de revisar
que no haya ningun error ni problema con el flujo proveedor-pedido como forma de auditoria
*/

SELECT 
	*
FROM
	ProveedorTienda PT
FULL JOIN 
	Pedido P ON PT.id_proveedor = P.id_proveedor;
GO





------------------------------------------------------------------------------------------------------------------





/* E.	Desarrollar 2 funciones de tablas y dos funciones escalares dentro de las necesidades del 
proyecto a desarrollar. Estos procedimientos deben estar debidamente documentados. */

-- FUNCIONES TABLA

-- 1.	

-- =============================================
-- Author: Jhonatan Toro Hurtado
-- Description:	Función que retorna tabla con Compras totales por producto de la tienda de mascotas
-- del ultimo mes - cantidad de producto y valor total
-- =============================================
CREATE FUNCTION COMPRAS_PRODUCTOS_TIENDAMASCOTAS
()
RETURNS TABLE 
AS
RETURN 
(

	SELECT 
		P.nombre_producto AS NombreProducto, P.tipo_producto AS TipoProducto, P.precio_unitario AS PrecioUnitario,
		SUM(DC.cantidad_producto) AS NroComprasDelMesPasado, 
		SUM(DC.valor_total_detalle) AS ComprasTotalesDelMesPasado
	FROM 
		Producto P
	INNER JOIN 
		DetalleCompra DC ON P.id_producto = DC.id_producto 
	INNER JOIN 
		Compra C ON DC.id_compra = C.id_compra
	WHERE  MONTH(C.fecha_compra) >= MONTH(DATEADD(MONTH, -1, GETDATE()))
	GROUP BY P.nombre_producto, P.precio_unitario, P.tipo_producto

)
GO

-- 2.

-- =============================================
-- Author: Jhonatan Toro Hurtado
-- Description:	Función que retorna tabla con los productos de la tienda de mascotas
-- que tienen fecha de vencimiento proxima o que ya estan vencidos y todavia hay existencia de 
-- estos producto
-- =============================================
CREATE FUNCTION  PRODUCTOS_PROXIMOS_VENCER_TIENDA
()
RETURNS TABLE 
AS
RETURN 
(
	
	SELECT 
		P.id_producto AS IdDelProducto, L.fecha_vencimiento AS FechaDeVencimiento,P.nombre_producto AS NombreProducto, P.Stock AS ExistenciaDelProducto, P.precio_unitario AS PrecioUnitario
	FROM
		Producto P
	INNER JOIN 
		Lote L ON P.id_lote = L.id_lote
	WHERE L.fecha_vencimiento <= DATEADD(DAY, 30, GETDATE()) AND P.Stock > 0
	ORDER BY L.fecha_vencimiento ASC

)
GO

-- FUNCIONES ESCALARES

-- 1.


-- =============================================
-- Author: Jhonatan Toro Hurtado
-- Description:	Funcion que retorna la cantidad de insumos utilizados durante un
--  mes y año especificado, en caso de no enviar mes o año devuelve el ultimo mes,
-- en caso de no enviar año usa año actual
-- =============================================
CREATE FUNCTION INSUMOS_USADOS_AÑO_MES 
( @YEAR INT = NULL, @MONTH INT = NULL)
RETURNS INT
AS
BEGIN

	IF @YEAR <= 0 OR @YEAR IS NULL OR @YEAR > YEAR(GETDATE())
    BEGIN
        SET @YEAR = YEAR(GETDATE());
    END
	
	IF @MONTH <= 0 OR @MONTH IS NULL OR @MONTH > 12
    BEGIN
        SET @MONTH = MONTH(GETDATE());
    END

	DECLARE @TOTAL INT;

	SELECT 
		@TOTAL = COUNT(UI.cantidad_usada)
    FROM 
        UsoInsumo UI
    INNER JOIN 
		Insumo I ON UI.id_insumo = I.id_insumo
    WHERE 
        MONTH(UI.fecha_registro) = @MONTH AND YEAR(UI.fecha_registro) = @YEAR;

	RETURN @TOTAL;

END
GO

-- 2.

-- =============================================
-- Author: Jhonatan Toro Hurtado
-- Description:	Funcion que retorna 1 verdadero o 0 falso 
-- para verificar si un cliente es elegible para ser preferencial
-- en el salon de belleza, se reciben 2 parametro primero el id del 
-- propietario a validar y luego el numero de servicios limite propuesto 
-- por el salon para ser preferente
-- =============================================
CREATE FUNCTION ES_CLIENTE_PREFERENTE
(@IDPROPIETARIO INT, @NRO_SERVICIOS_PARA_CALIFICAR INT)
RETURNS BIT
AS
BEGIN

	IF NOT EXISTS (SELECT * FROM Propietario WHERE id_propietario = @IDPROPIETARIO) OR @NRO_SERVICIOS_PARA_CALIFICAR < 0 OR @NRO_SERVICIOS_PARA_CALIFICAR = NULL
	BEGIN
		RETURN 0
	END

    DECLARE @CANTIDAD_SERVICIOS INT;

    SELECT 
		@CANTIDAD_SERVICIOS = COUNT(*)
    FROM 
		Propietario P
    INNER JOIN 
		Mascota M ON P.id_propietario = M.id_propietario
	INNER JOIN 
		CitaBelleza CB ON M.id_mascota = CB.id_mascota
	INNER JOIN
		ServicioBelleza SB ON CB.id_citabelleza = SB.id_citabelleza
    WHERE P.id_propietario = @IDPROPIETARIO AND SB.estado_serviciobelleza = 'realizado';
    
    IF @CANTIDAD_SERVICIOS >= @NRO_SERVICIOS_PARA_CALIFICAR
	BEGIN
        RETURN 1;
	END
    RETURN 0; 
END;
GO





------------------------------------------------------------------------------------------------------------------





/* F.	Hacer 2 consultas que utilice teoría de conjuntos. Deben ir con su enunciado y producir 
algún resultado. */


-- 1.  Muestra una lista de propietarios que no han registrado mascotas en el sistema, por lo que pueden ser 
-- propietarios que adquirieron otros servicios como comprar en la tienda de mascotas, haciendose util para
-- marketing (DIFERENCIA)

SELECT 
	PR1.nombre_propietario
FROM 
	Propietario PR1
EXCEPT
SELECT 
	PR2.nombre_propietario
FROM 
	Propietario PR2
INNER JOIN 
	Mascota M ON PR2.id_propietario = M.id_propietario;

-- 2.  Muestra una lista de los proveedores que han interactuado con la clinica veterinaria y
-- con la tienda de mascotas (INTERSECCIÓN)

SELECT 
    PC.nombre_proveedor
FROM 
	ProveedorClinica PC
INTERSECT
SELECT 
    PT.nombre_proveedor
FROM 
	ProveedorTienda PT;

GO





------------------------------------------------------------------------------------------------------------------





/* G.	Implementar dos vistas útiles para el negocio. Dichas vistas deben ser actualizables, y 
deben tener 4 tablas base como mínimo. */

CREATE VIEW PROPIETARIOS_MASCOTAS AS 
SELECT 
	P.id_propietario, P.nombre_propietario, P.cedula AS cedula_propietario, P.direccion AS direccion_propietario, P.telefono AS telefono_propietario,
	M.nombre AS nombre_mascota, M.identificacion AS identificacion_mascota,
	TF.nombre_fauna, E.nombre_especie
FROM 
	Propietario P
INNER JOIN
	Mascota M ON P.id_propietario = M.id_propietario 
INNER JOIN 
	TipoFauna TF ON M.id_tipofauna = TF.id_tipofauna
INNER JOIN 
	Especie E ON M.id_especie = E.id_especie
GO

INSERT INTO PROPIETARIOS_MASCOTAS (nombre_propietario,cedula_propietario,direccion_propietario,telefono_propietario) VALUES ('nombre prueba','21212', 'direccion prueba','1243234'); -- Funciona
UPDATE PROPIETARIOS_MASCOTAS SET nombre_propietario = 'nombre ACTUALIZADO PRUEBA' WHERE id_propietario = 51; -- No funciona con 4 tablas base como especifica el ejercicio
DELETE FROM PROPIETARIOS_MASCOTAS WHERE id_propietario = 51; -- No funciona con 4 tablas base como especifica el ejercicio
GO





------------------------------------------------------------------------------------------------------------------





/* H.	Generar los procedimientos almacenados necesarios para hacerle CRUD a MINIMO 2 TABLAS las 
tablas del proyecto. Estos procedimientos deben estar debidamente documentados. */


-- TABLA PROOVEDORTIENDA
-- =============================================
-- Author: Jhonatan Toro Hurtado
-- Description:	INSERTAR en la tabla
-- =============================================
CREATE PROCEDURE INSERTAR_PROOVEDORTIENDA
(@NOMBRE VARCHAR(100), @TELEFONO VARCHAR(15), @DIRECCION VARCHAR(255))
AS
BEGIN
	IF (@NOMBRE IS NULL OR LTRIM(RTRIM(@NOMBRE)) = '' OR @TELEFONO IS NULL OR LTRIM(RTRIM(@TELEFONO)) = '' OR @DIRECCION IS NULL OR LTRIM(RTRIM(@DIRECCION)) = '')
	BEGIN
		PRINT 'Valores no validos, revise la información suministrada' 
		RETURN
	END
	INSERT INTO ProveedorTienda (nombre_proveedor, telefono, direccion)
    VALUES (@NOMBRE, @TELEFONO, @DIRECCION);
END
GO

-- =============================================
-- Author: Jhonatan Toro Hurtado
-- Description:	ACTUALIZAR en la tabla PROOVEDORTIENDA
-- =============================================
CREATE PROCEDURE ACTUALIZAR_PROOVEDORTIENDA
(@IDPROVEEDOR INT ,@NOMBRE VARCHAR(100), @TELEFONO VARCHAR(15), @DIRECCION VARCHAR(255))
AS
BEGIN

	IF (@NOMBRE IS NULL OR LTRIM(RTRIM(@NOMBRE)) = '' OR @TELEFONO IS NULL OR LTRIM(RTRIM(@TELEFONO)) = '' OR @DIRECCION IS NULL OR LTRIM(RTRIM(@DIRECCION)) = '')
	BEGIN
		PRINT 'Valores no validos, revise la información suministrada' 
		RETURN
	END

	UPDATE ProveedorTienda SET nombre_proveedor = @NOMBRE, telefono = @TELEFONO, direccion = @DIRECCION WHERE id_proveedor = @IDPROVEEDOR;

END
GO

-- =============================================
-- Author: Jhonatan Toro Hurtado
-- Description:	CONSULTAR en la tabla PROOVEDORTIENDA
-- =============================================
CREATE PROCEDURE CONSULTAR_PROOVEDORTIENDA
(@IDPROVEEDOR INT)
AS
BEGIN
	
	IF (@IDPROVEEDOR < 1 OR NOT EXISTS(SELECT * FROM ProveedorTienda WHERE id_proveedor = @IDPROVEEDOR)) 
	BEGIN
		PRINT 'No se pudo encontrar el proveedor'
		RETURN
	END
	SELECT 
		* 
	FROM 
		ProveedorTienda
	WHERE id_proveedor = @IDPROVEEDOR;

END
GO

-- =============================================
-- Author: Jhonatan Toro Hurtado
-- Description:	ELIMINAR en la tabla PROOVEDORTIENDA
-- =============================================
CREATE PROCEDURE ELIMINAR_PROOVEDORTIENDA
(@IDPROVEEDOR INT)
AS
BEGIN

	IF (@IDPROVEEDOR < 1 OR NOT EXISTS(SELECT * FROM ProveedorTienda WHERE id_proveedor = @IDPROVEEDOR)) 
	BEGIN
		PRINT 'No se pudo encontrar el proveedor'
		RETURN
	END
	DELETE FROM ProveedorTienda WHERE id_proveedor = @IDPROVEEDOR;

END
GO

-- TABLA CARGO
-- =============================================
-- Author: Jhonatan Toro Hurtado
-- Description:	INSERTAR en la tabla CARGO
-- =============================================
CREATE PROCEDURE INSERTAR_CARGO
(@NOMBRE VARCHAR(100))
AS
BEGIN
	
	IF (@NOMBRE IS NULL OR LTRIM(RTRIM(@NOMBRE)) = '')
	BEGIN
		PRINT 'Valores no validos, revise la información suministrada' 
		RETURN
	END

	INSERT INTO Cargo (nombre_cargo) VALUES (@NOMBRE);

END
GO

-- =============================================
-- Author: Jhonatan Toro Hurtado
-- Description:	ACTUALIZAR en la tabla CARGO
-- =============================================
CREATE PROCEDURE ACTUALIZAR_CARGO
(@IDCARGO INT ,@NOMBRE VARCHAR(100))
AS
BEGIN
	IF (@NOMBRE IS NULL OR LTRIM(RTRIM(@NOMBRE)) = '' OR @IDCARGO < 1 OR @IDCARGO = NULL)
	BEGIN
		PRINT 'Valores no validos, revise la información suministrada' 
		RETURN
	END
	UPDATE Cargo SET nombre_cargo = @NOMBRE WHERE id_cargo = @IDCARGO;
END
GO

 -- =============================================
-- Author: Jhonatan Toro Hurtado
-- Description:	CONSULTAR en la tabla CARGO
-- =============================================
CREATE PROCEDURE CONSULTAR_CARGO
(@IDCARGO INT)
AS
BEGIN
	IF (@IDCARGO < 1 OR NOT EXISTS(SELECT * FROM Cargo WHERE id_cargo = @IDCARGO)) 
	BEGIN
		PRINT 'No se pudo encontrar el cargo'
		RETURN
	END
	SELECT 
		* 
	FROM 
		Cargo
	WHERE id_cargo = @IDCARGO;
END
GO

-- =============================================
-- Author: Jhonatan Toro Hurtado
-- Description:	ELIMINAR en la tabla CARGO
-- =============================================
CREATE PROCEDURE ELIMINAR_CARGO
(@IDCARGO INT)
AS
BEGIN
	
	IF (@IDCARGO < 1 OR NOT EXISTS(SELECT * FROM Cargo WHERE id_cargo = @IDCARGO)) 
	BEGIN
		PRINT 'No se pudo encontrar el cargo'
		RETURN
	END
	DELETE FROM Cargo WHERE id_cargo = @IDCARGO;

END
GO





------------------------------------------------------------------------------------------------------------------





/* I.	Generar una necesidad dentro del negocio que implique hacer un procedimiento almacenado que 
se integre con funciones de usuario y disparen Triggers (mínimo 2). No olviden usar control de 
errores, usar cursores en lo posible y conservar la atomicidad. */


CREATE TRIGGER TRIGGER_INSERCION_CLIENTE_PREFERENTE
ON ClientePreferenteBelleza
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM ClientePreferenteBelleza CPB JOIN inserted I ON CPB.id_propietario = I.id_propietario)
    BEGIN
        PRINT 'El cliente o propietario ya se encuentra registrado como cliente preferente'
		ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        INSERT INTO ClientePreferenteBelleza (fecha_registro, motivo, id_propietario)
        SELECT 
			fecha_registro, motivo, id_propietario
        FROM 
			inserted;
        PRINT 'Se registro exitosamente el cliente preferente'
    END
END;
GO


-- =============================================
-- Author: Jhonatan Toro Hurtado
-- Description:	Procedimiento almacenado que se encarga de agregar
-- un propietario a la tabla de preferentes.
-- =============================================
CREATE PROCEDURE INSERTAR_CLIENTE_PERFERENCIAL_BELLEZA 
(@IDPROPIETARIO INT ,@MOTIVO VARCHAR(100), @NRO_SERVICIOS_PARA_CALIFICAR INT)
AS
BEGIN

	IF EXISTS( SELECT * FROM Propietario) AND dbo.ES_CLIENTE_PREFERENTE(@IDPROPIETARIO, @NRO_SERVICIOS_PARA_CALIFICAR) = 1
	BEGIN
		INSERT INTO ClientePreferenteBelleza(motivo, fecha_registro, id_propietario) VALUES (@MOTIVO, GETDATE(), @IDPROPIETARIO)
	END
	ELSE
	BEGIN
		PRINT 'No se pudo ingresar el Propietario o Cliente como preferencial, verifique la eligibilidad o el id ingresado.'
	END

END
GO
