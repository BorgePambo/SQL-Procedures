USE [BancoSSIS]
GO
/****** Object:  StoredProcedure [dbo].[AtualizarDimensoes]    Script Date: 28/02/2025 20:33:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[AtualizarDimensoes]
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION

            -- Atualização da tabela DimCategoria
            MERGE INTO DimCategoria AS alvo
            USING (
                SELECT DISTINCT Categoria
                FROM VendaHistorico
            ) AS origem
            ON alvo.CategoriaNome = origem.Categoria
            WHEN NOT MATCHED THEN
                INSERT (CategoriaNome)
                VALUES (origem.Categoria);

            -- Atualização da tabela DimProduto
            MERGE INTO DimProduto AS alvo
            USING (
                SELECT DISTINCT Produto
                FROM VendaHistorico
            ) AS origem
            ON origem.Produto = alvo.ProdutoNome
            WHEN NOT MATCHED THEN
                INSERT (ProdutoNome)
                VALUES (origem.Produto);

            -- Atualização da tabela DimContinente
            MERGE INTO DimContinente AS alvo
            USING (
                SELECT DISTINCT Continente 
                FROM VendaHistorico
            ) AS origem
            ON origem.Continente = alvo.ContinenteNome
            WHEN NOT MATCHED THEN
                INSERT (ContinenteNome)
                VALUES (origem.Continente);

            -- Atualização da tabela DimMarca
            MERGE INTO DimMarca AS alvo
            USING (
                SELECT DISTINCT Marca
                FROM VendaHistorico
            ) AS origem
            ON origem.Marca = alvo.MarcaNome
            WHEN NOT MATCHED THEN
                INSERT (MarcaNome)
                VALUES (origem.Marca);

            -- Atualização da tabela DimCalendario
            MERGE INTO DimCalendario AS alvo
            USING (
                SELECT DISTINCT
                    TRY_CAST(FORMAT(DataVenda, 'yyyyMMdd') AS INT) AS DataID,
                    CAST(DataVenda AS DATE) AS Data,
                    YEAR(DataVenda) AS Ano,
                    MONTH(DataVenda) AS Mes,
                    DAY(DataVenda) AS Dia,
                    DATEPART(QUARTER, DataVenda) AS Trimeste,
                    DATEPART(WEEKDAY, DataVenda) AS DiaSemana
                FROM VendaHistorico
            ) AS origem
            ON origem.DataID = alvo.DataID
            WHEN MATCHED THEN
                UPDATE SET 
                    alvo.Data = origem.Data,
                    alvo.Ano = origem.Ano,
                    alvo.Mes = origem.Mes,
                    alvo.Dia = origem.Dia,
                    alvo.Trimeste = origem.Trimeste,
                    alvo.DiaSemana = origem.DiaSemana
            WHEN NOT MATCHED BY TARGET THEN
                INSERT (DataID, Data, Ano, Mes, Dia, Trimeste, DiaSemana)
                VALUES (origem.DataID, origem.Data, origem.Ano, origem.Mes,
                        origem.Dia, origem.Trimeste, origem.DiaSemana);

        COMMIT;

    END TRY
    BEGIN CATCH
        -- Caso ocorra um erro, a transação será desfeita
        ROLLBACK;

        -- Retorne o erro
        THROW;
    END CATCH;

END;
