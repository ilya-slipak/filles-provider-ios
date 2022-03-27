import Foundation

public protocol FilesManageable {
    var storageURL: URL? { get }
}

// MARK: - FileManageable + Extension

extension FilesManageable {
    public func save(data: Data, fileName: String) throws -> URL {
        let storageURL = try getStorage()
        let fileURL = storageURL.appendingPathComponent(fileName)
        let isExist = fileExists(at: fileURL.path)
        if !isExist {
            try data.write(to: fileURL)
        }
        return fileURL
    }
    
    public func getFileURL(by name: String) throws -> URL {
        let storageURL = try getStorage()
        let fileURL = storageURL.appendingPathComponent(name)
        return fileURL
    }
    
    public func fileExists(at path: String) -> Bool {
        FileManager.default.fileExists(atPath: path)
    }
    
    public func delete(at path: String) throws {
        let isExist = fileExists(at: path)
        guard isExist else {
            return
        }
        try FileManager.default.removeItem(atPath: path)
    }
    
    public func removeAll() throws {
        let storageURL = try getStorage()
        let path = storageURL.absoluteString
        try delete(at: path)
    }
}

// MARK: - FileStorable + Private Extension

fileprivate extension FilesManageable {
    func getStorage() throws -> URL {
        guard let storageURL = storageURL else {
            throw FilesProviderError.emptyStorage
        }
        return storageURL
    }
}
