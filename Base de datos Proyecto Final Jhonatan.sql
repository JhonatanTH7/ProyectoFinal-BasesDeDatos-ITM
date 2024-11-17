CREATE DATABASE ClinicaVeterinariaProyectoFinal;
GO
USE ClinicaVeterinariaProyectoFinal;
GO

CREATE TABLE Propietario (
    id_propietario INT PRIMARY KEY IDENTITY NOT NULL,
    nombre_propietario VARCHAR(100) NOT NULL,
    cedula VARCHAR(20) UNIQUE NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    telefono VARCHAR(20) NOT NULL
);

CREATE TABLE TipoFauna(
    id_tipofauna INT PRIMARY KEY IDENTITY NOT NULL,
	nombre_fauna VARCHAR(20) NOT NULL
);

CREATE TABLE Especie (
    id_especie INT PRIMARY KEY IDENTITY NOT NULL,
	nombre_especie VARCHAR(20) NOT NULL
);

CREATE TABLE Mascota (
    id_mascota INT PRIMARY KEY IDENTITY NOT NULL,
    nombre VARCHAR(100),
    identificacion VARCHAR(100),
	id_tipofauna INT NOT NULL,
	id_especie INT NOT NULL,
    id_propietario INT NOT NULL,
    FOREIGN KEY (id_tipofauna) REFERENCES TipoFauna(id_tipofauna),
    FOREIGN KEY (id_especie) REFERENCES Especie(id_especie),
    FOREIGN KEY (id_propietario) REFERENCES Propietario(id_propietario)
);



--Modulo Tienda de Mascotas
CREATE TABLE ProveedorTienda (
    id_proveedor INT PRIMARY KEY IDENTITY NOT NULL,
    nombre_proveedor VARCHAR(100) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    direccion VARCHAR(255)
);

CREATE TABLE Pedido (
    id_pedido INT PRIMARY KEY IDENTITY NOT NULL,
    fecha_pedido DATE,
    estado_pedido VARCHAR(50) CHECK(estado_pedido IN ('En Proceso', 'Cancelado', 'Recibido')),
	valor_pedido MONEY,
	id_proveedor INT NOT NULL,
	FOREIGN KEY (id_proveedor) REFERENCES ProveedorTienda(id_proveedor)
);

CREATE TABLE Producto (
    id_producto INT PRIMARY KEY IDENTITY NOT NULL,
    nombre_producto VARCHAR(100),
    tipo_producto VARCHAR(50),
    edad_recomendada VARCHAR(20),
    tama�o_recomendado VARCHAR(20),
    Stock INT NOT NULL,
    precio_unitario MONEY,
);

CREATE TABLE Lote (
    id_lote INT PRIMARY KEY IDENTITY NOT NULL,
	cantidad_producto_pedido INT NOT NULL,
    fecha_vencimiento DATE,
	id_producto INT NOT NULL,
    id_pedido INT NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
	FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);

CREATE TABLE Compra (
    id_compra INT PRIMARY KEY IDENTITY NOT NULL,
    fecha_compra DATE NOT NULL,
	valor_total_compra MONEY DEFAULT 0,
    id_propietario INT NOT NULL,
    FOREIGN KEY (id_propietario) REFERENCES Propietario(id_propietario)
);

CREATE TABLE DetalleCompra (
    id_detalle_compra INT PRIMARY KEY IDENTITY NOT NULL,
    cantidad_producto INT NOT NULL,
	valor_total_detalle MONEY,
    id_compra INT NOT NULL,
    id_producto INT NOT NULL,
    FOREIGN KEY (id_compra) REFERENCES Compra(id_compra),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

--Modulo Salon de Belleza
CREATE TABLE CitaBelleza (
    id_citabelleza INT PRIMARY KEY IDENTITY NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_aprox_fin TIME NOT NULL,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Realizada', 'Cancelada', 'Asignada')),
    id_mascota INT NOT NULL,
    FOREIGN KEY (id_mascota) REFERENCES Mascota (id_mascota)
);

CREATE TABLE ClientePreferenteBelleza (
    id_clientepreferente INT PRIMARY KEY IDENTITY NOT NULL,
    fecha_registro DATE DEFAULT GETDATE(),
    motivo VARCHAR(100) NOT NULL,
    id_propietario INT NOT NULL UNIQUE,
    FOREIGN KEY (id_propietario) REFERENCES Propietario (id_propietario)
);

CREATE TABLE TipoServicioBelleza (
    id_tipo_serviciobelleza INT PRIMARY KEY IDENTITY NOT NULL,
    nombre_tipo_serviciobelleza VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) NULL,
    duracion_aprox_minutos INT NOT NULL
);

CREATE TABLE EmpleadoBelleza (
    id_empleadobelleza INT PRIMARY KEY IDENTITY NOT NULL, 
    nombre_empleadobelleza VARCHAR(100) NOT NULL,
	numero_documento INT NOT NULL,
);

CREATE TABLE Instalaci�nBelleza (
	 id_instalacionbelleza INT PRIMARY KEY IDENTITY NOT NULL,
	 nombre_instalacionguarderia VARCHAR(50) NOT NULL
);

CREATE TABLE ServicioBelleza (
    id_serviciobelleza INT PRIMARY KEY IDENTITY NOT NULL,
    estado_serviciobelleza VARCHAR(20) NOT NULL CHECK (estado_serviciobelleza IN ('Realizado', 'Cancelado', 'Asignado')),
    id_tipo_serviciobelleza INT NOT NULL,
    id_citabelleza INT NOT NULL,
	id_empleadobelleza INT NOT NULL,
	id_instalacionbelleza INT NOT NULL,
    FOREIGN KEY (id_citabelleza) REFERENCES CitaBelleza (id_citabelleza),
    FOREIGN KEY (id_tipo_serviciobelleza) REFERENCES TipoServicioBelleza (id_tipo_serviciobelleza),
	FOREIGN KEY (id_empleadobelleza) REFERENCES EmpleadoBelleza(id_empleadobelleza),
	FOREIGN KEY (id_instalacionbelleza) REFERENCES Instalaci�nBelleza(id_instalacionbelleza)
);

--Modulo Guarderia
CREATE TABLE Cargo (
    id_cargo INT PRIMARY KEY IDENTITY NOT NULL,
	nombre_cargo VARCHAR(100) NOT NULL
);

CREATE TABLE EmpleadoGuarderia (
    id_empleadoguarderia INT PRIMARY KEY IDENTITY NOT NULL, 
    nombre_empleadoguarderia VARCHAR(100) NOT NULL,
    id_cargo INT NOT NULL,
	FOREIGN KEY (id_cargo) REFERENCES Cargo(id_cargo)
);

CREATE TABLE InstalacionGuarderia (
    id_instalacionguarderia INT PRIMARY KEY IDENTITY NOT NULL,
    nombre_instalacion VARCHAR(100) NOT NULL,
    capacidad INT NULL,
    descripcion VARCHAR(100) NULL
);

CREATE TABLE EstanciaGuarderia (
    id_estanciaguarderia INT PRIMARY KEY IDENTITY NOT NULL,
    fecha_ingreso DATETIME NOT NULL,
    fecha_salida DATETIME NULL,
    duracion_dias INT NULL,
    cuidado_especial VARCHAR(255) NULL,
    id_instalacionguarderia INT NOT NULL,
    id_empleadoguarderia INT NOT NULL,
    id_mascota INT NOT NULL,
    FOREIGN KEY (id_instalacionguarderia) REFERENCES InstalacionGuarderia (id_instalacionguarderia),
    FOREIGN KEY (id_empleadoguarderia) REFERENCES EmpleadoGuarderia (id_empleadoguarderia),
    FOREIGN KEY (id_mascota) REFERENCES Mascota (id_mascota)
);

--Modulo Veterinaria
CREATE TABLE HistoriaClinica (
    id_historiaclinica INT PRIMARY KEY IDENTITY NOT NULL,
    fecha_apertura_historiaclinica DATE NOT NULL,
    id_mascota INT NOT NULL,
	FOREIGN KEY (id_mascota) REFERENCES Mascota(id_mascota),
);

CREATE TABLE AtencionMedica (
    id_atencionmedica INT PRIMARY KEY IDENTITY NOT NULL,
    fecha_atencion DATE NOT NULL,
    motivo_consulta VARCHAR(255),
    anamnesis VARCHAR(255),
    tratamiento_previo VARCHAR(255),
    evolucion VARCHAR(255),
    diagnostico_presuntivo VARCHAR(255),
    diagnostico_definitivo VARCHAR(255),
    id_historiaclinica INT NOT NULL,
	FOREIGN KEY (id_historiaclinica) REFERENCES HistoriaClinica(id_historiaclinica)
);

CREATE TABLE TipoServicioMedico (
    id_tipo_serviciomedico INT PRIMARY KEY IDENTITY NOT NULL,
	nombre_tipo_serviciomedico VARCHAR(50) NOT NULL,
	descripcion_tipo_serviciomedico VARCHAR(255) NULL
);

CREATE TABLE ServicioMedico (
    id_servicio_medico INT PRIMARY KEY IDENTITY NOT NULL,
	nombre_servicio_medico VARCHAR(50) NOT NULL,
    descripcion_servicio_medico VARCHAR(255),
	id_tipo_serviciomedico INT NOT NULL,
    FOREIGN KEY (id_tipo_serviciomedico) REFERENCES TipoServicioMedico(id_tipo_serviciomedico)
);

CREATE TABLE AtencionMedica_ServicioMedico (
	id_atencionmedica_serviciomedico INT PRIMARY KEY IDENTITY NOT NULL,
	detalles VARCHAR(MAX),
	recomendaciones VARCHAR(MAX),
    id_atencionmedica INT NOT NULL,
    id_servicio_medico INT NOT NULL,
	FOREIGN KEY (id_atencionmedica) REFERENCES AtencionMedica(id_atencionmedica),
	FOREIGN KEY (id_servicio_medico) REFERENCES ServicioMedico(id_servicio_medico)
);

CREATE TABLE TipoExamen (
    id_tipo_examen INT PRIMARY KEY IDENTITY NOT NULL,
    nombre_tipo_examen VARCHAR(50) NOT NULL,
	descripcion_examen VARCHAR(255) NOT NULL
);

CREATE TABLE Examen (
    id_examen INT PRIMARY KEY IDENTITY NOT NULL,
    fecha_toma_muestra DATE,
    resultados VARCHAR(MAX),
	id_tipo_examen INT NOT NULL,
    id_atencionmedica_serviciomedico INT NOT NULL,
	FOREIGN KEY (id_tipo_examen) REFERENCES TipoExamen(id_tipo_examen),
	FOREIGN KEY (id_atencionmedica_serviciomedico) REFERENCES AtencionMedica_ServicioMedico(id_atencionmedica_serviciomedico)
);

CREATE TABLE Procedimiento (
    id_procedimiento INT PRIMARY KEY IDENTITY NOT NULL,
    fecha_programada DATE,
    lugar VARCHAR(255),
	descripcion VARCHAR(255),
    id_atencionmedica_serviciomedico INT NOT NULL,
	FOREIGN KEY (id_atencionmedica_serviciomedico) REFERENCES AtencionMedica_ServicioMedico(id_atencionmedica_serviciomedico)
);

CREATE TABLE Receta (
    id_receta INT PRIMARY KEY IDENTITY NOT NULL,
    tratamiento VARCHAR(MAX),
	id_atencionmedica_serviciomedico INT NOT NULL,
	FOREIGN KEY (id_atencionmedica_serviciomedico) REFERENCES AtencionMedica_ServicioMedico(id_atencionmedica_serviciomedico)
);

CREATE TABLE ProveedorClinica (
    id_proveedor INT PRIMARY KEY IDENTITY NOT NULL,
    nombre_proveedor VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(255)
);

CREATE TABLE Insumo (
    id_insumo INT PRIMARY KEY IDENTITY NOT NULL,
    nombre_insumo VARCHAR(100) NOT NULL,
    cantidad_inicial INT NOT NULL,
    stock_actual INT NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    temperatura_almacenamiento DECIMAL(5,2),
    tiempo_rotacion TIME,
    id_proveedor INT NOT NULL,
    FOREIGN KEY (id_proveedor) REFERENCES ProveedorClinica(id_proveedor)
);

CREATE TABLE UsoInsumo (
    id_usoinsumo INT PRIMARY KEY IDENTITY NOT NULL,
    fecha_registro DATE DEFAULT GETDATE(),
    cantidad_usada INT NOT NULL,
    cantidad_restante INT NOT NULL,
    id_insumo INT NOT NULL,
    id_atencionmedica_serviciomedico INT NOT NULL,
    FOREIGN KEY (id_insumo) REFERENCES Insumo(id_insumo),
    FOREIGN KEY (id_atencionmedica_serviciomedico) REFERENCES AtencionMedica_ServicioMedico(id_atencionmedica_serviciomedico)
);










