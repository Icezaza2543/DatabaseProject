# CPE Computer Engineering Graduate Standard Database Management System

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-success?style=for-the-badge)

An industrial-grade, full-featured **Relational Database Management & Analytics System** engineered for the Computer Engineering (CPE) 3rd Year Database System Course.

---

## 🏛️ System Architecture & Engineering Highlights

This codebase has been fully refactored into **Clean Architecture** with complete separation of concerns:

```
lib/
├── core/
│   ├── constants/           # Centralized design tokens & palette (AppColors)
│   ├── engine/              # In-Memory Relational Engine & Indexing System
│   │   ├── database_engine.dart # Relational Storage & Index Operations
│   │   ├── index_manager.dart   # Primary Hash Index O(1) & Secondary Inverted Lists
│   │   └── sql_parser.dart      # SQL Query Parser & Execution Engine
│   └── utils/               # Form Validators (GPA bounds, ID Regex, Email)
├── domain/
│   ├── entities/            # 3NF Relational Entities (Student, Department, Course, Enrollment)
│   └── repositories/        # Abstract Repository Contracts (IDatabaseRepository)
├── data/
│   ├── repositories/        # Repository Concrete Implementation
│   └── sample_data.dart     # Seed dataset for CPE Engineering Faculties
├── presentation/
│   ├── providers/           # Reactive State Management (DatabaseProvider)
│   ├── screens/             # UI Screens (Records Table, Analytics Charts, SQL Console)
│   └── widgets/             # Dialog Modals & Metric Cards
└── main.dart                # Application Entry Point
```

---

## 🚀 Key Features

### 1. 3NF Relational Data Model & Indexing Engine
- **Normalized Schema**: `Students`, `Departments`, `Courses`, and `Enrollments`.
- **Indexing Engine**: 
  - Primary Key Hash Index for **$O(1)$** lookup by Student ID.
  - Secondary Inverted List Indexing on `departmentId` and `major`.
- **Data Integrity Constraints**: Primary key uniqueness enforcement, Foreign key validation, GPA range checking ($0.00 \le GPA \le 4.00$), and 8-digit Student ID regex validation.

### 2. Interactive SQL Query Console
- Live SQL Execution Terminal capable of parsing and executing:
  - `SELECT * FROM students WHERE gpa >= 3.5 ORDER BY gpa DESC;`
  - `SELECT * FROM students WHERE major = 'CPE';`
  - `SELECT * FROM departments;`
- Displays query execution latency (in milliseconds) and output data grid.

### 3. Data Analytics & Visualization Dashboard
- **GPA Distribution Histogram**: Rendered dynamically using `fl_chart`.
- **Department Enrolment Share**: Dynamic pie chart breakdown across CPE, SKE, EE, ME, and CE.
- **KPI Summary Cards**: Real-time mean GPA, total enrollment, first-class honors, and probation alerts.

### 4. Advanced Student Records Management
- Instant Search across Name, Student ID, and Email.
- Major Filter Chips (CPE, SKE, EE, ME, CE).
- Multi-column Sorting (ID, Name, GPA, Admission Year).
- Detailed Student Academic Transcript view.

---

## 🏃 Getting Started

1. Clone repository:
   ```bash
   git clone https://github.com/Icezaza2543/DatabaseProject.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```
