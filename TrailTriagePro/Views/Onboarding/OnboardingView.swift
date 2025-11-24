//
//  OnboardingView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/9/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Onboarding featuring your favorite raccoon WFR!
//

import SwiftUI
import AuthenticationServices
import CoreLocation
import StoreKit
import UserNotifications

// MARK: - Onboarding Step Enum
enum OnboardingStep: Int, CaseIterable, Sendable {
    case welcome = 0
    case featureTour = 1
    case signIn = 2
    case profile = 3
    case permissions = 4
    case subscription = 5
    case complete = 6
}

// MARK: - Onboarding Coordinator
@MainActor
@Observable
class OnboardingCoordinator {
    var currentStep: OnboardingStep = .welcome
    var hasCompletedOnboarding: Bool
    
    // User info collected during onboarding
    var userID: String?
    var userName: String = ""
    var userEmail: String?
    var responderAgency: String = ""
    var responderIDNumber: String = ""
    var certifications: String = ""
    
    // Permissions
    var hasLocationPermission = false
    var hasiCloudEnabled = false
    var hasNotificationPermission = false
    var hasStartedTrial = false
    
    init() {
        // Load onboarding status from UserDefaults
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        self.userID = UserDefaults.standard.string(forKey: "userID")
    }
    
    func nextStep() {
        guard let currentIndex = OnboardingStep.allCases.firstIndex(of: currentStep),
              currentIndex < OnboardingStep.allCases.count - 1 else {
            completeOnboarding()
            return
        }
        currentStep = OnboardingStep.allCases[currentIndex + 1]
    }
    
    func previousStep() {
        guard let currentIndex = OnboardingStep.allCases.firstIndex(of: currentStep),
              currentIndex > 0 else { return }
        currentStep = OnboardingStep.allCases[currentIndex - 1]
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        // Save to UserDefaults
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        UserDefaults.standard.set(userID, forKey: "userID")
    }
    
    func canProceedFromCurrentStep() -> Bool {
        switch currentStep {
        case .welcome:
            return true
        case .featureTour:
            return true
        case .signIn:
            return userID != nil // Must be signed in
        case .profile:
            return true // All fields optional - can skip
        case .permissions:
            return true // Optional permissions
        case .subscription:
            // MUST subscribe or start trial to proceed
            // This ensures no access to main app without subscription
            return hasStartedTrial
        case .complete:
            return true
        }
    }
}

// MARK: - Main Onboarding View
struct OnboardingView: View {
    @State private var coordinator = OnboardingCoordinator()
    @Environment(AppSettings.self) private var settings
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            TabView(selection: $coordinator.currentStep) {
                WelcomeStepView(coordinator: coordinator)
                    .tag(OnboardingStep.welcome)
                
                FeatureTourStepView(coordinator: coordinator)
                    .tag(OnboardingStep.featureTour)
                
                SignInStepView(coordinator: coordinator)
                    .tag(OnboardingStep.signIn)
                
                ProfileStepView(coordinator: coordinator, settings: settings)
                    .tag(OnboardingStep.profile)
                
                PermissionsStepView(coordinator: coordinator)
                    .tag(OnboardingStep.permissions)
                
                SubscriptionStepView(coordinator: coordinator)
                    .tag(OnboardingStep.subscription)
                
                CompletionStepView(coordinator: coordinator)
                    .tag(OnboardingStep.complete)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.3), value: coordinator.currentStep)
            
            // Custom page indicators with smooth transitions
            VStack {
                Spacer()
                OnboardingPageIndicator(currentStep: coordinator.currentStep)
                    .padding(.bottom, 80)
                    .transition(.opacity.combined(with: .scale(scale: 0.9)))
            }
        }
        .onChange(of: coordinator.currentStep) { oldStep, newStep in
            // Prevent skipping subscription step without purchasing
            if oldStep == .subscription && newStep == .complete && !coordinator.hasStartedTrial {
                // Force them back to subscription page
                coordinator.currentStep = .subscription
            }
        }
        .onChange(of: coordinator.hasCompletedOnboarding) { _, completed in
            if completed {
                withAnimation(.easeOut(duration: 0.3)) {
                    isPresented = false
                }
            }
        }
    }
}

