CREATE DATABASE ClinicaVeterinariaProyectoFinal;
GO
USE ClinicaVeterinariaProyectoFinal;
GO



--USE master;
--GO
--DROP DATABASE ClinicaVeterinariaProyectoFinal;
--GO



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
    estado_pedido VARCHAR(50),
	valor_pedido MONEY,
	id_proveedor INT NOT NULL,
	FOREIGN KEY (id_proveedor) REFERENCES ProveedorTienda(id_proveedor)
);

CREATE TABLE Producto (
    id_producto INT PRIMARY KEY IDENTITY NOT NULL,
    nombre_producto VARCHAR(100),
    tipo_producto VARCHAR(50),
    edad_recomendada VARCHAR(20),
    tamaño_recomendado VARCHAR(20),
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
    fecha_compra DATE,
    id_propietario INT NOT NULL,
    FOREIGN KEY (id_propietario) REFERENCES Propietario(id_propietario)
);

CREATE TABLE DetalleCompra (
    id_detalle_compra INT PRIMARY KEY IDENTITY NOT NULL,
    cantidad_producto INT NOT NULL,
	valor_total MONEY,
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

CREATE TABLE InstalaciónBelleza (
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
	FOREIGN KEY (id_instalacionbelleza) REFERENCES InstalaciónBelleza(id_instalacionbelleza)
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
    nombre_tipo_examen VARCHAR(50) NOT NULL
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










--REGISTROS PROPIETARIO
INSERT INTO Propietario (nombre_propietario, cedula, direccion, telefono)
VALUES
('Juan Pérez', '0101010101', 'Calle Falsa 123, Ciudad', '555-1234'),
('María González', '0101010102', 'Av. Central 456, Ciudad', '555-2345'),
('Carlos Sánchez', '0101010103', 'Calle Principal 789, Ciudad', '555-3456'),
('Ana Rodríguez', '0101010104', 'Boulevard 12, Ciudad', '555-4567'),
('Luis Fernández', '0101010105', 'Plaza Mayor 34, Ciudad', '555-5678'),
('Laura García', '0101010106', 'Av. Libertad 101, Ciudad', '555-6789'),
('Pedro Martínez', '0101010107', 'Calle Comercio 22, Ciudad', '555-7890'),
('Silvia Jiménez', '0101010108', 'Barrio Norte 98, Ciudad', '555-8901'),
('Jorge Ramírez', '0101010109', 'Residencial Verde 5, Ciudad', '555-9012'),
('Marta Herrera', '0101010110', 'Urbanización Sol 8, Ciudad', '555-0123'),
('Francisco Torres', '0101010111', 'Calle Azul 76, Ciudad', '555-1235'),
('Gloria Díaz', '0101010112', 'Av. del Bosque 12, Ciudad', '555-2346'),
('Raúl Castro', '0101010113', 'Residencial Oeste 56, Ciudad', '555-3457'),
('Claudia Flores', '0101010114', 'Condominio Vista 3, Ciudad', '555-4568'),
('Ricardo Peña', '0101010115', 'Barrio Sur 88, Ciudad', '555-5679'),
('Patricia León', '0101010116', 'Calle Oro 45, Ciudad', '555-6780'),
('Andrés Ortiz', '0101010117', 'Av. de los Lagos 90, Ciudad', '555-7891'),
('Lucía Castillo', '0101010118', 'Calle Sol 33, Ciudad', '555-8902'),
('Diego Ruiz', '0101010119', 'Residencial Norte 44, Ciudad', '555-9013'),
('Isabel Morales', '0101010120', 'Urbanización Mar 99, Ciudad', '555-0124'),
('Manuel Romero', '0101010121', 'Av. Norte 11, Ciudad', '555-1236'),
('Carmen Vega', '0101010122', 'Calle Sur 12, Ciudad', '555-2347'),
('José Paredes', '0101010123', 'Barrio Oriente 78, Ciudad', '555-3458'),
('Gabriela Molina', '0101010124', 'Condominio Horizonte 2, Ciudad', '555-4569'),
('Fernando Muñoz', '0101010125', 'Calle del Río 41, Ciudad', '555-5670'),
('Teresa Bustos', '0101010126', 'Av. Oeste 31, Ciudad', '555-6782'),
('Daniel Salazar', '0101010127', 'Residencial Colinas 7, Ciudad', '555-7893'),
('Rosa Aguirre', '0101010128', 'Urbanización Amanecer 6, Ciudad', '555-8904'),
('Pablo Ponce', '0101010129', 'Calle Estrella 17, Ciudad', '555-9015'),
('Nancy Ortiz', '0101010130', 'Av. Atlántico 43, Ciudad', '555-0126'),
('Roberto Fuentes', '0101010131', 'Calle del Parque 28, Ciudad', '555-1237'),
('Alejandra Ríos', '0101010132', 'Condominio Verde 4, Ciudad', '555-2348'),
('David Lara', '0101010133', 'Barrio Centro 64, Ciudad', '555-3459'),
('Sofía Serrano', '0101010134', 'Residencial Alta 15, Ciudad', '555-4570'),
('Oscar Navarro', '0101010135', 'Av. del Sur 59, Ciudad', '555-5671'),
('Liliana Cruz', '0101010136', 'Calle Bosque 29, Ciudad', '555-6783'),
('Rodrigo Campos', '0101010137', 'Urbanización Oriente 92, Ciudad', '555-7894'),
('Julia Espinoza', '0101010138', 'Calle Brisa 34, Ciudad', '555-8905'),
('Enrique Mendoza', '0101010139', 'Barrio Jardín 49, Ciudad', '555-9016'),
('Inés Cabrera', '0101010140', 'Condominio Norte 23, Ciudad', '555-0127'),
('Fabián Solano', '0101010141', 'Calle del Sol 30, Ciudad', '555-1238'),
('Paola Barrera', '0101010142', 'Av. del Lago 36, Ciudad', '555-2349'),
('Emanuel Gil', '0101010143', 'Residencial Oeste 18, Ciudad', '555-3460'),
('Mercedes Luna', '0101010144', 'Urbanización Brisa 77, Ciudad', '555-4571'),
('Guillermo Calderón', '0101010145', 'Calle Lirio 38, Ciudad', '555-5672'),
('Fátima Sosa', '0101010146', 'Av. Norte 27, Ciudad', '555-6784'),
('Arturo Delgado', '0101010147', 'Residencial del Río 32, Ciudad', '555-7895'),
('Verónica Carrillo', '0101010148', 'Urbanización Mirador 26, Ciudad', '555-8906'),
('Gustavo Zamora', '0101010149', 'Calle Este 53, Ciudad', '555-9017'),
('Sandra Valencia', '0101010150', 'Av. Sur 65, Ciudad', '555-0128');

-- REGISTROS TIPO DE FAUNA
INSERT INTO TipoFauna (nombre_fauna)
VALUES 
('Silvestre'),('Doméstica');

--  REGISTROS ESPECIE
INSERT INTO Especie(nombre_especie)
VALUES 
('León'), ('Lobo'), ('Oso'), ('Lince'), ('Comadreja'),
('Vaca'), ('Caballo'), ('Oveja'), ('Cabra'), ('Jabalí'),
('Gato'), ('Perro'), ('Zorro'), ('Mapache'), ('Ratón'),
('Panda'), ('Rata'), ('Gorila'), ('Orangután'), ('Conejo'),
('Hámster'), ('Cerdo'), ('Mini Cerdo'), ('Serpiente'), ('Iguana'),
('Gallina'), ('Sapo'), ('Búho'), ('Paloma'), ('Rana'),
('Cuervo'), ('Perico'), ('Halcón'), ('Cisne'), ('Pato'),
('Mono'), ('Guacamayo'), ('Cacatúa'), ('Tortuga'), ('Cóndor'), ('Loro'),
('Tarántula'), ('Escorpión'), ('Ardilla'), ('Camaleón'), ('Gecko'), ('Pez');

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

--	REGISTROS CARGO (GUARDERIA)
INSERT INTO Cargo (nombre_cargo)
VALUES
('Cuidador'),('Supervisor'),
('Veterinario'),('Encargado de Cuidados Especiales'),
('Asistente de Cuidados Especiales');

-- REGISTROS EMPLEADOS DE LA GUARDERIA
INSERT INTO EmpleadoGuarderia (nombre_empleadoguarderia, id_cargo)
VALUES 
('Carlos Gómez', 1),
('Andrea Pérez', 1),
('Juan Torres', 2),
('María Ríos', 1),
('Luisa Sánchez', 1),
('Sofía Díaz', 1),
('Ricardo Peña', 1),
('Laura Medina', 5),
('Fernando Núñez', 4),
('Isabel Herrera', 1),
('José Luis Méndez', 5),
('Paula Camacho', 1),
('Victoria Andrade', 1),
('Natalia Fernández', 3),
('Manuel Salas', 2),
('Sergio Vázquez', 1),
('Emilia Prado', 1),
('Ramón Ríos', 1),
('Claudia Torres', 1),
('Patricio Ortega', 1),
('Daniel Ruiz', 1),
('Beatriz Silva', 1),
('Oscar Villanueva', 2),
('Carolina León', 1),
('Alejandra Gutiérrez', 3),
('Inés Alarcón', 1),
('Joaquín Ledesma', 1),
('Patricia Romero', 1),
('Santiago Arce', 1),
('Valeria Zambrano', 4),
('Cecilia Vargas', 1),
('Héctor Campos', 1),
('Raquel Flores', 1),
('Ignacio Luna', 5),
('Rosa Valencia', 1),
('Leonardo Fuentes', 1),
('Martina Delgado', 1),
('Luciano Figueroa', 3),
('Pamela Ibáñez', 1),
('Enrique Espinoza', 2),
('Lidia Rodríguez', 1);

-- REGISTROS INSTALACIONES DE LA GUARDERIA
INSERT INTO InstalacionGuarderia (nombre_instalacion, capacidad, descripcion)
VALUES 
('Habitación 1', 1, 'Espacio privado para alojamiento de animales de tamaño mediano'),
('Habitación 2', 1, 'Espacio privado para alojamiento de animales de tamaño mediano'),
('Habitación 3', 1, 'Espacio privado para alojamiento de animales de tamaño mediano'),
('Habitación 4', 1, 'Espacio privado para alojamiento de animales de tamaño mediano'),
('Habitación 5', 1, 'Espacio privado para alojamiento de animales de tamaño mediano'),
('Habitación 6', 1, 'Espacio privado para alojamiento de animales de tamaño mediano'),
('Habitación 7', 1, 'Espacio privado para alojamiento de animales de tamaño mediano'),
('Habitación 8', 1, 'Espacio privado para alojamiento de animales de tamaño mediano'),
('Habitación 9', 1, 'Espacio privado para alojamiento de animales de tamaño mediano'),
('Habitación 10', 1, 'Espacio privado para alojamiento de animales de tamaño mediano'),
('Habitación 11', 1, 'Espacio privado para alojamiento de animales de tamaño mediano'),
('Habitación 12', 1, 'Espacio privado para alojamiento de animales de tamaño mediano'),
('Habitación 13', 2, 'Espacio privado para alojamiento de animales de tamaño mediano'),
('Habitación 14', 3, 'Espacio privado para alojamiento de animales de tamaño mediano'),
('Habitación 15', 3, 'Espacio privado para alojamiento de animales de tamaño mediano'),
('Habitación 16', 1, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 17', 1, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 18', 1, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 19', 1, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 20', 1, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 21', 1, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 22', 1, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 23', 1, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 24', 1, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 25', 1, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 26', 1, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 27', 1, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 28', 1, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 29', 1, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 30', 1, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 31', 1, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 32', 1, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 33', 3, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 34', 3, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 35', 3, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 36', 5, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 37', 5, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 38', 5, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 39', 5, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 40', 5, 'Espacio privado para alojamiento de animales de tamaño pequeño'),
('Habitación 41', 1, 'Espacio privado para alojamiento de animales de tamaño grande'),
('Habitación 42', 1, 'Espacio privado para alojamiento de animales de tamaño grande'),
('Habitación 43', 1, 'Espacio privado para alojamiento de animales de tamaño grande'),
('Habitación 44', 1, 'Espacio privado para alojamiento de animales de tamaño grande'),
('Habitación 45', 1, 'Espacio privado para alojamiento de animales de tamaño grande'),
('Habitación 46', 1, 'Espacio privado para alojamiento de animales de tamaño grande'),
('Habitación 47', 1, 'Espacio privado para alojamiento de animales de tamaño grande'),
('Habitación 48', 2, 'Espacio privado para alojamiento de animales de tamaño grande'),
('Habitación 49', 2, 'Espacio privado para alojamiento de animales de tamaño grande'),
('Habitación 50', 3, 'Espacio privado para alojamiento de animales de tamaño grande');

-- REGISTROS ESTANCIA EN LA GUARDERIA
INSERT INTO EstanciaGuarderia (fecha_ingreso, fecha_salida, duracion_dias, cuidado_especial, id_instalacionguarderia, id_empleadoguarderia, id_mascota)
VALUES
('2024-10-01 10:00:00', '2024-10-05 10:00:00', 4, NULL, 1, 1, 1),
('2024-10-03 11:00:00', '2024-10-06 10:00:00', 3, 'Requiere alimentación especial', 2, 2, 2),
('2024-10-04 09:00:00', '2024-10-08 09:00:00', 4, NULL, 3, 3, 3),
('2024-10-07 08:00:00', '2024-10-09 08:00:00', 2, 'Supervisión constante', 4, 4, 4),
('2024-10-05 07:00:00', '2024-10-06 07:00:00', 1, NULL, 5, 5, 5),
('2024-10-09 08:30:00', '2024-10-10 08:30:00', 1, 'Requiere medicamentos cada 6 horas', 6, 6, 6),
('2024-10-15 11:00:00', '2024-10-20 10:00:00', 5, NULL, 7, 7, 7),
('2024-10-11 12:00:00', '2024-10-15 12:00:00', 4, NULL, 8, 8, 8),
('2024-10-12 13:00:00', '2024-10-18 13:00:00', 6, 'Supervisión de peso', 9, 9, 9),
('2024-11-13 10:00:00', NULL, 7, NULL, 10, 10, 10),
('2024-11-01 14:00:00', '2024-11-07 10:00:00', 6, NULL, 11, 11, 11),
('2024-11-05 09:00:00', '2024-11-10 09:00:00', 5, 'Alimentación a base de dieta', 12, 12, 12),
('2024-11-07 08:30:00', '2024-11-11 08:30:00', 4, NULL, 13, 13, 13),
('2024-11-10 07:00:00', '2024-11-13 07:00:00', 3, 'Ejercicio diario', 14, 14, 14),
('2024-11-12 10:00:00', '2024-11-15 10:00:00', 3, NULL, 15, 15, 15),
('2024-11-14 12:00:00', '2024-11-16 12:00:00', 2, 'Supervisión médica', 16, 16, 16),
('2024-11-13 11:00:00', '2024-11-18 11:00:00', 5, NULL, 17, 17, 17),
('2024-11-15 08:00:00', '2024-11-20 08:00:00', 5, NULL, 18, 18, 18),
('2024-11-18 09:00:00', '2024-11-21 09:00:00', 3, 'Alergia a ciertos alimentos', 19, 19, 19),
('2024-11-20 14:00:00', NULL, 3, NULL, 20, 20, 20),
('2024-09-01 10:00:00', '2024-09-05 10:00:00', 4, 'Ejercicio diario supervisado', 21, 21, 21),
('2024-09-03 11:00:00', '2024-09-07 10:00:00', 4, NULL, 22, 22, 22),
('2024-09-05 13:00:00', '2024-09-09 13:00:00', 4, NULL, 23, 23, 23),
('2024-09-07 09:00:00', '2024-09-12 09:00:00', 5, 'Requiere aislamiento', 24, 24, 24),
('2024-09-10 10:00:00', '2024-09-15 10:00:00', 5, NULL, 25, 25, 25),
('2024-09-12 08:00:00', '2024-09-18 08:00:00', 6, 'Atención en horarios específicos', 26, 26, 26),
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

-- REGISTROS TIPO DE SERVICIOS DEL SALON DE BELLEZA 
INSERT INTO TipoServicioBelleza (nombre_tipo_serviciobelleza, descripcion, duracion_aprox_minutos)
VALUES 
('Peluquería', 'Corte y arreglo de pelaje', 60),
('Baño normal', 'Baño básico con shampoo suave', 30),
('Baño medicado', 'Baño con productos médicos especializados', 45),
('Drenaje de glándulas perianales', 'Drenaje manual', 20),
('Corte de uñas', 'Corte de uñas de rutina', 15),
('Limpieza de oídos', 'Limpieza con solución especial', 15),
('Limpieza de dientes', 'Limpieza dental básica', 20);

-- REGISTROS EMPLEADOS DEL SALON DE BELLEZA
INSERT INTO EmpleadoBelleza (nombre_empleadobelleza, numero_documento)
VALUES 
('Carlos Martínez', 1012345678),
('María Pérez', 1023456789),
('Juan Gómez', 1034567890),
('Laura González', 1045678901),
('Luis Ramírez', 1056789012),
('Ana López', 1067890123),
('Pedro Rodríguez', 1078901234),
('Marta Jiménez', 1089012345),
('Sofía Torres', 1090123456),
('Diego Sánchez', 1101234567),
('Camila Díaz', 1112345678),
('Andrés Moreno', 1123456789),
('Paula Muñoz', 1134567890),
('Javier Castillo', 1145678901),
('Gabriela Ortiz', 1156789012),
('Sebastián Rivas', 1167890123),
('Fernanda Reyes', 1178901234),
('Daniela Castro', 1189012345),
('Manuel Vargas', 1190123456),
('Adriana Ruiz', 1201234567),
('Nicolás Espinosa', 1212345678),
('Valentina Pardo', 1223456789),
('Felipe Valencia', 1234567890),
('Diana Mendoza', 1245678901),
('Ángela Figueroa', 1256789012),
('Miguel Romero', 1267890123),
('Sara Prieto', 1278901234),
('Ricardo Peña', 1289012345),
('Carolina Cardozo', 1290123456),
('Jorge Vera', 1301234567),
('Alejandra Herrera', 1312345678),
('David Niño', 1323456789),
('Claudia Beltrán', 1334567890),
('Tomás Cárdenas', 1345678901),
('Santiago Ramírez', 1356789012),
('Lucía Zambrano', 1367890123),
('Esteban Serrano', 1378901234),
('Natalia Bernal', 1389012345),
('Gustavo Pineda', 1390123456),
('Carmen Parra', 1401234567),
('Pablo Guevara', 1412345678),
('Elena Porras', 1423456789),
('Rafael Suárez', 1434567890),
('Yolanda Giraldo', 1445678901),
('José Mejía', 1456789012),
('César Medina', 1467890123),
('Teresa Acosta', 1478901234),
('Victoria Quintero', 1489012345),
('Alberto Becerra', 1490123456),
('Rosa Delgadillo', 1501234567),
('Julio Vargas', 1512345678);

-- REGISTROS INSTALACIONES DEL SALON DE BELLEZA
INSERT INTO InstalaciónBelleza (nombre_instalacionguarderia)
VALUES
(1),(2),
( 3),(4);


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


SELECT * FROM Propietario;
SELECT * FROM TipoFauna;
SELECT * FROM especie;
SELECT * FROM Mascota;
SELECT * FROM Cargo;
SELECT * FROM EstanciaGuarderia;
SELECT * FROM EmpleadoGuarderia;
SELECT * FROM TipoServicioBelleza;
SELECT * FROM EmpleadoBelleza;
SELECT * FROM InstalaciónBelleza;
SELECT * FROM CitaBelleza;
SELECT * FROM ServicioBelleza;


---------------------------------------------------------------------------------------------------------------------------
SELECT M.id_mascota, M.nombre, Especie.nombre_especie FROM Mascota M INNER JOIN Especie ON M.id_especie = Especie.id_especie
SELECT * FROM InstalacionGuarderia;
---------------------------------------------------------------------------------------------------------------------------
SELECT EmpleadoGuarderia.*, Cargo.nombre_cargo
FROM EmpleadoGuarderia
INNER JOIN Cargo ON EmpleadoGuarderia.id_cargo = Cargo.id_cargo;
---------------------------------------------------------------------------------------------------------------------------
SELECT dbo.Especie.nombre_especie, dbo.Mascota.nombre AS nombre_mascota, dbo.EstanciaGuarderia.fecha_ingreso, dbo.EstanciaGuarderia.fecha_salida, dbo.EstanciaGuarderia.id_estanciaguarderia, dbo.EstanciaGuarderia.duracion_dias, 
                  dbo.EstanciaGuarderia.cuidado_especial
FROM     dbo.Especie INNER JOIN
                  dbo.Mascota ON dbo.Especie.id_especie = dbo.Mascota.id_especie INNER JOIN
                  dbo.EstanciaGuarderia ON dbo.Mascota.id_mascota = dbo.EstanciaGuarderia.id_mascota;
---------------------------------------------------------------------------------------------------------------------------