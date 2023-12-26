# Data Analysis README

## 1) Peak Season Analysis

### Seasons

```sql
-- Peak season analysis for seasons
SELECT [Warehouse].Dates.Season , COUNT(DISTINCT [Warehouse].OrderItems.OrderID) Number_of_orders
FROM [Warehouse].Dates 
JOIN [Warehouse].OrderItems
ON [Warehouse].Dates.DateKey = [Warehouse].OrderItems.OrderDateKey
GROUP BY [Warehouse].Dates.Season
ORDER BY Number_of_orders DESC;
```
| Season | Number_of_orders |
| --- | --- |
| Spring | 29719 |
| Summer | 27089 |
| Winter | 24423 |
| Fall | 18210 |

### Months

```sql
-- Peak season analysis for months
SELECT [Warehouse].Dates.[Month Name] , COUNT(DISTINCT [Warehouse].OrderItems.OrderID) Number_of_orders
FROM [Warehouse].Dates 
JOIN [Warehouse].OrderItems
ON [Warehouse].Dates.DateKey = [Warehouse].OrderItems.OrderDateKey
GROUP BY [Warehouse].Dates.[Month Name]
ORDER BY Number_of_orders DESC;
```
| Month Name | Number_of_orders |
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

```sql
-- Order timing analysis
SELECT [Warehouse].Times.Hour ,[Warehouse].Times.[AM/PM] , COUNT(DISTINCT [Warehouse].OrderItems.OrderID) Number_of_orders
FROM [Warehouse].Times 
JOIN [Warehouse].OrderItems
ON [Warehouse].Times.TimeKey = [Warehouse].OrderItems.OrderTimeKey
GROUP BY [Warehouse].Times.Hour ,[Warehouse].Times.[AM/PM]
ORDER BY Number_of_orders DESC;
```

| Hour | AM/PM | Number_of_orders |
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
-- Preferred payment method analysis
SELECT [Warehouse].Payments.PaymentType , COUNT([Warehouse].Payments.PaymentType) Number_of_orders
FROM [Warehouse].Payments
GROUP BY [Warehouse].Payments.PaymentType
ORDER BY Number_of_orders DESC
```
| PaymentType | Number_of_orders |
| --- | --- |
| Credit Card | 76795 |
| Blipay | 19784 |
| Voucher | 5775 |
| Debit Card | 1529 |
| Not Defined | 3 |

The most preferred payment method is **credit card**.

## 4) Average Installments

```sql
-- Average number of installments analysis
WITH MAX_INSTALLMENTS AS (
SELECT DISTINCT [Warehouse].OrderItems.OrderID , MAX([Warehouse].Payments.PaymentInstallments) MAX_INST
FROM [Warehouse].Payments
JOIN [Warehouse].OrderItems
ON [Warehouse].Payments.PaymentID = [Warehouse].OrderItems.PaymentID
GROUP BY [Warehouse].OrderItems.OrderID
)

