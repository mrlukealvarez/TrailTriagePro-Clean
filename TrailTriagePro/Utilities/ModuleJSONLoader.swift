//
//  ModuleJSONLoader.swift
//  TrailTriagePro
//
//  Created by TrailTriage Bot on 11/25/25.
//

import Foundation

/// Loads WFR modules from the JSON files stored in `Data/Modules/`.
struct ModuleJSONLoader {
    static func loadModules(from bundle: Bundle = .main) throws -> [WFRModule] {
        let urls = ModuleJSONLoader.jsonURLs(in: bundle)
        guard !urls.isEmpty else { throw LoaderError.missingResources }
        
        let decoder = JSONDecoder()
        return try urls
            .map { url -> FileModule in
                let data = try Data(contentsOf: url)
                return try decoder.decode(FileModule.self, from: data)
            }
            .sorted(by: { $0.orderIndex < $1.orderIndex })
            .map { $0.toModel() }
    }
}

extension ModuleJSONLoader {
    enum LoaderError: Error {
        case missingResources
    }
    
    struct FileModule: Decodable {
        var moduleTitle: String
        var moduleSubtitle: String?
        var category: String
        var iconName: String?
        var moduleDescription: String?
        var sections: [FileSection]
        var orderIndex: Int
        var location: String?
        var pageImageNames: [String]?
        
        func toModel() -> WFRModule {
            WFRModule(
                moduleTitle: moduleTitle,
                moduleSubtitle: moduleSubtitle,
                category: mapCategory(),
                iconName: iconName,
                moduleDescription: moduleDescription,
                sections: sections
                    .sorted(by: { $0.orderIndex < $1.orderIndex })
                    .map { $0.toModel() },
                orderIndex: orderIndex,
                location: location,
                pageImageNames: pageImageNames
            )
        }
        
        private func mapCategory() -> ModuleCategory {
            ModuleSeedData.mapCategory(category)
        }
    }
    
    struct FileSection: Decodable {
        var title: String
        var subtitle: String?
        var orderIndex: Int
        var content: [FileContent]
        
        enum CodingKeys: String, CodingKey {
            case title
            case legacyTitle = "sectionTitle"
            case subtitle
            case orderIndex
            case content
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let explicit = try container.decodeIfPresent(String.self, forKey: .title) {
                self.title = explicit
            } else if let legacy = try container.decodeIfPresent(String.self, forKey: .legacyTitle) {
                self.title = legacy
            } else {
                self.title = "Untitled Section"
            }
            self.subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
            self.orderIndex = try container.decode(Int.self, forKey: .orderIndex)
            self.content = try container.decode([FileContent].self, forKey: .content)
        }
        
        func toModel() -> WFRModuleSection {
            WFRModuleSection(
                title: title,
                subtitle: subtitle,
                content: content
                    .sorted(by: { $0.orderIndex < $1.orderIndex })
                    .map { $0.toModel() },
                orderIndex: orderIndex
            )
        }
    }
    
    struct FileContent: Decodable {
        var type: String
        var content: String?
        var orderIndex: Int
        var metadata: String?
        var location: String?
        var pageImageNames: [String]?
        var items: [String]?
        var tableData: TableData?
        
        struct TableData: Codable {
            var headers: [String]?
            var rows: [[String]]
        }
        
        func toModel() -> WFRModuleContentBlock {
            WFRModuleContentBlock(
                type: ModuleSeedData.mapContentType(type),
                content: resolvedContent(),
                orderIndex: orderIndex,
                metadata: resolvedMetadata(),
                location: location,
                pageImageNames: pageImageNames
            )
        }
        
        private func resolvedContent() -> String {
            if let table = tableData {
                return table.rows
                    .map { $0.joined(separator: " | ") }
                    .joined(separator: "\n")
            }
            if let list = items, !list.isEmpty {
                return list.joined(separator: "\n")
            }
            return content ?? ""
        }
        
        private func resolvedMetadata() -> String? {
            if let metadata {
                return metadata
            }
            if let table = tableData {
                return encodeMetadata(table)
            }
            if let list = items {
                return encodeMetadata(BulletMetadata(items: list))
            }
            return nil
        }
        
        private func encodeMetadata<T: Codable>(_ value: T) -> String? {
            guard let data = try? JSONEncoder().encode(value) else { return nil }
            return String(data: data, encoding: .utf8)
        }
    }
    
    struct BulletMetadata: Codable {
        var items: [String]
    }
}

private extension ModuleJSONLoader {
    static func jsonURLs(in bundle: Bundle) -> [URL] {
        if let nested = bundle.urls(forResourcesWithExtension: "json", subdirectory: "Data/Modules") {
            return nested
        }
        
        guard let flat = bundle.urls(forResourcesWithExtension: "json", subdirectory: nil) else {
            return []
        }
        
        return flat.filter { url in
            let name = url.lastPathComponent
            return name.hasPrefix("module_") || name == "module_TOC.json"
        }
    }
}