--REGISTROS PROPIETARIOS
INSERT INTO Propietario (nombre_propietario, cedula, direccion, telefono)
VALUES
('Juan P�rez', '0101010101', 'Calle Falsa 123, Ciudad', '555-1234'),
('Mar�a Gonz�lez', '0101010102', 'Av. Central 456, Ciudad', '555-2345'),
('Carlos S�nchez', '0101010103', 'Calle Principal 789, Ciudad', '555-3456'),
('Ana Rodr�guez', '0101010104', 'Boulevard 12, Ciudad', '555-4567'),
('Luis Fern�ndez', '0101010105', 'Plaza Mayor 34, Ciudad', '555-5678'),
('Laura Garc�a', '0101010106', 'Av. Libertad 101, Ciudad', '555-6789'),
('Pedro Mart�nez', '0101010107', 'Calle Comercio 22, Ciudad', '555-7890'),
('Silvia Jim�nez', '0101010108', 'Barrio Norte 98, Ciudad', '555-8901'),
('Jorge Ram�rez', '0101010109', 'Residencial Verde 5, Ciudad', '555-9012'),
('Marta Herrera', '0101010110', 'Urbanizaci�n Sol 8, Ciudad', '555-0123'),
('Francisco Torres', '0101010111', 'Calle Azul 76, Ciudad', '555-1235'),
('Gloria D�az', '0101010112', 'Av. del Bosque 12, Ciudad', '555-2346'),
('Ra�l Castro', '0101010113', 'Residencial Oeste 56, Ciudad', '555-3457'),
('Claudia Flores', '0101010114', 'Condominio Vista 3, Ciudad', '555-4568'),
('Ricardo Pe�a', '0101010115', 'Barrio Sur 88, Ciudad', '555-5679'),
('Patricia Le�n', '0101010116', 'Calle Oro 45, Ciudad', '555-6780'),
('Andr�s Ortiz', '0101010117', 'Av. de los Lagos 90, Ciudad', '555-7891'),
('Luc�a Castillo', '0101010118', 'Calle Sol 33, Ciudad', '555-8902'),
('Diego Ruiz', '0101010119', 'Residencial Norte 44, Ciudad', '555-9013'),
('Isabel Morales', '0101010120', 'Urbanizaci�n Mar 99, Ciudad', '555-0124'),
('Manuel Romero', '0101010121', 'Av. Norte 11, Ciudad', '555-1236'),
('Carmen Vega', '0101010122', 'Calle Sur 12, Ciudad', '555-2347'),
('Jos� Paredes', '0101010123', 'Barrio Oriente 78, Ciudad', '555-3458'),
('Gabriela Molina', '0101010124', 'Condominio Horizonte 2, Ciudad', '555-4569'),
('Fernando Mu�oz', '0101010125', 'Calle del R�o 41, Ciudad', '555-5670'),
('Teresa Bustos', '0101010126', 'Av. Oeste 31, Ciudad', '555-6782'),
('Daniel Salazar', '0101010127', 'Residencial Colinas 7, Ciudad', '555-7893'),
('Rosa Aguirre', '0101010128', 'Urbanizaci�n Amanecer 6, Ciudad', '555-8904'),
('Pablo Ponce', '0101010129', 'Calle Estrella 17, Ciudad', '555-9015'),
('Nancy Ortiz', '0101010130', 'Av. Atl�ntico 43, Ciudad', '555-0126'),
('Roberto Fuentes', '0101010131', 'Calle del Parque 28, Ciudad', '555-1237'),
('Alejandra R�os', '0101010132', 'Condominio Verde 4, Ciudad', '555-2348'),
('David Lara', '0101010133', 'Barrio Centro 64, Ciudad', '555-3459'),
('Sof�a Serrano', '0101010134', 'Residencial Alta 15, Ciudad', '555-4570'),
('Oscar Navarro', '0101010135', 'Av. del Sur 59, Ciudad', '555-5671'),
('Liliana Cruz', '0101010136', 'Calle Bosque 29, Ciudad', '555-6783'),
('Rodrigo Campos', '0101010137', 'Urbanizaci�n Oriente 92, Ciudad', '555-7894'),
('Julia Espinoza', '0101010138', 'Calle Brisa 34, Ciudad', '555-8905'),
('Enrique Mendoza', '0101010139', 'Barrio Jard�n 49, Ciudad', '555-9016'),
('In�s Cabrera', '0101010140', 'Condominio Norte 23, Ciudad', '555-0127'),
('Fabi�n Solano', '0101010141', 'Calle del Sol 30, Ciudad', '555-1238'),
('Paola Barrera', '0101010142', 'Av. del Lago 36, Ciudad', '555-2349'),
('Emanuel Gil', '0101010143', 'Residencial Oeste 18, Ciudad', '555-3460'),
('Mercedes Luna', '0101010144', 'Urbanizaci�n Brisa 77, Ciudad', '555-4571'),
('Guillermo Calder�n', '0101010145', 'Calle Lirio 38, Ciudad', '555-5672'),
('F�tima Sosa', '0101010146', 'Av. Norte 27, Ciudad', '555-6784'),
('Arturo Delgado', '0101010147', 'Residencial del R�o 32, Ciudad', '555-7895'),
('Ver�nica Carrillo', '0101010148', 'Urbanizaci�n Mirador 26, Ciudad', '555-8906'),
('Gustavo Zamora', '0101010149', 'Calle Este 53, Ciudad', '555-9017'),
('Sandra Valencia', '0101010150', 'Av. Sur 65, Ciudad', '555-0128');

-- REGISTROS TIPO DE FAUNA
INSERT INTO TipoFauna (nombre_fauna)
VALUES 
('Silvestre'),('Dom�stica');

--  REGISTROS ESPECIES
INSERT INTO Especie(nombre_especie)
VALUES 
('Le�n'), ('Lobo'), ('Oso'), ('Lince'), ('Comadreja'),
('Vaca'), ('Caballo'), ('Oveja'), ('Cabra'), ('Jabal�'),
('Gato'), ('Perro'), ('Zorro'), ('Mapache'), ('Rat�n'),
('Panda'), ('Rata'), ('Gorila'), ('Orangut�n'), ('Conejo'),
('H�mster'), ('Cerdo'), ('Mini Cerdo'), ('Serpiente'), ('Iguana'),
('Gallina'), ('Sapo'), ('B�ho'), ('Paloma'), ('Rana'),
('Cuervo'), ('Perico'), ('Halc�n'), ('Cisne'), ('Pato'),
('Mono'), ('Guacamayo'), ('Cacat�a'), ('Tortuga'), ('C�ndor'), ('Loro'),
('Tar�ntula'), ('Escorpi�n'), ('Ardilla'), ('Camale�n'), ('Gecko'), ('Pez');

-- REGISTROS MASCOTAS
INSERT INTO Mascota (nombre, identificacion, id_tipofauna, id_especie, id_propietario)
VALUES 
('Max', 'M001', 2, 11, 1), 
('Luna', 'M002', 2, 12, 2), 
('Rex', 'M003', 2, 7, 3),  
('Bella', 'M004', 2, 20, 4), 
('Nala', 'M005', 2, 6, 5), 
('Rocky', 'M006', 2, 12, 6), 
('Simba', 'M007', 1, 1, 7), 
('Duke', 'M008', 2, 13, 8),
('Shadow', 'M009', 1, 3, 9), 
('Ginger', 'M010', 2, 11, 10), 
('Buddy', 'M011', 2, 19, 11), 
('Oscar', 'M012', 2, 17, 12), 
('Chico', 'M013', 1, 14, 13),
('Lola', 'M014', 2, 25, 14), 
('Lucky', 'M015', 2, 26, 15), 
('Milo', 'M016', 2, 15, 16), 
('Mochi', 'M017', 2, 18, 17), 
('Kiki', 'M018', 2, 29, 18), 
('Chester', 'M019', 2, 28, 19), 
('Sasha', 'M020', 1, 16, 20), 
('Ziggy', 'M021', 1, 33, 21), 
('Lily', 'M022', 1, 38, 22),
('Pepe', 'M023', 2, 31, 23), 
('Loki', 'M024', 2, 10, 24),
('Rocco', 'M025', 1, 9, 25),
('Lucy', 'M026', 2, 4, 26), 
('Zara', 'M027', 2, 34, 27), 
('Mango', 'M028', 2, 37, 28),
('Bolt', 'M029', 2, 12, 29), 
('Nemo', 'M030', 2, 44, 30), 
('Daisy', 'M031', 2, 5, 31),
('Fiona', 'M032', 1, 35, 32),
('Mocha', 'M033', 1, 32, 33), 
('Milo', 'M034', 2, 22, 34), 
('Chispas', 'M035', 1, 42, 35), 
('Hugo', 'M036', 2, 43, 36),
('Kaa', 'M037', 1, 24, 37), 
('Max', 'M038', 2, 13, 38), 
('Blue', 'M039', 1, 41, 39), 
('Rio', 'M040', 2, 30, 40),
('Bella', 'M040', 2, 11, 1),
('Luna', 'M041', 2, 12, 2),
('Charlie', 'M042', 2, 12, 3),
('Max', 'M043', 2, 12, 4),
('Oliver', 'M044', 2, 11, 5),
('Milo', 'M045', 2, 11, 6),
('Simba', 'M046', 2, 11, 7),
('Nala', 'M047', 2, 11, 8),
('Rocky', 'M048', 2, 12, 9),
('Coco', 'M049', 2, 11, 10),
('Daisy', 'M050', 2, 12, 1),
('Maggie', 'M051', 2, 12, 2),
('Sophie', 'M052', 2, 11, 3),
('Buddy', 'M053', 2, 12, 4),
('Chloe', 'M054', 2, 11, 5),
('Rosie', 'M055', 2, 11, 6),
('Jack', 'M056', 2, 12, 7),
('Buster', 'M057', 2, 12, 8),
('Oreo', 'M058', 2, 11, 9),
('Zoe', 'M059', 2, 11, 10),
('Duke', 'M060', 2, 12, 1),
('Ruby', 'M061', 2, 11, 2),
('Mochi', 'M062', 2, 11, 3),
('Finn', 'M063', 2, 12, 4),
('Oscar', 'M064', 2, 11, 5),
('Pepper', 'M065', 2, 11, 6),
('Ginger', 'M066', 2, 12, 7),
('Hazel', 'M067', 2, 11, 8),
('Lily', 'M068', 2, 12, 9),
('Scout', 'M069', 2, 12, 10),
('Penny', 'M070', 2, 11, 1),
('Molly', 'M071', 2, 12, 2),
('Riley', 'M072', 2, 11, 3),
('Biscuit', 'M073', 2, 12, 4),
('Archie', 'M074', 2, 11, 5),
('Ellie', 'M075', 2, 12, 6),
('Teddy', 'M076', 2, 12, 7),
('Ziggy', 'M077', 2, 11, 8),
('Winnie', 'M078', 2, 12, 9),
('Loki', 'M079', 2, 11, 10),
('Thor', 'M080', 2, 12, 1),
('Mittens', 'M081', 2, 11, 2),
('Smokey', 'M082', 2, 12, 3),
('Blue', 'M083', 2, 12, 4),
('Toby', 'M084', 2, 11, 5),
('Sasha', 'M085', 2, 11, 6),
('Holly', 'M086', 2, 12, 7),
('Ace', 'M087', 2, 12, 8),
('Cleo', 'M088', 2, 11, 9),
('Hunter', 'M089', 2, 11, 10);

--	REGISTROS CARGOS (GUARDERIA)
INSERT INTO Cargo (nombre_cargo)
VALUES
('Cuidador'),('Supervisor'),
('Veterinario'),('Encargado de Cuidados Especiales'),
('Asistente de Cuidados Especiales');

-- REGISTROS EMPLEADOS DE LA GUARDERIA
INSERT INTO EmpleadoGuarderia (nombre_empleadoguarderia, id_cargo)
VALUES 
('Carlos G�mez', 1),
('Andrea P�rez', 1),
('Juan Torres', 2),
('Mar�a R�os', 1),
('Luisa S�nchez', 1),
('Sof�a D�az', 1),
('Ricardo Pe�a', 1),
('Laura Medina', 5),
('Fernando N��ez', 4),
('Isabel Herrera', 1),
('Jos� Luis M�ndez', 5),
('Paula Camacho', 1),
('Victoria Andrade', 1),
('Natalia Fern�ndez', 3),
('Manuel Salas', 2),
('Sergio V�zquez', 1),
('Emilia Prado', 1),
('Ram�n R�os', 1),
('Claudia Torres', 1),
('Patricio Ortega', 1),
('Daniel Ruiz', 1),
('Beatriz Silva', 1),
('Oscar Villanueva', 2),
('Carolina Le�n', 1),
('Alejandra Guti�rrez', 3),
('In�s Alarc�n', 1),
('Joaqu�n Ledesma', 1),
('Patricia Romero', 1),
('Santiago Arce', 1),
('Valeria Zambrano', 4),
('Cecilia Vargas', 1),
('H�ctor Campos', 1),
('Raquel Flores', 1),
('Ignacio Luna', 5),
('Rosa Valencia', 1),
('Leonardo Fuentes', 1),
('Martina Delgado', 1),
('Luciano Figueroa', 3),
('Pamela Ib��ez', 1),
('Enrique Espinoza', 2),
('Lidia Rodr�guez', 1);

