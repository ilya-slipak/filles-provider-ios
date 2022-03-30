import Foundation
@testable import FilesProvider

final class MockFileManager: FileManager {
    // MARK: - Private Properties
    
    private var inMemoryStorage: [URL: Data] = [:]
    
    // MARK: - Override
    
    override func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]? = nil) throws {
        let data: Data = url.absoluteString.data(using: .utf8)!
        try save(data: data, to: url)
    }
    
    override func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        return [.init(string: "unitTest/inMemoryStorage/dev/")!]
    }
    
    override func save(data: Data, to url: URL) throws {
        inMemoryStorage[url] = data
    }
    
    override func fileExists(atPath path: String) -> Bool {
        return inMemoryStorage.contains(where: { $0.key.absoluteString == path })
    }
    
    override func removeItem(atPath path: String) throws {
        inMemoryStorage.removeValue(forKey: URL(string: path)!)
    }
}
