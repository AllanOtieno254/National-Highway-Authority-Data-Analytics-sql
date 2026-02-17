--FINANCIAL & PAYMENT ANALYSIS (Requires Joins)
SELECT * FROM [01_Projects]
SELECT * FROM [02_Contractors]
SELECT * FROM [03_Employees]
SELECT * FROM [04_Road_Inspections]
SELECT * FROM [05_Payments]
SELECT * FROM [06_Equipment]
SELECT * FROM [07_Traffic_Data]

--1.What is the total payment made per contractor?
SELECT 
    a.Contractor_Name,
    SUM(ISNULL(b.Payment_Amount_KES,0)) AS Total_Payment
FROM [02_Contractors] a
LEFT JOIN [05_Payments] b
    ON a.Contractor_ID = b.Contractor_ID
GROUP BY a.Contractor_Name
ORDER BY Total_Payment DESC;

--2.What is the total net payment per project?
SELECT 
    a.Project_Name,
    SUM(ISNULL(b.Net_Payment_KES,0)) AS Total_Net_Payment
FROM [01_Projects] a
LEFT JOIN [05_Payments] b
    ON a.Project_ID = b.Project_ID
GROUP BY a.Project_Name;


--3.Which contractor has the highest penalty deductions?
SELECT TOP(1)
    a.Contractor_Name,
    SUM(ISNULL(b.Penalty_Deductions_KES,0)) AS Total_Penalty
FROM [02_Contractors] a
LEFT JOIN [05_Payments] b
    ON a.Contractor_ID = b.Contractor_ID
GROUP BY a.Contractor_Name
ORDER BY Total_Penalty DESC;


--4.What percentage of payments are still pending?
WITH Total_Payment AS (
    SELECT SUM([Payment_Amount_KES]) AS Total_Amt
    FROM [05_Payments]
)

SELECT 
    CAST((SUM(b.[Payment_Amount_KES]) * 100.0 / tp.Total_Amt) AS DECIMAL(18, 2)) AS [Percentage_Pending]
    
FROM [05_Payments] b, Total_Payment tp
WHERE b.Payment_Status = 'Pending'
GROUP BY tp.Total_Amt

--5.What is the total retention amount held per contractor?
SELECT 
a.Contractor_Name,SUM(ISNULL(b.Retention_Amount_KES,0))
 AS [Retention Amount]
FROM [02_Contractors] a
LEFT JOIN [05_Payments] b
ON a.Contractor_ID=b.Contractor_ID
GROUP BY a.Contractor_Name

--6.Compare total budget vs total payments per project.
SELECT 
    a.[Project_ID],
    a.[Project_Name],
    a.[Budget_KES] AS [Total Budget],
    ISNULL(p.[Total_Paid], 0) AS [Total Payment Amount],
    (a.[Budget_KES] - ISNULL(p.[Total_Paid], 0)) AS [Remaining Balance]
FROM [01_Projects] a
LEFT JOIN (
    -- Sum payments per project first
    SELECT [Project_ID], SUM([Payment_Amount_KES]) AS [Total_Paid]
    FROM [05_Payments]
    GROUP BY [Project_ID]
) p ON a.[Project_ID] = p.[Project_ID]
ORDER BY [Remaining Balance] DESC;


--7.Which financial year had the highest payments?
SELECT TOP(1) [Financial_Year],SUM([Payment_Amount_KES]) AS [Payment Amount]
FROM [05_Payments]
GROUP BY [Financial_Year]
ORDER BY [Payment Amount] DESC

--8.Which funding source pays contractors fastest?
SELECT 
    pay.Funding_Source,
    AVG(DATEDIFF(DAY, p.Start_Date, pay.Payment_Date)) AS Avg_Days_To_Pay
FROM [05_Payments] pay
JOIN [01_Projects] p
    ON pay.Project_ID = p.Project_ID
GROUP BY pay.Funding_Source
ORDER BY Avg_Days_To_Pay ASC;


--9.What is the average payment per project milestone?
SELECT 
    Payment_Type,
    AVG(Payment_Amount_KES) AS Avg_Payment_Per_Milestone
FROM [05_Payments]
GROUP BY Payment_Type;


SELECT * FROM [05_Payments]

--10.Identify projects where payments exceed budget.
SELECT Project_Name,Actual_Cost_KES,Budget_KES
FROM [01_Projects]
WHERE Actual_Cost_KES>Budget_KES


--(Tables involved: Projects + Payments + Contractors)
