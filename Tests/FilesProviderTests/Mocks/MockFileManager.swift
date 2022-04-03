import Foundation
@testable import FilesProvider

final class MockFileManager: FileManager {
    // MARK: - Private Properties
    
    private var inMemoryStorage: [String: Data] = [:]
    
    // MARK: - Override
    
    override func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]? = nil) throws {
        let data: Data = url.absoluteString.data(using: .utf8)!
        try save(data: data, to: url.absoluteURL)
    }
    
    override func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        guard let storageURL: URL = .init(string: "unitTest/inMemoryStorage/dev/") else {
            return []
        }
        inMemoryStorage["unitTest/inMemoryStorage/dev/"] = Data()
        return [storageURL]
    }
    
    override func save(data: Data, to url: URL) throws {
        inMemoryStorage[url.absoluteString] = data
    }
    
    override func fileExists(atPath path: String) -> Bool {
        return inMemoryStorage.contains(where: { $0.key == path })
    }
    
    override func removeItem(atPath path: String) throws {
        inMemoryStorage.removeValue(forKey: path)
    }
}
