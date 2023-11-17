Create database atv;
drop database atv;
-- 1 Crie uma view chamada "relatorio_pedidos_cliente" que exiba o nome do cliente, o número de pedidos realizados por ele e o valor total gasto em pedidos.

create table atv.Clientes(
ID int primary key auto_increment, 
nome varchar(255), 
email varchar(255), 
telefone varchar(255)
);

insert into atv.Clientes(nome,email,telefone)
values("Marcio","marcio@gmail.com","(11) 11111-1111");
insert into atv.Clientes(nome,email,telefone)
values("Matheus","matheus@gmail.com","(15) 11555-1111");

create table atv.Pedidos(
ID int primary key auto_increment, 
ID_cliente int, 
data_pedido date,
valor_total float,
foreign key (ID_cliente) references atv.Clientes(ID)
);

insert into atv.Pedidos(ID_cliente,data_pedido,valor_total)
values(1,"2022-02-22",22);
insert into atv.Pedidos(ID_cliente,data_pedido,valor_total)
values(2,"2023-02-22",23);



create view atv.relatorio_pedidos_cliente as
select C.nome as "Nome",
count(P.ID) as "Quantidade de Pedidos",
P.valor_total as "Valor total"
From atv.Clientes C
inner join atv.Pedidos P on C.ID = P.ID_Cliente;


drop database atv;

select * from atv.relatorio_pedidos_cliente;


-- 2 Crie uma view chamada "estoque_critico" que exiba o nome e a quantidade em estoque dos produtos que possuem quantidade abaixo de um determinado limite estabelecido pela empresa.    

create table atv.Produtos(
ID int primary key auto_increment, 
nome varchar (255), 
preco_unitario decimal(10.2), 
categoria varchar(255)
);

insert into atv.Produtos(nome,preco_unitario,categoria)
values("Desodorante",2.00,"Higiene");
insert into atv.Produtos(nome,preco_unitario,categoria)
values("lapis",2.00,"escritorio");
insert into atv.Produtos(nome,preco_unitario,categoria)
values("Sabão",10.00,"Higiene");

create table atv.Estoque(
ID int auto_increment primary key,
ID_Produto int, 
quantidade int,
foreign key (ID_Produto) references atv.Produtos(ID)
);

insert into atv.Estoque(ID_Produto,quantidade)
values(1,6);

insert into atv.Estoque(ID_Produto,quantidade)
values(2,11);
insert into atv.Estoque(ID_Produto,quantidade)
values(3,10);


create view atv.estoque_critico as
select P.nome as "Nome",
E.quantidade as "Quantidade"
from atv.Produtos P
inner join atv.Estoque E
on P.ID = E.ID_Produto
where Quantidade < 10;

select * from  atv.estoque_critico;


-- 3 Crie uma view chamada "relatorio_vendas_funcionario" que exiba o nome do funcionário, o número de vendas realizadas por ele e o valor total das vendas.

create table atv.funcionarios(
ID int primary key auto_increment,
nome varchar(255),
cargo varchar(255),
salario decimal(10.2)
);

insert into atv.funcionarios(nome,cargo,salario)
values("Macita","Empregado",1.00);

insert into atv.funcionarios(nome,cargo,salario)
values("Matheus","Chefe",111.00);


create table atv.vendas(
ID int primary key auto_increment,
ID_Funcionario int,
data_venda date,
valor_venda decimal(10.2)
);

insert into atv.vendas(ID_Funcionario,data_venda,valor_venda)
values(1,"2022-10-02",2000);

insert into atv.vendas(ID_Funcionario,data_venda,valor_venda)
values(2,"2023-08-11",1000);

select * from atv.funcionarios;

create view atv.relatorio_vendas_funcionario as
select F.nome as "Nome do Funcionário",
count(V.ID) as "Número de Vendas",
Sum(V.valor_venda) as "Valor Total das Vendas"
from atv.funcionarios F 
left join atv.vendas V
on F.ID = V.ID_Funcionario
group by F.nome;


select * from atv.relatorio_vendas_funcionario;

create database atv;
drop database atv;

-- 4  Crie uma view chamada "relatorio_produtos_categoria" que exiba o nome da categoria e a quantidade de produtos pertencentes a cada categoria.

create table atv.categorias(
ID int primary key auto_increment,
Nome varchar(255),
descricao text
);

insert into atv.categorias(Nome,descricao)
values("Sapatos","Verdes");
insert into atv.categorias(Nome,descricao)
values("Blusas","Brancas");


create table atv.produtos_2(
ID int primary key auto_increment, 
nome varchar (255), 
preco_unitario decimal(10.2), 
ID_Categoria int,
foreign key (ID_Categoria) references atv.categorias(ID)
);

insert into atv.produtos_2(nome,preco_unitario,ID_Categoria)
values("Nike",1200,2);
insert into atv.produtos_2(nome,preco_unitario,ID_Categoria)
values("Adidas",112.00,1);



create view atv.relatorio_produtos_categoria as
select C.nome as "Nome",
count(P.ID) as "Quantidade de Produtos"
from atv.categorias C
left join atv.produtos_2 P
on C.ID = P.ID_Categoria
group by C.nome;


select * from atv.relatorio_produtos_categoria;


-- 5 Crie uma view chamada "relatorio_pagamentos_cidade" que exiba o nome da cidade e o valor total de pagamentos realizados por clientes dessa cidade.

create table atv.Clientes_2(
ID int primary key auto_increment, 
nome varchar(255), 
endereco varchar(255), 
cidade varchar(255)
);

insert into atv.Clientes_2(nome,endereco,cidade)
values("Matheus","Rua 1","Salvador");

insert into atv.Clientes_2(nome,endereco,cidade)
values("Macita","Rua 2","São Paulo");


create table atv.Pagamento(
ID int primary key auto_increment,
ID_Cliente int,
data_pagamento date,
valor_pagamento float,
foreign key (ID_Cliente) references atv.Clientes_2(ID)
);

insert into atv.Pagamento(ID_Cliente,data_pagamento,valor_pagamento)
values(1,"2022-10-22",1000);

insert into atv.Pagamento(ID_Cliente,data_pagamento,valor_pagamento)
values(2,"2022-08-10",3000);



create view atv.relatorio_pagamentos_cidade as
select C.nome as "Nome do Cliente",
C.cidade as "Cidade do Cliente",
sum(P.valor_pagamento) as "Valor total de pagamentos"
from atv.Clientes_2 C
inner join atv.Pagamento P
on C.ID = P.ID_Cliente
group by C.nome;

select * from atv.relatorio_pagamentos_cidade;