-- REGISTROS INSTALACIONES DE LA GUARDERIA
INSERT INTO InstalacionGuarderia (nombre_instalacion, capacidad, descripcion)
VALUES 
('Habitaci�n 1', 1, 'Espacio privado para alojamiento de animales de tama�o mediano'),
('Habitaci�n 2', 1, 'Espacio privado para alojamiento de animales de tama�o mediano'),
('Habitaci�n 3', 1, 'Espacio privado para alojamiento de animales de tama�o mediano'),
('Habitaci�n 4', 1, 'Espacio privado para alojamiento de animales de tama�o mediano'),
('Habitaci�n 5', 1, 'Espacio privado para alojamiento de animales de tama�o mediano'),
('Habitaci�n 6', 1, 'Espacio privado para alojamiento de animales de tama�o mediano'),
('Habitaci�n 7', 1, 'Espacio privado para alojamiento de animales de tama�o mediano'),
('Habitaci�n 8', 1, 'Espacio privado para alojamiento de animales de tama�o mediano'),
('Habitaci�n 9', 1, 'Espacio privado para alojamiento de animales de tama�o mediano'),
('Habitaci�n 10', 1, 'Espacio privado para alojamiento de animales de tama�o mediano'),
('Habitaci�n 11', 1, 'Espacio privado para alojamiento de animales de tama�o mediano'),
('Habitaci�n 12', 1, 'Espacio privado para alojamiento de animales de tama�o mediano'),
('Habitaci�n 13', 2, 'Espacio privado para alojamiento de animales de tama�o mediano'),
('Habitaci�n 14', 3, 'Espacio privado para alojamiento de animales de tama�o mediano'),
('Habitaci�n 15', 3, 'Espacio privado para alojamiento de animales de tama�o mediano'),
('Habitaci�n 16', 1, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 17', 1, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 18', 1, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 19', 1, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 20', 1, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 21', 1, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 22', 1, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 23', 1, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 24', 1, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 25', 1, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 26', 1, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 27', 1, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 28', 1, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 29', 1, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 30', 1, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 31', 1, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 32', 1, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 33', 3, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 34', 3, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 35', 3, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 36', 5, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 37', 5, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 38', 5, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 39', 5, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 40', 5, 'Espacio privado para alojamiento de animales de tama�o peque�o'),
('Habitaci�n 41', 1, 'Espacio privado para alojamiento de animales de tama�o grande'),
('Habitaci�n 42', 1, 'Espacio privado para alojamiento de animales de tama�o grande'),
('Habitaci�n 43', 1, 'Espacio privado para alojamiento de animales de tama�o grande'),
('Habitaci�n 44', 1, 'Espacio privado para alojamiento de animales de tama�o grande'),
('Habitaci�n 45', 1, 'Espacio privado para alojamiento de animales de tama�o grande'),
('Habitaci�n 46', 1, 'Espacio privado para alojamiento de animales de tama�o grande'),
('Habitaci�n 47', 1, 'Espacio privado para alojamiento de animales de tama�o grande'),
('Habitaci�n 48', 2, 'Espacio privado para alojamiento de animales de tama�o grande'),
('Habitaci�n 49', 2, 'Espacio privado para alojamiento de animales de tama�o grande'),
('Habitaci�n 50', 3, 'Espacio privado para alojamiento de animales de tama�o grande');

-- REGISTROS ESTANCIAS EN LA GUARDERIA
INSERT INTO EstanciaGuarderia (fecha_ingreso, fecha_salida, duracion_dias, cuidado_especial, id_instalacionguarderia, id_empleadoguarderia, id_mascota)
VALUES
('2024-10-01 10:00:00', '2024-10-05 10:00:00', 4, NULL, 1, 1, 1),
('2024-10-03 11:00:00', '2024-10-06 10:00:00', 3, 'Requiere alimentaci�n especial', 2, 2, 2),
('2024-10-04 09:00:00', '2024-10-08 09:00:00', 4, NULL, 3, 3, 3),
('2024-10-07 08:00:00', '2024-10-09 08:00:00', 2, 'Supervisi�n constante', 4, 4, 4),
('2024-10-05 07:00:00', '2024-10-06 07:00:00', 1, NULL, 5, 5, 5),
('2024-10-09 08:30:00', '2024-10-10 08:30:00', 1, 'Requiere medicamentos cada 6 horas', 6, 6, 6),
('2024-10-15 11:00:00', '2024-10-20 10:00:00', 5, NULL, 7, 7, 7),
('2024-10-11 12:00:00', '2024-10-15 12:00:00', 4, NULL, 8, 8, 8),
('2024-10-12 13:00:00', '2024-10-18 13:00:00', 6, 'Supervisi�n de peso', 9, 9, 9),
('2024-11-13 10:00:00', NULL, 7, NULL, 10, 10, 10),
('2024-11-01 14:00:00', '2024-11-07 10:00:00', 6, NULL, 11, 11, 11),
('2024-11-05 09:00:00', '2024-11-10 09:00:00', 5, 'Alimentaci�n a base de dieta', 12, 12, 12),
('2024-11-07 08:30:00', '2024-11-11 08:30:00', 4, NULL, 13, 13, 13),
('2024-11-10 07:00:00', '2024-11-13 07:00:00', 3, 'Ejercicio diario', 14, 14, 14),
('2024-11-12 10:00:00', '2024-11-15 10:00:00', 3, NULL, 15, 15, 15),
('2024-11-14 12:00:00', '2024-11-16 12:00:00', 2, 'Supervisi�n m�dica', 16, 16, 16),
('2024-11-13 11:00:00', '2024-11-18 11:00:00', 5, NULL, 17, 17, 17),
('2024-11-15 08:00:00', '2024-11-20 08:00:00', 5, NULL, 18, 18, 18),
('2024-11-18 09:00:00', '2024-11-21 09:00:00', 3, 'Alergia a ciertos alimentos', 19, 19, 19),
('2024-11-20 14:00:00', NULL, 3, NULL, 20, 20, 20),
('2024-09-01 10:00:00', '2024-09-05 10:00:00', 4, 'Ejercicio diario supervisado', 21, 21, 21),
('2024-09-03 11:00:00', '2024-09-07 10:00:00', 4, NULL, 22, 22, 22),
('2024-09-05 13:00:00', '2024-09-09 13:00:00', 4, NULL, 23, 23, 23),
('2024-09-07 09:00:00', '2024-09-12 09:00:00', 5, 'Requiere aislamiento', 24, 24, 24),
('2024-09-10 10:00:00', '2024-09-15 10:00:00', 5, NULL, 25, 25, 25),
('2024-09-12 08:00:00', '2024-09-18 08:00:00', 6, 'Atenci�n en horarios espec�ficos', 26, 26, 26),
('2024-09-14 07:30:00', '2024-09-18 07:30:00', 4, NULL, 27, 27, 27),
('2024-09-17 10:00:00', '2024-09-20 10:00:00', 3, 'Requiere cuidados especiales', 28, 28, 28),
('2024-09-19 11:00:00', '2024-09-23 11:00:00', 4, NULL, 29, 29, 29),
('2024-09-22 12:00:00', '2024-09-27 12:00:00', 5, NULL, 30, 30, 30),
('2024-09-26 09:30:00', '2024-09-29 09:30:00', 3, 'Dieta especial sin carnes', 31, 31, 31),
('2024-09-26 09:30:00', '2024-09-29 09:30:00', 3, NULL, 13, 1, 32),
('2024-09-26 09:30:00', '2024-09-29 09:30:00', 3, NULL, 30, 4, 33),
('2024-09-26 09:30:00', '2024-09-29 09:30:00', 3, NULL, 48, 12, 34),
('2024-09-26 09:30:00', '2024-09-29 09:30:00', 3, 'Tendencias violentas, tener cuidado al interactuar', 24, 3, 35),
('2024-09-26 09:30:00', '2024-09-29 09:30:00', 3, NULL, 25, 41, 36),
('2024-09-26 09:30:00', '2024-09-29 09:30:00', 3, 'Requiere aislamiento', 19, 40, 37),
('2024-09-26 09:30:00', '2024-09-29 09:30:00', 3, NULL, 6, 33, 38),
('2024-09-26 09:30:00', '2024-09-29 09:30:00', 3, NULL, 22, 36, 39),
('2024-09-26 09:30:00', '2024-09-29 09:30:00', 3, 'Dieta especial sin carnes', 30, 34, 40);

-- REGISTROS TIPOS DE SERVICIOS DEL SALON DE BELLEZA 
INSERT INTO TipoServicioBelleza (nombre_tipo_serviciobelleza, descripcion, duracion_aprox_minutos)
VALUES 
('Peluquer�a', 'Corte y arreglo de pelaje', 60),
('Ba�o normal', 'Ba�o b�sico con shampoo suave', 30),
('Ba�o medicado', 'Ba�o con productos m�dicos especializados', 45),
('Drenaje de gl�ndulas perianales', 'Drenaje manual', 20),
('Corte de u�as', 'Corte de u�as de rutina', 15),
('Limpieza de o�dos', 'Limpieza con soluci�n especial', 15),
('Limpieza de dientes', 'Limpieza dental b�sica', 20);

-- REGISTROS EMPLEADOS DEL SALON DE BELLEZA
INSERT INTO EmpleadoBelleza (nombre_empleadobelleza, numero_documento)
VALUES 
('Carlos Mart�nez', 1012345678),
('Mar�a P�rez', 1023456789),
('Juan G�mez', 1034567890),
('Laura Gonz�lez', 1045678901),
('Luis Ram�rez', 1056789012),
('Ana L�pez', 1067890123),
('Pedro Rodr�guez', 1078901234),
('Marta Jim�nez', 1089012345),
('Sof�a Torres', 1090123456),
('Diego S�nchez', 1101234567),
('Camila D�az', 1112345678),
('Andr�s Moreno', 1123456789),
('Paula Mu�oz', 1134567890),
('Javier Castillo', 1145678901),
('Gabriela Ortiz', 1156789012),
('Sebasti�n Rivas', 1167890123),
('Fernanda Reyes', 1178901234),
('Daniela Castro', 1189012345),
('Manuel Vargas', 1190123456),
('Adriana Ruiz', 1201234567),
('Nicol�s Espinosa', 1212345678),
('Valentina Pardo', 1223456789),
('Felipe Valencia', 1234567890),
('Diana Mendoza', 1245678901),
('�ngela Figueroa', 1256789012),
('Miguel Romero', 1267890123),
('Sara Prieto', 1278901234),
('Ricardo Pe�a', 1289012345),
('Carolina Cardozo', 1290123456),
('Jorge Vera', 1301234567),
('Alejandra Herrera', 1312345678),
('David Ni�o', 1323456789),
('Claudia Beltr�n', 1334567890),
('Tom�s C�rdenas', 1345678901),
('Santiago Ram�rez', 1356789012),
('Luc�a Zambrano', 1367890123),
('Esteban Serrano', 1378901234),
('Natalia Bernal', 1389012345),
('Gustavo Pineda', 1390123456),
('Carmen Parra', 1401234567),
('Pablo Guevara', 1412345678),
('Elena Porras', 1423456789),
('Rafael Su�rez', 1434567890),
('Yolanda Giraldo', 1445678901),
('Jos� Mej�a', 1456789012),
('C�sar Medina', 1467890123),
('Teresa Acosta', 1478901234),
('Victoria Quintero', 1489012345),
('Alberto Becerra', 1490123456),
('Rosa Delgadillo', 1501234567),
('Julio Vargas', 1512345678);

-- REGISTROS INSTALACIONES DEL SALON DE BELLEZA
INSERT INTO Instalaci�nBelleza (nombre_instalacionguarderia)
VALUES
('Sala de peluquer�a'),('�rea de ba�o'),
('Sala de procedimientos'),('Zona de atenci�n r�pida');

