-- ============================================================================
-- SETUP SAMPLE DATA FOR SSRS REPORT TEMPLATE: WorkDashBoard_Template
-- Target: Microsoft SQL Server (MSSQL 2016+)
--
-- Description:
-- Creates the database [WorkDashBoard], two source tables 
-- (EmployeeGoals and EmployeePerformance), views for the SSRS datasets,
-- and inserts mock demonstration test data.
--
-- Datasets created:
-- 1. Goals: Contains Employee and Goal (numeric target)
-- 2. Performance: Contains Employee and Performance (numeric achieved total)
--
-- LEGAL DISCLAIMER / FICTITIOUS DATA NOTICE:
-- All names, employee identities, companies, figures, and transaction descriptions
-- in this script are entirely fictitious and created strictly for demonstration,
-- evaluation, and testing purposes. Any resemblance to real persons (living or
-- deceased), actual companies, contracts, or real-world events is purely coincidental.
--
-- USE AT YOUR OWN RISK:
-- This script creates a database and database objects. It is provided "AS IS"
-- without warranty of any kind. The author assumes no liability or responsibility
-- for any server errors, performance degradation, data loss, or system issues.
-- Always inspect and test thoroughly in a dedicated development/sandbox environment
-- before running on any shared or production SQL Server instance.
-- ============================================================================

USE [master];
GO

-- 1. Create Database if it does not exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'WorkDashBoard')
BEGIN
    CREATE DATABASE [WorkDashBoard];
    PRINT 'Database [WorkDashBoard] created.';
END
ELSE
BEGIN
    PRINT 'Database [WorkDashBoard] already exists.';
END
GO

USE [WorkDashBoard];
GO

-- 2. Clean up existing objects if re-running
IF OBJECT_ID('dbo.vw_SSRS_Goals', 'V') IS NOT NULL DROP VIEW dbo.vw_SSRS_Goals;
IF OBJECT_ID('dbo.vw_SSRS_Performance', 'V') IS NOT NULL DROP VIEW dbo.vw_SSRS_Performance;
IF OBJECT_ID('dbo.EmployeePerformance', 'U') IS NOT NULL DROP TABLE dbo.EmployeePerformance;
IF OBJECT_ID('dbo.EmployeeGoals', 'U') IS NOT NULL DROP TABLE dbo.EmployeeGoals;
PRINT 'Cleaned up any previous table/view objects.';
GO

-- 3. Create Table: EmployeeGoals
-- Stores individual employee targets
CREATE TABLE dbo.EmployeeGoals (
    Employee NVARCHAR(100) NOT NULL PRIMARY KEY,
    Goal DECIMAL(12, 2) NOT NULL
);
PRINT 'Table dbo.EmployeeGoals created.';
GO

-- 4. Create Table: EmployeePerformance
-- Stores granular performance records / transactions per employee
CREATE TABLE dbo.EmployeePerformance (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Employee NVARCHAR(100) NOT NULL,
    Performance DECIMAL(12, 2) NOT NULL,
    PerformanceDate DATE NOT NULL,
    Description NVARCHAR(250) NULL
);
PRINT 'Table dbo.EmployeePerformance created.';
GO

-- 5. Insert Employee Goals
INSERT INTO dbo.EmployeeGoals (Employee, Goal) VALUES
(N'Jan Kowalski', 100000.00),
(N'Anna Kowalczyk', 120000.00),
(N'Piotr Nowak', 90000.00),
(N'Maria Wisniewska', 110000.00),
(N'Tomasz Mazur', 85000.00),
(N'Michal Wojcik', 95000.00),
(N'Agnieszka Kaczmarek', 105000.00),
(N'Kamil Nowakowski', 80000.00),
(N'Piotr Zielinski', 100000.00),
(N'Ewa Wozniak', 115000.00),
(N'Krzysztof Szymanski', 75000.00),
(N'Barbara Kozlowska', 90000.00);
PRINT 'Inserted 12 employee goals.';
GO

