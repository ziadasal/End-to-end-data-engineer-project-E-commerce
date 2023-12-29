# Data Analysis README

## 1) When Is the Peak of Our E-Commerce?

### Seasons

```sql
SELECT Dates.Season, COUNT(DISTINCT OrderItems.OrderID) 'Total Orders'
FROM Dates 
JOIN OrderItems
ON Dates.DateKey = OrderItems.OrderDateKey
GROUP BY Dates.Season
ORDER BY 'Total Orders' DESC;
```
| Season | Total Orders |
| --- | --- |
| Spring | 29719 |
| Summer | 27089 |
| Winter | 24423 |
| Fall | 18210 |

### Months

```sql
SELECT Dates.[Month Name], COUNT(DISTINCT OrderItems.OrderID) 'Total Orders'
FROM Dates
JOIN OrderItems
ON Dates.DateKey = OrderItems.OrderDateKey
GROUP BY Dates.[Month Name]
ORDER BY 'Total Orders' DESC;
```

| Month Name | Total Orders |
| --- | --- |
| August | 10843 |
| May | 10573 |
| July | 10318 |
| March | 9893 |
| June | 9412 |
| April | 9343 |
| February | 8508 |
| January | 8069 |
| November | 7544 |
| December | 5674 |
| October | 4959 |
| September | 4305 |

The peak season is **Spring**.

The peak month is **August**.

## 2) Order Timing Analysis


### Time of Day

```sql
SELECT Times.TimeOfDay 'Time Of Day', COUNT(DISTINCT OrderItems.OrderID) 'Total Orders'
FROM Times 
JOIN OrderItems
ON Times.TimeKey = OrderItems.OrderTimeKey
GROUP BY Times.TimeOfDay
ORDER BY 'Total Orders' DESC;

```
| Time Of Day | Total Orders |
| --- | --- |
| Afternoon | 26216 |
| Morning | 25816 |
| Night | 23513 |
| Evening | 17901 |
| Noon | 5995 |


### Hour

```sql
-- What Time Users Are Most Likely Making An Order Or Using The E-Commerce App?
SELECT Times.Hour, Times.[AM/PM], COUNT(DISTINCT OrderItems.OrderID) 'Total Orders'
FROM Times 
JOIN OrderItems
ON Times.TimeKey = OrderItems.OrderTimeKey
GROUP BY Times.Hour, Times.[AM/PM]
ORDER BY 'Total Orders' DESC;
```

| Hour | AM/PM | Total Orders |
| --- | --- | --- |
| 16 | P.M. | 6675 |
| 11 | A.M. | 6578 |
| 14 | P.M. | 6569 |
| 13 | P.M. | 6518 |
| 15 | P.M. | 6454 |
| 21 | P.M. | 6217 |
| 20 | P.M. | 6193 |
| 10 | A.M. | 6177 |
| 17 | P.M. | 6150 |
| 12 | P.M. | 5995 |
| 19 | P.M. | 5982 |
| 22 | P.M. | 5816 |
| 18 | P.M. | 5769 |
| 9 | A.M. | 4785 |
| 23 | P.M. | 4123 |
| 8 | A.M. | 2967 |
| 0 | A.M. | 2394 |
| 7 | A.M. | 1231 |
| 1 | A.M. | 1170 |
| 2 | A.M. | 510 |
| 6 | A.M. | 502 |
| 3 | A.M. | 272 |
| 4 | A.M. | 206 |
| 5 | A.M. | 188 |

We can SEE that the peak hours are 16 PM, 11 AM, 14 PM, 13 PM, 15 PM.

## 3) Preferred Payment Method

```sql
-- What Is The Preferred Way To Pay In The E-Commerce?
SELECT Payments.PaymentType 'Payment Type', COUNT(Payments.PaymentType) 'Total Orders'
FROM Payments
GROUP BY Payments.PaymentType
ORDER BY 'Total Orders' DESC;
```
| PaymentType | Total Orders |
| --- | --- |
| Credit Card | 76795 |
| Blipay | 19784 |
| Voucher | 5775 |
| Debit Card | 1529 |
| Not Defined | 3 |

The most preferred payment method is **credit card**.

## 4) Average Installments

```sql
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
```

| Avg_of_installments |
| --- |
|2.932013|

We can see that the average number of installments is 2.93.

## 5) Average Spending Time

_(To be implemented)_

## 6) What Is The Frequency Of Purchase In Each State?

```sql
-- What Is The Frequency Of Purchase In Each State?
SELECT Users.UserState 'User State',
    COUNT(DISTINCT OrderItems.OrderID) * 1.0 / COUNT(DISTINCT OrderItems.UserID) AS 'Purchase Frequency'
FROM OrderItems
LEFT JOIN Users on OrderItems.UserID = Users.UserID
GROUP BY Users.UserState
ORDER BY 'Purchase Frequency' DESC;
```