SELECT AVG(MAX_INST*1.0) Avg_of_installments
FROM MAX_INSTALLMENTS
```

| Avg_of_installments |
| --- |
|2.932013|

We can see that the average number of installments is 2.93.

## 5) Average Spending Time

_(To be implemented)_

## 6) Purchase Frequency by State

```sql
-- Purchase frequency analysis by state
------------------------------------------------------------
SELECT [Warehouse].Users.UserState , COUNT(DISTINCT [Warehouse].OrderItems.OrderID)*1.0 / (SELECT COUNT(DISTINCT [Warehouse].OrderItems.OrderID) FROM Warehouse.OrderItems) Frequency_of_purchase
FROM [Warehouse].OrderItems
JOIN [Warehouse].Users
ON [Warehouse].Users.UserID = [Warehouse].OrderItems.UserID
GROUP BY [Warehouse].Users.UserState
ORDER BY Frequency_of_purchase DESC
```
| UserState | Frequency_of_purchase |
| --- | --- |
| Banten | 0.212859886767 |
| Jawa Barat | 0.129162015667 |
| Dki Jakarta | 0.125964139540 |
| Jawa Tengah | 0.086312486801 |
| Jawa Timur | 0.084954897879 |
| Sumatera Utara | 0.039500809525 |
| Sulawesi Selatan | 0.023963958528 |
| Sumatera Selatan | 0.021600748182 |
| Sumatera Barat | 0.019006244909 |
| Papua | 0.018111241841 |
| Di Yogyakarta | 0.017678824629 |
| Kalimantan Timur | 0.016964833418 |
| Lampung | 0.016864271276 |
| Kalimantan Barat | 0.015778200138 |
| Riau | 0.015737975281 |
| Kalimantan Selatan | 0.015335726712 |
| Bali | 0.014340161502 |
| Nusa Tenggara Timur | 0.012630605082 |
| Sulawesi Utara | 0.012349031083 |
| Jambi | 0.010961273518 |
| Kalimantan Tengah | 0.010699811948 |
| Sulawesi Tengah | 0.009935539666 |
| Sulawesi Tenggara | 0.008960086885 |
| Aceh | 0.008266208103 |
| Kepulauan Riau | 0.007300811536 |
| Papua Barat | 0.007160024537 |
| Bengkulu | 0.005782323186 |
| Maluku Utara | 0.005319737331 |
| Maluku | 0.004897376333 |
| Kalimantan Utara | 0.004867207690 |
| Gorontalo | 0.004816926619 |
| Sulawesi Barat | 0.004726420691 |
| Nusa Tenggara Barat | 0.003791192767 |
| Kepulauan Bangka Belitung | 0.003399000412 |

## 7) Heavy Traffic Logistic Route

```sql
-- Heavy traffic logistic route analysis
SELECT TOP 10 CONCAT([Warehouse].Sellers.SellerState,'->',[Warehouse].Users.UserState) Route, COUNT(DISTINCT [Warehouse].OrderItems.OrderID) Number_of_orders
FROM [Warehouse].OrderItems
JOIN [Warehouse].Users
ON [Warehouse].Users.UserID = [Warehouse].OrderItems.UserID
JOIN [Warehouse].Sellers
ON [Warehouse].Sellers.SellerID = [Warehouse].OrderItems.SellerID
GROUP BY [Warehouse].Sellers.SellerState , [Warehouse].Users.UserState
ORDER BY Number_of_orders DESC
```
| Route | Number_of_orders |
| --- | --- |
| Banten->Banten | 6650 |
| Banten->Jawa Barat | 4009 |
| Banten->Dki Jakarta | 3448 |
| Banten->Jawa Timur | 2696 |
| Banten->Jawa Tengah | 2579 |
| Jawa Barat->Banten | 2144 |
| Jawa Tengah->Banten | 2013 |
| Kalimantan Timur->Banten | 1669 |
| Jawa Timur->Banten | 1497 |
| Dki Jakarta->Banten | 1391 |

## 8) Late Delivered Orders

```sql
-- Late delivered orders analysis
SELECT COUNT([Warehouse].OrderItems.DeliveryDelayCheck) Number_of_delayed_days
FROM [Warehouse].OrderItems
WHERE [Warehouse].OrderItems.DeliveryDelayCheck = 'Delayed'
```
| Number_of_delayed_days |
| --- |
|6927 |

## 9) Correlation Between Late Orders and Customer Satisfaction

```sql
-- Correlation analysis between late orders and customer satisfaction
DECLARE @N FLOAT, @SumX FLOAT, @SumY FLOAT, @SumXY FLOAT, @SumXSquare FLOAT, @SumYSquare FLOAT;

SELECT
    @N = COUNT(*),
    @SumX = SUM([Warehouse].Feedbacks.FeedbackScore),
    @SumY = SUM([Warehouse].OrderItems.DeliveryDelayDays),
    @SumXY = SUM([Warehouse].Feedbacks.FeedbackScore * [Warehouse].OrderItems.DeliveryDelayDays),
    @SumXSquare = SUM([Warehouse].Feedbacks.FeedbackScore * [Warehouse].Feedbacks.FeedbackScore),
    @SumYSquare = SUM([Warehouse].OrderItems.DeliveryDelayDays * [Warehouse].OrderItems.DeliveryDelayDays)
