--DECLARACION DE LAS VARIABLES PARA EL SP 
DECLARE
	@cNombre VARCHAR(MAX) = 'Tepic',
	@localidadesZona dbo.LocalidadesZona 
--CREACION DE LA TABLA TEMPORAL PARA ALMACENAR LOS VALORES A LA VARIABLE @localidadesZona QUE ES DE TIPO TABLA
CREATE  TABLE #localidadesZona(
	ZonaDetPK   NUMERIC(18, 0),
	ZonaPK      NUMERIC(18, 0),
	PaisPK      NUMERIC(18, 0),
	Pais        VARCHAR(250),
	EstadoPK    NUMERIC(18, 0),
	Estado      VARCHAR(250),
	MunicipioPK NUMERIC(18, 0),
	Municipio   VARCHAR(250),
	LocalidadPK NUMERIC(18, 0),
	Localidad   VARCHAR(250)
)
--INSERCION DE LOS DATOS A LA TABLA TEMPORAL
	INSERT INTO #localidadesZona VALUES( 0,0,1,'Mexico',1,'Nayarit',1,'Tepic',1,'Cantera')
--INSERCION DE LOS DATOS DE LA TABLA TEMPORAL A LA VARIABLE @localidadesZona 
	INSERT INTO  @localidadesZona select * from #localidadesZona
--EJECUCION DE DEL SP CON VALORES ASIGNADOS A LAS VARIABLES
EXEC ZonasInsert 'tepic', @localidadesZona
--ELIMINACION DE LA TABLA TEMPORAL
DROP table #localidadesZona