| UserState | Purchase Frequency |
| --- | --- |
| Maluku | 1.047311827956 |
| Jambi | 1.042065009560 |
| Nusa Tenggara Barat | 1.041436464088 |
| Kalimantan Timur | 1.040073982737 |
| Dki Jakarta | 1.038984737889 |
| Sumatera Barat | 1.037891268533 |
| Banten | 1.037089661930 |
| Sulawesi Selatan | 1.036988685813 |
| Nusa Tenggara Timur | 1.035449299258 |


## 7) Which Logistic Route Has Heavy Traffic In Our E-Commerce? (Delay Frequency)
```sql
SELECT TOP 10 CONCAT([Warehouse].Sellers.SellerState, ', ', [Warehouse].Sellers.SellerCity,' ==>> ', [Warehouse].Users.UserState, ', ', [Warehouse].Users.UserCity) 'Logistic Route', COUNT(DISTINCT [Warehouse].OrderItems.OrderID) 'Total Orders'
FROM [Warehouse].OrderItems
JOIN [Warehouse].Users
ON [Warehouse].Users.UserID = [Warehouse].OrderItems.UserID
JOIN [Warehouse].Sellers
ON [Warehouse].Sellers.SellerID = [Warehouse].OrderItems.SellerID
GROUP BY [Warehouse].Sellers.SellerState, [Warehouse].Sellers.SellerCity, [Warehouse].Users.UserState, [Warehouse].Users.UserCity
ORDER BY 'Total Orders' DESC;
```
| Logistic Route | Total Orders |
| --- | --- |
| Banten, Kota Tangerang ==>> Dki Jakarta, Kota Jakarta Barat | 4182 |
| Banten, Kota Tangerang ==>> Banten, Kota Tangerang | 1432 |   
| Kalimantan Timur, Kabupaten Berau ==>> Banten, Kota Tangerang | 1113 |
| Banten, Kota Tangerang ==>> Banten, Kabupaten Tangerang | 605 |
| Kalimantan Timur, Kabupaten Berau ==>> Dki Jakarta, Kota Jakarta Barat | 504 |
| Banten, Kota Tangerang ==>> Jawa Barat, Kabupaten Bekasi | 485 |
| Jawa Barat, Kabupaten Bogor ==>> Banten, Kota Tangerang | 437 |
| Banten, Kota Tangerang ==>> Dki Jakarta, Kota Jakarta Selatan | 387 |
| Banten, Kota Tangerang ==>> Dki Jakarta, Kota Jakarta Timur | 378 |
| Dki Jakarta, Kota Jakarta Selatan ==>> Banten, Kota Tangerang | 371 |

## 8) Which Logistic Route Has Heavy Traffic In Our E-Commerce? (Delay Frequency)
```sql
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
```

| Logistic Route | Average Delivery Days Per Order |
| --- | --- |
| Banten, Kabupaten Tangerang ==>> Kepulauan Riau, Kabupaten Bintan | 181.000000 |
| Banten, Kota Tangerang ==>> Lampung, Kabupaten Lampung Selatan | 175.000000 |
| Sumatera Utara, Kabupaten Nias Selatan ==>> Jawa Barat, Kabupaten Tasikmalaya | 167.000000 |
| Jawa Tengah, Kabupaten Kendal ==>> Kepulauan Bangka Belitung, Kabupaten Bangka Tengah | 166.000000 |
| Aceh, Kabupaten Simeulue ==>> Jambi, Kabupaten Bungo | 162.000000 |
| Jawa Timur, Kota Malang ==>> Jawa Tengah, Kabupaten Jepara | 161.000000 |
| Kalimantan Timur, Kota Balikpapan ==>> Jawa Barat, Kota Bekasi | 161.000000 |
| Jawa Timur, Kota Mojokerto ==>> Jawa Barat, Kota Tasikmalaya | 159.000000 |
| Jawa Barat, Kota Bandung ==>> Sulawesi Utara, Kota Manado | 155.000000 |
| Jawa Timur, Kabupaten Jombang ==>> Sumatera Barat, Kota Bukittinggi | 153.000000 |

## 9) How Many Late Delivered Orders In Our E-Commerce?
```sql
SELECT COUNT(DISTINCT(OrderItems.OrderID)) AS 'Total Delayed Orders'
FROM OrderItems
WHERE OrderItems.DeliveryDelayCheck = 'Delayed';
```
| Total Delayed |
| --- |
|6535 |

## 10) Are Late Orders Affecting Customer Satisfaction

```sql
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

```

| Feedback Score & Delivery Delay Correlation Coefficient |
| --- |
|-0.127822949637289 |


