--Universidad Politécnica de San Luis Potosí
--          13 de Febrero, 2025
--            Base de Datos
--    Christian Alejandro Cárdenas Rucoba

--          Ejercicio de PostgreSQL

--Tabla Clientes
CREATE TABLE Clientes(
  cliente_id INT PRIMARY KEY,
  nombre VARCHAR,
  email VARCHAR
);
--Tabla Pedidos
CREATE TABLE Pedidos(
  pedido_id INT PRIMARY KEY,
  cliente_id INT,
  FOREIGN KEY(cliente_id) REFERENCES Clientes(cliente_id),
  fecha DATE,
  total DECIMAL
);
--Tabla Productos
CREATE TABLE Productos(
  producto_id INT PRIMARY KEY,
  nombre VARCHAR,
  precio DECIMAL
);
--Tabla Detalles_Pedido
CREATE TABLE Detalles_Pedido(
  detalle_id INT PRIMARY KEY,
  pedido_id INT,
  FOREIGN KEY(pedido_id) REFERENCES Pedidos(pedido_id),
  producto_id INT,
  FOREIGN KEY(producto_id) REFERENCES Productos(producto_id),
  cantidad INT
);

--INSERT Clientes
INSERT INTO Clientes (cliente_id,nombre,email) VALUES 
(1,'Ana Pérez','ana.perez@gmail.com'),
(2,'Carlos López','carlos.lopez@yahoo.com'),
(3,'María García','maria.garcia@hotmail.com'),
(4,'Juan Martínez','juan.martinez@gmail.com'),
(5,'Laura Fernández','laura.fernandez@outlook.com');

--INSERT Pedidos
INSERT INTO Pedidos (pedido_id,cliente_id,fecha,total) VALUES
(1,1,'2025-01-15',150.75),
(2,2,'2025-01-20',200.50),
(3,3,'2025-01-25',300.00),
(4,4,'2025-02-01',450.25),
(5,5,'2025-02-10',120.00);

--INSERT Productos
INSERT INTO Productos (producto_id,nombre,precio) VALUES
(1,'Laptop',1000.00),
(2,'Smartphone',750.00),
(3,'Tablet',500.00),
(4,'Monitor',300.00),
(5,'Teclado',50.00);

--INSERT Detalles_Pedido
INSERT INTO Detalles_Pedido (detalle_id,pedido_id,producto_id,cantidad) VALUES 
(1,1,1,1),
(2,2,2,2),
(3,3,3,1),
(4,4,4,3),
(5,5,5,4);

--New INSERT Clientes
INSERT INTO Clientes (cliente_id,nombre,email) VALUES 
(6,'Pedro Sánchez','pedro.sanchez@example.com');

--New INSERT Pedidos
INSERT INTO Pedidos (pedido_id,cliente_id,fecha,total) VALUES 
(6,6,'2025-02-15',1000.00),
(7,6,'2025-02-16',750.00),
(8,6,'2025-02-17',500.00),
(9,6,'2025-02-18',300.00),
(10,6,'2025-02-19',50.00);

--New INSERT Detalles_Pedido
INSERT INTO Detalles_Pedido (detalle_id,pedido_id,producto_id,cantidad) VALUES 
(6,6,1,1),
(7,7,2,1),
(8,8,3,1),
(9,9,4,1),
(10,10,5,1);
--Consultas
--SELECCIÓN: Obtén todos los clientes cuyo nombre empieza con 'A'.
SELECT * FROM Clientes WHERE nombre LIKE 'A%';

--PROYECCIÓN: Muestra solo los nombres y correos electrónicos de los clientes.
SELECT nombre,email FROM Clientes;

--UNIÓN: Encuentra todos los productos que han sido pedidos.
    --Extraigo los datos de Productos
SELECT producto_id, nombre, precio FROM productos
UNION 
    --De acuerdo a lo obtenido en Productos, comparamos con la suma de Productos con Detalles_Pedido
SELECT p.producto_id, p.nombre, p.precio
FROM Detalles_Pedido d
JOIN Productos p ON d.producto_id = p.producto_id;

--INTERSECCIÓN: Encuentra los clientes que han realizado pedidos y aquellos que tienen un correo electrónico que contiene 'gmail'.
    --Extraigo los datos de Clientes
SELECT cliente_id,nombre,email FROM Clientes WHERE email LIKE '%gmail.com'
INTERSECT 
    -- Comparo los datos de Clientes con la suma de Clientes con Pedidos
SELECT c.cliente_id, c.nombre, c.email
FROM Pedidos p
JOIN Clientes c ON p.cliente_id = c.cliente_id;

--DIFERENCIA: Encuentra los productos que no han sido pedidos.
    --Extraigo los datos de Productos
SELECT * FROM Productos
INTERSECT
    --De acuerdo a lo obtenido en Productos, comparamos con la suma de Productos con Detalles_Pedido
SELECT p.producto_id, p.nombre,p.precio
FROM Detalles_Pedido d
JOIN Productos p ON d.cantidad = NULL;

--PRODUCTO CARTESIANO: Muestra todas las combinaciones posibles de clientes y productos.
SELECT * FROM Clientes, Productos;

--JOIN natural: Muestra los detalles de los pedidos junto con la información del cliente.
SELECT
  c.nombre AS nombre_cliente,
  p.fecha AS fecha_pedido,
  dp.producto_id AS dp_producto_id,
  dp.cantidad AS cantidad_prod
FROM Clientes c
JOIN Pedidos p ON c.cliente_id = p.cliente_id
JOIN Detalles_Pedido dp ON p.pedido_id = dp.pedido_id;

--DIVISIÓN: Encuentra los clientes que han pedido todos los productos disponibles.
SELECT C.cliente_id, C.nombre 
FROM Clientes C 
WHERE NOT EXISTS ( 
   SELECT P.producto_id 
   FROM Productos P 
   WHERE NOT EXISTS ( 
       SELECT DP.producto_id 
       FROM Detalles_Pedido DP 
       WHERE DP.producto_id = P.producto_id 
       AND DP.pedido_id IN ( 
           SELECT pedido_id 
           FROM Pedidos 
           WHERE cliente_id = C.cliente_id 
       ) 
   ) 
);
