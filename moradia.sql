-- 1. Cria o banco caso não exista e o seleciona
CREATE DATABASE IF NOT EXISTS catalogo_db
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE catalogo_db;

-- 2. Tabela de tipos de usuário (estritamente 'adm' e 'vendedor')
CREATE TABLE IF NOT EXISTS Tipo_Usuario (
    ID_Tipo_Usuario INT AUTO_INCREMENT PRIMARY KEY,
    Nome_Tipo VARCHAR(20) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Popula os 2 tipos obrigatórios
INSERT IGNORE INTO Tipo_Usuario (ID_Tipo_Usuario, Nome_Tipo) VALUES
    (1, 'adm'),
    (2, 'vendedor');

-- 3. Tabela de dados pessoais e acesso (ADM e Vendedor)
CREATE TABLE IF NOT EXISTS Usuario (
    ID_Usuario INT AUTO_INCREMENT PRIMARY KEY,
    ID_Tipo_Usuario INT NOT NULL,
    Nome VARCHAR(120) NOT NULL,
    CPF CHAR(11) NOT NULL UNIQUE,
    Email VARCHAR(120) NOT NULL UNIQUE,
    Senha_Hash VARCHAR(255) NOT NULL,
    Telefone VARCHAR(20) NOT NULL,
    CEP CHAR(8),
    Logradouro VARCHAR(150),
    Numero VARCHAR(15),
    Complemento VARCHAR(60),
    Bairro VARCHAR(80),
    Cidade VARCHAR(80),
    Estado CHAR(2),
    Data_Cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuario_tipo
        FOREIGN KEY (ID_Tipo_Usuario) REFERENCES Tipo_Usuario(ID_Tipo_Usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 4. Tabela principal de Alojamentos (endereço omitido por ser padrão: Vila Universitária do Fundão)
CREATE TABLE IF NOT EXISTS Alojamento (
    ID_Alojamento INT AUTO_INCREMENT PRIMARY KEY,
    ID_Usuario INT NOT NULL,
    Nome_Alojamento VARCHAR(120) NOT NULL,
    N_Quartos TINYINT UNSIGNED NOT NULL DEFAULT 1,
    N_Cozinhas TINYINT UNSIGNED NOT NULL DEFAULT 1,
    N_Banheiros TINYINT UNSIGNED NOT NULL DEFAULT 1,
    Valor DECIMAL(10, 2) NOT NULL,
    Data_Criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_alojamento_usuario
        FOREIGN KEY (ID_Usuario) REFERENCES Usuario(ID_Usuario)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- 5. Tabela de Fotos (1 alojamento possui N fotos)
CREATE TABLE IF NOT EXISTS Foto_Alojamento (
    ID_Foto INT AUTO_INCREMENT PRIMARY KEY,
    ID_Alojamento INT NOT NULL,
    Link_Foto VARCHAR(255) NOT NULL, -- Ex: '/uploads/alojamento_5/foto_01.jpg'
    Eh_Capa BOOLEAN NOT NULL DEFAULT FALSE,
    Ordem TINYINT UNSIGNED NOT NULL DEFAULT 1,
    CONSTRAINT fk_foto_alojamento
        FOREIGN KEY (ID_Alojamento) REFERENCES Alojamento(ID_Alojamento)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- 6. Tabela de Avaliações públicas (sem FK de usuário, pois o cliente não faz login)
CREATE TABLE IF NOT EXISTS Avaliacao (
    ID_Avaliacao INT AUTO_INCREMENT PRIMARY KEY,
    ID_Alojamento INT NOT NULL,
    Nome_Cliente VARCHAR(80) DEFAULT 'Visitante',
    Nota TINYINT UNSIGNED NOT NULL,
    Comentario TEXT,
    Data_Avaliacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_avaliacao_nota CHECK (Nota BETWEEN 1 AND 5),
    CONSTRAINT fk_avaliacao_alojamento
        FOREIGN KEY (ID_Alojamento) REFERENCES Alojamento(ID_Alojamento)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;
