//
//  PCRFormatter.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/9/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Modern patient transfer document for EMT handoff!
//

import Foundation
import SwiftUI
import UIKit
import PDFKit

/// Modern PDF formatter for patient transfer - designed for AirDrop to EMTs
/// Focuses on key transfer-critical information in a clean, modern design
@MainActor
class PCRFormatter {
    
    // MARK: - PDF Configuration
    
    struct PDFConfig {
        // Standard US Letter size at 72 DPI
        static let pageWidth: CGFloat = 612  // 8.5 inches
        static let pageHeight: CGFloat = 792 // 11 inches
        static let margin: CGFloat = 0  // No margins - fill entire page
        static let contentWidth: CGFloat = pageWidth  // Full page width
        static let contentPadding: CGFloat = 16  // Internal padding
    }
    
    // MARK: - Modern SwiftUI PDF Generation
    
    /// Generates a beautiful, modern patient transfer document
    /// Designed for quick EMT handoff - shows only critical information
    static func generatePDF(for note: SOAPNote) -> Data? {
        guard let documentImage = renderTransferDocumentImage(for: note) else {
            print("Error: Unable to render transfer document image")
            return nil
        }
        
        return renderSinglePagePDF(from: documentImage)
    }
    
    /// Renders the SwiftUI transfer document content into a UIImage
    private static func renderTransferDocumentImage(for note: SOAPNote) -> UIImage? {
        // Render content to fill full page width with internal padding
        let content = PatientTransferDocumentContent(
            note: note,
            layoutStyle: TransferLayoutStyle.condensed
        )
        .padding(.horizontal, PDFConfig.contentPadding)
        .padding(.vertical, PDFConfig.contentPadding)
        .frame(width: PDFConfig.contentWidth, alignment: Alignment.top)
        .background(SwiftUI.Color.white)
        
        let renderer = ImageRenderer(content: content)
        let screenScale: CGFloat = {
            if let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first {
                return windowScene.screen.scale
            }
            if let sessionScene = UIApplication.shared.openSessions
                .compactMap({ $0.scene as? UIWindowScene })
                .first {
                return sessionScene.screen.scale
            }
            return 2.0
        }()
        renderer.scale = screenScale
        // Let content render at natural height
        renderer.proposedSize = ProposedViewSize(width: PDFConfig.contentWidth, height: nil)
        renderer.isOpaque = true
        
        return renderer.uiImage
    }
    