-- REGISTROS CITAS DEL SALON DE BELLEZA
INSERT INTO CitaBelleza (fecha, hora_inicio, hora_aprox_fin, estado, id_mascota)
VALUES 
('2024-11-01', '09:00', '10:00', 'Cancelada', 41),
('2024-11-02', '10:00', '11:00', 'Realizada', 42),
('2024-11-03', '11:00', '12:00', 'Realizada', 43),
('2024-11-04', '12:00', '13:00', 'Realizada', 44),
('2024-11-05', '13:00', '14:00', 'Realizada', 45),
('2024-11-06', '14:00', '15:00', 'Realizada', 46),
('2024-11-07', '15:00', '16:00', 'Realizada', 47),
('2024-11-08', '16:00', '17:00', 'Realizada', 48),
('2024-11-09', '17:00', '18:00', 'Realizada', 49),
('2024-11-10', '09:00', '10:00', 'Realizada', 50),
('2024-11-11', '10:00', '11:00', 'Realizada', 51),
('2024-11-12', '11:00', '12:00', 'Realizada', 52),
('2024-11-13', '12:00', '13:00', 'Realizada', 53),
('2024-11-14', '13:00', '14:00', 'Asignada', 54),
('2024-11-15', '14:00', '15:00', 'Asignada', 55),
('2024-11-16', '15:00', '16:00', 'Asignada', 56),
('2024-11-17', '16:00', '17:00', 'Asignada', 57),
('2024-11-18', '17:00', '18:00', 'Asignada', 58),
('2024-11-19', '09:00', '10:00', 'Asignada', 59),
('2024-11-20', '10:00', '11:00', 'Asignada', 60),
('2024-11-21', '11:00', '12:00', 'Asignada', 61),
('2024-11-22', '12:00', '13:00', 'Asignada', 62),
('2024-11-23', '13:00', '14:00', 'Asignada', 63),
('2024-11-24', '14:00', '15:00', 'Asignada', 64),
('2024-11-25', '15:00', '16:00', 'Asignada', 65),
('2024-11-26', '16:00', '17:00', 'Asignada', 66),
('2024-11-27', '17:00', '18:00', 'Asignada', 67),
('2024-11-28', '09:00', '10:00', 'Asignada', 68),
('2024-11-29', '10:00', '11:00', 'Asignada', 69),
('2024-11-30', '11:00', '12:00', 'Asignada', 70),
('2024-12-01', '12:00', '13:00', 'Asignada', 71),
('2024-12-02', '13:00', '14:00', 'Asignada', 72),
('2024-12-03', '14:00', '15:00', 'Asignada', 73),
('2024-12-04', '15:00', '16:00', 'Asignada', 74),
('2024-12-05', '16:00', '17:00', 'Asignada', 75),
('2024-12-06', '17:00', '18:00', 'Asignada', 76),
('2024-12-07', '09:00', '10:00', 'Asignada', 77),
('2024-12-08', '10:00', '11:00', 'Asignada', 78),
('2024-12-09', '11:00', '12:00', 'Asignada', 79),
('2024-12-10', '12:00', '13:00', 'Asignada', 80),
('2024-12-11', '13:00', '14:00', 'Asignada', 81),
('2024-12-12', '14:00', '15:00', 'Asignada', 82),
('2024-12-13', '15:00', '16:00', 'Asignada', 83),
('2024-12-14', '16:00', '17:00', 'Asignada', 84),
('2024-12-15', '17:00', '18:00', 'Asignada', 85),
('2024-12-16', '09:00', '10:00', 'Asignada', 86),
('2024-12-17', '10:00', '11:00', 'Asignada', 87),
('2024-12-18', '11:00', '12:00', 'Asignada', 88),
('2024-12-19', '12:00', '13:00', 'Asignada', 89),
('2024-12-20', '13:00', '14:00', 'Cancelada', 90);

-- REGISTROS CLIENTES PREFERENTES DEL SALON DE BELLEZA 
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',1);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',2);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',3);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',4);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',5);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',6);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',7);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',8);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',9);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',10);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',11);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',12);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',13);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',14);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',15);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',16);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',17);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',18);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',19);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',20);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',21);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',22);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',23);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',24);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',25);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',26);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',27);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',28);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',29);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',30);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',31);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',32);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',33);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',34);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',35);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',36);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',37);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',38);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',39);
INSERT INTO ClientePreferenteBelleza(fecha_registro,motivo,id_propietario) VALUES ('2024-10-05','Cliente frecuente',40);

-- REGISTROS SERVICIOS PRESTADOS DEL SALON DE BELLEZA
INSERT INTO ServicioBelleza(id_instalacionbelleza, id_empleadobelleza, estado_serviciobelleza, id_tipo_serviciobelleza, id_citabelleza)
VALUES 
(1, 1, 'Cancelado', 1, 1),
(2, 2, 'Realizado', 2, 2),
(2, 3, 'Realizado', 3, 3),
(1, 4, 'Realizado', 1, 4),
(2, 5, 'Realizado', 2, 5),
(2, 6, 'Realizado', 3, 6),
(1, 7, 'Realizado', 1, 7),
(2, 8, 'Realizado', 2, 8),
(2, 9, 'Realizado', 3, 9),
(1, 10, 'Realizado', 1, 10),
(2, 11, 'Realizado', 2, 11),
(2, 12, 'Realizado', 3, 12),
(1, 13, 'Realizado', 1, 13),
(2, 14, 'Asignado', 2, 14),
(3, 15, 'Asignado', 4, 15),
(1, 16, 'Asignado', 1, 16),
(4, 17, 'Asignado', 6, 17),
(4, 18, 'Asignado', 7, 18),
(1, 19, 'Asignado', 1, 19),
(3, 20, 'Asignado', 4, 20),
(4, 21, 'Asignado', 5, 21),
(1, 22, 'Asignado', 1, 22),
(4, 23, 'Asignado', 6, 23),
(2, 24, 'Asignado', 3, 24),
(3, 25, 'Asignado', 4, 25),
(4, 26, 'Asignado', 7, 26),
(2, 27, 'Asignado', 3, 27),
(1, 28, 'Asignado', 1, 28),
(2, 29, 'Asignado', 2, 29),
(4, 30, 'Asignado', 5, 30),
(1, 31, 'Asignado', 1, 31),
(2, 32, 'Asignado', 2, 32),
(4, 33, 'Asignado', 7, 33),
(3, 34, 'Asignado', 4, 34),
(2, 35, 'Asignado', 3, 35),
(4, 36, 'Asignado', 7, 36),
(3, 37, 'Asignado', 4, 37),
(2, 38, 'Asignado', 3, 38),
(4, 39, 'Asignado', 6, 39),
(2, 40, 'Asignado', 3, 40),
(4, 42, 'Asignado', 5, 41),
(2, 43, 'Asignado', 2, 42),
(3, 44, 'Asignado', 4, 43),
(4, 45, 'Asignado', 6, 44),
(2, 46, 'Asignado', 3, 45),
(3, 47, 'Asignado', 4, 46),
(4, 48, 'Asignado', 6, 47),
(4, 49, 'Asignado', 5, 48),
(4, 50, 'Asignado', 6, 49),
(4, 51, 'Cancelado', 5, 50);

-- REGISTROS PROVEEDORES DE LA TIENDA DE MASCOTAS
INSERT INTO ProveedorTienda (nombre_proveedor, telefono, direccion)
VALUES 
('Proveedor A', '3011234567', 'Calle 123 #45-67, Ciudad A'),
('Proveedor B', '3021234567', 'Carrera 5 #10-20, Ciudad B'),
('Proveedor C', '3031234567', 'Avenida 7 #30-15, Ciudad C'),
('Proveedor D', '3041234567', 'Diagonal 12 #33-21, Ciudad D'),
('Proveedor E', '3051234567', 'Transversal 3 #22-09, Ciudad E'),
('Proveedor F', '3061234567', 'Calle 55 #60-13, Ciudad F'),
('Proveedor G', '3071234567', 'Carrera 22 #13-45, Ciudad G'),
('Proveedor H', '3081234567', 'Avenida 15 #50-30, Ciudad H'),
('Proveedor I', '3091234567', 'Calle 10 #10-20, Ciudad I'),
('Proveedor J', '3101234567', 'Carrera 40 #10-80, Ciudad J'),
('Proveedor K', '3111234567', 'Calle 20 #30-25, Ciudad K'),
('Proveedor L', '3121234567', 'Carrera 15 #40-30, Ciudad L'),
('Proveedor M', '3131234567', 'Avenida 18 #50-40, Ciudad M'),
('Proveedor N', '3141234567', 'Calle 30 #20-10, Ciudad N'),
('Proveedor O', '3151234567', 'Carrera 7 #11-35, Ciudad O'),
('Proveedor P', '3161234567', 'Avenida 1 #60-45, Ciudad P'),
('Proveedor Q', '3171234567', 'Carrera 5 #11-80, Ciudad Q'),
('Proveedor R', '3181234567', 'Calle 33 #21-12, Ciudad R'),
('Proveedor S', '3191234567', 'Avenida 22 #55-30, Ciudad S'),
('Proveedor T', '3201234567', 'Calle 3 #50-70, Ciudad T'),
('Proveedor U', '3211234567', 'Carrera 45 #23-10, Ciudad U'),
('Proveedor V', '3221234567', 'Avenida 11 #10-22, Ciudad V'),
('Proveedor W', '3231234567', 'Carrera 6 #40-33, Ciudad W'),
('Proveedor X', '3241234567', 'Calle 50 #55-22, Ciudad X'),
('Proveedor Y', '3251234567', 'Carrera 10 #15-50, Ciudad Y'),
('Proveedor Z', '3261234567', 'Avenida 17 #25-80, Ciudad Z'),
('Proveedor AA', '3271234567', 'Calle 70 #20-30, Ciudad AA'),
('Proveedor AB', '3281234567', 'Carrera 21 #50-20, Ciudad AB'),
('Proveedor AC', '3291234567', 'Avenida 30 #60-10, Ciudad AC'),
('Proveedor AD', '3301234567', 'Carrera 22 #33-40, Ciudad AD'),
('Proveedor AE', '3311234567', 'Calle 33 #40-33, Ciudad AE'),
('Proveedor AF', '3321234567', 'Avenida 8 #21-11, Ciudad AF'),
('Proveedor AG', '3331234567', 'Carrera 9 #10-22, Ciudad AG'),
('Proveedor AH', '3341234567', 'Calle 5 #14-23, Ciudad AH'),
('Proveedor AI', '3351234567', 'Avenida 13 #50-40, Ciudad AI'),
('Proveedor AJ', '3361234567', 'Calle 45 #60-50, Ciudad AJ'),
('Proveedor AK', '3371234567', 'Calle 33 #22-32, Ciudad AK'),
('Proveedor AL', '3381234567', 'Carrera 8 #50-11, Ciudad AL'),
('Proveedor AM', '3391234567', 'Avenida 12 #30-60, Ciudad AM'),
('Proveedor AN', '3401234567', 'Calle 40 #70-90, Ciudad AN');

-- RESGISTROS DE PEDIDOS DE LA TIENDA DE MASCOTAS
INSERT INTO Pedido (fecha_pedido, estado_pedido, valor_pedido, id_proveedor)
VALUES 
('2024-01-10', 'Recibido', 50000, 1),
('2024-01-15', 'Recibido', 150000, 2),
('2024-01-20', 'Recibido', 120000, 3),
('2024-01-25', 'Recibido', 75000, 4),
('2024-02-01', 'Recibido', 45000, 5),
('2024-02-05', 'Recibido', 200000, 6),
('2024-02-10', 'Recibido', 180000, 7),
('2024-02-15', 'Recibido', 135000, 8),
('2024-02-20', 'Recibido', 105000, 9),
('2024-02-25', 'Recibido', 160000, 10),
('2024-03-01', 'Recibido', 50000, 11),
('2024-03-05', 'Recibido', 95000, 12),
('2024-03-10', 'Recibido', 110000, 13),
('2024-03-15', 'Recibido', 130000, 14),
('2024-03-20', 'Recibido', 115000, 15),
('2024-03-25', 'Recibido', 100000, 16),
('2024-04-01', 'Recibido', 95000, 17),
('2024-04-05', 'Recibido', 125000, 18),
('2024-04-10', 'Recibido', 120000, 19),
('2024-04-15', 'Recibido', 150000, 20),
('2024-04-20', 'Recibido', 95000, 21),
('2024-04-25', 'Recibido', 80000, 22),
('2024-05-01', 'Recibido', 145000, 23),
('2024-05-05', 'Recibido', 155000, 24),
('2024-05-10', 'Recibido', 160000, 25),
('2024-05-15', 'Recibido', 105000, 26),
('2024-05-20', 'Recibido', 75000, 27),
('2024-05-25', 'Recibido', 180000, 28),
('2024-06-01', 'Recibido', 95000, 29),
('2024-06-05', 'Recibido', 90000, 30),
('2024-06-10', 'Recibido', 95000, 31),
('2024-06-15', 'Recibido', 155000, 32),
('2024-06-20', 'Recibido', 145000, 33),
('2024-06-25', 'Recibido', 105000, 34),
('2024-07-01', 'Recibido', 75000, 35),
('2024-07-05', 'Recibido', 85000, 36),
('2024-07-10', 'Recibido', 130000, 37),
('2024-07-15', 'Recibido', 115000, 38),
('2024-07-20', 'Recibido', 170000, 39),
('2024-07-25', 'Recibido', 90000, 40);

