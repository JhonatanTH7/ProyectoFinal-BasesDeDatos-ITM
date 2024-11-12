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
    personal_requerido VARCHAR(100) NOT NULL,
    espacio_requerido VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) NULL,
    duracion_aprox_minutos INT NOT NULL
);

CREATE TABLE ServicioBelleza (
    id_serviciobelleza INT PRIMARY KEY IDENTITY NOT NULL,
    espacio_asignado VARCHAR(100) NOT NULL,
    personal_asignado VARCHAR(100) NOT NULL,
    estado_serviciobelleza VARCHAR(20) NOT NULL CHECK (estado_serviciobelleza IN ('Realizado', 'Cancelado', 'Asignado')),
    id_tipo_serviciobelleza INT NOT NULL,
    id_citabelleza INT NOT NULL,
    FOREIGN KEY (id_citabelleza) REFERENCES CitaBelleza (id_citabelleza),
    FOREIGN KEY (id_tipo_serviciobelleza) REFERENCES TipoServicioBelleza (id_tipo_serviciobelleza)
);










--Modulo Guarderia
CREATE TABLE EmpleadoGuarderia (
    id_empleadoguarderia INT PRIMARY KEY IDENTITY NOT NULL,
    nombre_empleadoguarderia VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL
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
