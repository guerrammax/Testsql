-- =============================================
-- Author:		 Ana R.
-- Create date:	 06/11/2015 
-- Description: procedimiento para manejo de catalogos en TTCentral
-- =============================================
ALTER PROCEDURE [dbo].[CatTiposProductoInsert] 
	@nTipoProductoPK numeric(18,0)= NULL OUTPUT,
	@cMessage varchar(500) = NULL OUTPUT,
	@cClave varchar(3) ,
	@cDescripcion varchar(MAX)  = NULL,
	@bLocked bit ,
	@dBaja datetime  = NULL
AS
BEGIN
	SET NOCOUNT OFF;
	DECLARE 
		@SQL NVARCHAR(MAX),
		@PAR NVARCHAR(MAX),
		@DB  VARCHAR(200)
	
	
	DECLARE @Verifica INT = 0
	SELECT @Verifica = COUNT(*) FROM CatTiposProducto WHERE cClave = @cClave
	IF @Verifica > 0
	BEGIN	
		/* SE COMENTA ESTA PARTE PARA EVITAR QUE SE EDITE UN PRODUCTO DADO DE BAJA			
		SELECT @Verifica = COUNT(*) FROM CatTiposProducto WHERE cClave = @cClave and dBaja is not null
		if(@Verifica>0)
		BEGIN
			--DECLARE @TablePK TABLE(PK NUMERIC(18,0))
			UPDATE CatTiposProducto
			set cDescripcion=@cDescripcion,
				bLocked=@bLocked--,
				--dbaja=null				
			--OUTPUT inserted.nTipoProductoPK INTO @TablePK
			where cClave=@cClave			
			
				
				SET @nTipoProductoPK=(SELECT TOP 1 nTipoProductoPK FROM CatTiposProducto WHERE cClave=@cClave)
				SET @PAR = N'	 @_nTipoProductoPK NUMERIC(18,0)' 
				DECLARE Cursor2 CURSOR FOR 
				SELECT DISTINCT cBaseDatos FROM Empresas WHERE dBaja IS NULL
				OPEN Cursor2
				FETCH NEXT FROM Cursor2 INTO @DB

				WHILE @@FETCH_STATUS = 0 

				BEGIN
					SET @SQL = N' UPDATE V1 SET
								V1.nTipoProductoPK = V2.nTipoProductoPK,
								V1.cClave = V2.cClave,
								V1.cDescripcion = V2.cDescripcion,
								V1.bLocked = V2.bLocked,
								V1.dBaja=V2.dBaja
								FROM '+ @DB +'.dbo.CatTiposProducto AS V1
								INNER JOIN CatTiposProducto AS V2 ON V1.nTipoProductoPK = V2.nTipoProductoPK
								WHERE V1.nTipoProductoPK =@_nTipoProductoPK'		
							
					EXEC SP_EXECUTESQL @SQL,@PAR,@_nTipoProductoPK = @nTipoProductoPK

					FETCH NEXT FROM Cursor2 INTO @DB 
	
				END
		
				CLOSE Cursor2
				DEALLOCATE Cursor2
				
		END
		ELSE
		*/
		BEGIN
			SET @cMessage = 'La clave ya se encuentra asignada a otro elemento. Verifique en bajas si no se muestra en la lista'
			RETURN
		END		
	END
	ELSE
	BEGIN
		BEGIN  TRY
			INSERT INTO CatTiposProducto 
			(
				cClave,
				cDescripcion,
				bLocked,
				dBaja
			)

			VALUES
			(
				@cClave ,
				@cDescripcion ,
				@bLocked ,
				@dBaja 
			)
			SET @nTipoProductoPK = SCOPE_IDENTITY()
			SET @nTipoProductoPK = ISNULL(@nTipoProductoPK,0)

			IF  @nTipoProductoPK < 1 
			RAISERROR ('No se pudo insertar el registro en la BD Central',18,1) --grado de error
		ELSE
		BEGIN
			SET @PAR = N'	 @_nTipoProductoPK numeric(18,0) OUTPUT' 
			DECLARE Cursor2 CURSOR FOR 
			SELECT DISTINCT cBaseDatos FROM Empresas WHERE dBaja IS NULL
			OPEN Cursor2
			FETCH NEXT FROM Cursor2 INTO @DB

			WHILE @@FETCH_STATUS = 0 

			BEGIN
				SET @SQL = N' INSERT INTO '+ @DB + '.dbo.CatTiposProducto 
							SELECT *
								FROM CatTiposProducto
								WHERE nTipoProductoPK = @_nTipoProductoPK'				
				
	
				EXEC SP_EXECUTESQL @SQL,@PAR,@_nTipoProductoPK  = @nTipoProductoPK  OUTPUT--,
											-- @_cMessage = @cMessage OUTPUT

				FETCH NEXT FROM Cursor2 INTO @DB 
	
			END
		
			CLOSE Cursor2
			DEALLOCATE Cursor2
		END 
		END TRY
		BEGIN CATCH
			DECLARE 
				@Error VARCHAR(MAX)

			SET @Error = ERROR_MESSAGE()
			RAISERROR (@Error,18,1)

		END CATCH
	END
	
END