-- REGISTROS PRODUCTOS DE LA TIENDA DE MASCOTAS
INSERT INTO Producto (nombre_producto, tipo_producto, edad_recomendada, tama�o_recomendado, Stock, precio_unitario)
VALUES 
('Alimento para perros', 'Alimento', 'Adulto', 'Grande', 100, 25000),
('Juguete para gatos', 'Accesorio', 'Cachorro', 'Peque�o', 100, 15000),
('Cama para perros', 'Accesorio', 'Adulto', 'Grande', 100, 80000),
('Cepillo para gatos', 'Accesorio', 'Adulto', 'Mediano', 100, 20000),
('Correa para perros', 'Accesorio', 'Cachorro', 'Mediano', 100, 18000),
('Alimento para gatos', 'Alimento', 'Adulto', 'Peque�o', 100, 27000),
('Comedero para perros', 'Accesorio', 'Cachorro', 'Grande', 100, 30000),
('Juguete para perros', 'Accesorio', 'Adulto', 'Mediano', 100, 12000),
('Rascador para gatos', 'Accesorio', 'Cachorro', 'Grande', 100, 45000),
('Alimento para aves', 'Alimento', 'Adulto', 'Peque�o', 100, 10000),
('Collar para gatos', 'Accesorio', 'Adulto', 'Peque�o', 100, 15000),
('Casa para perros', 'Accesorio', 'Adulto', 'Grande', 100, 120000),
('Cepillo para perros', 'Accesorio', 'Adulto', 'Mediano', 100, 25000),
('Arenero para gatos', 'Accesorio', 'Adulto', 'Mediano', 100, 30000),
('Correa retr�ctil', 'Accesorio', 'Cachorro', 'Mediano', 100, 22000),
('Alimento para peces', 'Alimento', 'Adulto', 'Peque�o', 100, 8000),
('Arena para gatos', 'Alimento', 'Adulto', 'Mediano', 100, 20000),
('Jaula para aves', 'Accesorio', 'Adulto', 'Grande', 100, 60000),
('Ropa para perros', 'Accesorio', 'Cachorro', 'Peque�o', 100, 20000),
('Snack para perros', 'Alimento', 'Adulto', 'Peque�o', 100, 12000),
('Collar con placas', 'accesorio', 'todas las edades', 'mediano', 100, 5000),
('Bolsa de croquetas para gatos', 'alimento', 'adulto', 'peque�o', 100, 12000),
('Jaula para aves', 'accesorio', 'todas las edades', 'grande', 100, 80000),
('Juguete interactivo', 'juguete', 'cachorro', 'peque�o', 100, 20000),
('Peluche para perros', 'juguete', 'adulto', 'mediano', 100, 22000),
('Suplemento vitam�nico', 'medicina', 'adulto', 'peque�o', 100, 18000),
('Rascador para gatos', 'accesorio', 'todas las edades', 'grande', 100, 55000),
('Arena para gatos', 'accesorio', 'todas las edades', 'peque�o', 100, 10000),
('Cepillo para pelaje', 'accesorio', 'todas las edades', 'mediano', 100, 15000),
('Juguete de cuerda', 'juguete', 'adulto', 'mediano', 100, 7000),
('Shampoo antipulgas', 'medicina', 'todas las edades', 'mediano', 100, 35000),
('Pipeta para pulgas', 'medicina', 'adulto', 'peque�o', 100, 14000),
('Comedero interactivo', 'accesorio', 'todas las edades', 'grande', 100, 40000),
('Collar luminoso', 'accesorio', 'adulto', 'peque�o', 100, 17000),
('Transportadora peque�a', 'accesorio', 'cachorro', 'peque�o', 100, 90000),
('Golosinas para perros', 'alimento', 'todas las edades', 'peque�o', 100, 8000),
('Bebedero autom�tico', 'accesorio', 'adulto', 'mediano', 100, 45000),
('Jaula para perros', 'accesorio', 'adulto', 'grande', 100, 120000),
('Manta t�rmica', 'accesorio', 'adulto', 'mediano', 100, 25000),
('Cama ortop�dica', 'accesorio', 'adulto', 'grande', 100, 100000);

-- REGISTROS LOTES DE PRODUCTOS DE LA TIENDA DE MASCOTAS
INSERT INTO Lote (cantidad_producto_pedido, fecha_vencimiento, id_producto, id_pedido)
VALUES 
(200, '2025-10-15', 1, 1),   
(200, '2025-09-20', 2, 2),   
(200, '2025-10-01', 3, 3),   
(200, '2025-08-15', 4, 4),   
(200, '2025-09-10', 5, 5),  
(200, '2025-07-25', 6, 6),  
(200, '2025-10-05', 7, 7),  
(200, '2025-06-20', 8, 8),  
(200, '2025-08-15', 9, 9),  
(200, '2025-09-05', 10, 10), 
(200, '2025-07-10', 11, 11),  
(200, '2025-06-18', 12, 12),  
(200, '2025-09-22', 13, 13),  
(200, '2025-07-05', 14, 14),  
(200, '2025-08-12', 15, 15), 
(200, '2025-06-10', 16, 16),  
(200, '2025-08-01', 17, 17),  
(200, '2025-09-28', 18, 18), 
(200, '2025-07-05', 19, 19), 
(200, '2025-06-30', 20, 20), 
(200, '2025-08-15', 21, 21), 
(200, '2025-09-01', 22, 22), 
(200, '2025-10-25', 23, 23),  
(200, '2025-09-10', 24, 24),   
(200, '2025-08-19', 25, 25),  
(200, '2025-10-09', 26, 26), 
(200, '2025-09-27', 27, 27),  
(200, '2025-07-10', 28, 28),  
(200, '2025-08-15', 29, 29),  
(200, '2025-06-20', 30, 30), 
(200, '2025-07-25', 31, 31), 
(200, '2025-09-01', 32, 32), 
(200, '2025-08-12', 33, 33), 
(200, '2025-06-15', 34, 34),   
(200, '2025-10-08', 35, 35),  
(200, '2025-09-21', 36, 36),  
(200, '2025-08-17', 37, 37), 
(200, '2025-07-20', 38, 38), 
(200, '2025-08-30', 39, 39),  
(200, '2025-06-25', 40, 40);

-- REGISTROS COMPRAS DE CLIENTES EN LA TIENDA DE MASCOTAS
INSERT INTO Compra (fecha_compra, id_propietario, valor_total_compra)
VALUES
('2024-10-15',11,2500000),
('2024-10-15',12,1500000),
('2024-10-15',13,8000000),
('2024-10-15',14,2000000),
('2024-10-15',15,1800000),
('2024-10-15',16,2700000),
('2024-10-15',17,3000000),
('2024-10-15',18,1200000),
('2024-10-15',19,4500000),
('2024-10-15',20,1000000),
('2024-10-15',21,1500000),
('2024-10-15',22,12000000),
('2024-10-15',23,2500000),
('2024-10-15',24,3000000),
('2024-10-15',25,2200000),
('2024-10-15',26,800000),
('2024-10-15',27,2000000),
('2024-10-15',28,6000000),
('2024-10-15',29,2000000),
('2024-10-15',30,1200000),
('2024-10-15',31,500000),
('2024-10-15',32,1200000),
('2024-10-15',33,8000000),
('2024-10-15',34,2000000),
('2024-10-15',35,2200000),
('2024-10-15',36,1800000),
('2024-10-15',37,5500000),
('2024-10-15',38,1000000),
('2024-10-15',39,1500000),
('2024-10-15',40,700000),
('2024-10-15',41,3500000),
('2024-10-15',42,1400000),
('2024-10-15',43,4000000),
('2024-10-15',44,1700000),
('2024-10-15',45,9000000),
('2024-10-15',46,800000),
('2024-10-15',47,4500000),
('2024-10-15',48,12000000),
('2024-10-15',49,2500000),
('2024-10-15',50,10000000);

-- REGISTROS DE DETALLES DE LAS COMPRAS EN LA TIENDA DE MASCOTAS
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,2500000,1,1);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,1500000,2,2);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,8000000,3,3);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,2000000,4,4);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,1800000,5,5);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,2700000,6,6);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,3000000,7,7);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,1200000,8,8);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,4500000,9,9);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,1000000,10,10);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,1500000,11,11);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,12000000,12,12);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,2500000,13,13);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,3000000,14,14);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,2200000,15,15);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,800000,16,16);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,2000000,17,17);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,6000000,18,18);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,2000000,19,19);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,1200000,20,20);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,500000,21,21);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,1200000,22,22);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,8000000,23,23);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,2000000,24,24);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,2200000,25,25);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,1800000,26,26);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,5500000,27,27);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,1000000,28,28);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,1500000,29,29);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,700000,30,30);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,3500000,31,31);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,1400000,32,32);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,4000000,33,33);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,1700000,34,34);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,9000000,35,35);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,800000,36,36);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,4500000,37,37);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,12000000,38,38);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,2500000,39,39);
INSERT INTO DetalleCompra (cantidad_producto, valor_total_detalle,id_compra ,id_producto) VALUES (100,10000000,40,40);

-- REGISTROS HISTORIA CLINICA DE LAS MASCOTAS
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-01',1);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-02',2);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-03',3);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-04',4);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-05',5);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-06',6);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-07',7);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-08',8);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-09',9);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-10',10);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-11',11);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-12',12);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-13',13);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-14',14);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-15',15);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-16',16);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-17',17);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-18',18);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-19',19);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-20',20);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-21',21);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-22',22);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-23',23);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-24',24);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-25',25);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-26',26);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-27',27);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-28',28);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-29',29);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-30',30);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2023-10-31',31);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2024-11-01',32);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2024-11-02',33);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2024-11-03',34);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2024-11-04',35);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2024-11-05',36);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2024-11-06',37);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2024-11-07',38);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2024-11-08',39);
INSERT INTO HistoriaClinica(fecha_apertura_historiaclinica,id_mascota) VALUES ('2024-11-09',40);