## 11) How Long Is The Delay For Delivery/Shipping Process In Each State?
```sql
SELECT Top 10 Users.UserState 'User State', AVG(SubQuery.MaxShippingDays*1.0) AS 'Average Shipping Days'
FROM (
    SELECT OrderItems.UserID, OrderItems.OrderID, MAX(OrderItems.ShippingDays) AS MaxShippingDays
    FROM OrderItems
    GROUP BY OrderItems.UserID, OrderItems.OrderID
) AS SubQuery
JOIN Users ON Users.UserID = SubQuery.UserID
GROUP BY Users.UserState
ORDER BY 'Average Shipping Days' DESC;
```
| User State | Average Shipping Days |
| --- | --- |
| Kepulauan Bangka Belitung | 12.969696 |
| Bali | 12.297376 |
| Sulawesi Barat | 11.962800 |
| Kepulauan Riau | 11.834512 |
| Sulawesi Tenggara | 11.831242 |
| Nusa Tenggara Timur | 11.810074 |
| Sulawesi Utara | 11.690833 |
| Papua | 11.600341 |
| Lampung | 11.563467 |
| Aceh | 11.483188 |

## 12) How Long Is The Delay For Delivery/Shipping Process For Each Logistic Route?
```sql
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
```
| Logistic Route | Average Shipping Days |
| --- | --- |
| Banten, Kabupaten Tangerang ==>> Kepulauan Riau, Kabupaten Bintan | 195 |
| Jawa Tengah, Kabupaten Kendal ==>> Kepulauan Bangka Belitung, Kabupaten Bangka Tengah | 194 |
| Jawa Timur, Kota Mojokerto ==>> Jawa Barat, Kota Tasikmalaya | 187 |
| Sumatera Utara, Kabupaten Nias Selatan ==>> Jawa Barat, Kabupaten Tasikmalaya | 186 |
| Aceh, Kabupaten Simeulue ==>> Jambi, Kabupaten Bungo | 182 |
| Jawa Timur, Kabupaten Jombang ==>> Sumatera Barat, Kota Bukittinggi | 182 |
| Kalimantan Timur, Kabupaten Berau ==>> Sulawesi Barat, Kabupaten Majene | 182 |
| Jawa Barat, Kota Bandung ==>> Sulawesi Utara, Kota Manado | 181 |
| Jawa Timur, Kota Malang ==>> Jawa Tengah, Kabupaten Jepara | 181 |
| Jawa Barat, Kota Bandung ==>> Jawa Barat, Kota Cirebon | 179 |

## 13) How Long Is The Difference Between Estimated Delivery Time And Actual Delivery Time In Each State?

```sql
SELECT Users.UserState 'User State', AVG(SubQuery.MaxDeliveryDelayDays*1.0) AS 'Average Delivery Delay Days'
FROM (
    SELECT OrderItems.UserID, OrderItems.OrderID, MAX(OrderItems.DeliveryDelayDays*1.0) AS MaxDeliveryDelayDays
    FROM OrderItems
    GROUP BY OrderItems.UserID, OrderItems.OrderID
) AS SubQuery
JOIN Users ON Users.UserID = SubQuery.UserID
GROUP BY Users.UserState
ORDER BY 'Average Delivery Delay Days' DESC;
```

| User State | Average Delivery Delay Days |
| --- | --- |
| Nusa Tenggara Barat | 16.954545 |
| Kepulauan Bangka Belitung | 16.433333 |
| Bengkulu | 15.476190 |
| Maluku Utara | 14.941176 |
| Sulawesi Barat | 14.714285 |
| Jambi | 14.558441 |
| Kepulauan Riau | 14.156862 |
| Bali | 13.343065 |
| Sulawesi Utara | 12.444444 |
| Dki Jakarta | 12.319792 |

## 14) How Long Is The Difference Between Estimated Delivery Time And Actual Delivery Time For Each Logistic Route?
```sql
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
```

| Logistic Route | Average Delivery Delay Days |
| --- | --- |
| Banten, Kabupaten Tangerang ==>> Kepulauan Riau, Kabupaten Bintan | 181 |
| Banten, Kota Tangerang ==>> Lampung, Kabupaten Lampung Selatan | 175 |
| Sumatera Utara, Kabupaten Nias Selatan ==>> Jawa Barat, Kabupaten Tasikmalaya | 167 |
| Jawa Tengah, Kabupaten Kendal ==>> Kepulauan Bangka Belitung, Kabupaten Bangka Tengah | 166 |
| Aceh, Kabupaten Simeulue ==>> Jambi, Kabupaten Bungo | 162 |
| Jawa Timur, Kota Malang ==>> Jawa Tengah, Kabupaten Jepara | 161 |
| Kalimantan Timur, Kota Balikpapan ==>> Jawa Barat, Kota Bekasi | 161 |
| Jawa Timur, Kota Mojokerto ==>> Jawa Barat, Kota Tasikmalaya | 159 |
| Jawa Barat, Kota Bandung ==>> Sulawesi Utara, Kota Manado | 155 |
| Jawa Timur, Kabupaten Jombang ==>> Sumatera Barat, Kota Bukittinggi | 153 |

This README provides an overview of the data analysis performed to answer specific questions about the ecommerce dataset. The SQL queries and their explanations are provided for each analysis.