create database Meteor;

use Meteor;
DROP TABLE peca;

create table peca (
	id_peca INT,
	descricao VARCHAR(6),
	material VARCHAR(12),
	weight DECIMAL(5,2),
	dimensao VARCHAR(11),
    PRIMARY KEY(id_peca)
);	
drop table maquinas;
create table maquinas (
	id_maquina INT,
	nome_maquina VARCHAR(18),
	descricao VARCHAR(32),
	capacidade_max DECIMAL(7,2),
	ultima_manu varchar(20),
    PRIMARY KEY(id_maquina)
);
drop table ordens_prod;

create table ordens_prod (
	id_ordem INT,
	id_peca INT,
	descricao VARCHAR(25),
	quantidade INT,
	data_inicio varchar(15),
	data_termino varchar(15),
	status VARCHAR(10),
    PRIMARY KEY(id_ordem),
    FOREIGN KEY(id_peca) REFERENCES peca(id_peca)
);

create table operadores (
	id_operador INT,
	nome VARCHAR(100),
	especializacao VARCHAR(21),
	disponibilidade VARCHAR(12),
	historico_prod VARCHAR(11),
    PRIMARY KEY(id_operador)
);
drop table equipamentos;
create table equipamentos (
	id_equipamento INT,
	nome_equipamento VARCHAR(6),
	descrição VARCHAR(10),
	data_acsicao VARCHAR(20),
	vida_util DECIMAL(4,2),
    PRIMARY KEY(id_equipamento)
);

drop table manu_programada;
create table manu_programada (
	id_manutencao INT,
	fk_equipamento INT,
	descrição VARCHAR(10),
	data_programda VARCHAR(20),
	resp_manu VARCHAR(6),
    status varchar(11),
    primary key(id_manutencao),
    foreign key(fk_equipamento) references equipamentos(id_equipamento)
);
drop table historico_manu;
create table historico_manu (
	id_manutencao INT,
	fk_equipamento INT,
	tipo_de_manu VARCHAR(10),
	data_da_manu VARCHAR(20),
	custo_manutencao DECIMAL(6,2),
	status VARCHAR(11),
    primary key(id_manutencao),
    foreign key(fk_equipamento) references equipamentos(id_equipamento)
);
DROP TABLE inspecao;
create table inspecao (
	id_inspecao INT,
	fk_peca INT,
	data_inspecao VARCHAR(20),
	resultado_inspe VARCHAR(10),
	observacao VARCHAR(26),
    primary key(id_inspecao),
    foreign key(fk_peca) references peca(id_peca)
);
DROP TABLE rejeicoes;
create table rejeicoes (
	id_rejeicao INT,
	fk_peca INT,
	motivo_rejeicao VARCHAR(30),
	data_rejeicao VARCHAR(20),
	acoes_corretiva VARCHAR(12),
    primary key(id_rejeicao),
    foreign key(fk_peca) references peca(id_peca)
);

create table aceitacao (
	id_aceitacao INT,
	fk_peca_aceita INT,
	data_aceitacao VARCHAR(20),
	destino_peca VARCHAR(19),
	observacao VARCHAR(30),
    primary key(id_aceitacao),
    foreign key(fk_peca_aceita) references peca(id_peca)
    );
    drop table aceitacao;
    create table materia_prima (
	id_materia INT,
	descricao VARCHAR(8),
	fornecedor VARCHAR(18),
	quantidade INT,
	data_compra VARCHAR(15),
    primary key(id_materia)
);

create table fornecedor (
	id_fornecedor INT,
	nome_fornecedor VARCHAR(18),
	endereço VARCHAR(14),
	contato INT,
	avaliacao DECIMAL(2,1),
    primary key(id_fornecedor)
);