-- 6. Insert Granular Performance Records
-- Distributed across different days of the month to reflect realistic daily activity
-- Coverage includes:
--   - Overachievers (>100% -> Scrat holds acorn 'veverka_ma_orisek')
--   - Near Goal (80% - 99% -> Warning / In Progress)
--   - Underperforming (<80% -> Scrat reaching for acorn 'veverka3')
INSERT INTO dbo.EmployeePerformance (Employee, Performance, PerformanceDate, Description) VALUES
-- Jan Kowalski (Goal: 100,000 | Total: 118,500 = 118.5% -> MET GOAL)
(N'Jan Kowalski', 28500.00, '2026-08-05', N'Contract closed - Client A'),
(N'Jan Kowalski', 35000.00, '2026-08-12', N'Contract closed - Client B'),
(N'Jan Kowalski', 22000.00, '2026-08-19', N'Contract closed - Client C'),
(N'Jan Kowalski', 33000.00, '2026-08-26', N'Contract closed - Client D'),

-- Anna Kowalczyk (Goal: 120,000 | Total: 135,200 = 112.7% -> MET GOAL)
(N'Anna Kowalczyk', 41200.00, '2026-08-04', N'Major enterprise deal'),
(N'Anna Kowalczyk', 38000.00, '2026-08-11', N'Mid-market renewal'),
(N'Anna Kowalczyk', 29000.00, '2026-08-18', N'Expansion package'),
(N'Anna Kowalczyk', 27000.00, '2026-08-25', N'Consulting services'),

-- Piotr Nowak (Goal: 90,000 | Total: 98,400 = 109.3% -> MET GOAL)
(N'Piotr Nowak', 24400.00, '2026-08-06', N'Standard license order'),
(N'Piotr Nowak', 31000.00, '2026-08-13', N'Upgrade package'),
(N'Piotr Nowak', 23000.00, '2026-08-20', N'Maintenance agreement'),
(N'Piotr Nowak', 20000.00, '2026-08-27', N'Add-on module'),

-- Maria Wisniewska (Goal: 110,000 | Total: 112,000 = 101.8% -> MET GOAL)
(N'Maria Wisniewska', 32000.00, '2026-08-07', N'Regional contract'),
(N'Maria Wisniewska', 28000.00, '2026-08-14', N'Support contract'),
(N'Maria Wisniewska', 27000.00, '2026-08-21', N'Customization project'),
(N'Maria Wisniewska', 25000.00, '2026-08-28', N'Pilot rollout'),

-- Tomasz Mazur (Goal: 85,000 | Total: 82,100 = 96.6% -> NEAR GOAL)
(N'Tomasz Mazur', 21100.00, '2026-08-05', N'Direct sale'),
(N'Tomasz Mazur', 19000.00, '2026-08-12', N'Platform subscription'),
(N'Tomasz Mazur', 22000.00, '2026-08-19', N'Hardware order'),
(N'Tomasz Mazur', 20000.00, '2026-08-26', N'Cloud migration fee'),

-- Michal Wojcik (Goal: 95,000 | Total: 88,350 = 93.0% -> NEAR GOAL)
(N'Michal Wojcik', 25350.00, '2026-08-04', N'Corporate agreement'),
(N'Michal Wojcik', 21000.00, '2026-08-11', N'Annual license'),
(N'Michal Wojcik', 22000.00, '2026-08-18', N'Training program'),
(N'Michal Wojcik', 20000.00, '2026-08-25', N'Consulting block'),

-- Agnieszka Kaczmarek (Goal: 105,000 | Total: 91,800 = 87.4% -> NEAR GOAL)
(N'Agnieszka Kaczmarek', 23800.00, '2026-08-06', N'SaaS bundle'),
(N'Agnieszka Kaczmarek', 26000.00, '2026-08-13', N'Professional services'),
(N'Agnieszka Kaczmarek', 21000.00, '2026-08-20', N'Department expansion'),
(N'Agnieszka Kaczmarek', 21000.00, '2026-08-27', N'Technical support'),

-- Kamil Nowakowski (Goal: 80,000 | Total: 67,500 = 84.4% -> NEAR GOAL)
(N'Kamil Nowakowski', 18500.00, '2026-08-07', N'Basic subscription'),
(N'Kamil Nowakowski', 17000.00, '2026-08-14', N'Renewal tier 2'),
(N'Kamil Nowakowski', 16000.00, '2026-08-21', N'Implementation setup'),
(N'Kamil Nowakowski', 16000.00, '2026-08-28', N'Service pack'),

-- Piotr Zielinski (Goal: 100,000 | Total: 72,000 = 72.0% -> BEHIND GOAL)
(N'Piotr Zielinski', 20000.00, '2026-08-05', N'Pilot project'),
(N'Piotr Zielinski', 18000.00, '2026-08-12', N'Starter package'),
(N'Piotr Zielinski', 17000.00, '2026-08-19', N'Trial license converted'),
(N'Piotr Zielinski', 17000.00, '2026-08-26', N'Onboarding retainer'),

