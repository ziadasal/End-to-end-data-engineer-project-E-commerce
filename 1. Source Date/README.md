# Source Data README
![Data Source](source_data.png)

## Table: Feedback

- **feedback_id (string):** Unique identifier for each feedback entry.
- **order_id (string):** Identifier linking the feedback to a specific order.
- **feedback (integer):** Numeric representation of the feedback received.
- **feedback_form_sent_date (Date):** Date when the feedback form was sent.
- **feedback_answer_date (timestamp):** Timestamp indicating when the feedback was answered.

### Purpose:
The "Feedback" table captures information about customer feedback, associating feedback responses with specific orders.

---

## Table: Order

- **order_id (string):** Unique identifier for each order.
- **user_name (string):** Name of the user who placed the order.
- **order_status (string):** Current status of the order.
- **order_date (timestamp):** Timestamp indicating when the order was placed.
- **order_approved_date (timestamp):** Timestamp indicating when the order was approved.
- **pickup_date (timestamp):** Timestamp indicating the pickup date for the order.
- **delivered_date (timestamp):** Timestamp indicating when the order was delivered.
- **estimated_time_delivery (date):** Estimated delivery date for the order.

### Purpose:
The "Order" table contains information about orders, including user details, order status, and important timestamps related to the order lifecycle.

---

## Table: Order Item

- **order_id (string):** Identifier linking the order item to a specific order.
- **order_item_id (int):** Unique identifier for each order item.
- **product_id (string):** Identifier linking the order item to a specific product.
- **seller_id (string):** Identifier linking the order item to a specific seller.
- **pickup_limit_date (timestamp):** Timestamp indicating the pickup limit date for the order item.
- **price (double):** Price of the order item.
- **shipping_cost (double):** Shipping cost for the order item.

### Purpose:
The "Order Item" table provides details about individual items within an order, including product information, seller details, and pricing.

---

## Table: Payment

- **order_id (string):** Identifier linking the payment to a specific order.
- **payment (int):** Numeric representation of the payment.
- **product_type (string):** Type of product for which the payment was made.
- **payment_installments (int):** Number of payment installments.
- **payment_value (double):** Value of the payment.

### Purpose:
The "Payment" table records payment details associated with specific orders and products.

---

## Table: Product

- **product_id (string):** Unique identifier for each product.
- **product_category (string):** Category to which the product belongs.
- **product_name_length (int):** Length of the product name.
- **product_description_length (int):** Length of the product description.
- **product_photos_qty (int):** Quantity of photos associated with the product.
- **product_weight_g (int):** Weight of the product in grams.
- **product_length_cm (int):** Length of the product in centimeters.
- **product_height_cm (int):** Height of the product in centimeters.
- **product_width_cm (int):** Width of the product in centimeters.

### Purpose:
The "Product" table contains detailed information about individual products, including their characteristics and dimensions.

---

## Table: Seller

- **seller_id (string):** Unique identifier for each seller.
- **seller_zip_code (int):** ZIP code of the seller.
- **seller_city (string):** City where the seller is located.
- **seller_state (string):** State where the seller is located.

### Purpose:
The "Seller" table provides information about individual sellers, including their location details.

---

## Table: User

- **user_name (string):** Name of the user.
- **customer_zip_code (int):** ZIP code of the user.
- **customer_city (string):** City where the user is located.
- **customer_state (string):** State where the user is located.

### Purpose:
The "User" table contains details about users, including their location information.
