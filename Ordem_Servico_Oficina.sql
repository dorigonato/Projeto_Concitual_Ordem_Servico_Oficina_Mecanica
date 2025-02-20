-- CREATE DATABASE Ordem_Servico_Oficina;
-- USE Ordem_Servico_Oficina;

-- -----------------------------------------------------
-- Tabela Cliente
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Ordem_Servico_Oficina`.`Cliente` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(100) NOT NULL,
  `CPF` VARCHAR(14) UNIQUE,
  `Telefone` VARCHAR(20) NOT NULL,
  `Endereco` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idCliente`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela Pessoa_Fisica
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Ordem_Servico_Oficina`.`Pessoa_Fisica` (
  `idPessoaFisica` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(100) NOT NULL,
  `CPF` VARCHAR(14) UNIQUE NOT NULL,
  PRIMARY KEY (`idPessoaFisica`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela Pessoa_Juridica
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Ordem_Servico_Oficina`.`Pessoa_Juridica` (
  `idPessoaJuridica` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(100) NOT NULL,
  `CNPJ` VARCHAR(18) UNIQUE NOT NULL,
  PRIMARY KEY (`idPessoaJuridica`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela Equipe_de_Mecanicos
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Ordem_Servico_Oficina`.`Equipe_de_Mecanicos` (
  `idEquipeMecanicos` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idEquipeMecanicos`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela Mecanico
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Ordem_Servico_Oficina`.`Mecanico` (
  `idMecanico` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(100) NOT NULL,
  `Endereco` VARCHAR(100),
  `Especialidade` VARCHAR(100),
  `idEquipeMecanicos` INT NOT NULL,
  PRIMARY KEY (`idMecanico`),
  CONSTRAINT `fk_Mecanico_EquipeMecanicos`
    FOREIGN KEY (`idEquipeMecanicos`)
    REFERENCES `Ordem_Servico_Oficina`.`Equipe_de_Mecanicos` (`idEquipeMecanicos`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela Veiculo
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Ordem_Servico_Oficina`.`Veiculo` (
  `idVeiculo` INT NOT NULL AUTO_INCREMENT,
  `Modelo` VARCHAR(100) NOT NULL,
  `Placa` VARCHAR(10) UNIQUE NOT NULL,
  `Ano` INT NOT NULL,
  `Cliente_idCliente` INT NOT NULL,
  PRIMARY KEY (`idVeiculo`),
  CONSTRAINT `fk_Veiculo_Cliente`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `Ordem_Servico_Oficina`.`Cliente` (`idCliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela Ordem_de_Servico
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Ordem_Servico_Oficina`.`Ordem_de_Servico` (
  `idOrdemServico` INT NOT NULL AUTO_INCREMENT,
  `DataEmissao` DATE NOT NULL,
  `ValorTotal` DECIMAL(10,2) NOT NULL,
  `Status` ENUM('Aberta', 'Em Andamento', 'Concluída', 'Cancelada') NOT NULL,
  `DataConclusao` DATE,
  `idVeiculo` INT NOT NULL,
  `idEquipeMecanicos` INT NOT NULL,
  PRIMARY KEY (`idOrdemServico`),
  CONSTRAINT `fk_OrdemServico_Veiculo`
    FOREIGN KEY (`idVeiculo`)
    REFERENCES `Ordem_Servico_Oficina`.`Veiculo` (`idVeiculo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_OrdemServico_EquipeMecanicos`
    FOREIGN KEY (`idEquipeMecanicos`)
    REFERENCES `Ordem_Servico_Oficina`.`Equipe_de_Mecanicos` (`idEquipeMecanicos`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela Servico
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Ordem_Servico_Oficina`.`Servico` (
  `idServico` INT NOT NULL AUTO_INCREMENT,
  `Descricao` VARCHAR(200) NOT NULL,
  `Valor` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`idServico`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela Ordem_de_Servico_Servico
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Ordem_Servico_Oficina`.`Ordem_de_Servico_Servico` (
  `idOrdemServico` INT NOT NULL,
  `idServico` INT NOT NULL,
  PRIMARY KEY (`idOrdemServico`, `idServico`),
  CONSTRAINT `fk_OrdemServicoServico_OrdemServico`
    FOREIGN KEY (`idOrdemServico`)
    REFERENCES `Ordem_Servico_Oficina`.`Ordem_de_Servico` (`idOrdemServico`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_OrdemServicoServico_Servico`
    FOREIGN KEY (`idServico`)
    REFERENCES `Ordem_Servico_Oficina`.`Servico` (`idServico`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela Pecas
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Ordem_Servico_Oficina`.`Peca` (
  `idPeca` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(100) NOT NULL,
  `Valor` DECIMAL(10,2) NOT NULL,
  `Quantidade` INT NOT NULL,
  PRIMARY KEY (`idPeca`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela Ordem_de_Servico_Peca
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Ordem_Servico_Oficina`.`Ordem_de_Servico_Peca` (
  `idOrdemServico` INT NOT NULL,
  `idPeca` INT NOT NULL,
  `Quantidade` INT NOT NULL,
  PRIMARY KEY (`idOrdemServico`, `idPeca`),
  CONSTRAINT `fk_OrdemServicoPeca_OrdemServico`
    FOREIGN KEY (`idOrdemServico`)
    REFERENCES `Ordem_Servico_Oficina`.`Ordem_de_Servico` (`idOrdemServico`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_OrdemServicoPeca_Peca`
    FOREIGN KEY (`idPeca`)
    REFERENCES `Ordem_Servico_Oficina`.`Peca` (`idPeca`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- Tabela de Pagamento
CREATE TABLE Pagamento (
    idPagamento INT AUTO_INCREMENT PRIMARY KEY,
    idOrdemServico INT NOT NULL,
    valorTotal DECIMAL(10,2) NOT NULL,
    formaPagamento ENUM('Dinheiro', 'Cartão', 'Pix', 'Boleto') NOT NULL,
    dataPagamento DATE NOT NULL,
    statusPagamento ENUM('Pendente', 'Pago', 'Cancelado') DEFAULT 'Pendente',
    FOREIGN KEY (idOrdemServico) REFERENCES OrdemServico(idOrdemServico)
);

-- Tabela de Estoque
CREATE TABLE Estoque (
    idEstoque INT AUTO_INCREMENT PRIMARY KEY,
    idPeca INT NOT NULL,
    quantidadeAtual INT NOT NULL,
    localizacao VARCHAR(100),
    FOREIGN KEY (idPeca) REFERENCES Peca(idPeca)
);

-- Tabela de Fornecedor
CREATE TABLE Fornecedor (
    idFornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nomeFornecedor VARCHAR(100) NOT NULL,
    telefone VARCHAR(15),
    email VARCHAR(100),
    endereco VARCHAR(255)
);

-- Tabela de Agenda
CREATE TABLE Agenda (
    idAgenda INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT NOT NULL,
    idVeiculo INT NOT NULL,
    dataHoraAgendamento DATETIME NOT NULL,
    statusAgendamento ENUM('Agendado', 'Concluído', 'Cancelado') DEFAULT 'Agendado',
    observacoes TEXT,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    FOREIGN KEY (idVeiculo) REFERENCES Veiculo(idVeiculo)
);

CREATE TABLE Pagamento (
    idPagamento INT AUTO_INCREMENT PRIMARY KEY,
    idOrdemServico INT NOT NULL,
    valorTotal DECIMAL(10,2) NOT NULL,
    formaPagamento ENUM('Dinheiro', 'Cartão', 'Pix', 'Boleto') NOT NULL,
    dataPagamento DATE NOT NULL,
    statusPagamento ENUM('Pendente', 'Pago', 'Cancelado') DEFAULT 'Pendente',
    CONSTRAINT fk_Pagamento_OrdemServico FOREIGN KEY (idOrdemServico)
    REFERENCES Ordem_de_Servico(idOrdemServico)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

SHOW TABLES;

-- Adicionar a coluna TipoCliente e modificar CPF para permitir CPF ou CNPJ
ALTER TABLE Cliente
ADD COLUMN TipoCliente ENUM('Fisica', 'Juridica') NOT NULL AFTER Nome,
MODIFY COLUMN CPF VARCHAR(18) NOT NULL; 

-- Remover tabelas Pessoa_Fisica e Pessoa_Juridica (se já contiverem dados, fazer backup antes)
DROP TABLE IF EXISTS Pessoa_Fisica;
DROP TABLE IF EXISTS Pessoa_Juridica;

-- Alterar nome da tabela Equipe_de_Mecanicos para Equipe_Mecanicos
RENAME TABLE Equipe_de_Mecanicos TO Equipe_Mecanicos;

-- Permitir que idEquipeMecanicos na tabela Mecanico aceite NULL
-- -- Remove a chave estrangeira duplicada para evitar conflitos
ALTER TABLE Mecanico DROP FOREIGN KEY fk_Mecanico_EquipeMecanicos;

-- -- Modifica idEquipeMecanicos para aceitar NULL
ALTER TABLE Mecanico MODIFY COLUMN idEquipeMecanicos INT NULL;

-- Recria a FK com ON DELETE SET NULL, garantindo que, se uma equipe for excluída, 
-- os mecânicos dessa equipe não sejam removidos, apenas desvinculados.
ALTER TABLE Mecanico 
ADD CONSTRAINT fk_Mecanico_EquipeMecanicos 
FOREIGN KEY (idEquipeMecanicos) 
REFERENCES Equipe_Mecanicos(idEquipeMecanicos) 
ON DELETE SET NULL ON UPDATE CASCADE;

-- Ajustar o tamanho da coluna Placa na tabela Veiculo para o padrão Mercosul
ALTER TABLE Veiculo
MODIFY COLUMN Placa VARCHAR(7) UNIQUE NOT NULL;

SHOW TABLES;

-- Garantir que quantidadeAtual em Estoque nunca seja negativa
ALTER TABLE Estoque
MODIFY COLUMN quantidadeAtual INT NOT NULL CHECK (quantidadeAtual >= 0);

-- 8. Corrigir FK na tabela Agenda para referenciar Cliente corretamente
SHOW CREATE TABLE Agenda;

ALTER TABLE Agenda DROP FOREIGN KEY agenda_ibfk_1;

ALTER TABLE Agenda DROP FOREIGN KEY agenda_ibfk_2;

ALTER TABLE Agenda 
ADD CONSTRAINT fk_Agenda_Cliente 
FOREIGN KEY (idCliente) 
REFERENCES Cliente(idCliente) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Agenda 
ADD CONSTRAINT fk_Agenda_Veiculo 
FOREIGN KEY (idVeiculo) 
REFERENCES Veiculo(idVeiculo) 
ON DELETE CASCADE ON UPDATE CASCADE;


-- Tabela Cliente
INSERT INTO Cliente (Nome, TipoCliente, Documento, Telefone, Endereco) VALUES
('João Silva', 'Fisica', '12345678901', '11999999999', 'Rua A, 123 - Centro'),
('Maria Souza', 'Fisica', '98765432109', '21888888888', 'Av. B, 456 - Copacabana'),
('Oficina do Zé', 'Juridica', '12345678000190', '31777777777', 'Rua C, 789 - Savassi'),
('Pedro Alves', 'Fisica', '45678901234', '41666666666', 'Rua D, 101 - Batel'),
('Carla Rocha', 'Fisica', '65432109876', '51555555555', 'Av. E, 222 - Moinhos de Vento'),
('Auto Peças Brasil', 'Juridica', '87654321000123', '61444444444', 'Rua F, 333 - Asa Sul'),
('Lucas Mendes', 'Fisica', '32165498700', '71333333333', 'Rua G, 444 - Pelourinho'),
('Ana Pereira', 'Fisica', '78901234567', '81222222222', 'Av. H, 555 - Boa Viagem'),
('Mecânica Rápida LTDA', 'Juridica', '54321678000189', '91111111111', 'Rua I, 666 - Centro'),
('Ricardo Oliveira', 'Fisica', '23456789012', '11988888888', 'Av. J, 777 - Vila Mariana');

-- Tabela Equipe_Mecanicos
INSERT INTO Equipe_Mecanicos (Nome) VALUES
('Equipe Alfa'),
('Equipe Beta'),
('Equipe Gama'),
('Equipe Delta'),
('Equipe Omega');

-- Tabela Mecanico
INSERT INTO Mecanico (Nome, Endereco, Especialidade, idEquipeMecanicos) VALUES
('Carlos Alberto', 'Rua K, 111 - Centro', 'Motor', 1),
('Fernanda Silva', 'Av. L, 222 - Copacabana', 'Suspensão', 2),
('Roberto Souza', 'Rua M, 333 - Savassi', 'Freios', 1),
('Patrícia Oliveira', 'Av. N, 444 - Batel', 'Elétrica', 3),
('Gustavo Rocha', 'Rua O, 555 - Moinhos de Vento', 'Câmbio', 2),
('Juliana Mendes', 'Av. P, 666 - Asa Sul', 'Injeção Eletrônica', 4),
('Ricardo Alves', 'Rua Q, 777 - Pelourinho', 'Direção Hidráulica', 3),
('Amanda Pereira', 'Av. R, 888 - Boa Viagem', 'Ar Condicionado', 5),
('Sérgio Costa', 'Rua S, 999 - Centro', 'Motor', 4),
('Camila Oliveira', 'Av. T, 1010 - Vila Mariana', 'Suspensão', 5);

-- Tabela Veiculo
INSERT INTO Veiculo (Modelo, Placa, Ano, Cliente_idCliente) VALUES
('Fiat Uno', 'ABC1234', 2010, 1),
('VW Gol', 'DEF5678', 2015, 2),
('Chevrolet Onix', 'GHI9012', 2020, 3),
('Ford Ka', 'JKL3456', 2012, 4),
('Hyundai HB20', 'MNO7890', 2018, 5),
('Toyota Corolla', 'PQR1234', 2022, 6),
('Honda Civic', 'STU5678', 2017, 7),
('Renault Sandero', 'VWX9012', 2014, 8),
('Jeep Renegade', 'YZA3456', 2021, 9),
('Nissan Kicks', 'BCD7890', 2019, 10);

-- Tabela Ordem_de_Servico
INSERT INTO Ordem_de_Servico (DataEmissao, ValorTotal, Status, DataConclusao, idVeiculo, idEquipeMecanicos) VALUES
('2024-01-10', 500.00, 'Concluída', '2024-01-15', 1, 1),
('2024-01-12', 750.00, 'Em Andamento', NULL, 2, 2),
('2024-01-15', 1200.00, 'Concluída', '2024-01-20', 3, 1),
('2024-01-18', 300.00, 'Aberta', NULL, 4, 3),
('2024-01-20', 900.00, 'Em Andamento', NULL, 5, 2),
('2024-01-22', 600.00, 'Concluída', '2024-01-25', 6, 4),
('2024-01-25', 450.00, 'Aberta', NULL, 7, 3),
('2024-01-28', 1100.00, 'Em Andamento', NULL, 8, 5),
('2024-01-30', 800.00, 'Concluída', '2024-02-02', 9, 4),
('2024-02-01', 250.00, 'Aberta', NULL, 10, 5);

-- Tabela Servico
INSERT INTO Servico (Descricao, Valor) VALUES
('Troca de óleo', 150.00),
('Alinhamento e balanceamento', 200.00),
('Troca de pneus', 400.00),
('Revisão geral', 300.00),
('Troca de freios', 250.00),
('Troca de amortecedores', 500.00),
('Conserto de motor', 800.00),
('Conserto de câmbio', 1000.00),
('Funilaria e pintura', 1500.00),
('Troca de bateria', 350.00);

-- Tabela Ordem_de_Servico_Servico
INSERT INTO Ordem_de_Servico_Servico (idOrdemServico, idServico) VALUES
(1, 1), (1, 2), (2, 3), (2, 4), (3, 5), (3, 6), (4, 1), (4, 3), (5, 2), (5, 5),
(6, 7), (6, 8), (7, 9), (7, 10), (8, 1), (8, 4), (9, 3), (9, 6), (10, 5), (10, 7);

-- Tabela Peca
INSERT INTO Peca (Nome, Valor, Quantidade) VALUES
('Filtro de óleo', 30.00, 50),
('Pastilha de freio', 80.00, 100),
('Pneu', 300.00, 20),
('Amortecedor', 200.00, 30),
('Bateria', 250.00, 15),
('Vela de ignição', 20.00, 80),
('Correia dentada', 50.00, 40),
('Filtro de ar', 25.00, 60),
('Lâmpada', 10.00, 120),
('Aditivo de radiador', 15.00, 70);

-- Tabela Ordem_de_Servico_Peca
INSERT INTO Ordem_de_Servico_Peca (idOrdemServico, idPeca, Quantidade) VALUES
(1, 1, 1), (1, 2, 2), (2, 3, 4), (2, 4, 2), (3, 5, 1), (3, 6, 4), (4, 7, 1), (4, 8, 2), (5, 9, 2), (5, 10, 1),
(6, 1, 2), (6, 3, 1), (7, 5, 1), (7, 7, 2), (8, 9, 3), (8, 2, 1), (9, 4, 2), (9, 6, 3), (10, 8, 1), (10, 10, 2);

-- Tabela Pagamento
INSERT INTO Pagamento (idOrdemServico, valorTotal, formaPagamento, dataPagamento, statusPagamento) VALUES
(1, 500.00, 'Cartão', '2024-01-15', 'Pago'),
(2, 750.00, 'Dinheiro', '2024-01-12', 'Pendente'),
(3, 1200.00, 'Pix', '2024-01-20', 'Pago'),
(4, 300.00, 'Boleto', '2024-01-18', 'Pendente'),
(5, 900.00, 'Cartão', '2024-01-20', 'Pendente'),
(6, 600.00, 'Dinheiro', '2024-01-25', 'Pago'),
(7, 450.00, 'Pix', '2024-01-25', 'Pendente'),
(8, 1100.00, 'Boleto', '2024-01-28', 'Pendente'),
(9, 800.00, 'Cartão', '2024-02-02', 'Pago'),
(10, 250.00, 'Dinheiro', '2024-02-01', 'Pendente');

-- Tabela Estoque
INSERT INTO Estoque (idPeca, quantidadeAtual, localizacao) VALUES
(1, 40, 'Prateleira A1'),
(2, 80, 'Prateleira B2'),
(3, 16, 'Prateleira C3'),
(4, 24, 'Prateleira D4'),
(5, 12, 'Prateleira E5'),
(6, 64, 'Prateleira F6'),
(7, 32, 'Prateleira G7'),
(8, 48, 'Prateleira H8'),
(9, 96, 'Prateleira I9'),
(10, 56, 'Prateleira J10');

-- Tabela Fornecedor
INSERT INTO Fornecedor (nomeFornecedor, telefone, email, endereco) VALUES
('Distribuidora Automotiva LTDA', '1122223333', 'contato@distribuidoraauto.com.br', 'Rua X, 123 - São Paulo'),
('Peças e Cia', '2133334444', 'vendas@pecascia.com', 'Av. Y, 456 - Rio de Janeiro'),
('Importadora Brasil', '3144445555', 'import@brasil.com', 'Rua Z, 789 - Belo Horizonte'),
('Auto Norte Distribuidora', '4155556666', 'auto.norte@distribuidora.com', 'Av. W, 101 - Curitiba'),
('Sul Peças Automotivas', '5166667777', 'sul.pecas@automotivas.com', 'Rua V, 222 - Porto Alegre');

-- Tabela Agenda
INSERT INTO Agenda (idCliente, idVeiculo, dataHoraAgendamento, statusAgendamento, observacoes) VALUES
(1, 1, '2024-02-10 08:00:00', 'Agendado', 'Revisão de rotina'),
(2, 2, '2024-02-12 10:00:00', 'Agendado', 'Troca de pneus'),
(3, 3, '2024-02-15 14:00:00', 'Agendado', 'Conserto do ar condicionado'),
(4, 4, '2024-02-18 16:00:00', 'Agendado', 'Alinhamento e balanceamento'),
(5, 5, '2024-02-20 09:00:00', 'Agendado', 'Troca de óleo e filtros'),
(6, 6, '2024-02-22 11:00:00', 'Agendado', 'Revisão do sistema de freios'),
(7, 7, '2024-02-25 15:00:00', 'Agendado', 'Conserto da suspensão'),
(8, 8, '2024-02-28 17:00:00', 'Agendado', 'Troca da correia dentada'),
(9, 9, '2024-03-01 08:30:00', 'Agendado', 'Revisão geral'),
(10, 10, '2024-03-03 10:30:00', 'Agendado', 'Troca da bateria');


-- Recuperação Simples com SELECT Statement
-- Recuperar todos os clientes da tabela Cliente.

SELECT idCliente, Nome, TipoCliente, Documento, Telefone, Endereco
FROM Cliente;

-- Filtros com WHERE Statement
-- Recuperar todos os veículos fabricados após o ano de 2018.

SELECT idVeiculo, Modelo, Placa, Ano, Cliente_idCliente
FROM Veiculo
WHERE Ano > 2018;

SELECT 
    idMecanico,
    Nome,
    Endereco,
    Especialidade
FROM Mecanico
WHERE Especialidade = 'Motor';

-- Expressões para Gerar Atributos Derivados e Ordenação com ORDER BY
-- Recuperar a lista de serviços com o valor acrescido de 10%, ordenado do maior para o menor valor.

SELECT idServico, Descricao, Valor, Valor * 1.1 AS ValorComAumento
FROM Servico
ORDER BY ValorComAumento DESC;

-- Junções (JOIN) entre Tabelas
-- Listar todas as ordens de serviço com o nome do cliente e o modelo do veículo associado.

SELECT 
    OS.idOrdemServico,
    C.Nome AS NomeCliente,
    V.Modelo AS ModeloVeiculo,
    OS.DataEmissao,
    OS.ValorTotal,
    OS.Status
FROM Ordem_de_Servico AS OS
JOIN Veiculo AS V ON OS.idVeiculo = V.idVeiculo
JOIN Cliente AS C ON V.Cliente_idCliente = C.idCliente;

-- Agrupamento (GROUP BY) e Filtro de Grupos com HAVING Statement
-- Encontrar as equipes de mecânicos que concluíram mais de 2 ordens de serviço.

SELECT 
    EM.Nome AS NomeEquipe,
    COUNT(OS.idOrdemServico) AS TotalOrdensConcluidas
FROM Equipe_Mecanicos AS EM
JOIN Ordem_de_Servico AS OS ON EM.idEquipeMecanicos = OS.idEquipeMecanicos
WHERE OS.Status = 'Concluída'
GROUP BY EM.idEquipeMecanicos
HAVING COUNT(OS.idOrdemServico) >= 1;


-- Junções entre tabelas para fornecer uma perspectiva mais complexa dos dados
-- Listar todos os serviços realizados em cada veículo, incluindo o nome do cliente.
SELECT 
    C.Nome AS NomeCliente,
    V.Modelo AS ModeloVeiculo,
    S.Descricao AS ServicoRealizado,
    S.Valor AS ValorServico
FROM Cliente AS C
JOIN Veiculo AS V ON C.idCliente = V.Cliente_idCliente
JOIN Ordem_de_Servico AS OS ON V.idVeiculo = OS.idVeiculo
JOIN Ordem_de_Servico_Servico AS OSS ON OS.idOrdemServico = OSS.idOrdemServico
JOIN Servico AS S ON OSS.idServico = S.idServico;

-- Listar todas as peças utilizadas em cada ordem de serviço, incluindo o nome da peça e a quantidade.
SELECT 
    OS.idOrdemServico AS NumeroOrdemServico,
    P.Nome AS NomePeca,
    OSP.Quantidade AS QuantidadeUtilizada,
    P.Valor AS ValorUnitario,
    (P.Valor * OSP.Quantidade) AS ValorTotal
FROM Ordem_de_Servico AS OS
JOIN Ordem_de_Servico_Peca AS OSP ON OS.idOrdemServico = OSP.idOrdemServico
JOIN Peca AS P ON OSP.idPeca = P.idPeca;

-- Listar os mecânicos e as equipes a que pertencem, juntamente com o número de ordens de serviço que cada equipe concluiu

SELECT 
    M.Nome AS NomeMecanico,
    EM.Nome AS NomeEquipe,
    COUNT(OS.idOrdemServico) AS TotalOrdensConcluidas
FROM Mecanico AS M
JOIN Equipe_Mecanicos AS EM ON M.idEquipeMecanicos = EM.idEquipeMecanicos
LEFT JOIN Ordem_de_Servico AS OS ON EM.idEquipeMecanicos = OS.idEquipeMecanicos AND OS.Status = 'Concluída'
GROUP BY M.idMecanico, EM.idEquipeMecanicos;

show tables;