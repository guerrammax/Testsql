--DECLARACION DE LAS VARIABLES PARA EL SP 
DECLARE
	@cNombre VARCHAR(MAX) = 'Tepic',
	@localidadesZona dbo.LocalidadesZona 

--CREACION DE LA TABLA TEMPORAL PARA ALMACENAR LOS VALORES A LA VARIABLE @localidadesZona QUE ES DE TIPO TABLA
create  table #localidadesZona(
	ZonaDetPK numeric(18, 0),
	ZonaPK numeric(18, 0),
	PaisPK numeric(18, 0) NOT NULL,
	Pais varchar(250) NOT NULL,
	EstadoPK numeric(18, 0) NOT NULL,
	Estado varchar(250) NOT NULL,
	MunicipioPK numeric(18, 0) NOT NULL,
	Municipio varchar(250) NOT NULL,
	LocalidadPK numeric(18, 0) NOT NULL,
	Localidad varchar(250) NOT NULL
)

--INSERCION DE LOS DATOS A LA TABLA TEMPORAL
	INSERT INTO #localidadesZona VALUES( 0,0,1,'Mexico',1,'Nayarit',1,'Tepic',1,'Cantera')

--ISERCION DE LOS DATOS DE LA TABLA TEMPORAL A LA VARIABLE @localidadesZona 
	INSERT INTO  @localidadesZona select * from #localidadesZona

--EJECUCION DE DEL SP CON VALORES ASIGNADOS A LAS VARIABLES
exec ZonasInsert 'tepic', @localidadesZona

--ELIMINACION DE LA TABLA TEMPORAL
DROP table #localidadesZona