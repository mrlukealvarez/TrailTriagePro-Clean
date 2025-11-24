//
//  HapticFeedback.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/13/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Haptic feedback helpers for better UX!
//

import UIKit

/// Centralized haptic feedback manager for consistent UX
enum HapticFeedback {
    
    // MARK: - Notification Feedback
    
    /// Success haptic (note saved, purchase complete, action succeeded)
    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    /// Warning haptic (caution needed, risky action)
    static func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    /// Error haptic (purchase failed, validation error, network error)
    static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    // MARK: - Impact Feedback
    
    /// Light impact (button tap, selection change)
    static func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    /// Medium impact (toggle switch, segmented control change)
    static func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    /// Heavy impact (delete action, critical button)
    static func heavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    /// Soft impact (subtle feedback, minimal)
    @available(iOS 13.0, *)
    static func soft() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
    }
    
    /// Rigid impact (strong, definitive feedback)
    @available(iOS 13.0, *)
    static func rigid() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
    }
    
    // MARK: - Selection Feedback
    
    /// Selection changed (picker, carousel, scrolling through options)
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    // MARK: - Common Use Cases
    
    /// Button pressed (light tap feedback)
    static func buttonTap() {
        light()
    }
    
    /// Important action completed (save, submit, finish)
    static func actionComplete() {
        success()
    }
    
    /// Destructive action (delete, clear, remove)
    static func destructiveAction() {
        heavy()
    }
    
    /// Subscription/purchase success
    static func purchaseSuccess() {
        success()
        
        // Extra celebration feedback after a small delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            medium()
        }
    }
    
    /// Toggle switched
    static func toggle() {
        medium()
    }
    
    /// Navigation action (tab change, page swipe)
    static func navigation() {
        selection()
    }
}

// MARK: - SwiftUI Extension

import SwiftUI

extension View {
    /// Add haptic feedback to any view
    /// - Parameter type: The type of haptic feedback to trigger
    /// - Returns: Modified view with haptic feedback on tap
    func haptic(_ type: HapticType = .light) -> some View {
        self.onTapGesture {
            switch type {
            case .light:
                HapticFeedback.light()
            case .medium:
                HapticFeedback.medium()
            case .heavy:
                HapticFeedback.heavy()
            case .success:
                HapticFeedback.success()
            case .warning:
                HapticFeedback.warning()
            case .error:
                HapticFeedback.error()
            case .selection:
                HapticFeedback.selection()
            }
        }
    }
    
    /// Add haptic feedback to button actions
    func withHapticFeedback(_ type: HapticType = .medium, action: @escaping () -> Void) -> some View {
        Button(action: {
            switch type {
            case .light:
                HapticFeedback.light()
            case .medium:
                HapticFeedback.medium()
            case .heavy:
                HapticFeedback.heavy()
            case .success:
                HapticFeedback.success()
            case .warning:
                HapticFeedback.warning()
            case .error:
                HapticFeedback.error()
            case .selection:
                HapticFeedback.selection()
            }
            action()
        }) {
            self
        }
    }
}

enum HapticType {
    case light
    case medium
    case heavy
    case success
    case warning
    case error
    case selection
}

// MARK: - Usage Examples
/*
 
 // In your views:
 
 // Success feedback (note saved)
 HapticFeedback.success()
 
 // Button tap
 Button("Save") {
     HapticFeedback.buttonTap()
     saveNote()
 }
 
 // Purchase complete
 if success {
     HapticFeedback.purchaseSuccess()
 }
 
 // Delete action
 Button("Delete", role: .destructive) {
     HapticFeedback.destructiveAction()
     deleteNote()
 }
 
 // Toggle switch
 Toggle("Expert Mode", isOn: $expertMode)
     .onChange(of: expertMode) { _, _ in
         HapticFeedback.toggle()
     }
 
 // Tab change
 TabView(selection: $selectedTab) {
     // ...
 }
 .onChange(of: selectedTab) { _, _ in
     HapticFeedback.navigation()
 }
 
 */
