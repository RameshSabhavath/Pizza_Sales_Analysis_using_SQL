


# ==>>> Retrieve the total number of orders placed

Select Count(order_id) as Total_Orders From orders;

# ==>>> Calculate the total revenue generated from pizza sales

SELECT SUM(order_details.quantity * pizzas.price) AS Total_Sales
FROM order_details INNER JOIN pizzas
ON pizzas.pizza_id=order_details.pizza_id;

# ==>>> Identify the highest-priced pizza

Select pizza_types.name, pizzas.price
FROM pizza_types INNER JOIN pizzas 
ON pizzas.pizza_type_id=pizza_types.pizza_type_id
ORDER BY pizzas.price DESC LIMIT 2;


# ==>>> Identify the most common pizza size ordered.

Select pizzas.size, count(order_details.order_details_id) AS Total_quantity
From pizzas Inner join order_details
ON order_details.pizza_id= pizzas.pizza_id
Group by pizzas.size
ORDER BY Total_quantity DESC;


# ==>>> List the top 5 most ordered pizza types along with their quantities

Select pizza_types.name, Count(order_details.quantity) as total_quantity
FROM pizza_types INNER JOIN pizzas
ON pizzas.pizza_type_id=pizza_types.pizza_type_id
INNER JOIN order_details
ON order_details.pizza_id=pizzas.pizza_id
Group by pizza_types.name
ORDER BY total_quantity desc LIMIT 5;	

# ==>>> Join the necessary tables to find the total quantity of each pizza category ordered.

Select pizza_types.category, Count(order_details.quantity) as Total_Quantity
FROM pizza_types INNER JOIN pizzas
ON pizzas.pizza_type_id=pizza_types.pizza_type_id
Inner Join order_details
ON order_details.pizza_id=pizzas.pizza_id
Group by pizza_types.category;


# ==>>> Determine the distribution of orders by hour of the day.

SELECT HOUR(time) AS Hour, COUNT(order_id) AS Total_orders
FROM `order`
GROUP BY HOUR(time)
ORDER BY Hour ASC;


# ==>>> Join relevant tables to find the category-wise distribution of pizzas.


Select category, count(name) as Total_pizzas from pizza_types
group by category;


# ==>> Group the orders by date and calculate the average number of pizzas ordered per day.


select avg(quantity) AS Average_number from
(select orders.date,sum(order_details.quantity) as quantity
from orders inner join order_details 
on order_details.order_id=orders.order_id 
group by orders.date) as  order_quantity;


# ==>>> Determine the top 3 most ordered pizza types based on revenue.

Select pizza_types.name, SUM(order_details.quantity *pizzas.price) as revenue
from pizza_types INNER JOIN pizzas
ON pizzas.pizza_type_id=pizza_types.pizza_type_id INNER JOIN order_details
ON order_details.pizza_id=pizzas.pizza_id
Group by pizza_types.name ORDER BY revenue DESC LIMIT 3;


# ==>>> Calculate the percentage contribution of each pizza type to total revenue.

Select pizza_types.category, (SUM(order_details.quantity  * pizzas.price) / (Select 
SUM(order_details.quantity * pizzas.price) AS Total_Sales
FROM order_details INNER JOIN pizzas
ON pizzas.pizza_id=order_details.pizza_id) ) * 100  AS revenue_percentage
from pizza_types INNER JOIN pizzas
ON pizzas.pizza_type_id=pizza_types.pizza_type_id INNER JOIN order_details
ON order_details.pizza_id=pizzas.pizza_id
Group by pizza_types.category order by revenue_percentage desc;


# ==>>> Analyze the cumulative revenue generated over time.


SELECT Date,
       SUM(revenue) OVER (ORDER BY date) AS cum_revenue
FROM (
    SELECT orders.date,
           SUM(order_details.quantity * pizzas.price) AS revenue
    FROM order_details
   INNER JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
    INNER JOIN orders ON orders.order_id = order_details.order_id
    GROUP BY orders.date
) AS sales;


# ==>>> Determine the top 3 most ordered pizza types based on revenue for each pizza category.

With A AS
(Select pizza_types.category, pizza_types.name,
SUM(order_details.quantity * pizzas.price) AS revenue 
from pizza_types inner join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id 
inner join order_details 
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category, pizza_types.name)

Select Name, revenue from
(select category, name, revenue, rank() over(partition by category order by revenue desc) as rn 
from A) AS B 
where rn<=3 Order By rn Desc LIMIT 3;


-----------
Select Name, revenue from
(select category, name, revenue, rank() over(partition by category order by revenue desc) as rn 
from 
(Select pizza_types.category, pizza_types.name,
SUM(order_details.quantity*pizzas.price) AS revenue 
from pizza_types inner join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id 
inner join order_details 
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as A)as b
where rn<=3 LIMIT 3;










