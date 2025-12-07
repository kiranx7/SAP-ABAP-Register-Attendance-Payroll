# SAP-ABAP-Register-Attendance-Payroll
# SAP ABAP Mini Project – Employee Attendance & Salary Management System
# Project Overview
This mini project contains SAP ABAP programs developed to manage employee attendance and automated salary generation. The system maintains employee records, tracks daily login/leave, and generates a monthly salary slip based on present and leave days.

# Programs Included
1.ZEMP_ENTRY
program to add employee master details such as name, age, gender, salary etc.
2.ZEMP_ATTENDANCE
Program to mark employee attendance — login (present) or leave — with validations to prevent duplicate entries for the same day.
3.ZEMP_SALARY_CALC
Program to calculate salary for a selected month and generate a salary slip based on attendance data.

# ABAP Concepts Used
	•	PARAMETERS and LISTBOX dropdown
	•	Internal Tables and Work Areas
	•	DATE & TIME processing (sy-datum, sy-uzeit)
	•	UPDATE / INSERT database operations
	•	SELECT SINGLE / COUNT statements
	•	Validations with MESSAGE keyword
	•	String concatenation for Slip-ID
	•	Report output formatting using WRITE

# Tools & Environment
	•	SAP ABAP
	•	SAP GUI
	•	ABAP Workbench (SE38 / SE11 / SE80)

# Purpose
This project was developed for learning and practice purposes, focused on understanding:
	•	CRUD operations on custom tables
	•	Logical validations in attendance workflow
	•	Salary calculation logic based on business rules
	•	Real-time HR & Payroll use-case using SAP ABAP
