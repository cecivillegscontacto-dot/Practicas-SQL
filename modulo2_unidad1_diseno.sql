CREATE DATABASE Modulo3;

USE Modulo3;


-- Creación de la tabla Clientes
CREATE TABLE Clientes (
    -- INT: Ideal para claves primarias numéricas ya que ocupa poco espacio (4 bytes) y permite indexación rápida.
    -- IDENTITY(1,1): Genera valores secuenciales automáticamente, evitando duplicados.
    id_cliente INT PRIMARY KEY IDENTITY (1,1),
    
    -- VARCHAR(100): Almacena cadenas de longitud variable. Se usa para nombres porque optimiza el espacio
    -- (solo ocupa lo que pesa el texto real) y 100 caracteres es un límite seguro para nombres completos.
    nombre VARCHAR (100),
    
    -- TEXT: Permite almacenar grandes volúmenes de texto variable (como biografías o descripciones largas)
    -- sin la restricción de límite de caracteres de un VARCHAR estándar.
    perfil_bio TEXT,
    
    -- DATETIME: Tipo de dato correcto en SQL Server para almacenar fecha y hora exactas.
    -- DEFAULT GETDATE(): Asigna automáticamente la fecha y hora del servidor al insertar el registro.
    fecha_registro DATETIME DEFAULT GETDATE()
);

SELECT * FROM Clientes;

-- Creación de la tabla Productos
CREATE TABLE Productos (
    -- INT IDENTITY(1,1): Misma lógica; un identificador numérico único, autoincremental y eficiente.
    id_producto INT PRIMARY KEY IDENTITY (1,1),
    
    -- VARCHAR(255): Espacio variable óptimo para descripciones. El límite de 255 es un estándar ideal 
    -- para textos informativos medianos sin llegar a saturar el almacenamiento.
    descripcion VARCHAR (255),
    
    -- DECIMAL(10,2): Obligatorio para datos monetarios o de alta precisión. 
    -- El '10' indica que puede tener hasta 10 dígitos en total, y el '2' asegura exactamente dos decimales para los centavos, 
    -- evitando los errores de redondeo que tienen los tipos FLOAT.
    precio DECIMAL (10,2),
    
    -- BIT: El tipo de dato más eficiente para valores booleanos (Verdadero/Falso). Ocupa solo 1 bit en memoria.
    -- DEFAULT 1: Asegura que, por defecto, cualquier producto nuevo creado esté activo (1 = True / 0 = False).
    esta_activo BIT DEFAULT 1
);

SELECT * FROM Productos;
