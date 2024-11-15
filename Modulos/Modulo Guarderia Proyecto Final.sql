CREATE DATABASE ModuloGuarderiaProyectoFinal;
GO
USE ModuloGuarderiaProyectoFinal;
GO


CREATE TABLE Propietario (
    id_propietario INT PRIMARY KEY IDENTITY NOT NULL,
    nombre_propietario VARCHAR(100) NOT NULL,
    cedula VARCHAR(20) NOT NULL UNIQUE,
    direccion VARCHAR(255) NOT NULL,
    telefono VARCHAR(20) NOT NULL
);

CREATE TABLE TipoFauna (
    id_tipofauna INT PRIMARY KEY IDENTITY NOT NULL,
    nombre_fauna VARCHAR(20) NOT NULL
);

CREATE TABLE Especie (
    id_especie INT PRIMARY KEY IDENTITY NOT NULL,
    nombre_especie VARCHAR(20) NOT NULL
);

CREATE TABLE Mascota (
    id_mascota INT PRIMARY KEY IDENTITY NOT NULL,
    nombre VARCHAR(100) NULL,
    identificacion VARCHAR(100) NULL,
    id_tipofauna INT NOT NULL,
    id_especie INT NOT NULL,
    id_propietario INT NOT NULL,
    FOREIGN KEY (id_tipofauna) REFERENCES TipoFauna (id_tipofauna),
    FOREIGN KEY (id_especie) REFERENCES Especie (id_especie),
    FOREIGN KEY (id_propietario) REFERENCES Propietario (id_propietario)
);

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