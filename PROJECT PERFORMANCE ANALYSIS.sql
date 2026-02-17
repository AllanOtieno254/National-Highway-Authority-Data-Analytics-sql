--SELECT * FROM [01_Projects]
--SELECT * FROM [02_Contractors]
--SELECT * FROM [03_Employees]
--SELECT * FROM [04_Road_Inspections]
--SELECT * FROM [05_Payments]
--SELECT * FROM [06_Equipment]
--SELECT * FROM [07_Traffic_Data]

--PROJECT PERFORMANCE ANALYSIS

--1.What is the total number of projects per county?
SELECT County, COUNT(*) AS Total_Projects
FROM [01_Projects]
GROUP BY County;



--2.What is the total budget vs actual cost per project?
SELECT [Project_Name], 
		SUM([Budget_KES]) AS [Total Budget],
		SUM([Actual_Cost_KES]) AS [Actual cost]
FROM [01_Projects]
GROUP BY [Project_Name]


--3.Which projects are over budget?
SELECT [Project_Name],[Budget_KES],[Actual_Cost_KES]
FROM [01_Projects]
WHERE [Actual_Cost_KES]>[Budget_KES]


--4.What is the average completion percentage per county?
SELECT [County],AVG([Completion_Percentage]) AS [AVG completion percentage per county]
FROM [01_Projects]
GROUP BY [County]

--5.Which projects are delayed and by how many days?
SELECT Project_Name,
       DATEDIFF(DAY, End_Date, GETDATE()) AS Days_Delayed
FROM [01_Projects]
WHERE Project_Status = 'Delayed';


--6.Which contractor has handled the highest number of projects?
SELECT c.Contractor_Name,
       COUNT(p.Project_ID) AS Total_Projects
FROM [02_Contractors] c
LEFT JOIN [01_Projects] p
       ON c.Contractor_ID = p.Contractor_ID
GROUP BY c.Contractor_Name
ORDER BY Total_Projects DESC;


--7.What is the total road length constructed per county?
SELECT County,
       ROUND(SUM(Road_Length_KM),2) AS Total_Road_Length_KM
FROM [01_Projects]
GROUP BY County;


--8.Which funding source has financed the most projects?
SELECT Funding_Source,
       COUNT(*) AS Project_Count
FROM [01_Projects]
GROUP BY Funding_Source
ORDER BY Project_Count DESC;


--9.What is the average project duration?
SELECT AVG(DATEDIFF(DAY, Start_Date, End_Date)) 
       AS Avg_Project_Duration_Days
FROM [01_Projects];


--10.Rank projects by highest budget.
SELECT Project_Name,
       Budget_KES,
       RANK() OVER (ORDER BY Budget_KES DESC) AS Budget_Rank
FROM [01_Projects];

