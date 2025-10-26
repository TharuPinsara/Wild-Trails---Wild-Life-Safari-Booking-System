# Wild-Life Safari Trip Management System 🦒🌿

![ Safari Banner](https://via.placeholder.com/1200x300.png?text=Wild-Life+Safari+System) <!-- Replace with actual banner image URL -->

A web-based platform to streamline safari trip operations, enabling seamless trip planning, booking, and management for tourists, guides, drivers, and administrators.

---

## 🚀 Overview

The **Wild-Life Safari Trip Management System** automates and simplifies safari operations. Tourists can plan and book trips online, while administrators, guides, drivers, finance officers, and insurance officers manage trips, vehicles, wildlife reports, invoices, and insurance with ease.

---

## 🎯 System Purpose

This system digitizes and optimizes key safari management processes, including:

- 🗺️ Trip creation, approval, and scheduling
- 💳 Online booking and secure payment processing
- 🚗 Vehicle and guide allocation
- 🦒 Wildlife spotting and detailed reporting
- 📄 Automated invoice and report generation
- 🛡️ Insurance policy and claims management

It enhances coordination, improves accuracy, and provides a user-friendly experience for all stakeholders.

---

## 👥 Major Stakeholders

| Role               | Responsibilities                                      |
|--------------------|-----------------------------------------------------|
| **Tourist**        | Registers, books trips, and makes payments          |
| **Safari Manager**აშ| Approves trips, assigns guides, drivers, and vehicles |
| **Driver**         | Views trips, reports vehicle issues, updates status |
| **Guide**          | Logs wildlife sightings, uploads trip reports       |
| **Finance Officer**| Manages invoices, payments, and revenue reports     |
| **Insurance Officer** | Handles insurance policies and claims            |

---

## 🔧 Functional Features

- 🔒 Role-based authentication and secure login
- 📅 Trip creation, scheduling, and real-time status tracking
- 🛒 Online booking and payment gateway integration
- 🚙 Vehicle and equipment allocation with maintenance tracking
- 🐘 Wildlife sighting logging with species, time, and location
- 📊 Automated invoice generation and detailed reporting
- 🛡️ Insurance management with claim processing and alerts
- 🔔 Notification system for trip updates and confirmations

---

## 🏗️ System Architecture

The system follows a layered architecture:

- **Web Interface**: User-facing frontend for tourists, drivers, guides, managers, and officers.
- **Application Server**: Handles business logic, processes requests, and manages interactions.
- **Database**: Stores user data, trip details, bookings, payments, and reports.

### Technologies Used
- **Frontend**: HTML, Tailwind CSS
- **Backend**:Java
- **Database**: Microsoft SQL
- **Hosting**: SpringBoot

---

## 🗃️ Entity Overview

- **User**: Subtypes include Tourist, Manager, Driver, Guide, Finance Officer, Insurance Officer
- **Trip**: Stores destination, date, capacity, status, and approvals
- **TripDetails**: Links trips with assigned drivers, guides, and vehicles
- **Booking**: Manages trip and tourist details with payment references
- **Payment**: Tracks method, amount, and transaction details
- **Invoice**: Auto-generated post-booking or trip completion
- **Vehicle & Equipment**: Monitors allocation, maintenance, and condition
- **Insurance**: Handles policies, claims, and officer assignments
- **WildlifeSighting**: Logs species, time, location-Wesleyanlocation, and guide notes

---

## ⚙️ Non-Functional Requirements

- **Performance**: Optimized database queries for fast response times
- **Usability**: Intuitive, role-specific interfaces
- **Security**: Role-based access control and encrypted data
- **Reliability**: Regular backups with high uptime
- **Scalability**: Modular design for future enhancements

---

### Installation Steps
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/Safari-Trip-Management-System.git
   cd Safari-Trip-Management-System
  '''
  ### 👷 Contributors

| Name                     | Role                                                    |
|--------------------------|---------------------------------------------------------|
| **Wijekoon S.P.A.S.A**   | Developer – Customer Booking Management                 |
| **Vithanage R.A.I**      | Product Owner, Developer – Wildlife Spotting Management |
| **Dewmith H.L.T.P**      | Scrum Master, Developer – Vehicle and Driver Management |
| **Rupasingha R.S.M.P.S** | Developer – Insurance Management                        |
| **Venura Kithpura W.K**  | Developer – Trip Management                             |
| **Hisham M**             | Developer – Invoice/Report Management                   |