// MARK: - Custom Page Indicator
struct OnboardingPageIndicator: View {
    let currentStep: OnboardingStep
    @State private var pulseAnimation = false
    
    // Only show indicators for the main steps (not complete)
    private let steps: [OnboardingStep] = [
        .welcome, .featureTour, .signIn, .profile, .permissions, .subscription
    ]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(steps, id: \.self) { step in
                Circle()
                    .fill(step == currentStep ? Color.blue : Color.gray.opacity(0.4))
                    .frame(
                        width: step == currentStep ? 10 : 8,
                        height: step == currentStep ? 10 : 8
                    )
                    .overlay {
                        if step == currentStep {
                            Circle()
                                .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                                .scaleEffect(pulseAnimation ? 1.4 : 1.0)
                                .opacity(pulseAnimation ? 0.0 : 0.8)
                        }
                    }
                    .animation(.easeInOut(duration: 0.2), value: currentStep)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
        .onChange(of: currentStep) { _, _ in
            pulseAnimation = false
            withAnimation(.easeOut(duration: 0.8)) {
                pulseAnimation = true
            }
        }
    }
}

// MARK: - Step 1: Welcome
struct WelcomeStepView: View {
    @Bindable var coordinator: OnboardingCoordinator
    @State private var animateIcon = false
    
    var body: some View {
        ZStack {
            // Subtle gradient background
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color.blue.opacity(0.05)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
            
            // Animated icon
            Image(systemName: "cross.case.fill")
                .font(.system(size: 100))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .cyan],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .scaleEffect(animateIcon ? 1.0 : 0.8)
                .opacity(animateIcon ? 1.0 : 0.0)
            
            VStack(spacing: 16) {
                Text("Welcome to")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                
                VStack(spacing: 2) {
                    Text("TrailTriage:")
                        .font(.system(size: 40, weight: .bold))
                    Text("WFR Toolkit")
                        .font(.system(size: 40, weight: .bold))
                }
                .multilineTextAlignment(.center)
                
                // Raccoon mascot between title and description
                Text("🦝")
                    .font(.system(size: 60))
                    .padding(.vertical, 8)
                
                Text("Professional SOAP note\ndocumentation for\nwilderness first responders")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
            }
            .padding(.horizontal, 24)
            .opacity(animateIcon ? 1.0 : 0.0)
            
            Spacer()
            
            // Company name footer
            VStack(spacing: 4) {
                Text("by BlackElkMountainMedicine.com")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("🦝 Featuring Jimmothy the Raccoon WFR")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .italic()
            }
            .padding(.bottom, 8)
            
            HStack(spacing: 6) {
                Text("Swipe to continue")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 40)
        }
        .padding()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animateIcon = true
            }
        }
    }
}

// MARK: - Step 1.5: Feature Tour
struct FeatureTourStepView: View {
    @Bindable var coordinator: OnboardingCoordinator
    @State private var animateFeatures = false
    