    /// Embeds the rendered image into a single-page PDF, filling the entire page edge-to-edge
    private static func renderSinglePagePDF(from image: UIImage) -> Data? {
        let pageRect = CGRect(x: 0, y: 0, width: PDFConfig.pageWidth, height: PDFConfig.pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        
        return renderer.pdfData { context in
            context.beginPage()
            // Fill entire page with white background
            context.cgContext.setFillColor(UIColor.white.cgColor)
            context.cgContext.fill(pageRect)
            
            // Calculate scale to fill entire page edge-to-edge (aspect fill)
            // Use max scale to ensure content fills the page completely
            let widthScale = PDFConfig.pageWidth / image.size.width
            let heightScale = PDFConfig.pageHeight / image.size.height
            
            // Use max scale for aspect fill - this ensures content fills the entire page
            // maintaining aspect ratio but eliminating white borders
            let scale = max(widthScale, heightScale)
            
            let scaledSize = CGSize(
                width: image.size.width * scale,
                height: image.size.height * scale
            )
            
            // Center the scaled image on page (may extend slightly beyond edges, which is fine)
            let xOffset = (PDFConfig.pageWidth - scaledSize.width) / 2
            let yOffset = (PDFConfig.pageHeight - scaledSize.height) / 2
            
            // Clip to page bounds to prevent overflow
            context.cgContext.clip(to: pageRect)
            
            // Draw scaled image - this will fill the entire page
            image.draw(in: CGRect(
                x: xOffset,
                y: yOffset,
                width: scaledSize.width,
                height: scaledSize.height
            ))
        }
    }
    
    // MARK: - Modern SOAP Note Form PDF
    
    /// Generates a modern SOAP note form PDF with clean SwiftUI-inspired design
    /// Professional medical documentation in a beautiful, organized layout
    static func generateStandardFormPDF(for note: SOAPNote) -> Data? {
        let pageRect = CGRect(x: 0, y: 0, width: PDFConfig.pageWidth, height: PDFConfig.pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        
        return renderer.pdfData { context in
            var pageNumber = 1
            var yPosition: CGFloat = 30
            let leftMargin: CGFloat = 40
            let contentWidth = PDFConfig.pageWidth - (leftMargin * 2)
            let lineHeight: CGFloat = 18
            let fieldSpacing: CGFloat = 12
            let cardPadding: CGFloat = 16
            let bottomMargin: CGFloat = 60 // Space for footer
            
            // Helper function to start a new page - returns the new Y position
            func beginNewPage() -> CGFloat {
                context.beginPage()
                pageNumber += 1
                let newYPosition: CGFloat = 30
                yPosition = newYPosition
                
                // Fill page background
                context.cgContext.setFillColor(UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0).cgColor)
                context.cgContext.fill(pageRect)
                
                // Draw page header for subsequent pages
                if pageNumber > 1 {
                    let pageHeaderFont = UIFont.systemFont(ofSize: 10, weight: .medium)
                    let pageHeaderAttributes: [NSAttributedString.Key: Any] = [
                        .font: pageHeaderFont,
                        .foregroundColor: UIColor.systemGray
                    ]
                    let pageHeaderText = "SOAP Notes - Page \(pageNumber)"
                    let headerSize = NSString(string: pageHeaderText).size(withAttributes: pageHeaderAttributes)
                    NSString(string: pageHeaderText).draw(at: CGPoint(x: (PDFConfig.pageWidth - headerSize.width) / 2, y: 10), withAttributes: pageHeaderAttributes)
                    
                    // Draw patient name if available
                    if let patientName = note.patientName {
                        let nameText = "Patient: \(patientName)"
                        NSString(string: nameText).draw(at: CGPoint(x: leftMargin, y: 10), withAttributes: pageHeaderAttributes)
                    }
                }
                
                return newYPosition
            }
            
            // Helper function to check if we need a new page
            func checkPageBreak(requiredHeight: CGFloat) {
                if yPosition + requiredHeight > PDFConfig.pageHeight - bottomMargin {
                    yPosition = beginNewPage()
                }
            }
            
            // Start first page
            yPosition = beginNewPage()
            
            // Modern header section with icon and title (only on first page)
            if pageNumber == 1 {
                let headerHeight: CGFloat = 100
                checkPageBreak(requiredHeight: headerHeight + 20)
                
                // Draw header card background
                let headerRect = CGRect(x: leftMargin, y: yPosition, width: contentWidth, height: headerHeight)
                context.cgContext.setFillColor(UIColor.systemBlue.cgColor)
                let headerPath = UIBezierPath(roundedRect: headerRect, cornerRadius: 12)
                context.cgContext.addPath(headerPath.cgPath)
                context.cgContext.fillPath()
                
                // Draw icon circle (medical cross)
                let iconSize: CGFloat = 50
                let iconY = yPosition + (headerHeight - iconSize) / 2
                let iconCircleRect = CGRect(x: leftMargin + 20, y: iconY, width: iconSize, height: iconSize)
                context.cgContext.setFillColor(UIColor.white.withAlphaComponent(0.2).cgColor)
                context.cgContext.fillEllipse(in: iconCircleRect)
                
                // Draw medical cross symbol using SF Symbols-like shape
                let crossSize: CGFloat = 24
                let crossX = leftMargin + 20 + (iconSize - crossSize) / 2
                let crossY = iconY + (iconSize - crossSize) / 2
                
                // Vertical bar of cross
                let verticalBar = CGRect(x: crossX + crossSize / 3, y: crossY, width: crossSize / 3, height: crossSize)
                context.cgContext.setFillColor(UIColor.white.cgColor)
                context.cgContext.fill(verticalBar)
                
                // Horizontal bar of cross
                let horizontalBar = CGRect(x: crossX, y: crossY + crossSize / 3, width: crossSize, height: crossSize / 3)
                context.cgContext.fill(horizontalBar)
                
                // Title - "SOAP NOTES"
        let titleAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 28, weight: .bold),
                    .foregroundColor: UIColor.white
                ]
                let titleText = "SOAP NOTES"
                NSString(string: titleText).draw(at: CGPoint(x: leftMargin + 85, y: yPosition + 25), withAttributes: titleAttributes)
        
        // Subtitle
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 14, weight: .medium),
                    .foregroundColor: UIColor.white.withAlphaComponent(0.9)
                ]
                let subtitleText = "Wilderness First Responder Patient Care Report"
                NSString(string: subtitleText).draw(at: CGPoint(x: leftMargin + 85, y: yPosition + 58), withAttributes: subtitleAttributes)
                
