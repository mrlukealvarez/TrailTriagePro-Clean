//
//  FAQView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/16/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Frequently asked questions!
//

import SwiftUI

struct FAQView: View {
    @State private var searchText = ""
    
    private var filteredFAQs: [FAQItem] {
        if searchText.isEmpty {
            return FAQItem.allFAQs
        }
        return FAQItem.allFAQs.filter { faq in
            faq.question.localizedCaseInsensitiveContains(searchText) ||
            faq.answer.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        List {
            ForEach(FAQCategory.allCases, id: \.self) { category in
                let categoryFAQs = filteredFAQs.filter { $0.category == category }
                
                if !categoryFAQs.isEmpty {
                    Section(header: Text(category.rawValue)) {
                        ForEach(categoryFAQs) { faq in
                            FAQDisclosureRow(faq: faq)
                        }
                    }
                }
            }
        }
        .navigationTitle("FAQ")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Search questions")
    }
}

// MARK: - FAQ Row View
private struct FAQDisclosureRow: View {
    let faq: FAQItem
    @State private var isExpanded = false
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            Text(faq.answer)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.vertical, 8)
        } label: {
            HStack {
                Image(systemName: faq.icon)
                    .foregroundStyle(.blue)
                    .frame(width: 24)
                
                Text(faq.question)
                    .font(.body)
            }
        }
    }
}

// MARK: - FAQ Category
enum FAQCategory: String, CaseIterable {
    case general = "General"
    case subscription = "Subscription & Billing"
    case features = "Features"
    case support = "Support & Donations"
    case technical = "Technical"
    case usage = "Using TrailTriage"
}

// MARK: - FAQ Item
struct FAQItem: Identifiable {
    let id = UUID()
    let category: FAQCategory
    let question: String
    let answer: String
    let icon: String
    