-- REGISTROS DE ATENCIONES MEDICAS 
INSERT INTO AtencionMedica (fecha_atencion, motivo_consulta, anamnesis, tratamiento_previo, evolucion, diagnostico_presuntivo, diagnostico_definitivo, id_historiaclinica)
VALUES 
('2024-10-10', 'Revisi�n general', 'Mascota activa y comiendo bien', 'Ninguno', 'Salud estable', 'Posible dermatitis', 'Dermatitis leve', 1),
('2024-10-11', 'Problemas digestivos', 'V�mitos y diarrea', 'Medicamento X', 'Mejor�a parcial', 'Gastroenteritis', 'Gastroenteritis aguda', 2),
('2024-10-12', 'Cojea al caminar', 'Accidente en el parque', 'Ninguno', 'Cojea menos', 'Fractura menor', 'Fractura de metatarso', 3),
('2024-10-13', 'P�rdida de apetito', 'Ha dejado de comer hace dos d�as', 'Ninguno', 'Apetito recuperado', 'Infecci�n viral', 'Parvovirus', 4),
('2024-10-14', 'Infecci�n ocular', 'Ojo enrojecido', 'Pomada oft�lmica', 'Reducci�n de inflamaci�n', 'Conjuntivitis', 'Conjuntivitis al�rgica', 5),
('2024-10-15', 'Chequeo prequir�rgico', 'Preparaci�n para cirug�a', 'Ninguno', 'Salud estable', 'Evaluaci�n prequir�rgica', 'Apto para cirug�a', 6),
('2024-10-16', 'Problema de piel', 'Rascado excesivo', 'Ba�o medicado', 'Menos irritaci�n', 'Dermatitis al�rgica', 'Dermatitis', 7),
('2024-10-17', 'Problemas respiratorios', 'Dificultad al respirar', 'Inhalador', 'Sin cambios', 'Asma', 'Asma bronquial', 8),
('2024-10-18', 'Examen anual', 'Sin antecedentes relevantes', 'Ninguno', 'Normal', 'Chequeo general', 'Salud �ptima', 9),
('2024-10-19', 'Dolor abdominal', 'Llora al tocar abdomen', 'Medicamento Y', 'Mejor�a', 'Colitis', 'Colitis leve', 10),
('2024-10-20', 'Control de diabetes', 'Tratamiento con insulina', 'Insulina', 'Estable', 'Seguimiento de diabetes', 'Diabetes controlada', 11),
('2024-10-21', 'V�mitos', 'V�mitos frecuentes', 'Antiem�tico', 'V�mitos controlados', 'Intoxicaci�n alimentaria', 'Intoxicaci�n leve', 12),
('2024-10-22', 'Problemas de comportamiento', 'Mordisquea objetos', 'Adiestramiento', 'Mejoras evidentes', 'Ansiedad', 'Ansiedad por separaci�n', 13),
('2024-10-23', 'Herida en pata', 'Corte reciente', 'Desinfecci�n', 'Cicatrizaci�n avanzada', 'Corte superficial', 'Herida cicatrizada', 14),
('2024-10-24', 'Chequeo postoperatorio', 'Revisi�n de suturas', 'Analg�sicos', 'Suturas en buen estado', 'Seguimiento de cirug�a', 'Recuperaci�n favorable', 15),
('2024-10-25', 'Problemas de visi�n', 'Opacidad en ojos', 'L�grimas artificiales', 'Sin cambios', 'Cataratas', 'Cataratas avanzadas', 16),
('2024-10-26', 'Diarrea persistente', 'Diarrea por m�s de 3 d�as', 'Hidrataci�n', 'Diarrea reducida', 'Infecci�n intestinal', 'Infecci�n leve', 17),
('2024-10-27', 'Control de peso', 'Sobrepeso', 'Dieta especial', 'P�rdida de peso', 'Obesidad', 'Peso controlado', 18),
('2024-10-28', 'Otitis', 'Sacudidas de cabeza', 'Antibi�tico', 'Menos sacudidas', 'Otitis externa', 'Otitis tratada', 19),
('2024-10-29', 'Chequeo dental', 'Halitosis', 'Limpieza dental', 'Mejora en aliento', 'Sarro', 'Sarro removido', 20),
('2024-10-30', 'Infecci�n urinaria', 'Orina con sangre', 'Antibi�tico', 'Orina normal', 'Cistitis', 'Cistitis tratada', 21),
('2024-11-01', 'Consulta por tos', 'Tos seca', 'Jarabe', 'Tos reducida', 'Tos de perrera', 'Tos tratada', 22),
('2024-11-02', 'Chequeo cardiaco', 'Soplo en coraz�n', 'Control con especialista', 'Sin cambios', 'Problema cardiaco', 'Cardiopat�a', 23),
('2024-11-03', 'P�rdida de pelo', 'Ca�da excesiva de pelo', 'Champ� medicado', 'Menos ca�da', 'Alergia estacional', 'Alergia controlada', 24),
('2024-11-04', 'Chequeo reproductivo', 'Preparaci�n para cruza', 'Ninguno', 'Apto para cruza', 'Evaluaci�n reproductiva', 'Salud reproductiva �ptima', 25),
('2024-11-05', 'Control de vacunaci�n', 'Refuerzo de vacuna anual', 'Vacunaci�n previa', 'Vacuna aplicada', 'Calendario de vacunaci�n', 'Vacunaci�n completa', 26),
('2024-11-06', 'Dificultad al caminar', 'Dolor en articulaciones', 'Antiinflamatorio', 'Mejora en movilidad', 'Artritis', 'Artritis tratada', 27),
('2024-11-07', 'Consulta por fiebre', 'Fiebre intermitente', 'Antipir�tico', 'Fiebre controlada', 'Infecci�n viral', 'Infecci�n tratada', 28),
('2024-11-08', 'Chequeo de piel', 'Manchas en piel', 'Cremas t�picas', 'Manchas desapareciendo', 'Hongos en piel', 'Micosis tratada', 29),
('2024-11-09', 'Urgencia por golpe', 'Ca�da desde altura', 'Radiograf�a', 'Fractura leve', 'Contusi�n', 'Contusi�n tratada', 30),
('2024-11-10', 'Chequeo por letargo', 'Mascota deca�da', 'Vitaminas', 'Energ�a recuperada', 'Deficiencia de vitaminas', 'Anemia leve', 31),
('2024-11-11', 'Visita por tos', 'Tos con mucosidad', 'Jarabe expectorante', 'Tos mejorada', 'Bronquitis', 'Bronquitis tratada', 32),
('2024-11-12', 'Limpieza de dientes', 'Dientes amarillentos', 'Limpieza dental', 'Dientes m�s limpios', 'Placa dental', 'Placa removida', 33),
('2024-11-13', 'Consulta por hinchaz�n', 'Hinchaz�n en abdomen', 'Dieta l�quida', 'Hinchaz�n reducida', 'Distensi�n abdominal', 'Distensi�n tratada', 34),
('2024-11-14', 'Chequeo dermatol�gico', 'Erupciones en piel', 'Cremas antimic�ticas', 'Menos erupciones', 'Dermatitis por contacto', 'Dermatitis resuelta', 35),
('2024-11-10', 'Revisi�n de articulaciones', 'Dolor en cadera', 'Suplementos', 'Dolor reducido', 'Displasia de cadera', 'Displasia tratada', 36),
('2024-11-10', 'Chequeo de o�dos', 'Mal olor en o�dos', 'Gotas �ticas', 'Sin mal olor', 'Infecci�n de o�do', 'Infecci�n tratada', 37),
('2024-11-10', 'Consulta de comportamiento', 'Comportamiento agresivo', 'Adiestramiento', 'Comportamiento mejorado', 'Estr�s', 'Estr�s tratado', 38),
('2024-11-10', 'Evaluaci�n de movilidad', 'Rigidez al moverse', 'Terapia f�sica', 'Mejora en movilidad', 'Problema articular', 'Artrosis tratada', 39),
('2024-11-10', 'Problema ocular', 'Lagrimeo constante', 'L�grimas artificiales', 'Lagrimeo reducido', 'Obstrucci�n de conducto lagrimal', 'Obstrucci�n tratada', 40);

-- REGISTROS DE TIPOS DE EXAMENES EN LA CLINICA
INSERT INTO TipoExamen (nombre_tipo_examen, descripcion_examen)
VALUES
('Hemograma completo', 'Examen de sangre para evaluar la cantidad y tipo de c�lulas en la sangre.'),
('Perfil bioqu�mico', 'An�lisis de los componentes qu�micos en la sangre, como glucosa y prote�nas.'),
('Urian�lisis', 'Prueba para evaluar la composici�n de la orina y detectar infecciones o anomal�as.'),
('Coprol�gico', 'An�lisis de las heces para detectar par�sitos o infecciones intestinales.'),
('Radiograf�a de t�rax', 'Imagen de rayos X para evaluar el estado de los pulmones y coraz�n.'),
('Radiograf�a de abdomen', 'Imagen de rayos X para diagnosticar problemas en los �rganos abdominales.'),
('Ecograf�a abdominal', 'Estudio de ultrasonido para revisar los �rganos internos del abdomen.'),
('Ecocardiograma', 'Ultrasonido del coraz�n para evaluar su estructura y funci�n.'),
('Examen oftalmol�gico', 'Evaluaci�n de la salud de los ojos y detecci�n de problemas visuales.'),
('Electrocardiograma', 'Prueba para medir la actividad el�ctrica del coraz�n.'),
('Prueba de alergias', 'Examen para identificar posibles al�rgenos que afecten a la mascota.'),
('Biopsia de piel', 'Extracci�n de una muestra de piel para detectar enfermedades dermatol�gicas.'),
('Cultivo bacteriano', 'Prueba para identificar infecciones bacterianas en diferentes muestras.'),
('Cultivo f�ngico', 'Prueba para detectar hongos en muestras de piel o mucosas.'),
('Test de parvovirus', 'Prueba r�pida para confirmar la presencia del parvovirus en perros.'),
('Prueba de distemper', 'Detecci�n del virus del moquillo en caninos.'),
('Prueba de giardia', 'Examen para detectar la presencia del par�sito giardia en las heces.'),
('Prueba de leishmaniasis', 'Test para identificar la presencia de leishmaniasis en perros.'),
('Perfil hep�tico', 'An�lisis para evaluar el funcionamiento del h�gado.'),
('Perfil renal', 'Prueba de sangre para analizar el funcionamiento de los ri�ones.'),
('Examen de tiroides', 'Evaluaci�n de los niveles de hormonas tiroideas en sangre.'),
('Prueba de cortisol', 'Examen para medir los niveles de cortisol en sangre y detectar problemas adrenales.'),
('Citolog�a de o�dos', 'An�lisis de una muestra del canal auditivo para detectar infecciones.'),
('Test de dirofilariosis', 'Prueba para detectar la presencia de gusanos del coraz�n.'),
('Prueba de brucelosis', 'Detecci�n de la brucelosis en animales.'),
('Prueba de ehrlichiosis', 'Examen para confirmar la presencia de ehrlichiosis en perros.'),
('Prueba de anaplasmosis', 'Test para detectar la anaplasmosis en sangre.'),
('Examen de espermograma', 'An�lisis de la calidad del semen en animales para reproducci�n.'),
('Examen fecal flotaci�n', 'Prueba de laboratorio para detectar huevos de par�sitos en heces.'),
('Citolog�a vaginal', 'Examen para evaluar el estado reproductivo de hembras.'),
('Test de progesterona', 'Medici�n de los niveles de progesterona en hembras para control reproductivo.'),
('Prueba de leishmania', 'Detecci�n espec�fica de la enfermedad de leishmaniasis.'),
('Test de piel para alergias', 'Prueba cut�nea para determinar alergias espec�ficas.'),
('Test de glucosa en sangre', 'Medici�n r�pida de los niveles de glucosa.'),
('Prueba de funci�n pancre�tica', 'An�lisis para evaluar el estado y funci�n del p�ncreas.'),
('Perfil lip�dico', 'Evaluaci�n de los niveles de colesterol y triglic�ridos en sangre.'),
('Prueba de �cido �rico', 'An�lisis para medir el �cido �rico en sangre.'),
('Test de filariosis', 'Examen para detectar la presencia de filarias.'),
('Prueba de coagulopat�a', 'Prueba para detectar trastornos de la coagulaci�n sangu�nea.'),
('Examen serol�gico', 'Prueba para identificar anticuerpos en sangre y confirmar enfermedades infecciosas.');


-- REGISTROS DE TIPOS DE SERVICIOS MEDICOS
INSERT INTO TipoServicioMedico (nombre_tipo_serviciomedico, descripcion_tipo_serviciomedico)
VALUES 
('General', 'Servicios generales de consulta y atenciones primarias'),
('Especializado', 'Servicios que requieren atenci�n avanzada y especialistas'),
('Laboratorio', 'Servicios de an�lisis cl�nico');

-- REGISTROS DE SERVICIOS MEDICOS OFRECIDOS EN LA VETERINARIA
INSERT INTO ServicioMedico (nombre_servicio_medico, descripcion_servicio_medico, id_tipo_serviciomedico)
VALUES
('Consulta', 'Atenci�n primaria y revisi�n m�dica', 1),
('Vacunaci�n', 'Aplicaci�n de vacunas para prevenci�n de enfermedades', 1),
('Imagenolog�a', 'Estudios de im�genes como radiograf�as y ultrasonidos', 1),
('Urgencias', 'Atenci�n de emergencias m�dicas', 1),
('Interconsulta', 'Consulta especializada con otros profesionales m�dicos', 2),
('Cirug�a', 'Intervenci�n quir�rgica para tratar afecciones', 2),
('Fisioterapia', 'Tratamiento para mejorar el movimiento y aliviar el dolor', 2),
('Cuidados Intensivos', 'Atenci�n cr�tica para casos graves', 2),
('Oftalmolog�a', 'Atenci�n y tratamiento de condiciones oculares', 2),
('Neurolog�a', 'Diagn�stico y tratamiento de trastornos neurol�gicos', 2),
('Tratamientos Especiales', 'Protocolos de atenci�n para casos �nicos', 2),
('Comportamiento Animal', 'Evaluaci�n y tratamiento de conductas animales', 2),
('Tratamientos Alternativos', 'Opciones de terapia no convencionales', 2),
('Manejo Reproductivo', 'Servicios relacionados con la salud reproductiva', 2),
('An�lisis de Sangre', 'Ex�menes de laboratorio de rutina.', 3),
('Pruebas de Orina', 'An�lisis de orina para detectar anomal�as.', 3),
('Cultivo Bacteriano', 'Detecci�n de infecciones bacterianas.', 3),
('Biopsia', 'Toma de muestra de tejido para an�lisis.', 3),
('Ultrasonido', 'Examen de imagenolog�a para ver �rganos internos.', 3);

