# SQL-Procedures
1. AtualizarDimensoes
O que faz?
Atualiza as tabelas dimensionais (DimCategoria, DimProduto, DimMarca, DimContinente, DimCalendario) com base nos dados da tabela VendaHistorico.
Como funciona?
Insere novos registros nas dimensões quando não existem (ex.: novas categorias, produtos, marcas, etc.).
Atualiza a tabela DimCalendario com informações detalhadas sobre datas (ano, mês, dia, trimestre, etc.).
Garante que as dimensões estejam sempre sincronizadas com os dados mais recentes.

3. inserirFatoVendaHistorico
O que faz?
Carrega dados na tabela de fatos (FatoVendaHistorico) combinando informações das tabelas dimensionais e os dados de vendas históricos (VendaHistorico).
Como funciona?
Junta os IDs das dimensões (categoria, produto, marca, continente, data) com métricas de vendas (preço, quantidade, custo, faturamento).
Insere apenas novos registros na tabela de fatos, evitando duplicações.
Resumo Geral
AtualizarDimensoes : Mantém as tabelas dimensionais atualizadas com base nos dados históricos.
inserirFatoVendaHistorico : Preenche a tabela de fatos com dados consolidados para análise.
Ambas garantem que o modelo de dados esteja consistente e pronto para análises no Data Warehouse.
