
# Projeto Lógico de Banco de Dados

Projeto realizado durante o Bootcamp Database Experience da Digital Innovation One (DIO).

## Objetivos


- Replicar a modelagem do projeto lógico de banco de dados para o cenário de e-commerce;
- Recuperações simples com SELECT Statement;
- Filtros com WHERE Statement;
- Criar expressões para gerar atributos derivados;
- Definir ordenações dos dados com ORDER BY;
- Condições de filtros aos grupos – HAVING Statement;
- Criar junções entre tabelas para fornecer uma perspectiva mais complexa dos dados;


### Consultas elaboradas

#### Nome do cliente, Número do Pedido e Status do Pedido 
```sql
select Fname, Lname, idOrder, orderStatus from clients c, orders o where c.idClient = idOrderClient;
select concat(Fname, ' ' , Lname) as Client, idOrder as Request, orderStatus as Status from clients c, orders o where c.idClient = idOrderClient;
```

#### Recuperação de pedido com produto associado (group by)
```sql
select * from clients c 
	INNER JOIN orders o ON c.idClient = o.idOrderClient
	INNER JOIN productOrder p ON p.IdPOorder = o.idOrder
    group by idClient;
```

#### Recuperar quantos pedidos foram realizados e por quais clientes (group by, order by)
```sql
select c.idClient, Fname, count(*) as Number_of_orders from clients c 
	INNER JOIN orders o ON c.idClient = o.idOrderClient
    group by idClient
    order by Fname;
```

#### Recuperando nome de cliente que já realizou 2 ou mais pedidos (having, nasted query)
```sql
select Fname, Number_of_orders from (
	select c.idClient, Fname, count(*) as Number_of_orders from clients c 
	INNER JOIN orders o ON c.idClient = o.idOrderClient
    group by idClient) as a
    having Number_of_orders >= 2 
    ;
```

#### Recuperando nome completo do cliente, Status do pedido e tipo de pagamento (INNER JOIN 3 tabelas)
```sql
select concat(a.Fname, ' ', a.Lname) as 'Complete Name', 
		b.orderStatus as 'Order Status', 
        c.typePayment as 'Type Payment'
from clients as a
inner join orders as b on a.idClient = b.idOrderClient
inner join payment as c on b.idPayment = c.idPayment;
```
