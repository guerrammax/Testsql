-- =============================================
-- Author:		 DataBaseHelper
-- Create date:	 13/1/2016 
-- Description: Procedimiento generado para manejo de catálogos
-- =============================================
/*

DECLARE @localidadesZona dbo.LocalidadesZona
INSERT INTO @localidadesZona (ZonaDetPK, ZonaPK, PaisPK, Pais, EstadoPK, Estado, MunicipioPK, Municipio, LocalidadPK, Localidad)
VALUES(10, 8, 1, 'A',1,'A',1,'A',34,'A')

exec [dbo].[ZonasUpdate] 'test sql', 8, @localidadesZona

*/

CREATE PROCEDURE [dbo].[ZonasUpdate] 
	@cNombre varchar(max),
	@nZonaPK numeric(18,0),
	@localidadesZona dbo.LocalidadesZona READONLY
AS
BEGIN
	SET NOCOUNT OFF;
	
	UPDATE Zonas 
	SET cNombre = @cNombre
	WHERE nZonaPK = @nZonaPK


	MERGE ZonaDet AS TRG
	USING (SELECT LZ.ZonaDetPK AS DetPK, LZ.ZonaPK AS PK, LZ.PaisPK AS PaisPK, LZ.EstadoPK AS EstadoPK, LZ.MunicipioPK AS MunicipioPK, LZ.LocalidadPK AS LocalidadPK
	 FROM @localidadesZona LZ) AS SRC ON SRC.DetPK = TRG.nZonaDetPK AND SRC.PK = TRG.nZonaPK

	WHEN MATCHED THEN
	UPDATE SET nPaisPK = SRC.PaisPK, nEstadoPK = SRC.EstadoPK, nMunicipioPK = SRC.MunicipioPK, nLocalidadPK = SRC.LocalidadPK

	WHEN NOT MATCHED BY TARGET THEN

	INSERT(
		nZonaPK,
		nPaisPK,
		nEstadoPK,
		nMunicipioPK,
		nLocalidadPK
	)
	VALUES(
		SRC.PK,
		SRC.PaisPK,
		SRC.EstadoPK,
		SRC.MunicipioPK,
		SRC.LocalidadPK
	)

	WHEN NOT MATCHED BY SOURCE THEN

	DELETE

	;

	DECLARE @DB	NVARCHAR(MAX);
	DECLARE vCursor CURSOR FOR 
	SELECT DISTINCT cBaseDatos FROM Empresas WHERE dBaja IS NULL
	OPEN vCursor
	FETCH NEXT FROM vCursor INTO @DB

	WHILE @@FETCH_STATUS = 0 BEGIN
			DECLARE @SQL NVARCHAR(MAX) = N'',
					@PAR NVARCHAR(MAX) = N'';

			SET @PAR = '@_nZonaPK numeric(18,0)' 			

			SET @SQL = ' UPDATE V1 SET
						 V1.cNombre = V2.cNombre							
						 FROM '+ @DB +'.dbo.Zonas AS V1
						 INNER JOIN Zonas AS V2 ON V1.nZonaPK = V2.nZonaPK
						 WHERE V1.nZonaPK = @_nZonaPK'		
				
			PRINT @SQL

			EXEC SP_EXECUTESQL @SQL, @PAR, @_nZonaPK = @nZonaPK;

			SET @SQL = 							
					'MERGE '+@DB+'.dbo.ZonaDet AS TRG
					USING ZonaDet AS SRC ON SRC.nZonaDetPK = TRG.nZonaDetPK AND SRC.nZonaPK = TRG.nZonaPK '+

					'WHEN MATCHED THEN
					UPDATE SET nPaisPK = SRC.nPaisPK, nEstadoPK = SRC.nEstadoPK, nMunicipioPK = SRC.nMunicipioPK, nLocalidadPK = SRC.nLocalidadPK

					WHEN NOT MATCHED BY TARGET THEN

					INSERT(
						nZonaDetPK,
						nZonaPK,
						nPaisPK,
						nEstadoPK,
						nMunicipioPK,
						nLocalidadPK
					)
					VALUES(
						SRC.nZonaDetPK,
						SRC.nZonaPK,
						SRC.nPaisPK,
						SRC.nEstadoPK,
						SRC.nMunicipioPK,
						SRC.nLocalidadPK
					)

					WHEN NOT MATCHED BY SOURCE THEN

					DELETE

					;'
							
			EXEC SP_EXECUTESQL @SQL;					

	FETCH NEXT FROM vCursor INTO @DB 
	END		
	CLOSE vCursor
	DEALLOCATE vCursor


END

--exec [dbo].[ConceptosMantenimientoSelect] 