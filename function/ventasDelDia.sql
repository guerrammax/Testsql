-- =============================================
-- Author:		Oscar C.
-- Create date: 2014-11-06 15:35:45
-- Description:	Obtiene todas las ventas de cualquier tipo de pago
-- Author:		Martín Pérez.
-- Create date: 06/02/2016
-- Description:	Obtiene todas las ventas de cualquier tipo de pago, se modifico la linea del where
-- Update Martín P. 11/08/2016 Actualizacion se buscan ahora por apertura pk y no por fecha,.
-- =============================================
/*	
*/
CREATE PROCEDURE [dbo].[ventasDelDia]
	@nSucursalPK	NUMERIC(18,0) = 1,
	@nCajaPK	NUMERIC(18,0) = 6
AS
BEGIN
	SET NOCOUNT OFF;

	DECLARE @nAperturaPK NUMERIC(18,0)
	SELECT
		TOP 1 
		@nAperturaPK = nAperturaCajaPK
		FROM AperturaCajas
	WHERE nSubPartidaCajaPK = @nCajaPK AND bCorte = 0
	ORDER BY dFecha DESC

    SELECT
		TP.cDescripcion AS Tipo,
		(
			SELECT
				ISNULL(Convert(Numeric(18,2),SUM(PVD.mMonto)),0) AS Monto		
				FROM PagoVentaDet PVD 
					LEFT JOIN PagosVentas PV ON PVD.nPagoVentaPK = PV.nPagoVentaPK
					LEFT JOIN Ventas V ON PV.nVentaPK = V.nVentaPK 
					LEFT JOIN VentaDet VD ON V.nVentaPK=VD.nVentaPK
					LEFT JOIN Bodegas B ON VD.nBodegaPK = B.nBodegaPK 
					LEFT JOIN Sucursales S ON B.nSucursalPK = S.nSucursalPK
				--WHERE PVD.dFecha >= @Fecha AND B.nSucursalPK = @nSucursalPK AND V.dCancelada IS NULL AND PVD.nTipoPagoPK = TP.nTipoPagoPK
				WHERE PVD.nAperturaPK = @nAperturaPK AND V.nSucursalPK = @nSucursalPK AND V.dCancelada IS NULL AND PVD.nTipoPagoPK = TP.nTipoPagoPK
		) AS Monto
		FROM TiposPago TP
	WHERE TP.nTipoPagoPK <> 6
	ORDER BY Monto DESC
END


--EXEC [dbo].[ventasDelDia] 2,13