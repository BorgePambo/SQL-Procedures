USE [BancoSSIS]
GO
/****** Object:  StoredProcedure [dbo].[inserirFatoVendaHistorico]    Script Date: 28/02/2025 20:34:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
select * from VendaHistorico;
SELECT * FROM DimCalendario;
select * from  FatoVendaHistorico;
*/

ALTER PROCEDURE [dbo].[inserirFatoVendaHistorico]
AS
BEGIN
	SET XACT_ABORT ON; -- Garante que a transação seja cancelada em caso de erro

	BEGIN TRY
		BEGIN TRANSACTION 

			MERGE INTO FatoVendaHistorico AS alvo
			USING( 
				SELECT
					CAT.CategoriaID,
					P.ProdutoID,
					MA.MarcaID,
					CO.ContinenteID,
					CA.DataID,
					V.[PrecoUnitario] AS PrecoUnitario,  
					V.[Quantidade],
					V.[Custo Unitário] AS CustoUnitario,  
					V.[Faturamento]
				FROM VendaHistorico AS V
					INNER JOIN DimCategoria AS CAT ON CAT.CategoriaNome = V.Categoria
					INNER JOIN DimProduto AS P ON P.ProdutoNome = V.Produto
					INNER JOIN DimMarca AS MA ON MA.MarcaNome = V.Marca
					INNER JOIN DimContinente AS CO ON CO.ContinenteNome = V.Continente
					INNER JOIN DimCalendario AS CA ON CA.DataID = CONVERT(INT, FORMAT(V.DataVenda, 'yyyyMMdd'))
			) AS origem 
				ON origem.CategoriaID = alvo.CategoriaID
				AND origem.ProdutoID = alvo.ProdutoID
				AND origem.MarcaID = alvo.MarcaID
				AND origem.ContinenteID = alvo.ContinenteID
				AND origem.DataID = alvo.DataID
			WHEN NOT MATCHED THEN
				INSERT (CategoriaID, ProdutoID, MarcaID, ContinenteID, DataID,
						PrecoUnitario, Quantidade, CustoUnitario, Faturamento)
				VALUES (origem.CategoriaID, origem.ProdutoID, origem.MarcaID, 
						origem.ContinenteID, origem.DataID, origem.PrecoUnitario,
						origem.Quantidade, origem.CustoUnitario, origem.Faturamento);

		COMMIT
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK;

		-- Retorna a mensagem de erro para facilitar a depuração
		THROW;
	END CATCH

END;