    static let allFAQs: [FAQItem] = [
        // General
        FAQItem(
            category: .general,
            question: "What is TrailTriage?",
            answer: "TrailTriage is a comprehensive wilderness medicine reference app designed for Wilderness First Responders (WFRs). It provides offline access to medical protocols, SOAP note documentation, and emergency procedures for backcountry situations.",
            icon: "info.circle.fill"
        ),
        FAQItem(
            category: .general,
            question: "Who is this app for?",
            answer: "TrailTriage is designed for Wilderness First Responders, outdoor guides, search and rescue personnel, and anyone responsible for medical care in remote environments. It's based on 80+ hours of WFR training content.",
            icon: "person.fill"
        ),
        FAQItem(
            category: .general,
            question: "Can I use this app offline?",
            answer: "Yes! All content in TrailTriage is available offline once downloaded. This ensures you have access to critical medical information even in remote areas without cellular service.",
            icon: "wifi.slash"
        ),
        
        // Subscription & Billing
        FAQItem(
            category: .subscription,
            question: "What's included with the free trial?",
            answer: "The 3-day free trial includes full access to all TrailTriage features: complete WFR protocols, SOAP note creation, vital signs tracking, and all reference materials. No credit card required to start.",
            icon: "gift.fill"
        ),
        FAQItem(
            category: .subscription,
            question: "What's the difference between subscription and lifetime purchase?",
            answer: "The monthly subscription ($9.99/year) provides ongoing access with regular updates. The lifetime purchase ($49.99 one-time) gives you permanent access to all features without recurring charges. Both options include the same features.",
            icon: "creditcard.fill"
        ),
        FAQItem(
            category: .subscription,
            question: "Can I cancel my subscription anytime?",
            answer: "Yes! You can cancel your subscription at any time through your Apple ID account settings. Your access will continue until the end of the current billing period.",
            icon: "xmark.circle.fill"
        ),
        FAQItem(
            category: .subscription,
            question: "How do I restore my purchase on a new device?",
            answer: "Go to Settings → Manage Subscription and tap 'Restore Purchases'. Your purchases are tied to your Apple ID and will automatically sync across all your devices.",
            icon: "arrow.clockwise.circle.fill"
        ),
        
        // Features
        FAQItem(
            category: .features,
            question: "What is a SOAP note?",
            answer: "SOAP (Subjective, Objective, Assessment, Plan) is a standardized method for documenting medical encounters. TrailTriage helps you create professional SOAP notes with guided fields for patient history, vital signs, assessments, and treatment plans.",
            icon: "doc.text.fill"
        ),
        FAQItem(
            category: .features,
            question: "Can I export my SOAP notes?",
            answer: "Yes! You can export your SOAP notes as PDFs for sharing with medical professionals or for your records. Go to Settings → Export & Backup to access export options.",
            icon: "square.and.arrow.up.fill"
        ),
        FAQItem(
            category: .features,
            question: "How do vital signs tracking work?",
            answer: "TrailTriage includes a comprehensive vital signs tracker that records heart rate, respiratory rate, blood pressure, temperature, and more. You can log multiple sets of vitals over time to track patient trends.",
            icon: "heart.text.square.fill"
        ),
        FAQItem(
            category: .features,
            question: "Can I bookmark protocols?",
            answer: "Yes! Tap the bookmark icon on any protocol to save it to your favorites for quick access. Find all your bookmarks in the Reference section.",
            icon: "bookmark.fill"
        ),
        
        // Support & Donations
        FAQItem(
            category: .support,
            question: "What is Friends of Custer Search and Rescue?",
            answer: "Friends of Custer Search and Rescue is a 501(c)(3) nonprofit organization that supports volunteer search and rescue teams in the Black Hills of South Dakota. 100% of donations go directly to training, equipment, and operational costs.",
            icon: "cross.case.fill"
        ),
        FAQItem(
            category: .support,
            question: "Are donations tax-deductible?",
            answer: "Yes! Donations to Friends of Custer Search and Rescue are tax-deductible as they are a registered 501(c)(3) nonprofit organization. Keep your receipt for tax purposes.",
            icon: "doc.text.fill"
        ),
        FAQItem(
            category: .support,
            question: "How do tips support the developer?",
            answer: "Tips help support solo developer Luke in continuing to maintain TrailTriage, adding new features, updating content, and keeping the app ad-free. Every tip is deeply appreciated!",
            icon: "heart.fill"
        ),
        
        // Technical
        FAQItem(
            category: .technical,
            question: "Why isn't the app loading my products?",
            answer: "Make sure you have a stable internet connection when first launching the app. StoreKit requires an initial connection to load product information. Once loaded, all content is available offline.",
            icon: "exclamationmark.triangle.fill"
        ),
        FAQItem(
            category: .technical,
            question: "How do I clear the cache?",
            answer: "Go to Settings → Advanced → Clear Cache. This will remove temporary files and may improve performance. Your saved SOAP notes and offline content will not be affected.",
            icon: "trash.fill"
        ),
        FAQItem(
            category: .technical,
            question: "Does TrailTriage sync across devices?",
            answer: "Yes! If you have iCloud enabled, your SOAP notes, bookmarks, and preferences automatically sync across all your devices signed in with the same Apple ID.",
            icon: "icloud.fill"
        ),
        FAQItem(
            category: .technical,
            question: "How much storage does the app use?",
            answer: "TrailTriage uses approximately 8-10 MB of storage, including offline content. You can view detailed storage usage in Settings → Advanced → Storage Details.",
            icon: "internaldrive.fill"
        ),
        
        // Usage
        FAQItem(
            category: .usage,
            question: "How do I create a new SOAP note?",
            answer: "Tap the '+' button on the SOAP Notes tab. Fill in the patient information, vital signs, and assessment details. The note auto-saves as you type.",
            icon: "doc.badge.plus"
        ),
        FAQItem(
            category: .usage,
            question: "Can I edit a SOAP note after saving?",
            answer: "Yes! Tap on any saved SOAP note to view and edit it. All changes are automatically saved. You can also delete notes by swiping left on them in the list.",
            icon: "pencil"
        ),
        FAQItem(
            category: .usage,
            question: "What are the recommended best practices?",
            answer: "Always document patient encounters as soon as possible while details are fresh. Use the SOAP format consistently. Record vital signs regularly. Keep your device charged in the field. Export important notes as backup.",
            icon: "checkmark.seal.fill"
        ),
        FAQItem(
            category: .usage,
            question: "Is this app a replacement for WFR training?",
            answer: "No! TrailTriage is a reference tool and documentation aid. It is not a substitute for proper Wilderness First Responder training and certification. Always follow your training and local protocols.",
            icon: "exclamationmark.shield.fill"
        )
    ]
}

#Preview {
    NavigationStack {
        FAQView()
    }
}