    private let features: [(icon: String, title: String, description: String, color: Color)] = [
        ("doc.text.fill", "SOAP Documentation", "Create professional SOAP notes with guided templates for Subjective, Objective, Assessment, and Plan sections.", .blue),
        ("waveform.path.ecg", "Vital Signs Tracking", "Monitor and trend patient vitals over time. Track heart rate, blood pressure, respiratory rate, and more.", .red),
        ("mappin.circle.fill", "GPS Location", "Automatically capture incident location coordinates. Essential for SAR operations and evacuation planning.", .green),
        ("arrow.down.doc.fill", "PDF Export", "Generate professional PDF reports for EMS handoff. Share via AirDrop, email, or save to files.", .orange),
        ("icloud.fill", "iCloud Sync", "Keep your notes synced across all your devices. Access your documentation anywhere, anytime.", .cyan),
        ("book.fill", "Reference Protocols", "Quick access to wilderness medicine protocols and assessment tools right when you need them.", .purple)
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
            VStack(spacing: 32) {
                // Header with skip button
                HStack {
                    Spacer()
                    Button {
                        coordinator.nextStep()
                    } label: {
                        Text("Skip")
                            .font(.body.weight(.medium))
                            .foregroundStyle(.blue)
                    }
                    .padding(.trailing)
                }
                .padding(.top, 20)
                
                // Title
                VStack(spacing: 12) {
                    Text("What's Inside")
                        .font(.largeTitle.bold())
                    
                    Text("Everything you need for wilderness medicine documentation")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 20)
                
                // All features in vertical scroll with animation
                VStack(spacing: 24) {
                    ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                        FeatureTourCard(
                            icon: feature.icon,
                            title: feature.title,
                            description: feature.description,
                            color: feature.color
                        )
                        .opacity(animateFeatures ? 1.0 : 0.0)
                        .offset(x: animateFeatures ? 0 : 20)
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.8)
                                .delay(Double(index) * 0.1),
                            value: animateFeatures
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                // Bottom hint
                HStack(spacing: 6) {
                    Text("Swipe to continue")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
        }
        .scrollIndicators(.hidden)
        }
        .onAppear {
            animateFeatures = true
        }
    }
}

// Feature Card Component
private struct FeatureTourCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.2), color.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundStyle(color)
            }
            
            // Text content
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer(minLength: 0)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
        )
    }
}

// MARK: - Step 2: Sign In
struct SignInStepView: View {
    @Bindable var coordinator: OnboardingCoordinator
    @State private var isSigningIn = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)
            
            VStack(spacing: 12) {
                Text("Sign In")
                    .font(.largeTitle.bold())
                
                Text("Sign in to sync your notes across all your devices")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                // Sign in with Apple (Primary)
                SignInWithAppleButton(
                    onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    },
                    onCompletion: { result in
                        handleSignInWithApple(result)
                    }
                )
                .signInWithAppleButtonStyle(.black)
                .frame(height: 50)
                .cornerRadius(12)
                
                // Skip for now option
                Button(action: {
                    // Set a temporary ID to allow continuing
                    coordinator.userID = "temp_\(UUID().uuidString)"
                    coordinator.nextStep()
                }) {
                    Text("Skip for Now")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
        .padding()
        .disabled(isSigningIn)
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func handleSignInWithApple(_ result: Result<ASAuthorization, Error>) {
        isSigningIn = true
        
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                // Get user identifier (unique to this app)
                coordinator.userID = appleIDCredential.user
                
                // Get name if available
                if let fullName = appleIDCredential.fullName {
                    let firstName = fullName.givenName ?? ""
                    let lastName = fullName.familyName ?? ""
                    coordinator.userName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
                }
                
                // Get email if available
                coordinator.userEmail = appleIDCredential.email
                
                // Save to UserDefaults for future sessions
                UserDefaults.standard.set(coordinator.userID, forKey: "userID")
                
                // Move to next step
                isSigningIn = false
                coordinator.nextStep()
                return
            } else {
                errorMessage = "Could not get Apple ID credential"
                showError = true
            }
            
        case .failure(let error):
            let nsError = error as NSError
            
            // Check if user cancelled
            if nsError.domain == ASAuthorizationError.errorDomain,
               nsError.code == ASAuthorizationError.canceled.rawValue {
                // User cancelled - don't show error
                isSigningIn = false
                return
            } else if nsError.code == 1000 {
                // Error 1000 - Configuration issue
                errorMessage = """
                Sign in with Apple is not configured:
                
                1. Enable 'Sign in with Apple' capability in Xcode
                2. Ensure you're signed into an Apple ID in Settings
                3. For now, tap 'Skip for Now' to continue
                
                This works automatically in production builds.
                """
                showError = true
            } else {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
        
        isSigningIn = false
    }
}

