// File: SMSReport.java
package com.example.wildtrails.module;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "sms_reports")
public class SMSReport {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "report_id", unique = true, nullable = false)
    private String reportId;

    @Column(name = "booking_id", nullable = false)
    private Long bookingId;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "finance_officer_id")
    private Long financeOfficerId;

    @Column(name = "report_type", nullable = false)
    private String reportType;

    @Column(name = "status")
    private String status = "PENDING";

    @Column(name = "request_date")
    private LocalDateTime requestDate;

    @Column(name = "generated_date")
    private LocalDateTime generatedDate;

    @Column(name = "report_content", columnDefinition = "TEXT")
    private String reportContent;

    @Column(name = "total_cost")
    private Double totalCost;

    @Column(name = "message_to_user", columnDefinition = "TEXT")
    private String messageToUser;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Constructors
    public SMSReport() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        this.requestDate = LocalDateTime.now();
    }

    public SMSReport(String reportId, Long bookingId, Long userId, String reportType) {
        this();
        this.reportId = reportId;
        this.bookingId = bookingId;
        this.userId = userId;
        this.reportType = reportType;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getReportId() { return reportId; }
    public void setReportId(String reportId) { this.reportId = reportId; }

    public Long getBookingId() { return bookingId; }
    public void setBookingId(Long bookingId) { this.bookingId = bookingId; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public Long getFinanceOfficerId() { return financeOfficerId; }
    public void setFinanceOfficerId(Long financeOfficerId) { this.financeOfficerId = financeOfficerId; }

    public String getReportType() { return reportType; }
    public void setReportType(String reportType) { this.reportType = reportType; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getRequestDate() { return requestDate; }
    public void setRequestDate(LocalDateTime requestDate) { this.requestDate = requestDate; }

    public LocalDateTime getGeneratedDate() { return generatedDate; }
    public void setGeneratedDate(LocalDateTime generatedDate) { this.generatedDate = generatedDate; }

    public String getReportContent() { return reportContent; }
    public void setReportContent(String reportContent) { this.reportContent = reportContent; }

    public Double getTotalCost() { return totalCost; }
    public void setTotalCost(Double totalCost) { this.totalCost = totalCost; }

    public String getMessageToUser() { return messageToUser; }
    public void setMessageToUser(String messageToUser) { this.messageToUser = messageToUser; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    @PreUpdate
    public void setUpdatedAt() {
        this.updatedAt = LocalDateTime.now();
    }
}