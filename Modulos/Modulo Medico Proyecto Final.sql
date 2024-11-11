CREATE DATABASE ModuloMedicoProyectoFinal;
GO
USE ModuloMedicoProyectoFinal;
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

CREATE TABLE Proveedor (
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
    FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor)
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
