-- =============================================
-- Author:		 DataBaseHelper
-- Create date:	 13/1/2016 
-- Description: Procedimiento generado para manejo de cat�logos
-- =============================================
/*

DECLARE @localidadesZona dbo.LocalidadesDeZona
INSERT INTO @localidadesZona (ZonaPK, PaisPK, Pais, EstadoPK, Estado, MunicipioPK, Municipio, LocalidadPK, Localidad)
VALUES(13, 1,'A',1,'A',1,'A',34,'A')

exec [dbo].[ZonasInsert] 'test sql', @localidadesZona
*/

CREATE PROCEDURE [dbo].[ZonasUpdate] 
	@cNombre varchar(max),
	@localidadesZona dbo.LocalidadesZona READONLY
AS
BEGIN
	SET NOCOUNT OFF;
	
	UPDATE Zonas 
	SET cNombre = @cNombre
	WHERE nZonaPK = (SELECT DISTINCT ZonaPK FROM @localidadesZona)


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

END

--exec [dbo].[ConceptosMantenimientoSelect] 