-- Ewa Wozniak (Goal: 115,000 | Total: 79,350 = 69.0% -> BEHIND GOAL)
(N'Ewa Wozniak', 22350.00, '2026-08-04', N'Entry license'),
(N'Ewa Wozniak', 19000.00, '2026-08-11', N'Basic support'),
(N'Ewa Wozniak', 20000.00, '2026-08-18', N'Renewal tier 1'),
(N'Ewa Wozniak', 18000.00, '2026-08-25', N'Integration plugin'),

-- Krzysztof Szymanski (Goal: 75,000 | Total: 48,000 = 64.0% -> BEHIND GOAL)
(N'Krzysztof Szymanski', 14000.00, '2026-08-06', N'Security audit license'),
(N'Krzysztof Szymanski', 12000.00, '2026-08-13', N'Workshop fee'),
(N'Krzysztof Szymanski', 11000.00, '2026-08-20', N'User license pack'),
(N'Krzysztof Szymanski', 11000.00, '2026-08-27', N'Support ticket bundle'),

-- Barbara Kozlowska (Goal: 90,000 | Total: 52,200 = 58.0% -> BEHIND GOAL)
(N'Barbara Kozlowska', 15200.00, '2026-08-07', N'Introductory tier'),
(N'Barbara Kozlowska', 13000.00, '2026-08-14', N'Consultation session'),
(N'Barbara Kozlowska', 12000.00, '2026-08-21', N'User seats addition'),
(N'Barbara Kozlowska', 12000.00, '2026-08-28', N'Maintenance add-on');

PRINT 'Inserted 48 granular performance transactions.';
GO

-- 7. Create SSRS Views (Providing the 2 Datasets)

-- View 1: vw_SSRS_Goals
-- Supplies the 'Goals' dataset and employee list for report parameters
CREATE OR ALTER VIEW dbo.vw_SSRS_Goals AS
SELECT 
    Employee,
    Goal
FROM dbo.EmployeeGoals;
GO
PRINT 'View dbo.vw_SSRS_Goals created.';
GO

-- View 2: vw_SSRS_Performance
-- Supplies the 'Performance' dataset with aggregated actual values per worker
CREATE OR ALTER VIEW dbo.vw_SSRS_Performance AS
SELECT 
    Employee,
    CAST(SUM(Performance) AS DECIMAL(12,2)) AS Performance
FROM dbo.EmployeePerformance
GROUP BY Employee;
GO
PRINT 'View dbo.vw_SSRS_Performance created.';
GO

-- 8. Verification Query
-- Run this to view the exact data that SSRS will consume
PRINT '============================================================';
PRINT 'VERIFICATION: Overview of Goals vs Actual Performance';
PRINT '============================================================';

SELECT 
    g.Employee,
    g.Goal,
    ISNULL(p.Performance, 0.00) AS Performance,
    ISNULL(p.Performance, 0.00) - g.Goal AS Variance,
    CAST(ROUND((ISNULL(p.Performance, 0.00) / NULLIF(g.Goal, 0)) * 100.0, 1) AS DECIMAL(5,1)) AS [Achievement_%],
    CASE 
        WHEN ISNULL(p.Performance, 0.00) >= g.Goal THEN N'MET GOAL (Scrat with Acorn)'
        WHEN ISNULL(p.Performance, 0.00) >= g.Goal * 0.80 THEN N'NEAR GOAL (In Progress)'
        ELSE N'BEHIND (Scrat Reaching)'
    END AS Status_Indicator
FROM dbo.vw_SSRS_Goals g
LEFT JOIN dbo.vw_SSRS_Performance p ON g.Employee = p.Employee
ORDER BY [Achievement_%] DESC;

-- Overall Totals
SELECT 
    N'TOTAL TEAM OVERALL' AS Summary,
    SUM(g.Goal) AS Total_Goal,
    SUM(p.Performance) AS Total_Performance,
    SUM(p.Performance) - SUM(g.Goal) AS Total_Variance,
    CAST(ROUND((SUM(p.Performance) / NULLIF(SUM(g.Goal), 0)) * 100.0, 1) AS DECIMAL(5,1)) AS [Total_Achievement_%]
FROM dbo.vw_SSRS_Goals g
LEFT JOIN dbo.vw_SSRS_Performance p ON g.Employee = p.Employee;
GO
