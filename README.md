# SwiftShip Logistics Tracker

## Description

The **SwiftShip Logistics Tracker** is a SQL-based database system designed for a third-party logistics company to efficiently track shipments, identify delays, and evaluate delivery partner performance. The system helps detect "Lost in Transit" issues and provides insights into partner efficiency using success rate metrics.

## Key Features

* Shipment Tracking with Delivery Logs
* Detection of Delayed Shipments
* Partner Performance Analysis (Successful vs Returned Deliveries)
* Success Rate Calculation for Each Partner
* Ranking of Delivery Partners Based on Performance
* Identification of Most Active Delivery Zones
* Real-world Logistics Data Simulation

## Technologies Used

* SQL 
* Joins and Aggregations
* GROUP BY and COUNT
* CASE Statements
* Date Functions (DATEDIFF)

## Database Schema

* **Partners**
  - Stores delivery partner details
* **Shipments**
  - Tracks order dates, delivery timelines, status, and destination
* **DeliveryLogs**
  - Maintains shipment status updates and locations