// MARK: - Step 3: Profile Setup
struct ProfileStepView: View {
    @Bindable var coordinator: OnboardingCoordinator
    var settings: AppSettings
    @State private var animateContent = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
            VStack(spacing: 30) {
                VStack(spacing: 12) {
                    // Icon with gradient background
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "person.text.rectangle.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.blue)
                    }
                    .scaleEffect(animateContent ? 1.0 : 0.9)
                    
                    Text("Your Information")
                        .font(.largeTitle.bold())
                    
                    Text("This information will be included in your SOAP notes for EMS handoff")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 40)
                .opacity(animateContent ? 1.0 : 0.0)
                
                VStack(spacing: 16) {
                    // Name (optional)
                    ProfileTextField(
                        label: "Name",
                        placeholder: "Your full name",
                        text: $coordinator.userName,
                        icon: "person.fill"
                    )
                    .textContentType(.name)
                    
                    // Agency (optional)
                    ProfileTextField(
                        label: "Agency",
                        placeholder: "e.g., CSAR, Park Ranger",
                        text: $coordinator.responderAgency,
                        icon: "building.2.fill"
                    )
                    .textContentType(.organizationName)
                    
                    // ID Number (optional)
                    ProfileTextField(
                        label: "ID/Rescue Number",
                        placeholder: "e.g., 92",
                        text: $coordinator.responderIDNumber,
                        icon: "number.circle.fill"
                    )
                    .keyboardType(.numberPad)
                    
                    // Certifications (optional, combined field)
                    ProfileTextField(
                        label: "Certifications",
                        placeholder: "e.g., WFR, CPR, EMT",
                        text: $coordinator.certifications,
                        icon: "checkmark.seal.fill"
                    )
                }
                .padding(.horizontal, 24)
                .opacity(animateContent ? 1.0 : 0.0)
                
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "info.circle.fill")
                            .foregroundStyle(.blue)
                            .font(.caption)
                        Text("All fields are optional")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                    
                    Text("You can update these later in Settings")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                .opacity(animateContent ? 1.0 : 0.0)
            }
        }
        .onDisappear {
            saveToSettings()
        }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                animateContent = true
            }
        }
    }
    
    private func saveToSettings() {
        settings.responderName = coordinator.userName.trimmingCharacters(in: .whitespacesAndNewlines)
        settings.responderAgency = coordinator.responderAgency.trimmingCharacters(in: .whitespacesAndNewlines)
        settings.responderRescueNumber = coordinator.responderIDNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        settings.responderCertification = coordinator.certifications.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// Modern TextField Component
private struct ProfileTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline.bold())
                .foregroundStyle(.primary)
            
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundStyle(.blue)
                    .font(.body)
                    .frame(width: 20)
                
                TextField(placeholder, text: $text)
                    .font(.body)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
    }
}

// MARK: - Step 4: Permissions
struct PermissionsStepView: View {
    @Bindable var coordinator: OnboardingCoordinator
    @State private var locationHelper = LocationPermissionHelper()
    @State private var notificationStatus: PermissionStatus = .notDetermined
    @State private var iCloudStatus: String = "Checking..."
    
    enum PermissionStatus {
        case notDetermined
        case authorized
        case denied
        
