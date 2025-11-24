#!/bin/bash

# Fix 1: Add Combine import to WalletPassManager.swift
sed -i '' 's/import SwiftUI$/import SwiftUI\nimport Combine/' "WFR TrailTriage/WalletPassManager.swift"

# Fix 2: Add SwiftData imports to preview files
sed -i '' 's/import SwiftUI$/import SwiftUI\nimport SwiftData/' "WFR TrailTriage/Views/Notes/SOAPNoteCardView.swift"
sed -i '' 's/import PDFKit$/import PDFKit\nimport SwiftData/' "WFR TrailTriage/Views/Notes/ShareMultipleNotesView.swift"
sed -i '' 's/import Charts$/import Charts\nimport SwiftData/' "WFR TrailTriage/Views/Vitals/VitalsTimelineView.swift"
sed -i '' 's/import SwiftUI$/import SwiftUI\nimport SwiftData/' "WFR TrailTriage/Views/Vitals/VitalsTrackingPanel.swift"

# Fix 3: Remove "return" from preview blocks (5 files)
sed -i '' 's/    return NavigationStack {/    NavigationStack {/' "WFR TrailTriage/Views/Notes/NoteDetailView.swift"
sed -i '' 's/    return NavigationStack {/    NavigationStack {/' "WFR TrailTriage/Views/Notes/SOAPNoteCardView.swift"
sed -i '' 's/    return ShareMultipleNotesView(/    ShareMultipleNotesView(/' "WFR TrailTriage/Views/Notes/ShareMultipleNotesView.swift"
sed -i '' 's/    return VStack {/    VStack {/' "WFR TrailTriage/Views/Vitals/VitalsTrackingPanel.swift"
sed -i '' 's/    return VitalsTimelineView(/    VitalsTimelineView(/' "WFR TrailTriage/Views/Vitals/VitalsTimelineView.swift"

echo "Fixes applied successfully!"
