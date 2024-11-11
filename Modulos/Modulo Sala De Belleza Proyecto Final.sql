CREATE DATABASE ModuloSalaDeBellezaProyectoFinal;
GO
USE ModuloSalaDeBellezaProyectoFinal;
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
    FOREIGN KEY (id_especie) REFERENCES Especie (id_especie),
    FOREIGN KEY (id_propietario) REFERENCES Propietario (id_propietario),
    FOREIGN KEY (id_tipofauna) REFERENCES TipoFauna (id_tipofauna)
);

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
