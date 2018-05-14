CREATE TABLE [dbo].[tablaPrueba](
    [id] [int] NOT NULL,
    [nombre] [varchar](50) NULL,
    [fecha_ingreso] [datetime] NULL,
    [fecha_actualizacion] [datetime] NULL,
 CONSTRAINT [PK_tablaPrueba] PRIMARY KEY CLUSTERED 
(
    [id] ASC
)

--=================================================================*--
-- Ejemplo 1 obsoleto pero funcional en SQL 2008 o superior
GO
CREATE PROCEDURE InsertaTablaPrueba(
@id int,
@nombre varchar(50) 
)
AS
BEGIN
    SET NOCOUNT ON
 
    --Se actualizan los registros en la tabla
    UPDATE tablaPrueba
       SET nombre = @nombre,
           fecha_actualizacion = GETDATE()
     WHERE id = @id
     --Si no se actualizó ningún registro se inserta en la tabla
     IF (@@ROWCOUNT = 0 )
     BEGIN
        INSERT INTO tablaPrueba (id, nombre, fecha_ingreso, fecha_actualizacion)
        VALUES(@id, @nombre, GETDATE(), GETDATE())
     END
END
--=====================================================================*--
-- Ejemplo 2, obsoleto pero funcional en SQL 2008 o superior
GO
CREATE PROCEDURE InsertaTablaPrueba2(
@id int,
@nombre varchar(50) 
)
AS
BEGIN
    SET NOCOUNT ON
 
    IF EXISTS(SELECT 1 FROM tablaPrueba
               WHERE id = @id)
    BEGIN
        --Se actualizan los registros en la tabla
        UPDATE tablaPrueba
           SET nombre = @nombre,
               fecha_actualizacion = GETDATE()
         WHERE id = @id
     END
     ELSE
     BEGIN
        --Si no existe el registro se inserta en la tabla
        INSERT INTO tablaPrueba (id, nombre, fecha_ingreso, fecha_actualizacion)
        VALUES(@id, @nombre, GETDATE(), GETDATE())
     END
 
END
--====================================================================--
GO
-- Ejemplo 3, usando MERGE, mucho más eficiente
CREATE PROCEDURE InsertaTablaPruebaMerge(
@id int,
@nombre varchar(50) 
)
AS
BEGIN
    SET NOCOUNT ON
 
    MERGE tablaPrueba as TARGET
    USING(SELECT @id, @nombre) AS SOURCE(id, nombre)
    ON (TARGET.id = SOURCE.id)
    WHEN MATCHED THEN
        UPDATE SET nombre = SOURCE.nombre, 
                   fecha_actualizacion = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (id, nombre, fecha_ingreso, fecha_actualizacion)
        VALUES (SOURCE.id, SOURCE.nombre, GETDATE(), GETDATE());
END