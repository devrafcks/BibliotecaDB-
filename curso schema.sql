-- Apaga o banco de dados se já existir para recriar do zero
DROP DATABASE IF EXISTS BibliotecaDB;

-- Cria um novo banco de dados chamado BibliotecaDB
CREATE DATABASE BibliotecaDB;
USE BibliotecaDB;

-- Criar a tabela de usuários (clientes da biblioteca)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY, -- ID único para cada usuário
    name VARCHAR(100) NOT NULL, -- Nome do usuário
    email VARCHAR(100) UNIQUE NOT NULL, -- E-mail único
    age INT CHECK (age >= 12), -- Idade mínima de 12 anos
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Data de registro
);

-- Criar a tabela de autores (criadores dos livros)
CREATE TABLE authors (
    id INT AUTO_INCREMENT PRIMARY KEY, -- ID único do autor
    name VARCHAR(100) NOT NULL, -- Nome do autor
    country VARCHAR(50) DEFAULT 'Desconhecido' -- País de origem
);

-- Criar a tabela de livros
CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY, -- ID único do livro
    title VARCHAR(150) NOT NULL, -- Título do livro
    genre VARCHAR(50), -- Gênero literário
    author_id INT, -- Referência ao autor do livro
    stock INT NOT NULL CHECK (stock >= 0), -- Quantidade em estoque (não pode ser negativa)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Data de cadastro
    FOREIGN KEY (author_id) REFERENCES authors(id) ON DELETE SET NULL -- Se o autor for deletado, os livros dele ficarão sem autor
);

-- Criar a tabela de empréstimos
CREATE TABLE loans (
    id INT AUTO_INCREMENT PRIMARY KEY, -- ID do empréstimo
    user_id INT, -- Referência ao usuário que pegou o livro
    book_id INT, -- Referência ao livro emprestado
    loan_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Data do empréstimo
    return_date DATE, -- Data prevista para devolução
    status ENUM('Emprestado', 'Devolvido', 'Atrasado') NOT NULL DEFAULT 'Emprestado', -- Status do empréstimo
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, -- Se o usuário for deletado, os empréstimos dele também são
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE -- Se o livro for deletado, os empréstimos dele também são
);

-- Criar tabela de logs para registrar ações no sistema
CREATE TABLE logs (
    id INT AUTO_INCREMENT PRIMARY KEY, -- ID único do log
    action VARCHAR(255) NOT NULL, -- Ação registrada (exemplo: "Empréstimo realizado")
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Data do registro do log
);

-- Criar um índice para acelerar buscas por nome dos livros
CREATE INDEX idx_books_title ON books(title);

DELIMITER //

-- Criar um Trigger para registrar quando um empréstimo é realizado
CREATE TRIGGER after_loan_insert
AFTER INSERT ON loans
FOR EACH ROW
BEGIN
    INSERT INTO logs (action) VALUES (CONCAT('Novo empréstimo: Livro ', NEW.book_id, ' para usuário ', NEW.user_id));
END;
//

DELIMITER ;

-- Criar uma View para visualizar detalhes dos empréstimos
CREATE VIEW LoanDetails AS
SELECT 
    loans.id AS loan_id,
    users.name AS user_name,
    books.title AS book_title,
    loans.loan_date,
    loans.return_date,
    loans.status
FROM loans
JOIN users ON loans.user_id = users.id
JOIN books ON loans.book_id = books.id;

-- Criar uma Stored Procedure para buscar empréstimos de um usuário específico
DELIMITER //

CREATE PROCEDURE GetUserLoans(IN userId INT)
BEGIN
    SELECT * FROM loans WHERE user_id = userId;
END;
//

DELIMITER ;

-- Inserindo autores famosos
INSERT INTO authors (name, country) VALUES
('Frank Herbert', 'Estados Unidos'), -- Autor de Duna
('George Lucas', 'Estados Unidos'), -- Criador de Star Wars
('Eiichiro Oda', 'Japão'); -- Criador de One Piece

-- Inserindo livros
INSERT INTO books (title, genre, author_id, stock) VALUES
('Duna', 'Ficção Científica', 1, 5),
('Star Wars: Herdeiro do Império', 'Ficção Científica', 2, 3),
('One Piece Vol. 1', 'Mangá', 3, 10);

-- Inserindo usuários
INSERT INTO users (name, email, age) VALUES
('Alice', 'alice@email.com', 20),
('Bruno', 'bruno@email.com', 25),
('Carla', 'carla@email.com', 17);  -- Restrição de idade mínima não permitirá isso

-- Inserindo empréstimos de livros para usuários
INSERT INTO loans (user_id, book_id, return_date, status) VALUES
(1, 1, '2025-03-15', 'Emprestado'), -- Alice pegou "Duna"
(2, 2, '2025-03-10', 'Devolvido'); -- Bruno pegou "Star Wars: Herdeiro do Império" e já devolveu

-- Testando uma consulta com JOIN para ver quais usuários pegaram quais livros
SELECT users.name, books.title, loans.loan_date, loans.status
FROM loans
JOIN users ON loans.user_id = users.id
JOIN books ON loans.book_id = books.id;

-- Testando o uso da View criada
SELECT * FROM LoanDetails;

-- Testando o uso da Procedure para buscar empréstimos de um usuário específico
CALL GetUserLoans(1);
