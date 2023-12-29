-- When Is the Peak Season of Our E-Commerce?
SELECT Dates.Season, COUNT(DISTINCT OrderItems.OrderID) 'Total Orders'
FROM Dates 
JOIN OrderItems
ON Dates.DateKey = OrderItems.OrderDateKey
GROUP BY Dates.Season
ORDER BY 'Total Orders' DESC;


-- When Is the Peak Month of Our E-Commerce?
SELECT Dates.[Month Name], COUNT(DISTINCT OrderItems.OrderID) 'Total Orders'
FROM Dates
JOIN OrderItems
ON Dates.DateKey = OrderItems.OrderDateKey
GROUP BY Dates.[Month Name]
ORDER BY 'Total Orders' DESC;


-- What Time Users Are Most Likely Making An Order Or Using The E-Commerce App?
SELECT Times.TimeOfDay 'Time Of Day', COUNT(DISTINCT .OrderItems.OrderID) 'Total Orders'
FROM Times 
JOIN OrderItems
ON Times.TimeKey = OrderItems.OrderTimeKey
GROUP BY Times.TimeOfDay
ORDER BY 'Total Orders' DESC;


-- What Hours Users Are Most Likely Making An Order Or Using The E-Commerce App?
SELECT Times.Hour, Times.[AM/PM], COUNT(DISTINCT .OrderItems.OrderID) 'Total Orders'
FROM Times 
JOIN OrderItems
ON Times.TimeKey = OrderItems.OrderTimeKey
GROUP BY Times.Hour, Times.[AM/PM]
ORDER BY 'Total Orders' DESC;


-- What Is The Preferred Way To Pay In The E-Commerce?
SELECT Payments.PaymentType 'Payment Type', COUNT(Payments.PaymentType) 'Total Orders'
FROM Payments
GROUP BY Payments.PaymentType
ORDER BY 'Total Orders' DESC;


-- How Many Installments Are Usually Done When Paying In The Ecommerce?
WITH MAX_INSTALLMENTS AS (
SELECT DISTINCT OrderItems.OrderID , MAX(Payments.PaymentInstallments) MAX_INST
FROM Payments
JOIN OrderItems
ON Payments.PaymentID = OrderItems.PaymentID
GROUP BY OrderItems.OrderID
)
SELECT AVG(MAX_INST*1.0) 'Average Installments'
FROM MAX_INSTALLMENTS;


-- What Is The Frequency Of Purchase In Each State?
SELECT Users.UserState 'User State',
    COUNT(DISTINCT OrderItems.OrderID) * 1.0 / COUNT(DISTINCT OrderItems.UserID) AS 'Purchase Frequency'
FROM OrderItems
LEFT JOIN Users on OrderItems.UserID = Users.UserID
GROUP BY Users.UserState
ORDER BY 'Purchase Frequency' DESC;


-- Which Logistic Route Has Heavy Traffic In Our E-Commerce? (Web Traffic)
SELECT TOP 10 CONCAT(Sellers.SellerState, ', ', Sellers.SellerCity,' ==>> ', Users.UserState, ', ', Users.UserCity) 'Logistic Route', COUNT(DISTINCT OrderItems.OrderID) 'Total Orders'
FROM OrderItems
JOIN Users
ON Users.UserID = OrderItems.UserID
JOIN Sellers
ON Sellers.SellerID = OrderItems.SellerID
GROUP BY Sellers.SellerState, Sellers.SellerCity, Users.UserState, Users.UserCity
ORDER BY 'Total Orders' DESC;


-- Which Logistic Route Has Heavy Traffic In Our E-Commerce? (Delay Frequency)
SELECT TOP 10 CONCAT(Sellers.SellerState, ', ', Sellers.SellerCity,' ==>> ', Users.UserState, ', ', Users.UserCity) 'Logistic Route', AVG(SubQuery.MaxDeliveryDelayDays) / 
           COUNT(DISTINCT(OrderItems.OrderID)) AS 'Average Delivery Days Per Order'
FROM (
    SELECT OrderItems.OrderID, MAX(OrderItems.DeliveryDelayDays*1.0) AS MaxDeliveryDelayDays
    FROM OrderItems
	WHERE OrderItems.DeliveryDelayCheck = 'Delayed'
    GROUP BY OrderItems.OrderID
) AS SubQuery
JOIN OrderItems ON SubQuery.OrderID = OrderItems.OrderID
JOIN Users
ON Users.UserID = OrderItems.UserID
JOIN Sellers
ON Sellers.SellerID = OrderItems.SellerID
WHERE OrderItems.DeliveryDelayCheck = 'Delayed'
GROUP BY Sellers.SellerState, Sellers.SellerCity, Users.UserState, Users.UserCity
ORDER BY 'Average Delivery Days Per Order' DESC;


-- How Many Late Delivered Orders In Our E-Commerce?
SELECT COUNT(DISTINCT(OrderItems.OrderID)) AS 'Total Delayed Orders'
FROM OrderItems
WHERE OrderItems.DeliveryDelayCheck = 'Delayed';


