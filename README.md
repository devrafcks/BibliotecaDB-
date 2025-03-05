# BibliotecaDB - Banco de Dados Completo para Gestão de Livros e Autores

Este projeto é um **banco de dados relacional** desenvolvido para o gerenciamento de uma biblioteca, abrangendo livros, autores, usuários e empréstimos. Utilizando **funcionalidades avançadas** do SQL, como **triggers, views, índices e procedures**, este sistema proporciona um ambiente robusto e otimizado para manipulação de dados.

## Funcionalidades

- ✅ **Gestão de Livros e Autores**
- ✅ **Cadastro de Usuários**
- ✅ **Controle de Empréstimos e Devoluções**
- ✅ **Triggers para Registro de Eventos**
- ✅ **Views para Consultas Simplificadas**
- ✅ **Stored Procedures para Consultas Rápidas**
- ✅ **Índices para Otimização de Performance**

## Estrutura do Banco de Dados

O banco de dados **BibliotecaDB** contém as seguintes tabelas:

### Tabelas Principais

- **`autores`**: Armazena informações sobre os autores.
- **`livros`**: Registra os livros disponíveis na biblioteca.
- **`usuarios`**: Contém os usuários cadastrados para empréstimos.
- **`emprestimos`**: Controla os livros emprestados e devolvidos.

### Relacionamentos

- Cada livro pertence a **um autor** (chave estrangeira `autor_id`).
- Cada usuário pode pegar **vários livros emprestados**.
- Cada empréstimo está associado a **um usuário e um livro**.

## Recursos Avançados

### Índices
Foi criado um índice na coluna `titulo` da tabela `livros` para otimizar buscas por nome de livro.

### Views
A View `LivrosDetalhados` exibe informações sobre os livros e seus respectivos autores.

### Triggers
O trigger `after_emprestimo_insert` registra cada novo empréstimo na tabela de logs.

### Stored Procedures
A procedure `LivrosPorAutor` retorna todos os livros de um autor específico.

## Como Usar

1. Crie o banco de dados e utilize o comando `USE BibliotecaDB;`
2. Execute os scripts SQL para criar tabelas, índices, triggers e procedures.
3. Insira dados de exemplo na biblioteca.
4. Use as consultas e views para acessar as informações.

## Autores Cadastrados no Banco

- **Frank Herbert** - Autor da série *Duna*
- **George Lucas** - Criador de *Star Wars*
- **Eiichiro Oda** - Criador de *One Piece*

## Objetivo do Projeto

Este banco de dados foi desenvolvido com base nos conhecimentos adquiridos durante um curso de SQL, visando praticar e implementar conceitos avançados. Ele simula um sistema real de gerenciamento de biblioteca e pode ser adaptado para aplicações reais ou utilizado como material de aprendizado.
