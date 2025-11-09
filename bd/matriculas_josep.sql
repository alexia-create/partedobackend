-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Tempo de geração: 31/10/2025 às 22:22
-- Versão do servidor: 8.3.0
-- Versão do PHP: 8.1.2-1ubuntu2.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `matriculas_josep`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `alunos`
--

CREATE TABLE `alunos` (
  `id` int NOT NULL,
  `nome_aluno` varchar(100) NOT NULL,
  `endereco` varchar(150) DEFAULT NULL,
  `data_nascimento` date DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `nome_pai` varchar(100) DEFAULT NULL,
  `nome_mae` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Despejando dados para a tabela `alunos`
--

INSERT INTO `alunos` (`id`, `nome_aluno`, `endereco`, `data_nascimento`, `telefone`, `email`, `nome_pai`, `nome_mae`) VALUES
(1, 'Ana Clara Souza', 'Rua das Flores, 101', '2009-04-12', '(11) 99991-2345', 'ana.clara@email.com', 'Carlos Souza', 'Maria Souza'),
(2, 'Bruno Almeida', 'Av. Central, 230', '2008-08-25', '(11) 98888-4521', 'bruno.almeida@email.com', 'Ricardo Almeida', 'Fernanda Almeida'),
(3, 'Camila Rodrigues', 'Rua São João, 55', '2010-02-03', '(11) 97777-9000', 'camila.rodrigues@email.com', 'José Rodrigues', 'Cláudia Rodrigues'),
(4, 'Diego Martins', 'Travessa das Oliveiras, 12', '2007-11-30', '(11) 96666-1122', 'diego.martins@email.com', 'Paulo Martins', 'Sílvia Martins'),
(5, 'Larissa Gomes', 'Rua do Sol, 88', '2008-01-18', '(11) 95555-2211', 'larissa.gomes@email.com', 'Roberto Gomes', 'Patrícia Gomes');

-- --------------------------------------------------------

--
-- Estrutura para tabela `funcionarios`
--

CREATE TABLE `funcionarios` (
  `id` int NOT NULL,
  `nome` varchar(100) NOT NULL,
  `cargo` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `senha` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Despejando dados para a tabela `funcionarios`
--

INSERT INTO `funcionarios` (`id`, `nome`, `cargo`, `email`, `senha`) VALUES
(1, 'Mariana Silva', 'Secretária', 'mariana.silva@email.com', 'senha123'),
(2, 'Fernanda Costa', 'Auxiliar de Secretaria', 'fernanda.costa@email.com', 'senha456'),
(3, 'Patrícia Oliveira', 'Secretária', 'patricia.oliveira@email.com', 'senha789'),
(4, 'Sônia Almeida', 'Diretora', 'sonia.almeida@email.com', 'senhaDiretora123');

-- --------------------------------------------------------

--
-- Estrutura para tabela `matriculas`
--

CREATE TABLE `matriculas` (
  `id` int NOT NULL,
  `alunoID` int NOT NULL,
  `turmaID` int NOT NULL,
  `data_matricula` date NOT NULL,
  `matriculado_por` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Despejando dados para a tabela `matriculas`
--

INSERT INTO `matriculas` (`id`, `alunoID`, `turmaID`, `data_matricula`, `matriculado_por`) VALUES
(1, 1, 1, '2025-02-01', 1),
(2, 2, 1, '2025-02-01', 1),
(3, 3, 2, '2025-02-02', 1),
(4, 4, 3, '2025-02-03', 1),
(5, 5, 4, '2025-02-04', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `turmas`
--

CREATE TABLE `turmas` (
  `id` int NOT NULL,
  `nome_turma` varchar(50) NOT NULL,
  `turno` enum('Manhã','Tarde','Noite') NOT NULL,
  `codigo_turma` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Despejando dados para a tabela `turmas`
--

INSERT INTO `turmas` (`id`, `nome_turma`, `turno`, `codigo_turma`) VALUES
(1, '1º Ano A', 'Manhã', 'T001'),
(2, '1º Ano B', 'Tarde', 'T002'),
(3, '2º Ano A', 'Manhã', 'T003'),
(4, '2º Ano B', 'Tarde', 'T004'),
(5, '3º Ano A', 'Noite', 'T005'),
(6, '1º Ano A', 'Manhã', 'T006');

--
-- Acionadores `turmas`
--
DELIMITER $$
CREATE TRIGGER `gerar_codigo_turma` BEFORE INSERT ON `turmas` FOR EACH ROW BEGIN
    SET NEW.codigo_turma = CONCAT('T', LPAD((SELECT IFNULL(MAX(id),0)+1 FROM turmas), 3, '0'));
END
$$
DELIMITER ;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `alunos`
--
ALTER TABLE `alunos`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `funcionarios`
--
ALTER TABLE `funcionarios`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `matriculas`
--
ALTER TABLE `matriculas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `alunoID` (`alunoID`),
  ADD KEY `turmaID` (`turmaID`);

--
-- Índices de tabela `turmas`
--
ALTER TABLE `turmas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo_turma` (`codigo_turma`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `alunos`
--
ALTER TABLE `alunos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `funcionarios`
--
ALTER TABLE `funcionarios`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `matriculas`
--
ALTER TABLE `matriculas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `turmas`
--
ALTER TABLE `turmas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `matriculas`
--
ALTER TABLE `matriculas`
  ADD CONSTRAINT `matriculas_ibfk_1` FOREIGN KEY (`alunoID`) REFERENCES `alunos` (`id`),
  ADD CONSTRAINT `matriculas_ibfk_2` FOREIGN KEY (`turmaID`) REFERENCES `turmas` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