        var displayText: String {
            switch self {
            case .notDetermined: return "Not requested"
            case .authorized: return "Enabled ✓"
            case .denied: return "Denied"
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
            
            Image(systemName: "hand.raised.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)
            
            VStack(spacing: 12) {
                Text("Permissions")
                    .font(.largeTitle.bold())
                
                Text("These help TrailTriage work better for you")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 20) {
                // Location Permission
                PermissionRow(
                    icon: "location.fill",
                    title: "Location Access",
                    description: "Add GPS coordinates to incident locations",
                    status: locationHelper.status.displayText,
                    action: {
                        locationHelper.requestPermission()
                    }
                )
                
                // Notifications Permission
                PermissionRow(
                    icon: "bell.fill",
                    title: "Notifications",
                    description: "Get reminders for vital sign checks and updates",
                    status: notificationStatus.displayText,
                    action: {
                        requestNotificationPermission()
                    }
                )
                
                // iCloud Status
                PermissionRow(
                    icon: "icloud.fill",
                    title: "iCloud Sync",
                    description: "Backup and sync notes across devices",
                    status: iCloudStatus,
                    action: nil // iCloud can't be requested, just checked
                )
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            Button {
                coordinator.nextStep()
            } label: {
                HStack {
                    Text("Continue")
                        .font(.headline)
                    Image(systemName: "chevron.right")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundStyle(.white)
                .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            
            Text("Permissions are optional")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.bottom, 40)
        }
        .padding()
        .onAppear {
            checkStatuses()
        }
        .onChange(of: locationHelper.status) { _, newStatus in
            if newStatus == .authorized {
                coordinator.hasLocationPermission = true
            }
        }
        }
    }
    
    private func checkStatuses() {
        // Location is auto-checked by LocationPermissionHelper
        
        // Check notifications
        Task {
            let center = UNUserNotificationCenter.current()
            let settings = await center.notificationSettings()
            
            await MainActor.run {
                switch settings.authorizationStatus {
                case .notDetermined:
                    notificationStatus = .notDetermined
                case .authorized, .provisional, .ephemeral:
                    coordinator.hasNotificationPermission = true
                    notificationStatus = .authorized
                case .denied:
                    notificationStatus = .denied
                @unknown default:
                    notificationStatus = .denied
                }
            }
        }
        
        // Check iCloud
        Task {
            let token = FileManager.default.ubiquityIdentityToken
            await MainActor.run {
                if token != nil {
                    coordinator.hasiCloudEnabled = true
                    iCloudStatus = "Enabled ✓"
                } else {
                    iCloudStatus = "Not signed in"
                }
            }
        }
    }
    
    private func requestNotificationPermission() {
        Task {
            let center = UNUserNotificationCenter.current()
            do {
                let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
                await MainActor.run {
                    if granted {
                        coordinator.hasNotificationPermission = true
                        notificationStatus = .authorized
                    } else {
                        notificationStatus = .denied
                    }
                }
            } catch {
                await MainActor.run {
                    notificationStatus = .denied
                }
            }
        }
    }
}

// MARK: - Location Permission Helper
@MainActor
@Observable
class LocationPermissionHelper: NSObject, CLLocationManagerDelegate {
    var status: PermissionsStepView.PermissionStatus = .notDetermined
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        updateStatus()
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func updateStatus() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            status = .notDetermined
        case .authorizedWhenInUse, .authorizedAlways:
            status = .authorized
        case .denied, .restricted:
            status = .denied
        @unknown default:
            status = .denied
        }
    }
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            updateStatus()
        }
    }
}