FROM [Warehouse].OrderItems
JOIN [Warehouse].Feedbacks 
ON [Warehouse].OrderItems.FeedbackID = [Warehouse].Feedbacks.FeedbackID
WHERE [Warehouse].OrderItems.DeliveryDelayCheck = 'Delayed'

SELECT
    CAST((@N * @SumXY - @SumX * @SumY) AS FLOAT) /
    SQRT((@N * @SumXSquare - POWER(@SumX, 2)) * (@N * @SumYSquare - POWER(@SumY, 2)))
    AS CorrelationCoefficient;

```

| CorrelationCoefficient |
| --- |
|-0.127822949637289 |


## 10) Delay Analysis by State

```sql
-- Delay analysis for delivery/shipping process in each state
SELECT TOP 10 CONCAT([Warehouse].Sellers.SellerState,'->',[Warehouse].Users.UserState) Route, AVG(DISTINCT [Warehouse].OrderItems.ShippingDays) Avg_time_of_shipping_in_days
FROM [Warehouse].OrderItems
JOIN [Warehouse].Users
ON [Warehouse].Users.UserID = [Warehouse].OrderItems.UserID
JOIN [Warehouse].Sellers
ON [Warehouse].Sellers.SellerID = [Warehouse].OrderItems.SellerID
GROUP BY [Warehouse].Sellers.SellerState , [Warehouse].Users.UserState
ORDER BY Avg_time_of_shipping_in_days DESC
```
| Route | Avg_time_of_shipping_in_days |
| --- | --- |
| Aceh->Jambi | 182 |
| Kalimantan Utara->Bali | 61 |
| Kepulauan Bangka Belitung->Sulawesi Tenggara | 55 |
| Nusa Tenggara Barat->Di Yogyakarta | 46 |
| Kalimantan Tengah->Nusa Tenggara Barat | 40 |
| Banten->Dki Jakarta | 39 |
| Banten->Jawa Timur | 32 |
| Banten->Jawa Barat | 31 |
| Jawa Tengah->Jawa Timur | 31 |
| Papua->Riau | 31 |

## 11) Delay Difference Analysis by State

```sql
-- Delay difference analysis between estimated delivery time and actual delivery time in each state
SELECT TOP 10 CONCAT([Warehouse].Sellers.SellerState,'->',[Warehouse].Users.UserState) Route, AVG(DISTINCT [Warehouse].OrderItems.DeliveryDelayDays) Avg_time_of_delay_in_days
FROM [Warehouse].OrderItems
JOIN [Warehouse].Users
ON [Warehouse].Users.UserID = [Warehouse].OrderItems.UserID
JOIN [Warehouse].Sellers
ON [Warehouse].Sellers.SellerID = [Warehouse].OrderItems.SellerID
GROUP BY [Warehouse].Sellers.SellerState , [Warehouse].Users.UserState
ORDER BY Avg_time_of_delay_in_days DESC
```
| Route | Avg_time_of_delay_in_days |
| --- | --- |
| Aceh->Jambi | 162 |
| Nusa Tenggara Barat->Di Yogyakarta | 96 |
| Bali->Kalimantan Selatan | 94 |
| Jawa Tengah->Kepulauan Bangka Belitung | 87 |
| Kalimantan Tengah->Riau | 76 |
| Sulawesi Barat->Jawa Barat | 68 |
| Jawa Barat->Nusa Tenggara Barat | 67 |
| Papua->Riau | 63 |
| Kalimantan Timur->Sulawesi Barat | 61 |
| Bali->Kepulauan Bangka Belitung | 59 |


This README provides an overview of the data analysis performed to answer specific questions about the ecommerce dataset. The SQL queries and their explanations are provided for each analysis.