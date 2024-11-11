CREATE DATABASE ModuloVentasProyectoFinal;
GO
USE ModuloVentasProyectoFinal;
GO

CREATE TABLE Propietario (
    id_propietario INT PRIMARY KEY IDENTITY NOT NULL,
    nombre_propietario VARCHAR(100) NOT NULL,
    cedula VARCHAR(20) UNIQUE NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    telefono VARCHAR(20) NOT NULL
);

CREATE TABLE Proveedor (
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
	FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor)
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

CREATE TABLE Venta (
    id_venta INT PRIMARY KEY IDENTITY NOT NULL,
    fecha_venta DATE,
    estado_venta DATE,
    id_propietario INT NOT NULL,
    FOREIGN KEY (id_propietario) REFERENCES Propietario(id_propietario)
);

CREATE TABLE DetalleVenta (
    id_detalle_venta INT PRIMARY KEY IDENTITY NOT NULL,
    cantidad_producto INT NOT NULL,
	valor_total MONEY,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES Venta(id_venta),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);