struct PermissionRow: View {
    let icon: String
    let title: String
    let description: String
    let status: String
    let action: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon with colored background
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            if let action = action, !status.contains("✓") {
                Button {
                    action()
                } label: {
                    Text("Enable")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            } else {
                Text(status)
                    .font(.caption.bold())
                    .foregroundStyle(status.contains("✓") ? .green : .secondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    private var iconColor: Color {
        if icon.contains("location") {
            return .green
        } else if icon.contains("bell") {
            return .orange
        } else if icon.contains("icloud") {
            return .blue
        }
        return .blue
    }
}

// MARK: - Step 5: Subscription (PaywallView Style)
struct SubscriptionStepView: View {
    @Bindable var coordinator: OnboardingCoordinator
    @State private var isPurchasing = false
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var freeTrialEnabled = true // Toggle for free trial
    
    private var storeManager: StoreManager {
        StoreManager.shared
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Raccoon mascot 🦝
                VStack(spacing: 16) {
                    if let _ = UIImage(named: "RaccoonMascot") {
                        Image("RaccoonMascot")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .padding(.top, 20)
                    } else {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.gray.opacity(0.3), Color.brown.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                            
                            Text("🦝")
                                .font(.system(size: 70))
                        }
                        .padding(.top, 20)
                    }
                    
                    Text("Unlock Pro Access")
                        .font(.title.bold())
                    
                    Text("Get unlimited access to all wilderness medicine protocols and features")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                // Features with icons
                VStack(alignment: .leading, spacing: 14) {
                    OnboardingFeatureRow(
                        icon: "checkmark.seal.fill",
                        title: "Complete WFR Protocol Library",
                        description: "80+ hours of wilderness medicine content",
                        color: .blue
                    )
                    
                    OnboardingFeatureRow(
                        icon: "doc.text.fill",
                        title: "Unlimited SOAP Notes",
                        description: "Document every patient encounter",
                        color: .green
                    )
                    
                    OnboardingFeatureRow(
                        icon: "wifi.slash",
                        title: "100% Offline Access",
                        description: "Available in the backcountry",
                        color: .orange
                    )
                    
                    OnboardingFeatureRow(
                        icon: "arrow.triangle.2.circlepath",
                        title: "Regular Content Updates",
                        description: "Latest WFR standards and protocols",
                        color: .purple
                    )
                }
                .padding(.horizontal, 24)
                
                // Pricing Options
                VStack(spacing: 12) {
                    if storeManager.products.isEmpty {
                        // Products not loaded - show retry
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.largeTitle)
                                .foregroundStyle(.orange)
                            
                            Text("Unable to load subscription options")
                                .font(.headline)
                            
                            Button {
                                Task {
                                    await storeManager.loadProducts()
                                }
                            } label: {
                                Label("Retry", systemImage: "arrow.clockwise")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            
                        }
                        .padding(.vertical, 20)
                    } else {
                        // Lifetime Purchase - BEST VALUE
                        if let lifetimeProduct = storeManager.lifetimeProduct {
                            OnboardingPricingCard(
                                title: "Lifetime Access",
                                subtitle: "\(lifetimeProduct.displayPrice) one-time payment",
                                buttonText: "PAY ONCE",
                                badge: "BEST VALUE",
                                badgeColor: .green,
                                isHighlighted: true,
                                footnote: "Pay once, use forever"
                            ) {
                                await purchaseProduct(lifetimeProduct)
                            }
                        }
                        
                        // Monthly Subscription with Free Trial
                        if let monthlyProduct = storeManager.monthlyProduct {
                            OnboardingPricingCard(
                                title: freeTrialEnabled ? "3-Day Free Trial" : "Monthly Plan",
                                subtitle: freeTrialEnabled ? "then \(monthlyProduct.displayPrice) per month" : "\(monthlyProduct.displayPrice) per month",
                                buttonText: freeTrialEnabled ? "START FREE TRIAL" : "SUBSCRIBE",
                                badge: nil,
                                badgeColor: .blue,
                                isHighlighted: false,
                                footnote: "Cancel anytime, no commitment"
                            ) {
                                await purchaseProduct(monthlyProduct)
                            }
                        }
                        
                        // Free Trial Toggle
                        HStack {
                            Text("Free Trial Enabled")
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                            
                            Spacer()
                            
                            Toggle("", isOn: $freeTrialEnabled)
                                .labelsHidden()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                
                // Restore Purchases
                Button {
                    Task {
                        do {
                            try await storeManager.restorePurchases()
                            if storeManager.hasFullAccess {
                                coordinator.hasStartedTrial = true
                                coordinator.nextStep()
                            } else {
                                errorMessage = "No previous purchases found"
                                showError = true
                            }
                        } catch {
                            errorMessage = "Failed to restore purchases"
                            showError = true
                        }
                    }
                } label: {
                    Text("Restore Purchases")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                }
                
                // Legal Links
                HStack(spacing: 20) {
                    Link("Terms of Service", destination: URL(string: "https://blackelkmountainmedicine.com/terms.html")!)
                    .font(.caption)
                        .foregroundStyle(.blue)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Link("Privacy Policy", destination: URL(string: "https://blackelkmountainmedicine.com/privacy.html")!)
                    .font(.caption)
                        .foregroundStyle(.blue)
                }
                .padding(.bottom)
            }
        }
        .task {
            if storeManager.products.isEmpty {
                await storeManager.loadProducts()
            }
        }
        .overlay {
            if isPurchasing {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .overlay {
                        ProgressView()
                            .tint(.white)
                            .controlSize(.large)
                    }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") {
                showError = false
            }
        } message: {
            Text(errorMessage ?? "An error occurred")
        }
    }
    
    private func purchaseProduct(_ product: Product) async {
        isPurchasing = true
        defer { isPurchasing = false }
        
        do {
            let success = try await storeManager.purchase(product)
            if success {
                coordinator.hasStartedTrial = true
                coordinator.nextStep()
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

// MARK: - Onboarding Feature Row (Paywall Style)
private struct OnboardingFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.bold())
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Onboarding Pricing Card (Paywall Style)
private struct OnboardingPricingCard: View {
    let title: String
    let subtitle: String
    let buttonText: String
    let badge: String?
    let badgeColor: Color
    let isHighlighted: Bool
    let footnote: String
    let action: () async -> Void
    
    @State private var isPurchasing = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Badge at top
            if let badge = badge {
                Text(badge)
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(badgeColor)
                    .clipShape(Capsule())
                    .offset(y: -12)
            }
            
            // Card content
            VStack(spacing: 16) {
                VStack(spacing: 6) {
                    Text(title)
                        .font(.title3.bold())
                        .foregroundStyle(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                // Purchase button
                Button {
                    Task {
                        isPurchasing = true
                        await action()
                        isPurchasing = false
                    }
                } label: {
                    Group {
                        if isPurchasing {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text(buttonText)
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: isHighlighted ? 
                                [Color.green, Color.green.opacity(0.8)] : 
                                [Color.blue, Color.blue.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(
                        color: (isHighlighted ? Color.green : Color.blue).opacity(0.3),
                        radius: 8,
                        y: 4
                    )
                }
                .disabled(isPurchasing)
                
                // Footnote
                HStack(spacing: 4) {
                    Image(systemName: isHighlighted ? "checkmark.circle.fill" : "info.circle.fill")
                        .font(.caption2)
                        .foregroundStyle(isHighlighted ? .green : .blue)
                    
                    Text(footnote)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
                    .shadow(
                        color: isHighlighted ? .blue.opacity(0.2) : .black.opacity(0.05),
                        radius: isHighlighted ? 16 : 8
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isHighlighted ? 
                            LinearGradient(
                                colors: [.green, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) : 
                            LinearGradient(colors: [.clear], startPoint: .top, endPoint: .bottom),
                        lineWidth: isHighlighted ? 2 : 0
                    )
            )
        }
        .padding(.vertical, badge != nil ? 12 : 0)
    }
}

struct FeatureCheckmark: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
            Text(text)
                .font(.subheadline)
            Spacer()
        }
    }
}

// MARK: - Step 6: Completion
struct CompletionStepView: View {
    @Bindable var coordinator: OnboardingCoordinator
    @State private var animateContent = false
    @State private var showConfetti = false
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.1),
                    Color.green.opacity(0.05),
                    Color(.systemBackground)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Waving Raccoon Mascot
                VStack(spacing: 20) {
                    if let _ = UIImage(named: "RaccoonMascotWaving") {
                        Image("RaccoonMascotWaving")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 180)
                            .scaleEffect(animateContent ? 1.0 : 0.8)
                            .rotationEffect(.degrees(animateContent ? 0 : -10))
                    } else {
                        // Fallback emoji with wave animation
                        Text("🦝")
                            .font(.system(size: 100))
                            .scaleEffect(animateContent ? 1.0 : 0.8)
                            .rotationEffect(.degrees(animateContent ? 0 : -10))
                    }
                    
                    VStack(spacing: 12) {
                        Text("You're All Set!")
                            .font(.largeTitle.bold())
                            .multilineTextAlignment(.center)
                        
                        Text("Welcome to the TrailTriage: WFR Toolkit community of wilderness first responders")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .opacity(animateContent ? 1.0 : 0.0)
                }
                
                // Quick tips
                VStack(spacing: 16) {
                    CompletionTipRow(
                        icon: "doc.badge.plus",
                        title: "Create Your First Note",
                        description: "Start documenting with SOAP templates"
                    )
                    
                    CompletionTipRow(
                        icon: "book.fill",
                        title: "Browse Protocols",
                        description: "Access 80+ hours of WFR content"
                    )
                    
                    CompletionTipRow(
                        icon: "gearshape.fill",
                        title: "Customize Settings",
                        description: "Personalize your experience anytime"
                    )
                }
                .padding(.horizontal, 32)
                .opacity(animateContent ? 1.0 : 0.0)
                
                Spacer()
                
                // Get Started Button
                Button {
                    coordinator.completeOnboarding()
                } label: {
                    HStack {
                        Text("Get Started")
                            .font(.headline)
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            colors: [.blue, .green],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundStyle(.white)
                    .cornerRadius(16)
                    .shadow(color: .blue.opacity(0.3), radius: 12, y: 6)
                }
                .padding(.horizontal, 32)
                .scaleEffect(animateContent ? 1.0 : 0.9)
                .opacity(animateContent ? 1.0 : 0.0)
                
                VStack(spacing: 4) {
                    Text("by BlackElkMountainMedicine.com")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("🦝 Jimmothy the Raccoon WFR approves this setup!")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .italic()
                }
                .padding(.bottom, 32)
                .opacity(animateContent ? 1.0 : 0.0)
            }
            
            // Confetti overlay
            if showConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                animateContent = true
            }
            
            // Show confetti after a brief delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showConfetti = true
            }
        }
    }
}

// MARK: - Completion Tip Row
private struct CompletionTipRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.bold())
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

// MARK: - Confetti View
private struct ConfettiView: View {
    @State private var confettiPieces: [ConfettiPiece] = []
    
    struct ConfettiPiece: Identifiable {
        let id = UUID()
        let color: Color
        let x: CGFloat
        let y: CGFloat
        let rotation: Double
        let delay: Double
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(confettiPieces) { piece in
                    Circle()
                        .fill(piece.color)
                        .frame(width: 8, height: 8)
                        .rotationEffect(.degrees(piece.rotation))
                        .position(x: piece.x, y: piece.y)
                        .transition(.opacity.combined(with: .scale))
                }
            }
            .onAppear {
                generateConfetti(in: geometry.size)
            }
        }
    }
    
    private func generateConfetti(in size: CGSize) {
        let colors: [Color] = [.blue, .green, .yellow, .orange, .red, .purple, .pink]
        
        for i in 0..<30 {
            let piece = ConfettiPiece(
                color: colors.randomElement() ?? .blue,
                x: CGFloat.random(in: 0...size.width),
                y: -20,
                rotation: Double.random(in: 0...360),
                delay: Double(i) * 0.05
            )
            confettiPieces.append(piece)
            
            // Animate each piece falling
            withAnimation(
                .easeIn(duration: 2.0)
                    .delay(piece.delay)
            ) {
                if let index = confettiPieces.firstIndex(where: { $0.id == piece.id }) {
                    confettiPieces[index] = ConfettiPiece(
                        color: piece.color,
                        x: piece.x + CGFloat.random(in: -50...50),
                        y: size.height + 20,
                        rotation: piece.rotation + Double.random(in: 360...720),
                        delay: piece.delay
                    )
                }
            }
        }
        
        // Remove confetti after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation {
                confettiPieces.removeAll()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    OnboardingView(isPresented: .constant(true))
        .environment(AppSettings())
}