--  Are Late Orders Affecting Customer Satisfaction?
DECLARE @N FLOAT, @SumX FLOAT, @SumY FLOAT, @SumXY FLOAT, @SumXSquare FLOAT, @SumYSquare FLOAT;
SELECT
    @N = COUNT(*),
    @SumX = SUM(Feedbacks.FeedbackScore),
    @SumY = SUM(OrderItems.DeliveryDelayDays),
    @SumXY = SUM(Feedbacks.FeedbackScore * OrderItems.DeliveryDelayDays),
    @SumXSquare = SUM(Feedbacks.FeedbackScore * Feedbacks.FeedbackScore),
    @SumYSquare = SUM(OrderItems.DeliveryDelayDays * OrderItems.DeliveryDelayDays)
FROM OrderItems
JOIN Feedbacks 
ON OrderItems.FeedbackID = Feedbacks.FeedbackID
WHERE OrderItems.DeliveryDelayCheck = 'Delayed'
SELECT
    CAST((@N * @SumXY - @SumX * @SumY) AS FLOAT) /
    SQRT((@N * @SumXSquare - POWER(@SumX, 2)) * (@N * @SumYSquare - POWER(@SumY, 2)))
    AS 'Feedback Score & Delivery Delay Correlation Coefficient';


-- How Long Is The Delay For Delivery/Shipping Process In Each State?
SELECT Users.UserState 'User State', AVG(SubQuery.MaxShippingDays*1.0) AS 'Average Shipping Days'
FROM (
    SELECT OrderItems.UserID, OrderItems.OrderID, MAX(OrderItems.ShippingDays) AS MaxShippingDays
    FROM OrderItems
    GROUP BY OrderItems.UserID, OrderItems.OrderID
) AS SubQuery
JOIN Users ON Users.UserID = SubQuery.UserID
GROUP BY Users.UserState
ORDER BY 'Average Shipping Days' DESC;


-- How Long Is The Delay For Delivery/Shipping Process For Each Route?
SELECT CONCAT(Sellers.SellerState, ', ', Sellers.SellerCity,' ==>> ', Users.UserState, ', ', Users.UserCity) 'Logistic Route', AVG(SubQuery.MaxShippingDays*1.0) AS 'Average Shipping Days'
FROM (
    SELECT OrderItems.UserID, OrderItems.OrderID, MAX(OrderItems.ShippingDays) AS MaxShippingDays
    FROM OrderItems
    GROUP BY OrderItems.UserID, OrderItems.OrderID
) AS SubQuery
JOIN OrderItems ON SubQuery.OrderID = OrderItems.OrderID
JOIN Users
ON Users.UserID = OrderItems.UserID
JOIN Sellers
ON Sellers.SellerID = OrderItems.SellerID
WHERE OrderItems.DeliveryDelayCheck = 'Delayed'
GROUP BY Sellers.SellerState, Sellers.SellerCity, Users.UserState, Users.UserCity
ORDER BY 'Average Shipping Days' DESC;


-- How Long Is The Difference Between Estimated Delivery Time And Actual Delivery Time In Each State?
SELECT Users.UserState 'User State', AVG(SubQuery.MaxDeliveryDelayDays*1.0) AS 'Average Delivery Delay Days'
FROM (
    SELECT OrderItems.UserID, OrderItems.OrderID, MAX(OrderItems.DeliveryDelayDays*1.0) AS MaxDeliveryDelayDays
    FROM OrderItems
    GROUP BY OrderItems.UserID, OrderItems.OrderID
) AS SubQuery
JOIN Users ON Users.UserID = SubQuery.UserID
GROUP BY Users.UserState
ORDER BY 'Average Delivery Delay Days' DESC;


-- How Long Is The Difference Between Estimated Delivery Time And Actual Delivery Time For Each Logistic Route?
SELECT CONCAT(Sellers.SellerState, ', ', Sellers.SellerCity,' ==>> ', Users.UserState, ', ', Users.UserCity) 'Logistic Route', AVG(SubQuery.MaxDeliveryDelayDays*1.0) AS 'Average Delivery Delay Days'
FROM (
    SELECT OrderItems.UserID, OrderItems.OrderID, MAX(OrderItems.DeliveryDelayDays*1.0) AS MaxDeliveryDelayDays
    FROM OrderItems
    GROUP BY OrderItems.UserID, OrderItems.OrderID
) AS SubQuery
JOIN OrderItems ON SubQuery.OrderID = OrderItems.OrderID
JOIN Users
ON Users.UserID = OrderItems.UserID
JOIN Sellers
ON Sellers.SellerID = OrderItems.SellerID
WHERE OrderItems.DeliveryDelayCheck = 'Delayed'
GROUP BY Sellers.SellerState, Sellers.SellerCity, Users.UserState, Users.UserCity
ORDER BY 'Average Delivery Delay Days' DESC;