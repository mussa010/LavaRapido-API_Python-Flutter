create table if not exists tb_fornecedor(
	id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cnpj VARCHAR(100) NOT NULL,
	telefone VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL,
    cep VARCHAR(100) NOT NULL,
    logradouro VARCHAR(255) NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    numero INTEGER NOT NULL,
    complemento VARCHAR(100),
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(100) NOT NULL
);


create table if not exists tb_produto(
	id SERIAL PRIMARY KEY,
    modelo VARCHAR(100) NOT NULL,
    marca VARCHAR(100) NOT NULL,
    descricao TEXT NOT NULL,
    quantidade INTEGER NOT NULL, 
    valorUnitario DECIMAL(10, 2) NOT NULL,
    idFornecedor BIGINT UNSIGNED NOT NULL,
    
    foreign key (idFornecedor) references tb_fornecedor(id)
);