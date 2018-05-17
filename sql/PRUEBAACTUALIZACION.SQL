--PARTE I INSERTASR REGISTROS 
--DECLARACION DE LAS VARIABLES PARA EL SP 
DECLARE
	@cNombre VARCHAR(MAX) = 'B',
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
	INSERT INTO #localidadesZona VALUES( 0,0,1,'Mexico',1,'Nayarit',1,'Tepic',3,'CENTRO')
	INSERT INTO #localidadesZona VALUES( 0,0,1,'Mexico',1,'Nayarit',1,'Tepic',4,'BRISAS')

--ISERCION DE LOS DATOS DE LA TABLA TEMPORAL A LA VARIABLE @localidadesZona 
	INSERT INTO  @localidadesZona select * from #localidadesZona

--EJECUCION DE DEL SP CON VALORES ASIGNADOS A LAS VARIABLES
exec ZonasInsert @cNombre, @localidadesZona

DROP TABLE #localidadesZona


--==================================================================
--PARTE II ACTUALIZAMOS REGISTROS
GO
DECLARE
	@cNombre varchar(max)	='a',
	@nZonaPK numeric(18,0)	= 9,
	@localidadesZona dbo.LocalidadesZona

CREATE TABLE #TEMP(
	ZonaDetPK	 numeric(18, 0) ,
	ZonaPK		 numeric(18, 0) ,
	PaisPK		 numeric(18, 0) ,
	Pais		 varchar(250)	,
	EstadoPK	 numeric(18, 0) ,
	Estado		 varchar(250)	,
	MunicipioPK	 numeric(18, 0) ,
	Municipio	 varchar(250)	,
	LocalidadPK	 numeric(18, 0) ,
	Localidad	 varchar(250)	 
)
--INSERTAMOS DATOS A TEMP

INSERT INTO #TEMP VALUES( 1,9,1,'Mexico',1,'Nayarit',1,'Tepic',10,'VISTAHER')
INSERT INTO #TEMP VALUES( 0,9,1,'Mexico',1,'Nayarit',1,'Tepic',11,'bien')


SELECT COUNT(*)  FROM #TEMP 
SELECT COUNT(*) FROM ZonaDet WHERE nZonaPK =9
 
 --ACTUALIZA EL NOMBRE
	UPDATE Zonas 
	SET cNombre = @cNombre
	WHERE nZonaPK = @nZonaPK
	
--ACTUALIZA LAS LOCALIDADES

--SI VIENE UN NUEVO REGISTRO
	IF exists(select 1 from #TEMP where ZonaDetPK = 0)
	      
		insert into ZonaDet select ZonaPK,PaisPK,EstadoPK,MunicipioPK,LocalidadPK   from #TEMP where ZonaDetPK=0

--SI LOS MISMOS REGISTRO  
	ELSE
		 UPDATE ZonaDet 
			SET nPaisPK = #TEMP.PaisPK,
				nEstadoPK = #TEMP.EstadoPK,
				nMunicipioPK=#TEMP.MunicipioPK,
				nLocalidadPK=#TEMP.LocalidadPK 		  
			FROM #TEMP WHERE nZonaDetPK=ZonaDetPK
	
	SELECT * FROM #TEMP
	SELECT * FROM ZonaDet where nZonaPK=9



DROP TABLE #TEMP	


SELECT * FROM Zonas
SELECT * FROM ZonaDet

--nzonapk=9
	
	
	select * from ZonaDet where nZonaPK=9
	

	SELECT * FROM #TEMP
	SELECT * FROM ZonaDet