-- 1.	Schema Design
CREATE TABLE Partners (
    PartnerID INT PRIMARY KEY,
    PartnerName VARCHAR(100),
    ContactEmail VARCHAR(100)
);

CREATE TABLE Shipments (
    ShipmentID INT PRIMARY KEY,
    OrderDate DATE,
    PromisedDate DATE,
    ActualDeliveryDate DATE,
    DestinationCity VARCHAR(100),
    PartnerID INT,
    Status VARCHAR(50), 
    FOREIGN KEY (PartnerID) REFERENCES Partners(PartnerID)
);

CREATE TABLE DeliveryLogs (
    LogID INT PRIMARY KEY,
    ShipmentID INT,
    StatusUpdate VARCHAR(100),
    UpdateTime TIMESTAMP,
    Location VARCHAR(100),
    FOREIGN KEY (ShipmentID) REFERENCES Shipments(ShipmentID)
);

INSERT INTO Partners VALUES
(1, 'DHL Express', 'dhl@swiftship.com'),
(2, 'FedEx Logistics', 'fedex@swiftship.com'),
(3, 'BlueDart', 'bluedart@swiftship.com'),
(4, 'Delhivery', 'delhivery@swiftship.com'),
(5, 'Ekart', 'ekart@swiftship.com'),
(6, 'India Post', 'indiapost@swiftship.com'),
(7, 'XpressBees', 'xpress@swiftship.com'),
(8, 'DTDC', 'dtdc@swiftship.com'),
(9, 'Shadowfax', 'shadowfax@swiftship.com'),
(10, 'Ecom Express', 'ecom@swiftship.com');

INSERT INTO Shipments VALUES
(101, '2026-03-01', '2026-03-05', '2026-03-04', 'Hyderabad', 1, 'Delivered'),
(102, '2026-03-02', '2026-03-06', '2026-03-08', 'Bangalore', 2, 'Delivered'),
(103, '2026-03-03', '2026-03-07', '2026-03-07', 'Chennai', 3, 'Delivered'),
(104, '2026-03-04', '2026-03-08', '2026-03-10', 'Mumbai', 4, 'Delivered'),
(105, '2026-03-05', '2026-03-09', '2026-03-09', 'Delhi', 5, 'Delivered'),
(106, '2026-03-06', '2026-03-10', '2026-03-12', 'Pune', 6, 'Returned'),
(107, '2026-03-07', '2026-03-11', '2026-03-10', 'Kolkata', 7, 'Delivered'),
(108, '2026-03-08', '2026-03-12', '2026-03-15', 'Ahmedabad', 8, 'Delivered'),
(109, '2026-03-09', '2026-03-13', '2026-03-13', 'Jaipur', 9, 'Delivered'),
(110, '2026-03-10', '2026-03-14', '2026-03-18', 'Lucknow', 10, 'Returned'),
(111, '2026-03-11', '2026-03-15', '2026-03-14', 'Hyderabad', 1, 'Delivered'),
(112, '2026-03-12', '2026-03-16', '2026-03-20', 'Bangalore', 2, 'Delivered');


INSERT INTO DeliveryLogs VALUES
(1, 101, 'Picked Up', '2026-03-01 10:00:00', 'Hyderabad'),
(2, 101, 'In Transit', '2026-03-02 14:00:00', 'Nagpur'),
(3, 102, 'Picked Up', '2026-03-02 09:30:00', 'Delhi'),
(4, 102, 'Delayed at Hub', '2026-03-06 18:00:00', 'Bangalore'),
(5, 103, 'Out for Delivery', '2026-03-07 08:00:00', 'Chennai'),
(6, 104, 'In Transit', '2026-03-07 12:00:00', 'Mumbai'),
(7, 105, 'Delivered', '2026-03-09 16:00:00', 'Delhi'),
(8, 106, 'Return Initiated', '2026-03-11 11:00:00', 'Pune'),
(9, 107, 'Out for Delivery', '2026-03-10 09:00:00', 'Kolkata'),
(10, 108, 'Delayed due to Weather', '2026-03-13 15:00:00', 'Ahmedabad'),
(11, 109, 'Delivered', '2026-03-13 13:00:00', 'Jaipur'),
(12, 110, 'Customer Not Available', '2026-03-17 17:30:00', 'Lucknow');


-- 2.	Delayed Shipment Query
SELECT *
FROM Shipments
WHERE ActualDeliveryDate > PromisedDate;


-- 3.	Performance Ranking
SELECT 
    P.PartnerName,

    (SELECT COUNT(*) 
     FROM Shipments S 
     WHERE S.PartnerID = P.PartnerID AND S.Status = 'Delivered') 
     AS Successful_Deliveries,

    (SELECT COUNT(*) 
     FROM Shipments S 
     WHERE S.PartnerID = P.PartnerID AND S.Status = 'Returned') 
     AS Returned_Deliveries

FROM Partners P;
SELECT 
    P.PartnerName,
    COUNT(CASE WHEN S.Status = 'Delivered' THEN 1 END) AS Successful_Deliveries,
    COUNT(CASE WHEN S.Status = 'Returned' THEN 1 END) AS Returned_Deliveries
FROM Partners P
JOIN Shipments S ON P.PartnerID = S.PartnerID
GROUP BY P.PartnerName;

-- 4.	The "Zone" Filter
SELECT DestinationCity, COUNT(*) AS TotalOrders
FROM Shipments
WHERE DATEDIFF(CURRENT_DATE, OrderDate) <= 30
GROUP BY DestinationCity
ORDER BY TotalOrders DESC
LIMIT 1;

-- Partner Scorecard 
SELECT 
    P.PartnerName,
    COUNT(*) AS TotalShipments,

    SUM(CASE 
        WHEN S.ActualDeliveryDate <= S.PromisedDate THEN 1 
        ELSE 0 
    END) AS OnTime,

    SUM(CASE 
        WHEN S.ActualDeliveryDate > S.PromisedDate THEN 1 
        ELSE 0 
    END) AS Delay,

    ROUND(
        SUM(CASE WHEN S.ActualDeliveryDate <= S.PromisedDate THEN 1 ELSE 0 END) * 100.0 
        / NULLIF(COUNT(*), 0), 2
    ) AS SuccessRate

FROM Partners P
JOIN Shipments S ON P.PartnerID = S.PartnerID
GROUP BY P.PartnerName
ORDER BY Delay ASC;