-- REGISTROS DE SERVICIOS MEDICOS PRESTADOS DURANTE LA ATENCION
INSERT INTO AtencionMedica_ServicioMedico (detalles, recomendaciones, id_atencionmedica, id_servicio_medico)
VALUES
('Revisi�n de signos vitales y estado general de salud.', 'Mantener chequeo cada seis meses.', 1, 1),
('Aplicaci�n de vacuna anual contra rabia.', 'Evitar exposici�n a otros animales por 24 horas.', 26, 2),
('Radiograf�a de extremidad para revisar posible fractura.', 'Evitar movimientos bruscos por dos semanas.', 3, 3),
('Atenci�n urgente por colapso respiratorio.', 'Revisi�n en 24 horas para evaluar mejor�a.', 8, 4),
('Consulta de interconsulta para posible cirug�a.', 'Preparar al paciente para cirug�a la pr�xima semana.', 15, 5),
('Cirug�a para remover quiste en la piel.', 'Aplicar antibi�tico y revisar herida cada dos d�as.', 16, 6),
('Fisioterapia de extremidad tras recuperaci�n de fractura.', 'Realizar ejercicios diarios en casa.', 27, 7),
('Estabilizaci�n y monitoreo en cuidados intensivos.', 'Revisi�n cada hora durante las pr�ximas 24 horas.', 20, 8),
('Revisi�n ocular por opacidad en la c�rnea.', 'Administrar gotas oft�lmicas y evitar luz directa.', 25, 9),
('Consulta de neurolog�a por episodios de convulsiones.', 'Evitar est�mulos fuertes y administrar medicaci�n.', 22, 10),
('Aplicaci�n de protocolo especial para caso de diabetes.', 'Control de glucosa cada semana.', 10, 11),
('Evaluaci�n de comportamiento agresivo y recomendaciones.', 'Iniciar sesiones de adiestramiento.', 13, 12),
('Aplicaci�n de acupuntura para aliviar dolor cr�nico.', 'Volver cada dos semanas para refuerzo.', 14, 13),
('Revisi�n reproductiva y control de niveles hormonales.', 'Aplicar control para pr�ximo ciclo reproductivo.', 18, 14),
('Extracci�n de muestra sangu�nea para hemograma.', 'Evitar alimentos s�lidos antes de la pr�xima prueba.', 7, 15),
('An�lisis de orina para detectar posibles infecciones.', 'Repetir examen si persiste el malestar.', 30, 16),
('Cultivo bacteriano de herida para identificar infecci�n.', 'Limpiar la herida y mantener �rea seca.', 23, 17),
('Biopsia de piel para detectar dermatitis.', 'Mantener la zona limpia y esperar resultados.', 12, 18),
('Examen de ultrasonido abdominal para evaluar bazo.', 'Evitar comidas pesadas antes de la pr�xima visita.', 5, 19),
('Consulta por s�ntomas de alergia y malestar general.', 'Administrar antihistam�nicos y evitar al�rgenos.', 11, 1),
('Vacunaci�n para prevenir parvovirus.', 'Evitar contacto con otros animales por 72 horas.', 17, 2),
('Radiograf�a de t�rax por problemas respiratorios.', 'Evitar esfuerzo f�sico.', 21, 3),
('Atenci�n de emergencia por diarrea aguda.', 'Proveer hidrataci�n constante.', 4, 4),
('Consulta de interconsulta para tratamiento de otitis cr�nica.', 'Aplicar gotas y mantener o�do limpio.', 24, 5),
('Cirug�a dental para remover placa y sarro.', 'Administrar analg�sicos si es necesario.', 29, 6),
('Fisioterapia de movilidad en articulaciones tras artritis.', 'Hacer sesiones de terapia dos veces por semana.', 28, 7),
('Monitoreo en cuidados intensivos por intoxicaci�n grave.', 'Revisi�n de signos vitales cada cuatro horas.', 19, 8),
('Consulta oftalmol�gica por enrojecimiento en ojos.', 'Aplicar l�grimas artificiales cada seis horas.', 9, 9),
('Consulta de neurolog�a por temblores intermitentes.', 'Evitar movimientos bruscos y estr�s.', 31, 10),
('Protocolo de tratamiento especial por malestar hep�tico.', 'Evitar alimentos grasos y medicar seg�n receta.', 6, 11),
('Control de conducta para ansiedad en animales.', 'Aumentar actividad f�sica y reducir estr�s.', 32, 12),
('Sesi�n de acupuntura para mejorar flujo sangu�neo.', 'Mantener reposo tras la sesi�n.', 33, 13),
('Evaluaci�n reproductiva previa a cruce.', 'Iniciar preparativos seg�n ciclo hormonal.', 34, 14),
('An�lisis de sangre para verificar niveles de gl�bulos blancos.', 'Aumentar vigilancia ante posibles infecciones.', 2, 15),
('Prueba de orina para descartar infecci�n.', 'Repetir examen en caso de s�ntomas.', 35, 16),
('Cultivo bacteriano de secreci�n para diagn�stico preciso.', 'Mantener �rea afectada limpia y seca.', 36, 17),
('Biopsia de ganglio para identificar tipo de infecci�n.', 'Esperar resultados de laboratorio.', 37, 18),
('Ultrasonido de tejidos blandos para diagn�stico de masa.', 'Evitar presi�n en el �rea de examen.', 38, 19),
('Atenci�n m�dica general de rutina y control de peso.', 'Implementar dieta balanceada.', 39, 1),
('Aplicaci�n de vacunas contra leptospirosis.', 'Evitar contacto con agua contaminada.', 40, 2);

-- REGISTROS DE EXAMENES REALIZADOS DURANTE LOS SERVICIOS DE LAS ATENCIONES
INSERT INTO Examen (fecha_toma_muestra, resultados, id_tipo_examen, id_atencionmedica_serviciomedico)
VALUES
('2024-10-05', 'Hemograma completo sin anomal�as detectadas.', 1, 1),
('2024-10-07', 'Perfil bioqu�mico: niveles normales de glucosa y prote�nas.', 2, 10),
('2024-10-06', 'Urian�lisis sin signos de infecci�n.', 3, 30),
('2024-10-08', 'Coprol�gico negativo para par�sitos e infecciones.', 4, 34),
('2024-10-09', 'Radiograf�a de t�rax: sin anomal�as en pulmones ni coraz�n.', 5, 21),
('2024-10-10', 'Radiograf�a abdominal: leve inflamaci�n observada.', 6, 5),
('2024-10-12', 'Ecograf�a abdominal: sin alteraciones notables.', 7, 5),
('2024-10-13', 'Ecocardiograma muestra funci�n card�aca normal.', 8, 33),
('2024-10-15', 'Examen oftalmol�gico con ligera opacidad en el cristalino.', 9, 25),
('2024-10-16', 'Electrocardiograma sin arritmias detectadas.', 10, 31),
('2024-10-18', 'Prueba de alergias positiva para al�rgenos de polen.', 11, 11),
('2024-10-20', 'Biopsia de piel indica dermatitis leve.', 12, 12),
('2024-10-22', 'Cultivo bacteriano detecta presencia de bacteria.', 13, 23),
('2024-10-24', 'Cultivo f�ngico: positivo para hongos en piel.', 14, 23),
('2024-10-25', 'Test de parvovirus negativo.', 15, 17),
('2024-10-26', 'Prueba de distemper negativa.', 16, 17),
('2024-10-28', 'Prueba de giardia negativa en muestra fecal.', 17, 34),
('2024-10-29', 'Prueba de leishmaniasis negativa.', 18, 32),
('2024-11-01', 'Perfil hep�tico dentro de los par�metros normales.', 19, 6),
('2024-11-02', 'Perfil renal sin anomal�as.', 20, 28),
(NULL, 'Examen oftalmol�gico: visi�n y estructura ocular normales.', 9, 9),
(NULL, 'Biopsia de piel: no se detectaron signos de infecci�n.', 12, 8),
(NULL, 'Examen oftalmol�gico: ojos sin signos de infecci�n o irritaci�n.', 12, 3),
(NULL, 'Electrocardiograma: actividad el�ctrica normal.', 10, 22),
(NULL, 'Ecocardiograma indica funci�n normal.', 8, 31),
(NULL, 'Perfil bioqu�mico: niveles estables de compuestos sangu�neos.', 2, 13),
(NULL, 'Urian�lisis: sin anormalidades observadas.', 3, 4),
(NULL, 'Prueba de alergias: sin reacci�n al�rgica notable.', 11, 10),
(NULL, 'Prueba de alergias: muestra sensibilidad leve a un al�rgeno.', 11, 6),
(NULL, 'Ecocardiograma sin indicaciones de anomal�as.', 8, 19),
(NULL, 'Examen oftalmol�gico: sin problemas visuales detectados.', 9, 7),
(NULL, 'Test de parvovirus negativo.', 15, 15),
(NULL, 'Perfil renal: funci�n adecuada.', 20, 27),
(NULL, 'Prueba de leishmaniasis negativa.', 18, 18),
(NULL, 'Perfil hep�tico sin anomal�as.', 21, 24),
(NULL, 'Citolog�a de o�dos: canal auditivo limpio, sin infecci�n.', 23, 26),
(NULL, 'Prueba de alergias: sensibilidad leve detectada.', 11, 11),
(NULL, 'Radiograf�a de t�rax sin indicios de enfermedad.', 5, 2),
(NULL, 'Test de filariosis negativo.', 15, 29),
(NULL, 'Cultivo f�ngico: negativo para hongos en la muestra.', 14, 20);

-- REGISTROS DE PROVEEDORES DE LA CLINICA 
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 1','1324324','Cra a ninguna parte 1');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 2','3455654','Cra a ninguna parte 2');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 3','5586984','Cra a ninguna parte 3');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 4','7718314','Cra a ninguna parte 4');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 5','9849644','Cra a ninguna parte 5');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 6','11980974','Cra a ninguna parte 6');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 7','14112304','Cra a ninguna parte 7');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 8','16243634','Cra a ninguna parte 8');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 9','18374964','Cra a ninguna parte 9');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 10','20506294','Cra a ninguna parte 10');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 11','22637624','Cra a ninguna parte 11');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 12','24768954','Cra a ninguna parte 12');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 13','26900284','Cra a ninguna parte 13');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 14','29031614','Cra a ninguna parte 14');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 15','31162944','Cra a ninguna parte 15');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 16','33294274','Cra a ninguna parte 16');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 17','35425604','Cra a ninguna parte 17');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 18','37556934','Cra a ninguna parte 18');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 19','39688264','Cra a ninguna parte 19');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 20','41819594','Cra a ninguna parte 20');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 21','43950924','Cra a ninguna parte 21');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 22','46082254','Cra a ninguna parte 22');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 23','48213584','Cra a ninguna parte 23');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 24','50344914','Cra a ninguna parte 24');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 25','52476244','Cra a ninguna parte 25');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 26','54607574','Cra a ninguna parte 26');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 27','56738904','Cra a ninguna parte 27');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 28','58870234','Cra a ninguna parte 28');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 29','61001564','Cra a ninguna parte 29');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 30','63132894','Cra a ninguna parte 30');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 31','65264224','Cra a ninguna parte 31');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 32','67395554','Cra a ninguna parte 32');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 33','69526884','Cra a ninguna parte 33');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 34','71658214','Cra a ninguna parte 34');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 35','73789544','Cra a ninguna parte 35');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 36','75920874','Cra a ninguna parte 36');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 37','78052204','Cra a ninguna parte 37');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 38','80183534','Cra a ninguna parte 38');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 39','82314864','Cra a ninguna parte 39');
INSERT INTO ProveedorClinica(nombre_proveedor, telefono, direccion) VALUES ('Proveedor 40','84446194','Cra a ninguna parte 40');

