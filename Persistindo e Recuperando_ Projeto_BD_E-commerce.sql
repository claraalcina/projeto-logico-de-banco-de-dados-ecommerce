-- inserção de dados e queries
use ecommerce;
show tables;
-- idClient, Fname, Minit, Lname, CPF, Address
insert into Clients (Fname, Minit, Lname, CPF, Address)
	values('Maria','M','Silva',123456789,'rua silva de prata 29, Carangola - Cidade das flores'),
		  ('Matheus','O','Pimental',987654321,'rua alameda 289, Centro - Cidade das flores'),
		  ('Ricardo','F','Silva',567894097,'avenida vinho 1009, Centro - Cidade das flores'),
		  ('Juliana','S','França',789654345,'rua laranjeiras 861, Centro - Cidade das flores'),
	      ('Roberta','G','Assis',987123564,'avenida koller 19, Centro - Cidade das flores'),
		  ('Isabela','M','Cruz',654321098,'rua das flores 28, Centro - Cidade das flores');
          
-- idProduct, Pname, classification_kids boolean, category('Eletronico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Moveis'), avaliacao, size
insert into product (Pname, classification_kids, category, avaliacao, size) values
                    ('Barbie Elsa', true, 'Brinquedos','3', null),
                    ('Body Carters', true, 'Vestimenta','5', null),
                    ('Sofá retrátil', false, 'Moveis','3', '3x57x80');
                    
DELETE FROM product WHERE category='Eletronico';
DELETE FROM product WHERE category='Alimentos';
				
insert into product (Pname, classification_kids, category, avaliacao, size) values                    
                    ('Fone de ouvido', false, 'Eletronico','4', null),
                    ('Microfone Vedo - Youtuber', false, 'Eletronico','4', null),
                    ('Farinha de arroz', false, 'Alimentos','2', null),
                    ('Fire Stick Amazon', false, 'Eletronico','3', null);
                    
select * from clients;
select * from product;
                    
-- idOrder, idOrderClient, orderStatus, orderDescription, sendValue, paymentCash
delete from orders where idOrderClient in (1,2,3,4);
insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
					(1, default, 'compra via aplicativo', null, 1),
                    (2, default, 'compra via aplicativo', 50, 0),
                    (3, 'Confirmado', null, null, 1),
                    (4, default, 'compra via web site', 150, 0);
                    
update orders set idPayment = 
	case 
    when idOrder in (5,6) then 1
    when idOrder in (7,8) then 2
    else 3
    end;

select * from orders;

-- idPOproduct, idPOorder, poQuantity, poStatus
insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) values
							(10,5,2,null),
                            (11,5,1,null),
                            (13,6,1,null);
                            
-- storageLocation, quantity
insert into productStorage (storageLocation, quantity) values
							('Rio de Janeiro',1000),
                            ('Rio de Janeiro',500),
                            ('São Paulo',10),
                            ('São Pauloo',100),
                            ('São Paulo',10),
                            ('Brasília',60);
                            
-- idLproduct, idLstorage, location 
insert into storageLocation (idLproduct, idLstorage, location) values
			(10,2,'RJ'),
            (11,6,'GO');
            
-- idSupplier, SocialName, CNPJ, contact
insert into supplier (SocialName, CNPJ, contact) values
				('Almeida e filhos',123456789123456,'21985474'),
                ('Eletronicos Silva',853456789553456,'21985484'),
                ('Eletronicos Valma',934456719123410,'21975474');
                
select * from supplier;

-- idPsSupplier, idPsProduct, quantity
insert into productSupplier (idPsSupplier, idPsProduct, quantity) values 
							(1,11,500),
                            (1,13,400),
                            (2,17,633),
                            (3,18,5),
                            (2,19,10);
                            
-- idSeller, SocialName, AbstName, CNPJ, CPF, location, contact
insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact) values
						('Tech eletronics', null, 123456789987654, null, 'Rio de Janeiro' , 2199391428),
                        ('Botique Dunga', null, null, 123456783, 'Rio de Janeiro' , 2199397898),
                        ('Kids Worlds', null, 453456789981854, null, 'São Paulo' , 11955671428);

select * from seller;

-- idPseller, idPproduct, prodQuantity
insert into productSeller(idPseller, idPproduct, prodQuantity) values
							(1,10,80),
                            (2,13,10);
                            
-- typePayment, limitAvailable
insert into payment (typePayment, limitAvailable) values
					('Boleto', null),
                    ('Cartão de crédito', 5000.00),
                    ('Cartão de débito', null),
                    ('Pix', null);
                    
                    
select * from payment;
                            
select * from productSeller;

-- Iniciando as consultas

select count(*) from clients;

select * from clients c, orders o where c.idClient = idOrderClient;

-- Nome do cliente, Número do Pedido e Status do Pedido 
select Fname, Lname, idOrder, orderStatus from clients c, orders o where c.idClient = idOrderClient;
select concat(Fname, ' ' , Lname) as Client, idOrder as Request, orderStatus as Status from clients c, orders o where c.idClient = idOrderClient;

insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
					(2, default, 'compra via aplicativo', null, 1);
                    
select count(*) from clients c, orders o 
		where c.idClient = idOrderClient
		group by IdOrder;

-- Recuperação de pedido com produto associado
select * from clients c 
	INNER JOIN orders o ON c.idClient = o.idOrderClient
	INNER JOIN productOrder p ON p.IdPOorder = o.idOrder
    group by idClient;
 
 
-- Recuperar quantos pedidos foram realizados e por quais clientes
select c.idClient, Fname, count(*) as Number_of_orders from clients c 
	INNER JOIN orders o ON c.idClient = o.idOrderClient
    group by idClient
    order by Fname;
    
    
-- HAVING Statement
-- Recuperando nome de cliente que já realizou 2 ou mais pedidos
select Fname, Number_of_orders from (
	select c.idClient, Fname, count(*) as Number_of_orders from clients c 
	INNER JOIN orders o ON c.idClient = o.idOrderClient
    group by idClient) as a
    having Number_of_orders >= 2 
    ;
    
-- INNER JOIN 3 tabelas - recuperando nome completo do cliente, Status do pedido e tipo de pagamento
-- tabela a clients = idClient, Fname, Lname
-- tabela b orders =  idOrderClient, orderStatus, idPayment
-- tabela c payment = idPayment, typePayment
select concat(a.Fname, ' ', a.Lname) as 'Complete Name', 
		b.orderStatus as 'Order Status', 
        c.typePayment as 'Type Payment'
from clients as a
inner join orders as b on a.idClient = b.idOrderClient
inner join payment as c on b.idPayment = c.idPayment;



select * from orders;
select * from clients;
select * from payment;




