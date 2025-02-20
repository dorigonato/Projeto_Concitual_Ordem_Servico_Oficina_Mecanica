# Projeto: Banco de Dados para Oficina Mecânica (Ordem_Servico_Oficina)

## Descrição do Desafio

Este projeto consiste na criação de um banco de dados para o contexto de uma oficina mecânica, desde o esquema lógico até a implementação física e a persistência de dados. O objetivo é aplicar os conhecimentos adquiridos sobre modelagem de dados, modelo relacional e linguagem SQL para resolver um problema real.

## Contexto

O sistema visa gerenciar informações cruciais para o funcionamento eficiente de uma oficina mecânica, incluindo:

*   **Clientes:** Dados dos clientes que utilizam os serviços da oficina.
*   **Veículos:** Informações sobre os veículos dos clientes (modelo, placa, ano).
*   **Equipe de Mecânicos:** Dados sobre as equipes de mecânicos e seus membros.
*   **Ordens de Serviço:** Detalhes sobre as ordens de serviço, incluindo data de emissão, status, serviços realizados, peças utilizadas e valor total.
*   **Serviços:** Descrição e valor dos serviços oferecidos pela oficina.
*   **Peças:** Informações sobre as peças disponíveis em estoque, incluindo nome, valor e quantidade.
*   **Pagamentos:** Registro dos pagamentos efetuados pelas ordens de serviço.
*   **Estoque:** Controle do estoque de peças da oficina.
*   **Fornecedores:** Dados dos fornecedores de peças e serviços.
*   **Agenda:** Agendamento de serviços para os clientes.

## Esquema Lógico (Modelo Relacional)

O esquema lógico do banco de dados foi modelado utilizando o modelo relacional e implementado no MySQL Workbench. 

## Script SQL para Criação do Esquema

O script SQL para criar o esquema do banco de dados está no arquivo ‘Ordem_Servico_Oficina.sql’. Este arquivo contém os comandos `CREATE TABLE` para todas as tabelas do esquema lógico, bem como as constraints de chave primária e chave estrangeira.

## Persistência de Dados (Dados de Teste)

Para testar o banco de dados, foram inseridos dados fictícios em todas as tabelas.

## Queries SQL Complexas

A seguir, algumas queries SQL complexas que exploram os dados do banco de dados, demonstrando o uso de diferentes cláusulas e funcionalidades do SQL.

1. Recuperações Simples com SELECT Statement:

*   **Pergunta:** Quais são os nomes e telefones de todos os clientes?
SELECT Nome, Telefone FROM Cliente;

2. Filtros com WHERE Statement:
•	Pergunta: Quais são os veículos fabricados após 2020?
SELECT Modelo, Placa, Ano FROM Veiculo WHERE Ano > 2020;

3. Crie Expressões para Gerar Atributos Derivados:
•	Pergunta: Qual o valor total de cada ordem de serviço, incluindo o valor dos serviços e das peças?
SELECT
    OS.idOrdemServico,
    OS.ValorTotal,
    SUM(S.Valor * OSS.Quantidade) AS ValorTotalServicos,
    SUM(P.Valor * OSP.Quantidade) AS ValorTotalPecas
FROM Ordem_de_Servico AS OS
LEFT JOIN Ordem_de_Servico_Servico AS OSS ON OS.idOrdemServico = OSS.idOrdemServico
LEFT JOIN Servico AS S ON OSS.idServico = S.idServico
LEFT JOIN Ordem_de_Servico_Peca AS OSP ON OS.idOrdemServico = OSP.idOrdemServico
LEFT JOIN Peca AS P ON OSP.idPeca = P.idPeca
GROUP BY OS.idOrdemServico;

4. Defina Ordenações dos Dados com ORDER BY:
•	Pergunta: Quais são os serviços, ordenados do mais caro para o mais barato?
SELECT Descricao, Valor FROM Servico ORDER BY Valor DESC;

5. Condições de Filtros aos Grupos – HAVING Statement:
•	Pergunta: Quais clientes têm mais de um veículo cadastrado na oficina?
SELECT
    C.Nome,
    COUNT(V.idVeiculo) AS NumeroVeiculos
FROM Cliente AS C
JOIN Veiculo AS V ON C.idCliente = V.Cliente_idCliente
GROUP BY C.idCliente
HAVING COUNT(V.idVeiculo) >= 1;

6. Crie Junções entre Tabelas para Fornecer uma Perspectiva Mais Complexa dos Dados:
•	Pergunta: Quais serviços foram realizados em cada ordem de serviço, incluindo o nome do cliente e a placa do veículo?
SELECT
    C.Nome AS Cliente,
    V.Placa AS Veiculo,
    OS.idOrdemServico AS OrdemServico,
    S.Descricao AS Servico
FROM Cliente AS C
JOIN Veiculo AS V ON C.idCliente = V.Cliente_idCliente
JOIN Ordem_de_Servico AS OS ON V.idVeiculo = OS.idVeiculo
JOIN Ordem_de_Servico_Servico AS OSS ON OS.idOrdemServico = OSS.idOrdemServico
JOIN Servico AS S ON OSS.idServico = S.idServico;

Ferramentas Utilizadas
•	MySQL Workbench 8.0 CE

Instrutora
•	Juliana Mascarenhas
