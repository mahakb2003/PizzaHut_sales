#Q1.Retrieve the total number of orders placed.
create database pizzahut;
use pizzahut;
create table order_details(
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key(order_details_id));
select * from pizza_types;

#Q2.Calculate the total revenue generated from pizza sales.
select * from orders;
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
             AS total_sales
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;

#Q2.Calculate the total revenue generated from pizza sales.
select * from pizzas;
select * from pizza_types;
select
 pizza_types.name ,pizzas.price from pizza_types
join
pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
order by pizzas.price desc
limit 1;

#Q3.Identify the highest-priced pizza.
 select * from pizzas;
select * from pizza_types;
select
 pizza_types.name ,pizzas.price from pizza_types
join
pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
order by pizzas.price desc
limit 1;

#Q4.Identify the most common pizza size ordered.
select pizzas.size,count(order_Details.order_details_id) as order_count
from pizzas join 
order_details
on pizzas.pizza_id=order_details.pizza_id
group by pizzas.size
order by order_count desc;

#Q5.List the top 5 most ordered pizza types along with their quantities.
 select pizza_types.name,sum(order_details.quantity)   as quantity
 from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name
order by quantity desc
limit 5;

 (Intermediate)

#Q1.Join the necessary tables to find the total quantity of each pizza category ordered.
  select pizza_types.category,
sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_Details.pizza_id=pizzas.pizza_id
group by pizza_types.category order by quantity desc;


#Q2.Determine the distribution of orders by hour of the day.
   SELECT 
    HOUR(orders.time), COUNT(order_id) AS order_count
FROM
    orders
GROUP BY HOUR(orders.time);


#Q3.Join relevant tables to find the category-wise distribution of pizzas.
select category,count(pizza_type_id) as name from pizza_types
group by category ;


#Q4.Group the orders by date and calculate the average number of pizzas ordered per day.
  use pizzahut;
WITH order_quantity AS (
    SELECT 
        orders.date, 
        SUM(order_details.quantity) AS quantity
    FROM 
        orders 
    JOIN 
        order_details ON orders.order_id = order_details.order_id 
    GROUP BY 
        orders.date
)
SELECT 
    round(AVG(quantity))
FROM 
    order_quantity;

  
#Q5.Determine the top 3 most ordered pizza types based on revenue.
  select pizza_types.name,
sum(order_details.quantity*pizzas.price) as revenue
from pizza_types join pizzas on
 pizzas.pizza_type_id=pizza_types.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name order by revenue desc limit 3;


(Advanced)
#Q1.Calculate the percentage contribution of each pizza type to total revenue.
    SELECT 
    pizza_types.category,
    (SUM(order_details.quantity * pizzas.price) / 
        (SELECT 
            ROUND(SUM(order_details.quantity * pizzas.price), 2)
         FROM 
            order_details
         JOIN 
            pizzas ON order_details.pizza_id = pizzas.pizza_id
        ) * 100) AS revenue_percentage
FROM 
    pizza_types
JOIN 
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN 
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY 
    pizza_types.category
ORDER BY 
    revenue_percentage DESC;

#Q2.Analyze the cumulative revenue generated over time.
  
  WITH sales AS (
    SELECT 
        orders.date,
        SUM(order_details.quantity * pizzas.price) AS revenue 
    FROM 
        orders
    JOIN 
        order_details ON orders.order_id = order_details.order_id
    JOIN 
        pizzas ON order_details.pizza_id = pizzas.pizza_id
    GROUP BY 
        orders.date
)
SELECT 
    date, 
    SUM(revenue) OVER (ORDER BY date) AS cum_revenue
FROM 
    sales;

  
#Q3.Determine the top 3 most ordered pizza types based on revenue for each pizza category.
  
  WITH a AS (
    SELECT 
        pizza_types.category,
        pizza_types.name,
        SUM(order_details.quantity * pizzas.price) AS revenue
    FROM 
        pizza_types
    JOIN 
        pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
    JOIN 
        order_details ON order_details.pizza_id = pizzas.pizza_id
    GROUP BY 
        pizza_types.category, pizza_types.name
),
b AS (
    SELECT 
        category,
        name,
        revenue,
        RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rn
    FROM 
        a
)

SELECT 
    name,
    revenue 
FROM 
    b 
WHERE 
    rn <= 3
ORDER BY 
    category, revenue DESC;

