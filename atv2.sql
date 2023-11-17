Create database atividade;

-- 1-Crie um trigger que, ao inserir um novo empréstimo na tabela "emprestimos", atualize automaticamente a quantidade de estoque do livro correspondente na tabela "livros", subtraindo 1.

create table atividade.Livros(
ID int auto_increment primary key,
titulo varchar(255), 
autor varchar(255), 
quantidade_estoque int
);

insert into atividade.Livros(titulo,autor,quantidade_estoque)
values("Turma","Monet",4);

create table atividade.Emprestimos(
ID int auto_increment primary key,
id_livro int, 
data_emprestimo date, 
data_devolucao date,
foreign key (id_livro) references atividade.Livros(ID)
);


insert into atividade.Emprestimos(id_livro,data_emprestimo,data_devolucao)
values(1,"2023-02-10","2023-11-25");

SELECT * FROM atividade.Livros;

DELIMITER //
CREATE TRIGGER atividade.atualizar_estoque_apos_emprestimo
AFTER INSERT ON atividade.Emprestimos
FOR EACH ROW
BEGIN
    UPDATE atividade.Livros
    SET quantidade_estoque = quantidade_estoque - 1
    WHERE ID = NEW.id_livro;
END;
//
DELIMITER ;

drop database atividade;

-- 2.Crie um trigger que, ao inserir uma nova transação na tabela "transacoes", atualize automaticamente o saldo da conta correspondente na tabela "contas". Se o tipo da transação for "entrada", adicione o valor ao saldo. Se o tipo for "saída", subtraia o valor do saldo.

create table atividade.Contas(
ID int auto_increment primary key,
nome varchar(255),
saldo decimal(10.2)
);

insert into atividade.Contas(nome,saldo)
values("Matheus",1000);
insert into atividade.Contas(nome,saldo)
values("Marcio",700);
insert into atividade.Contas(nome,saldo)
values("Lima",800);

create table atividade.Transacoes(
ID int auto_increment primary key,
id_conta int, 
tipo varchar(255), 
valor decimal(10.2),
foreign key (id_conta) references atividade.Contas(ID)
);

insert into atividade.Transacoes(id_conta,tipo,valor)
values(1,"Entrada",1000);
insert into atividade.Transacoes(id_conta,tipo,valor)
values(2,"Saída",10.00);
insert into atividade.Transacoes(id_conta,tipo,valor)
values(3,"Saída",100.00);

select * from atividade.Contas;

DELIMITER //
CREATE TRIGGER atividade.atualizar_estoque_apos_emprestimo
AFTER INSERT ON atividade.Transacoes
FOR EACH ROW
BEGIN
    IF New.tipo="Entrada" THEN
    UPDATE atividade.Contas
    SET saldo = saldo + new.valor
    WHERE ID = NEW.id_conta;
    ELSE
    UPDATE atividade.Contas
    SET saldo = saldo - new.valor
    WHERE  ID = NEW.id_conta;
    END IF;
END;
//
DELIMITER ;

drop database atividade;

Create database atividade;


-- Exercício 3 Em um sistema de recursos humanos, crie um trigger que, ao inserir um novo funcionário na tabela "funcionarios", verifique se a data de admissão é maior que a data atual. Caso contrário, o trigger deve exibir uma mensagem de erro informando que a data de admissão deve ser maior que a data atual.

Create table atividade.Funcionarios(
ID int primary key auto_increment,
nome varchar(255),
data_admissao date
);

insert into atividade.Funcionarios(nome,data_admissao)
values("Matheus","2024-02-04");

insert into atividade.Funcionarios(nome,data_admissao)
values("Lica","2023-02-04");



DELIMITER //
CREATE TRIGGER atividade.verificar_data
BEFORE INSERT ON atividade.Funcionarios
FOR EACH ROW
BEGIN
    IF New.data_admissao >"2023-11-14" THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROOO,A DATA DE ADMISSÃO TEM QUE SER MAIOR QUE A DATA ATUAL';
    END IF;
END;
//
DELIMITER ;

drop table atividade.Funcionarios;

-- 4 Crie um trigger que, ao inserir um novo item de venda na tabela "itens_venda", verifique se a quantidade em estoque do produto correspondente é suficiente para a venda. Se não for, retorne um erro informando que o produto está fora de estoque.

Create table atividade.Produtos(
ID int primary key auto_increment,
nome varchar(255),
quantidade_estoque int
);

insert into atividade.Produtos(nome,quantidade_estoque)
values("Camisa",1);

Create table atividade.Vendas(
ID int primary key auto_increment,
data_venda date
);

insert into atividade.Vendas(data_venda)
values("2022-06-10");

create table atividade.Itens_venda(
ID int primary key auto_increment,
ID_Venda int,
ID_Produto int,
Quantidade int,
foreign key (ID_venda) references atividade.Vendas(ID),
foreign key (ID_Produto) references atividade.Produtos(ID)
);

insert into atividade.Itens_venda(ID_Venda,ID_Produto,Quantidade)
values(1,1,3);

DELIMITER //