                yPosition += headerHeight + 20
            }
            
            // Patient Info Card
            checkPageBreak(requiredHeight: 150) // Estimate for patient info card
            yPosition = drawModernCardWithPageBreak(
                context: context,
                title: "Patient Information",
                icon: "person.fill",
                color: UIColor.systemBlue,
                yPosition: yPosition,
                leftMargin: leftMargin,
                contentWidth: contentWidth,
                cardPadding: cardPadding,
                lineHeight: lineHeight,
                pageHeight: PDFConfig.pageHeight,
                bottomMargin: bottomMargin,
                checkPageBreak: checkPageBreak,
                beginNewPage: beginNewPage,
                setCurrentYPosition: { yPosition = $0 }
            ) { yPos in
                var currentY = yPos
                let fieldFont = UIFont.systemFont(ofSize: 11, weight: .regular)
                let labelFont = UIFont.systemFont(ofSize: 9, weight: .semibold)
                
                // Name
        if let name = note.patientName {
                    currentY = drawModernFieldRow(
                        context: context,
                        label: "NAME",
                        value: name,
                        yPosition: currentY,
                        xPosition: leftMargin + cardPadding,
                        labelFont: labelFont,
                        valueFont: fieldFont,
                        lineHeight: lineHeight
                    )
                    currentY += fieldSpacing
                }
                
                // Age and Sex on same row
                let rowY = currentY
        if let age = note.patientAge {
                    currentY = drawModernFieldRow(
                        context: context,
                        label: "AGE",
                        value: "\(age) years",
                        yPosition: rowY,
                        xPosition: leftMargin + cardPadding,
                        labelFont: labelFont,
                        valueFont: fieldFont,
                        lineHeight: lineHeight
                    )
        }
        
        if let sex = note.patientSex {
                    _ = drawModernFieldRow(
                        context: context,
                        label: "SEX",
                        value: sex.rawValue,
                        yPosition: rowY,
                        xPosition: leftMargin + cardPadding + (contentWidth / 2),
                        labelFont: labelFont,
                        valueFont: fieldFont,
                        lineHeight: lineHeight
                    )
                }
                currentY += lineHeight + fieldSpacing
                
                // Weight
        if let weight = note.patientWeight {
            let weightKg = weight * 0.453592
                    currentY = drawModernFieldRow(
                        context: context,
                        label: "WEIGHT",
                        value: String(format: "%.0f lbs (%.1f kg)", weight, weightKg),
                        yPosition: currentY,
                        xPosition: leftMargin + cardPadding,
                        labelFont: labelFont,
                        valueFont: fieldFont,
                        lineHeight: lineHeight
                    )
                    currentY += fieldSpacing
                }
                
                // Date/Time
                currentY = drawModernFieldRow(
                    context: context,
                    label: "REPORT DATE/TIME",
                    value: note.createdDate.formatted(date: .abbreviated, time: .shortened),
                    yPosition: currentY,
                    xPosition: leftMargin + cardPadding,
                    labelFont: labelFont,
                    valueFont: fieldFont,
                    lineHeight: lineHeight
                )
                
                return currentY + fieldSpacing
            }
            
            yPosition += 15
            
            // SUBJECTIVE Section
            checkPageBreak(requiredHeight: 200) // Estimate for subjective section
            yPosition = drawModernCardWithPageBreak(
                context: context,
                title: "Subjective",
                icon: "bubble.left.fill",
                color: UIColor.systemOrange,
                yPosition: yPosition,
                leftMargin: leftMargin,
                contentWidth: contentWidth,
                cardPadding: cardPadding,
                lineHeight: lineHeight,
                pageHeight: PDFConfig.pageHeight,
                bottomMargin: bottomMargin,
                checkPageBreak: checkPageBreak,
                beginNewPage: beginNewPage,
                setCurrentYPosition: { yPosition = $0 }
            ) { yPos in
                var currentY = yPos
                let fieldFont = UIFont.systemFont(ofSize: 11)
                let labelFont = UIFont.systemFont(ofSize: 9, weight: .semibold)
                
                // Chief complaint (CC)
                currentY = drawModernFieldRow(context: context, label: "CHIEF COMPLAINT", value: note.signsSymptoms, yPosition: currentY, xPosition: leftMargin + cardPadding, labelFont: labelFont, valueFont: fieldFont, lineHeight: lineHeight)
                currentY += fieldSpacing
                
                // Allergies
                currentY = drawModernFieldRow(context: context, label: "ALLERGIES", value: note.allergies, yPosition: currentY, xPosition: leftMargin + cardPadding, labelFont: labelFont, valueFont: fieldFont, lineHeight: lineHeight)
                currentY += fieldSpacing
                
                // Medications
                currentY = drawModernFieldRow(context: context, label: "MEDICATIONS", value: note.medications, yPosition: currentY, xPosition: leftMargin + cardPadding, labelFont: labelFont, valueFont: fieldFont, lineHeight: lineHeight)
                currentY += fieldSpacing
                
                // Pre existing conditions
                currentY = drawModernFieldRow(context: context, label: "PERTINENT HISTORY", value: note.pertinentHistory, yPosition: currentY, xPosition: leftMargin + cardPadding, labelFont: labelFont, valueFont: fieldFont, lineHeight: lineHeight)
                currentY += fieldSpacing
                
                // Last ins/outs
                currentY = drawModernFieldRow(context: context, label: "LAST INS/OUTS", value: note.lastInOut, yPosition: currentY, xPosition: leftMargin + cardPadding, labelFont: labelFont, valueFont: fieldFont, lineHeight: lineHeight)
                currentY += fieldSpacing
                
                // Events prior
                currentY = drawModernFieldRow(context: context, label: "EVENTS PRIOR", value: note.events, yPosition: currentY, xPosition: leftMargin + cardPadding, labelFont: labelFont, valueFont: fieldFont, lineHeight: lineHeight)
                
                return currentY + fieldSpacing
            }
            
            yPosition += 15
            
            // OBJECTIVE Section with Vitals Table
            checkPageBreak(requiredHeight: 300) // Estimate for objective section with vitals
            yPosition = drawModernCardWithPageBreak(
                context: context,
                title: "Objective",
                icon: "waveform.path.ecg",
                color: UIColor.systemRed,
                yPosition: yPosition,
                leftMargin: leftMargin,
                contentWidth: contentWidth,
                cardPadding: cardPadding,
                lineHeight: lineHeight,
                pageHeight: PDFConfig.pageHeight,
                bottomMargin: bottomMargin,
                checkPageBreak: checkPageBreak,
                beginNewPage: beginNewPage,
                setCurrentYPosition: { yPosition = $0 }
            ) { yPos in
                var currentY = yPos
                
                // Modern vitals table
                let tableX = leftMargin + cardPadding
                let colWidth: CGFloat = 70
                let headerFont = UIFont.systemFont(ofSize: 9, weight: .bold)
                let headerAttributes: [NSAttributedString.Key: Any] = [
                    .font: headerFont,
                    .foregroundColor: UIColor.systemGray
                ]
                let valueFont = UIFont.systemFont(ofSize: 10, weight: .medium)
        
        // Table header
                NSString(string: "VITAL").draw(at: CGPoint(x: tableX, y: currentY), withAttributes: headerAttributes)
                NSString(string: "TIME 1").draw(at: CGPoint(x: tableX + colWidth * 1.5, y: currentY), withAttributes: headerAttributes)
                NSString(string: "TIME 2").draw(at: CGPoint(x: tableX + colWidth * 2.5, y: currentY), withAttributes: headerAttributes)
                NSString(string: "TIME 3").draw(at: CGPoint(x: tableX + colWidth * 3.5, y: currentY), withAttributes: headerAttributes)
                currentY += lineHeight + 5
                
                // Get up to 3 most recent vitals
                let sortedVitals = note.vitalSigns.sorted(by: { $0.timestamp > $1.timestamp }).prefix(3)
                let vitalsArray = Array(sortedVitals)
                
                // Draw modern vital rows with alternating background
                let vitalRows: [(String, (VitalSigns) -> String?)] = [
                    ("HR", { $0.heartRate.map { "\($0) bpm" } }),
                    ("RR", { $0.respiratoryRate.map { "\($0) /min" } }),
                    ("BP", { $0.bloodPressureString }),
                    ("SpO₂", { $0.oxygenSaturation.map { "\($0)%" } }),
                    ("Temp", { $0.temperature.map { String(format: "%.1f°F", ($0 * 9/5) + 32) } })
                ]
                
                for (index, (label, getter)) in vitalRows.enumerated() {
                    // Alternating row background
                    if index % 2 == 0 {
                        let rowRect = CGRect(x: tableX - 8, y: currentY - 2, width: contentWidth - (cardPadding * 2) + 16, height: lineHeight + 4)
                        context.cgContext.setFillColor(UIColor.systemGray6.cgColor)
                        let rowPath = UIBezierPath(roundedRect: rowRect, cornerRadius: 4)
                        context.cgContext.addPath(rowPath.cgPath)
                        context.cgContext.fillPath()
                    }
                    
                    currentY = drawModernVitalRow(context: context, label: label, vitals: vitalsArray, vitalKey: getter, yPosition: currentY, tableX: tableX, colWidth: colWidth, valueFont: valueFont, lineHeight: lineHeight)
                }
                
                // Additional assessments
                currentY += fieldSpacing
                let labelFont = UIFont.systemFont(ofSize: 9, weight: .semibold)
                let fieldFont = UIFont.systemFont(ofSize: 11)
        
        if let lor = note.levelOfResponsiveness {
                    currentY = drawModernFieldRow(context: context, label: "LEVEL OF RESPONSIVENESS", value: lor.rawValue, yPosition: currentY, xPosition: tableX, labelFont: labelFont, valueFont: fieldFont, lineHeight: lineHeight)
                    currentY += fieldSpacing
        }
        
        if let perrl = note.perrl {
                    currentY = drawModernFieldRow(context: context, label: "PERRL (Pupils Equal, Round, Reactive to Light)", value: perrl ? "Yes" : "No", yPosition: currentY, xPosition: tableX, labelFont: labelFont, valueFont: fieldFont, lineHeight: lineHeight)
                    currentY += fieldSpacing
        }
        
        if let sctm = note.sctm {
                    currentY = drawModernFieldRow(context: context, label: "SCTM (Skin Color, Temperature, Moisture)", value: sctm, yPosition: currentY, xPosition: tableX, labelFont: labelFont, valueFont: fieldFont, lineHeight: lineHeight)
                    currentY += fieldSpacing
        }
        
        if let csm = note.csm {
                    currentY = drawModernFieldRow(context: context, label: "CSM (Circulation, Sensation, Movement)", value: csm, yPosition: currentY, xPosition: tableX, labelFont: labelFont, valueFont: fieldFont, lineHeight: lineHeight)
                }
                
                return currentY + fieldSpacing
            }
            
            yPosition += 15
            
            // ASSESSMENT Section
            checkPageBreak(requiredHeight: 150) // Estimate for assessment section
            yPosition = drawModernCardWithPageBreak(
                context: context,
                title: "Assessment",
                icon: "stethoscope",
                color: UIColor.systemGreen,
                yPosition: yPosition,
                leftMargin: leftMargin,
                contentWidth: contentWidth,
                cardPadding: cardPadding,
                lineHeight: lineHeight,
                pageHeight: PDFConfig.pageHeight,
                bottomMargin: bottomMargin,
                checkPageBreak: checkPageBreak,
                beginNewPage: beginNewPage,
                setCurrentYPosition: { yPosition = $0 }
            ) { yPos in
                var currentY = yPos
                let fieldFont = UIFont.systemFont(ofSize: 11)
                let labelFont = UIFont.systemFont(ofSize: 9, weight: .semibold)
                
                // Assessment field
                currentY = drawModernFieldRow(context: context, label: "ASSESSMENT", value: note.assessment, yPosition: currentY, xPosition: leftMargin + cardPadding, labelFont: labelFont, valueFont: fieldFont, lineHeight: lineHeight)
                currentY += fieldSpacing
                
                // Anticipated worst case scenario
                currentY = drawModernFieldRow(context: context, label: "ANTICIPATED WORST CASE", value: note.anticipatedWorstCase, yPosition: currentY, xPosition: leftMargin + cardPadding, labelFont: labelFont, valueFont: fieldFont, lineHeight: lineHeight)
                
                return currentY + fieldSpacing
            }
            
            yPosition += 15
            
            // PLAN Section
            checkPageBreak(requiredHeight: 150) // Estimate for plan section
            yPosition = drawModernCardWithPageBreak(
                context: context,
                title: "Plan",
                icon: "checkmark.circle.fill",
                color: UIColor.systemPurple,
                yPosition: yPosition,
                leftMargin: leftMargin,
                contentWidth: contentWidth,
                cardPadding: cardPadding,
                lineHeight: lineHeight,
                pageHeight: PDFConfig.pageHeight,
                bottomMargin: bottomMargin,
                checkPageBreak: checkPageBreak,
                beginNewPage: beginNewPage,
                setCurrentYPosition: { yPosition = $0 }
            ) { yPos in
                var currentY = yPos
                let fieldFont = UIFont.systemFont(ofSize: 11)
                let labelFont = UIFont.systemFont(ofSize: 9, weight: .semibold)
                
                // Treatment (Tx)
                currentY = drawModernFieldRow(context: context, label: "TREATMENT PROVIDED", value: note.treatmentProvided, yPosition: currentY, xPosition: leftMargin + cardPadding, labelFont: labelFont, valueFont: fieldFont, lineHeight: lineHeight)
                currentY += fieldSpacing
                
                // Monitoring Plan
                currentY = drawModernFieldRow(context: context, label: "MONITORING PLAN", value: note.monitoringPlan, yPosition: currentY, xPosition: leftMargin + cardPadding, labelFont: labelFont, valueFont: fieldFont, lineHeight: lineHeight)
                currentY += fieldSpacing
                
                // Evacuation Plan
                currentY = drawModernFieldRow(context: context, label: "EVACUATION PLAN", value: note.evacuationPlan?.rawValue, yPosition: currentY, xPosition: leftMargin + cardPadding, labelFont: labelFont, valueFont: fieldFont, lineHeight: lineHeight)
                
                return currentY + fieldSpacing
            }
            
            // Footer on last page
            checkPageBreak(requiredHeight: 50) // Space for footer
            yPosition = max(yPosition + 20, PDFConfig.pageHeight - bottomMargin)
            
            // Draw divider line
            context.cgContext.setStrokeColor(UIColor.systemGray4.cgColor)
            context.cgContext.setLineWidth(1)
            context.cgContext.move(to: CGPoint(x: leftMargin, y: yPosition))
            context.cgContext.addLine(to: CGPoint(x: PDFConfig.pageWidth - leftMargin, y: yPosition))
            context.cgContext.strokePath()
            yPosition += 15
            
            // Footer text
            let footerFont = UIFont.systemFont(ofSize: 9, weight: .regular)
            let footerAttributes: [NSAttributedString.Key: Any] = [
                .font: footerFont,
                .foregroundColor: UIColor.systemGray
            ]
            
            let footerText = "🦝 Generated by TrailTriage • BlackElkMountainMedicine.com"
            let footerSize = NSString(string: footerText).size(withAttributes: footerAttributes)
            let footerX = (PDFConfig.pageWidth - footerSize.width) / 2
            NSString(string: footerText).draw(at: CGPoint(x: footerX, y: yPosition), withAttributes: footerAttributes)
            
            yPosition += lineHeight
            
            // ID
            let idText = "Report ID: \(note.id.uuidString.prefix(8))"
            let idSize = NSString(string: idText).size(withAttributes: footerAttributes)
            let idX = (PDFConfig.pageWidth - idSize.width) / 2
            NSString(string: idText).draw(at: CGPoint(x: idX, y: yPosition), withAttributes: footerAttributes)
        }
    }
    
    /// Draws a modern card with automatic page break handling
    private static func drawModernCardWithPageBreak(
        context: UIGraphicsPDFRendererContext,
        title: String,
        icon: String,
        color: UIColor,
        yPosition: CGFloat,
        leftMargin: CGFloat,
        contentWidth: CGFloat,
        cardPadding: CGFloat,
        lineHeight: CGFloat,
        pageHeight: CGFloat,
        bottomMargin: CGFloat,
        checkPageBreak: (CGFloat) -> Void,
        beginNewPage: () -> CGFloat,
        setCurrentYPosition: (CGFloat) -> Void,
        contentDrawer: (CGFloat) -> CGFloat
    ) -> CGFloat {
        let headerHeight: CGFloat = 36
        
        // Check if card will fit on current page
        let estimatedCardHeight: CGFloat = 400
        var currentY = yPosition
        
        if currentY + estimatedCardHeight > pageHeight - bottomMargin {
            // Need a new page - get the new Y position directly
            currentY = beginNewPage()
        }
        
        let contentStartY = currentY + headerHeight + cardPadding
        let contentEndY = contentDrawer(contentStartY)
        let actualContentHeight = contentEndY - contentStartY
        let actualTotalHeight = headerHeight + cardPadding + actualContentHeight + cardPadding
        
        // Draw card with actual height
        let finalY = drawCardWithKnownHeight(
            context: context,
            title: title,
            icon: icon,
            color: color,
            yPosition: currentY,
            leftMargin: leftMargin,
            contentWidth: contentWidth,
            cardPadding: cardPadding,
            headerHeight: headerHeight,
            totalHeight: actualTotalHeight,
            contentStartY: contentStartY,
            contentDrawer: contentDrawer
        )
        
        // Update the outer yPosition
        setCurrentYPosition(finalY)
        return finalY
    }
    
    /// Helper to draw card with known height (used by both regular and page-break versions)
    private static func drawCardWithKnownHeight(
        context: UIGraphicsPDFRendererContext,
        title: String,
        icon: String,
        color: UIColor,
        yPosition: CGFloat,
        leftMargin: CGFloat,
        contentWidth: CGFloat,
        cardPadding: CGFloat,
        headerHeight: CGFloat,
        totalHeight: CGFloat,
        contentStartY: CGFloat,
        contentDrawer: (CGFloat) -> CGFloat
    ) -> CGFloat {
        // Draw card background with known height
        let cardRect = CGRect(x: leftMargin, y: yPosition, width: contentWidth, height: totalHeight)
        context.cgContext.saveGState()
        context.cgContext.setFillColor(UIColor.white.cgColor)
        let cardPath = UIBezierPath(roundedRect: cardRect, cornerRadius: 12)
        context.cgContext.addPath(cardPath.cgPath)
        context.cgContext.fillPath()
        
        // Draw subtle shadow (border)
        context.cgContext.setStrokeColor(UIColor.systemGray5.cgColor)
        context.cgContext.setLineWidth(1)
        let borderPath = UIBezierPath(roundedRect: cardRect, cornerRadius: 12)
        context.cgContext.addPath(borderPath.cgPath)
        context.cgContext.strokePath()
        context.cgContext.restoreGState()
        
        // Draw header section with color accent
        let headerRect = CGRect(x: leftMargin, y: yPosition, width: contentWidth, height: headerHeight)
        context.cgContext.setFillColor(color.withAlphaComponent(0.1).cgColor)
        let headerPath = UIBezierPath(roundedRect: headerRect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 12, height: 12))
        context.cgContext.addPath(headerPath.cgPath)
        context.cgContext.fillPath()
        
        // Draw icon circle
        let iconSize: CGFloat = 24
        let iconY = yPosition + (headerHeight - iconSize) / 2
        let iconCircleRect = CGRect(x: leftMargin + cardPadding, y: iconY, width: iconSize, height: iconSize)
        context.cgContext.setFillColor(color.withAlphaComponent(0.2).cgColor)
        context.cgContext.fillEllipse(in: iconCircleRect)
        
        // For simplicity, we'll use a colored dot instead of trying to draw SF Symbols
        let dotSize: CGFloat = 10
        let dotRect = CGRect(
            x: leftMargin + cardPadding + (iconSize - dotSize) / 2,
            y: iconY + (iconSize - dotSize) / 2,
            width: dotSize,
            height: dotSize
        )
        context.cgContext.setFillColor(color.cgColor)
        context.cgContext.fillEllipse(in: dotRect)
        
        // Draw title
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
            .foregroundColor: UIColor.black
        ]
        let titleX = leftMargin + cardPadding + iconSize + 10
        let titleY = yPosition + (headerHeight - 16) / 2
        NSString(string: title).draw(at: CGPoint(x: titleX, y: titleY), withAttributes: titleAttributes)
        
        // Draw content on top of the background
        _ = contentDrawer(contentStartY)
        
        // Return the end position (bottom of card)
        return yPosition + totalHeight
    }
    
    // MARK: - Modern PDF Helper Functions
    
    /// Draws a modern card with icon, title, and custom content
    private static func drawModernCard(
        context: UIGraphicsPDFRendererContext,
        title: String,
        icon: String,
        color: UIColor,
        yPosition: CGFloat,
        leftMargin: CGFloat,
        contentWidth: CGFloat,
        cardPadding: CGFloat,
        lineHeight: CGFloat,
        contentDrawer: (CGFloat) -> CGFloat
    ) -> CGFloat {
        let headerHeight: CGFloat = 36
        let contentStartY = yPosition + headerHeight + cardPadding
        
        // Use a large estimated height that should cover most content
        // We'll draw the background first, then content on top
        let estimatedContentHeight: CGFloat = 400 // Large enough for most sections
        let estimatedTotalHeight = headerHeight + cardPadding + estimatedContentHeight + cardPadding
        
        // Draw card background FIRST with estimated height
        let cardRect = CGRect(x: leftMargin, y: yPosition, width: contentWidth, height: estimatedTotalHeight)
        context.cgContext.saveGState()
        context.cgContext.setFillColor(UIColor.white.cgColor)
        let cardPath = UIBezierPath(roundedRect: cardRect, cornerRadius: 12)
        context.cgContext.addPath(cardPath.cgPath)
        context.cgContext.fillPath()
        
        // Draw subtle shadow (border)
        context.cgContext.setStrokeColor(UIColor.systemGray5.cgColor)
        context.cgContext.setLineWidth(1)
        let borderPath = UIBezierPath(roundedRect: cardRect, cornerRadius: 12)
        context.cgContext.addPath(borderPath.cgPath)
        context.cgContext.strokePath()
        context.cgContext.restoreGState()
        
        // Draw header section with color accent
        let headerRect = CGRect(x: leftMargin, y: yPosition, width: contentWidth, height: headerHeight)
        context.cgContext.setFillColor(color.withAlphaComponent(0.1).cgColor)
        let headerPath = UIBezierPath(roundedRect: headerRect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 12, height: 12))
        context.cgContext.addPath(headerPath.cgPath)
        context.cgContext.fillPath()
        
        // Draw icon circle
        let iconSize: CGFloat = 24
        let iconY = yPosition + (headerHeight - iconSize) / 2
        let iconCircleRect = CGRect(x: leftMargin + cardPadding, y: iconY, width: iconSize, height: iconSize)
        context.cgContext.setFillColor(color.withAlphaComponent(0.2).cgColor)
        context.cgContext.fillEllipse(in: iconCircleRect)
        
        // For simplicity, we'll use a colored dot instead of trying to draw SF Symbols
        let dotSize: CGFloat = 10
        let dotRect = CGRect(
            x: leftMargin + cardPadding + (iconSize - dotSize) / 2,
            y: iconY + (iconSize - dotSize) / 2,
            width: dotSize,
            height: dotSize
        )
        context.cgContext.setFillColor(color.cgColor)
        context.cgContext.fillEllipse(in: dotRect)
        
        // Draw title
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
            .foregroundColor: UIColor.black
        ]
        let titleX = leftMargin + cardPadding + iconSize + 10
        let titleY = yPosition + (headerHeight - 16) / 2
        NSString(string: title).draw(at: CGPoint(x: titleX, y: titleY), withAttributes: titleAttributes)
        
        // NOW draw content on top of the background
        let contentEndY = contentDrawer(contentStartY)
        let actualContentHeight = contentEndY - contentStartY
        let actualTotalHeight = headerHeight + cardPadding + actualContentHeight + cardPadding
        
        // If content is taller than estimated, extend the card background
        if actualTotalHeight > estimatedTotalHeight {
            let extraHeight = actualTotalHeight - estimatedTotalHeight
            let extensionRect = CGRect(
                x: leftMargin,
                y: yPosition + estimatedTotalHeight,
                width: contentWidth,
                height: extraHeight
            )
            context.cgContext.setFillColor(UIColor.white.cgColor)
            context.cgContext.fill(extensionRect)
            
            // Redraw bottom border
            let bottomBorderY = yPosition + actualTotalHeight
            context.cgContext.setStrokeColor(UIColor.systemGray5.cgColor)
            context.cgContext.setLineWidth(1)
            context.cgContext.move(to: CGPoint(x: leftMargin + 12, y: bottomBorderY))
            context.cgContext.addLine(to: CGPoint(x: leftMargin + contentWidth - 12, y: bottomBorderY))
            context.cgContext.strokePath()
        }
        
        // Return the actual end position
        return yPosition + actualTotalHeight
    }
    
    /// Draws a modern field row with label and value
    private static func drawModernFieldRow(
        context: UIGraphicsPDFRendererContext,
        label: String,
        value: String?,
        yPosition: CGFloat,
        xPosition: CGFloat,
        labelFont: UIFont,
        valueFont: UIFont,
        lineHeight: CGFloat
    ) -> CGFloat {
        // Label (small caps style)
        let labelAttributes: [NSAttributedString.Key: Any] = [
            .font: labelFont,
            .foregroundColor: UIColor.darkGray
        ]
        NSString(string: label).draw(at: CGPoint(x: xPosition, y: yPosition), withAttributes: labelAttributes)
        
        // Value
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: valueFont,
            .foregroundColor: UIColor.black
        ]
        let valueText = value ?? "—"
        NSString(string: valueText).draw(at: CGPoint(x: xPosition, y: yPosition + lineHeight - 4), withAttributes: valueAttributes)
        
        return yPosition + lineHeight + lineHeight - 4
    }
    
    /// Draws a modern vital row for the vitals table
    private static func drawModernVitalRow(
        context: UIGraphicsPDFRendererContext,
        label: String,
        vitals: [VitalSigns],
        vitalKey: (VitalSigns) -> String?,
        yPosition: CGFloat,
        tableX: CGFloat,
        colWidth: CGFloat,
        valueFont: UIFont,
        lineHeight: CGFloat
    ) -> CGFloat {
        let labelFont = UIFont.systemFont(ofSize: 10, weight: .semibold)
        let labelAttributes: [NSAttributedString.Key: Any] = [
            .font: labelFont,
            .foregroundColor: UIColor.black
        ]
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: valueFont,
            .foregroundColor: UIColor.darkGray
        ]
        
        // Draw label
        NSString(string: label).draw(at: CGPoint(x: tableX, y: yPosition), withAttributes: labelAttributes)
        
        // Draw values in columns
        for (index, vital) in vitals.enumerated() {
            let value = vitalKey(vital) ?? "—"
            let xPos = tableX + colWidth * (CGFloat(index) + 1.5)
            NSString(string: value).draw(at: CGPoint(x: xPos, y: yPosition), withAttributes: valueAttributes)
        }
        
        // Fill remaining columns with dashes
        for index in vitals.count..<3 {
            let xPos = tableX + colWidth * (CGFloat(index) + 1.5)
            NSString(string: "—").draw(at: CGPoint(x: xPos, y: yPosition), withAttributes: valueAttributes)
        }
        
        return yPosition + lineHeight + 4
    }
}