-- REGISTROS DE INSUMOS DE LA CLINICA VETERINARIA
INSERT INTO Insumo (nombre_insumo, cantidad_inicial, stock_actual, fecha_vencimiento, temperatura_almacenamiento, tiempo_rotacion, id_proveedor)
VALUES
('Reactivo Hemograma', 100, 80, '2025-01-15', 2.00, '00:30:00', 1),
('Reactivo Perfil Bioqu�mico', 200, 180, '2025-02-20', 4.00, '01:00:00', 2),
('Tubo para Hemograma', 500, 450, '2024-12-01', NULL, NULL, 3),
('Tubo para Bioqu�mico', 300, 270, '2025-01-25', NULL, NULL, 4),
('Contenedor para Urian�lisis', 400, 350, '2025-04-10', NULL, NULL, 5),
('Papel Radiogr�fico', 250, 200, '2025-05-15', 20.00, NULL, 6),
('Gel para Ultrasonido', 100, 90, '2025-07-01', 15.00, NULL, 7),
('L�quido de Contraste', 50, 40, '2025-03-05', 8.00, '01:30:00', 8),
('Lentes de Protecci�n', 150, 120, '2026-01-01', NULL, NULL, 9),
('Protector de Plomo', 20, 18, '2027-12-01', NULL, NULL, 10),
('Guantes Quir�rgicos', 1000, 900, '2024-11-20', NULL, NULL, 11),
('Gasa Est�ril', 800, 700, '2025-06-15', NULL, NULL, 12),
('Sutura Absorbible', 300, 250, '2025-08-10', NULL, '02:00:00', 13),
('Anest�sico General', 60, 50, '2025-09-01', 5.00, '00:30:00', 14),
('Antibi�tico Intravenoso', 150, 130, '2025-02-25', 4.00, NULL, 15),
('Banda El�stica', 100, 85, '2025-07-15', NULL, NULL, 16),
('Gel Antiinflamatorio', 200, 180, '2025-06-30', 22.00, NULL, 17),
('Electrodos', 120, 100, '2025-08-20', NULL, NULL, 18),
('Cinta para Kinesiolog�a', 150, 140, '2026-03-10', NULL, NULL, 19),
('Compresas Calientes', 60, 50, '2025-10-01', NULL, NULL, 20),
('Mascarilla de Ox�geno', 200, 150, '2025-04-05', NULL, NULL, 21),
('Ventilador Port�til', 15, 12, '2027-12-31', NULL, NULL, 22),
('Monitor de Signos Vitales', 20, 18, '2028-01-01', NULL, NULL, 23),
('Cat�ter Venoso', 250, 230, '2025-06-15', NULL, NULL, 24),
('Bolsa de Suero Fisiol�gico', 300, 250, '2025-01-10', 5.00, NULL, 25),
('Reactivo para Cultivo Bacteriano', 100, 90, '2025-03-15', 2.00, '01:00:00', 26),
('Reactivo para Biopsia', 50, 45, '2025-05-10', 3.00, '02:00:00', 27),
('Kit de Prueba de Alergias', 75, 70, '2025-06-01', 4.00, '01:00:00', 28),
('Kit de Prueba de Leishmania', 40, 35, '2025-08-01', 4.00, NULL, 29),
('Kit de Prueba de Giardia', 60, 55, '2025-08-10', 5.00, NULL, 30),
('Estetoscopio', 20, 15, '2027-05-01', NULL, NULL, 31),
('Term�metro Digital', 30, 28, '2026-10-20', NULL, NULL, 32),
('Equipo de Presi�n Arterial', 15, 12, '2026-12-31', NULL, NULL, 33),
('Alcohol en Gel', 500, 450, '2025-12-01', NULL, NULL, 34),
('Mascarilla Descartable', 1000, 950, '2024-12-15', NULL, NULL, 35),
('Desinfectante para Superficies', 300, 250, '2025-02-15', NULL, NULL, 36),
('Guantes de Nitrilo', 800, 750, '2025-03-20', NULL, NULL, 37),
('Jab�n Antis�ptico', 200, 180, '2025-06-30', NULL, NULL, 38),
('Soluci�n Salina', 100, 90, '2025-01-05', 8.00, NULL, 39),
('Cubrebocas N95', 150, 140, '2025-08-15', NULL, NULL, 40);

-- REGISTROS DE USOS DE LOS INSUMOS DURANTE LOS SERVICIOS PRESTADOS EN LAS ATENCIONES MEDICAS
INSERT INTO UsoInsumo (fecha_registro, cantidad_usada, cantidad_restante, id_insumo, id_atencionmedica_serviciomedico)
VALUES
('2024-10-01', 5, 95, 1, 1),  
('2024-10-02', 10, 140, 2, 2), 
('2024-10-03', 8, 42, 3, 3),   
('2024-10-04', 15, 130, 4, 4), 
('2024-10-05', 25, 175, 5, 6),  
('2024-10-06', 12, 68, 6, 7),   
('2024-10-07', 5, 30, 7, 8),   
('2024-10-08', 20, 90, 8, 9),   
('2024-10-09', 30, 70, 9, 11),  
('2024-10-10', 50, 450, 10, 12),
('2024-10-11', 15, 125, 11, 13),
('2024-10-12', 40, 210, 12, 14),
('2024-10-13', 20, 80, 13, 15),  
('2024-10-14', 12, 38, 14, 16), 
('2024-10-15', 10, 150, 15, 17),
('2024-10-16', 8, 92, 16, 18),
('2024-10-17', 5, 75, 17, 19),  
('2024-10-18', 10, 40, 18, 20), 
('2024-10-19', 4, 51, 19, 21),  
('2024-10-20', 15, 70, 20, 22), 
('2024-10-21', 10, 140, 21, 23), 
('2024-10-22', 20, 220, 22, 24), 
('2024-10-23', 30, 100, 23, 25),
('2024-10-24', 5, 45, 24, 26),  
('2024-10-25', 8, 92, 25, 27),  
('2024-10-26', 3, 77, 26, 28),   
('2024-10-27', 2, 48, 27, 29),   
('2024-10-28', 7, 83, 28, 30),   
('2024-10-29', 20, 130, 29, 31), 
('2024-10-30', 15, 230, 30, 32), 
('2024-10-31', 5, 195, 31, 33), 
('2024-11-01', 3, 24, 32, 34),  
('2024-11-02', 20, 120, 33, 35), 
('2024-11-03', 2, 13, 34, 36),   
('2024-11-04', 1, 97, 35, 37), 
('2024-11-05', 10, 390, 36, 38), 
('2024-11-06', 25, 200, 37, 39), 
('2024-11-07', 15, 210, 38, 40),
('2024-11-08', 10, 70, 13, 15),
('2024-11-09', 5, 45, 18, 20);

-- REGISTROS DE PROCEDIMIENTOS REALIZADOS DURANTE LAS 
-- Inserci�n de registros en Procedimiento con descripci�n
INSERT INTO Procedimiento (fecha_programada, lugar, descripcion, id_atencionmedica_serviciomedico)
VALUES
('2024-11-05', 'Sala de Consultas', 'Consulta general y chequeo f�sico.', 1),
('2024-11-06', 'Laboratorio de Imagenolog�a', 'Radiograf�a de t�rax para evaluar condici�n respiratoria.', 3),
('2024-11-07', 'Sala de Urgencias', 'Procedimiento de estabilizaci�n inicial.', 4),
('2024-11-08', 'Consultorio de Neurolog�a', 'Evaluaci�n de comportamiento y respuesta neurol�gica.', 10),
('2024-11-09', 'Sala de Cirug�a', 'Intervenci�n para extracci�n de objeto extra�o.', 6),
('2024-11-10', 'Sala de Vacunaci�n', 'Vacuna anual contra enfermedades comunes.', 2),
('2024-11-11', 'Sala de Cuidados Intensivos', 'Monitoreo constante para paciente cr�tico.', 8),
('2024-11-12', 'Consultorio de Oftalmolog�a', 'Evaluaci�n de salud ocular.', 9),
('2024-11-13', 'Laboratorio de Diagn�sticos', 'An�lisis sangu�neo completo.', 16),
('2024-11-14', '�rea de Fisioterapia', 'Terapia de movilidad para recuperaci�n.', 7),
('2024-11-15', 'Consultorio de Comportamiento Animal', 'Sesi�n de evaluaci�n de comportamiento.', 12),
('2024-11-16', 'Sala de Reproducci�n Asistida', 'Asesor�a en manejo reproductivo.', 14),
('2024-11-17', 'Laboratorio de Cultivos Bacterianos', 'Prueba de cultivo para identificar infecciones.', 17),
('2024-11-18', 'Laboratorio de Pruebas R�pidas', 'Prueba de moquillo canino.', 19),
('2024-11-19', '�rea de Pruebas Especiales', 'Evaluaci�n de funcionamiento hep�tico.', 21),
('2024-11-20', 'Consultorio de Reproducci�n', 'Pruebas para fertilidad y control reproductivo.', 20),
('2024-11-21', '�rea de Test Dermatol�gico', 'Test cut�neo para determinar alergias.', 13),
('2024-11-22', 'Consultorio de Neurolog�a', 'Evaluaci�n del sistema nervioso central.', 10),
('2024-11-23', 'Sala de Pruebas Especiales', 'Perfil renal para an�lisis de funci�n del ri��n.', 21),
('2024-11-24', 'Laboratorio de Cultivo F�ngico', 'Prueba de cultivo para hongos en piel.', 18),
('2024-11-25', '�rea de Pruebas de Filariosis', 'Test para detectar gusanos del coraz�n.', 35),
('2024-11-26', 'Laboratorio de Perfil Hep�tico', 'Evaluaci�n detallada de funciones hep�ticas.', 19),
('2024-11-27', 'Sala de Procedimientos', 'Tratamiento de fisioterapia para recuperaci�n.', 25),
('2024-11-28', '�rea de An�lisis Reproductivo', 'Estudio de calidad seminal para reproducci�n.', 30),
('2024-11-29', 'Consultorio de Interconsultas', 'Evaluaci�n general y consulta especializada.', 5),
('2024-11-30', 'Sala de Test Cardiol�gico', 'Evaluaci�n de actividad el�ctrica del coraz�n.', 23),
('2024-12-01', 'Sala de Procedimientos Especiales', 'Biopsia de tejido para diagn�stico dermatol�gico.', 28),
('2024-12-02', '�rea de Fisioterapia', 'Sesi�n de recuperaci�n de movilidad post-cirug�a.', 7),
('2024-12-03', 'Sala de Ex�menes Cut�neos', 'Test para alergias cut�neas.', 26),
('2024-12-04', 'Laboratorio de An�lisis Sangu�neos', 'Hemograma completo para evaluaci�n general.', 15),
('2024-12-05', '�rea de Biopsias', 'Extracci�n de muestra d�rmica para an�lisis.', 24),
('2024-12-06', 'Sala de Imagenolog�a', 'Estudio de ultrasonido abdominal.', 3),
('2024-12-07', 'Laboratorio de Cultivos', 'Cultivo de muestra bacteriana.', 29),
('2024-12-08', 'Sala de Consulta de Medicina Interna', 'Evaluaci�n general y diagn�stico inicial.', 1),
('2024-12-09', '�rea de Test de Tiroides', 'Prueba de funci�n tiroidea.', 31),
('2024-12-10', 'Laboratorio de Test Hormonales', 'Examen de progesterona para monitoreo reproductivo.', 33),
('2024-12-11', 'Consultorio de Endocrinolog�a', 'Control de niveles de glucosa en sangre.', 22),
('2024-12-12', 'Sala de Test de Diabetes', 'Evaluaci�n r�pida de niveles de az�car en sangre.', 34),
('2024-12-13', '�rea de Pruebas Especializadas', 'An�lisis de colesterol y triglic�ridos.', 36),
('2024-12-14', 'Sala de Tratamientos Alternativos', 'Sesi�n de acupuntura para alivio de dolor.', 13);

-- REGISTROS RECETAS 
INSERT INTO Receta (tratamiento, id_atencionmedica_serviciomedico)
VALUES
('Tratamiento antibi�tico para infecci�n leve.', 17),
('Aplicaci�n de antiinflamatorio ocular.', 9),
('Administraci�n de corticoides para asma.', 8),
('Analg�sico para control de dolor en articulaciones.', 7),
('Suplemento vitam�nico post-operaci�n.', 6),
('Tratamiento antiparasitario regular.', 35),
('Antihistam�nico para reacciones al�rgicas.', 13),
('Tratamiento hormonal para problemas de tiroides.', 31),
('Antibi�tico de amplio espectro.', 24),
('Antiparasitario oral para giardiasis.', 18),
('Antivirales para tratamiento de distemper.', 16),
('Analg�sico leve para recuperaci�n post-cirug�a.', 25),
('Inyecci�n de vitaminas para mejorar condici�n f�sica.', 12),
('Aplicaci�n de antibi�ticos t�picos para infecci�n de piel.', 26),
('Suplemento hep�tico para funci�n del h�gado.', 19),
('Esteroides para controlar inflamaci�n articular.', 23),
('Suplemento para control de glucosa.', 34),
('Aplicaci�n de crema antibi�tica para otitis.', 22),
('Inyecci�n de hierro para anemia.', 20),
('Tratamiento antibacteriano para infecci�n urinaria.', 15),
('Vitamina B para mejor recuperaci�n general.', 11),
('Suplemento de calcio para huesos.', 4),
('Antibi�ticos espec�ficos para infecciones respiratorias.', 5),
('Cuidado post-cirug�a con analg�sico.', 6),
('Tratamiento de alergias alimenticias.', 21),
('Aplicaci�n de probi�ticos para mejor digesti�n.', 14),
('Inmunomoduladores para sistema inmune.', 2),
('Corticoides para dolor en columna vertebral.', 10),
('Desparasitante de amplio espectro.', 27),
('Analg�sico de soporte post-biopsia.', 33),
('Aplicaci�n de protector g�strico.', 3),
('Suplemento de �cido f�lico para recuperaci�n.', 36),
('Vitamina D para huesos.', 20),
('Antivirales para control de brucelosis.', 30),
('Suplemento renal para funci�n de ri�ones.', 19),
('Aplicaci�n de sedantes para intervenci�n.', 6),
('Tratamiento para problemas dermatol�gicos.', 26),
('Suplemento proteico para recuperaci�n.', 12),
('Vitamina C para soporte inmunol�gico.', 17),
('Antif�ngico para infecciones d�rmicas.', 29);