CREATE TRIGGER atividade.verificar_estoque
BEFORE INSERT ON atividade.Itens_venda
FOR EACH ROW
BEGIN
  IF (
        SELECT quantidade_estoque
        FROM produtos
        WHERE ID = NEW.id_produto
    ) < NEW.quantidade THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: Quantidade em estoque insuficiente para o produto.';
    END IF;
END;
//
DELIMITER ;


-- 5 Crie um trigger que, ao inserir uma nova matrícula na tabela "matriculas", verifique se o aluno correspondente possui idade suficiente para a série em que está sendo matriculado. Se não tiver, retorne um erro informando que o aluno não atende aos requisitos de idade para a série.

Create table atividade.Aluno(
ID int primary key auto_increment, 
Nome varchar(255), 
Data_nascimento date, 
Serie int
);

insert into atividade.Aluno(Nome,Data_nascimento,Serie)
values("Lucas","2002-10-02",1);

Create table atividade.Matriculas(
ID int primary key auto_increment,
ID_Aluno int,
Data_matricula date,
Status varchar(255),
foreign key (ID_Aluno) references atividade.Aluno(ID)
);

insert into atividade.Matriculas(ID_Aluno,Data_matricula,Status)
values(1,"2023-10-02","Matricula");


drop table atividade.Matriculas;

drop database atividade;

create database atividade;


DELIMITER //

Create trigger atividade.verificador_idade2
BEFORE INSERT ON atividade.Matriculas
FOR each row
begin
IF(SELECT Serie from atividade.Aluno where ID = new.ID_Aluno) = 1 and (SELECT Data_nascimento from atividade.Aluno where ID = new.ID_Aluno) < "2017-01-01" OR (SELECT Data_nascimento from atividade.Aluno where ID = new.ID_Aluno)  > "2019-12-31"
THEN
SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT = "REQUISITO NAO ACEITO";

ELSE IF(SELECT Serie from atividade.Aluno where ID = new.ID_Aluno) = 2 and (SELECT Data_nascimento from atividade.Aluno where ID = new.ID_Aluno) < "2016-01-01" OR (SELECT Data_nascimento from atividade.Aluno where ID = new.ID_Aluno)  > "2018-12-31"
THEN
SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT = "REQUISITO NAO ACEITO";

ELSE IF(SELECT Serie from atividade.Aluno where ID = new.ID_Aluno) = 3 and (SELECT Data_nascimento from atividade.Aluno where ID = new.ID_Aluno) < "2015-01-01" OR (SELECT Data_nascimento from atividade.Aluno where ID = new.ID_Aluno)  > "2017-12-31"
THEN
SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT = "REQUISITO NAO ACEITO";

ELSE IF(SELECT Serie from atividade.Aluno where ID = new.ID_Aluno) = 4 and (SELECT Data_nascimento from atividade.Aluno where ID = new.ID_Aluno) < "2014-01-01" OR (SELECT Data_nascimento from atividade.Aluno where ID = new.ID_Aluno)  > "2016-12-31"
THEN
SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT = "REQUISITO NAO ACEITO";

ELSE IF(SELECT Serie from atividade.Aluno where ID = new.ID_Aluno) = 5 and (SELECT Data_nascimento from atividade.Aluno where ID = new.ID_Aluno) < "2013-01-01" OR (SELECT Data_nascimento from atividade.Aluno where ID = new.ID_Aluno)  > "2015-12-31"
THEN
SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT = "REQUISITO NAO ACEITO";

ELSE IF(SELECT Serie from atividade.Aluno where ID = new.ID_Aluno) = 6 and (SELECT Data_nascimento from atividade.Aluno where ID = new.ID_Aluno) < "2012-01-01" OR (SELECT Data_nascimento from atividade.Aluno where ID = new.ID_Aluno)  > "2014-12-31"
THEN
SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT = "REQUISITO NAO ACEITO";

ELSE IF(SELECT Serie from atividade.Aluno where ID = new.ID_Aluno) = 7 and (SELECT Data_nascimento from atividade.Aluno where ID = new.ID_Aluno) < "2011-01-01" OR (SELECT Data_nascimento from atividade.Aluno where ID = new.ID_Aluno)  > "2013-12-31"
THEN
SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT = "REQUISITO NAO ACEITO";

ELSE IF(SELECT Serie from atividade.Aluno where ID = new.ID_Aluno) = 8 and (SELECT Data_nascimento from atividade.Aluno where ID = new.ID_Aluno) < "2010-01-01" OR (SELECT Data_nascimento from atividade.Aluno where ID = new.ID_Aluno)  > "2012-12-31"
THEN
SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT = "REQUISITO NAO ACEITO";

ELSE IF(SELECT Serie from atividade.Aluno where ID = new.ID_Aluno) = 9 and (SELECT Data_nascimento from atividade.Aluno where ID = new.ID_Aluno) < "2009-01-01" OR (SELECT Data_nascimento from atividade.Aluno where ID = new.ID_Aluno)  > "2011-12-31"
THEN
SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT = "REQUISITO NAO ACEITO";

END IF;
END IF;
END IF;
END IF;
END IF;
END IF;
END IF;
END IF;
END IF;
END;


//
DELIMITER ;