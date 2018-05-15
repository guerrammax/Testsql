
DECLARE @localidadesZona table(
	ZonaDetPK numeric(18,0),
	ZonaPK numeric(18,0),
	PaisPK numeric(18,0),
	Pais numeric(18,0),
	EstadoPK numeric(18,0),
	Estado numeric(18,0),
	MunicipioPK numeric(18,0), 
	LocalidadPK numeric(18,0)
)

INSERT INTO @localidadesZona (ZonaDetPK, ZonaPK, PaisPK, Pais, EstadoPK, Estado, MunicipioPK, Municipio, LocalidadPK, Localidad)
VALUES(0, 13, 1,'A',1,'A',1,'A',34,'A')

exec [dbo].[ZonasInsert] 'test sql', @localidadesZona



declare 	
	@cNombre VARCHAR(MAX),
	@localidadesZona dbo.LocalidadesZona READONLY
AS
BEGIN
	SET NOCOUNT OFF;
	DECLARE
		@BDC VARCHAR(200),/*NOMBRE DE LA BASE DE DATOS*/
		@SQL NVARCHAR(MAX),/*SENTENCIA SQL*/
		@PAR NVARCHAR(MAX),/*PARAMETROS*/
		@nZonaPK NUMERIC(18,0)

	INSERT INTO Zonas
	(		
		cNombre,
		dAlta
	)
	VALUES
	(
		@cNombre,
		GETDATE()
	)

	SET @nZonaPK = SCOPE_IDENTITY()

	
	INSERT INTO ZonaDet (nZonaPK, nPaisPK, nEstadoPK, nMunicipioPK, nLocalidadPk) SELECT @nZonaPK, PaisPK, EstadoPK,  MunicipioPK, LocalidadPK FROM @localidadesZona
