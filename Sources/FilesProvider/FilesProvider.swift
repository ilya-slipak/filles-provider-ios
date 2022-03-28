import Foundation

public struct FilesProvider {
    private let name: String
    private let directory: FileManager.SearchPathDirectory
    private let domainMask: FileManager.SearchPathDomainMask
    private let fileManager: FileManager
    
    public init(
        name: String = "Storage",
        for directory: FileManager.SearchPathDirectory = .documentDirectory,
        in domainMask: FileManager.SearchPathDomainMask = .userDomainMask,
        fileManager: FileManager = .default
    ) {
        self.name = name
        self.directory = directory
        self.domainMask = domainMask
        self.fileManager = fileManager
    }
}

// MARK: - FileManageable

extension FilesProvider: FilesManageable {
    public func save(data: Data, by name: String) throws -> URL {
        let storageURL = try getStorageURL()
        let fileURL = storageURL.appendingPathComponent(name)
        let isExist = fileManager.fileExists(atPath: fileURL.path)
        guard !isExist else {
            throw FilesProviderError.urlAlreadyInUse
        }
        try data.write(to: fileURL)
        return fileURL
    }
    
    public func getFileURL(by name: String) throws -> URL {
        let storageURL = try getStorageURL()
        let fileURL = storageURL.appendingPathComponent(name)
        let isExist = fileManager.fileExists(atPath: fileURL.path)
        guard isExist else {
            throw FilesProviderError.noFile
        }
        return fileURL
    }
    
    public func delete(by name: String) throws {
        let storageURL = try getStorageURL()
        let fileURL = storageURL.appendingPathComponent(name)
        let isExist = fileManager.fileExists(atPath: fileURL.path)
        guard isExist else {
            throw FilesProviderError.noFile
        }
        try fileManager.removeItem(atPath: fileURL.path)
    }
    
    public func removeAll() throws {
        let storageURL = try getStorageURL()
        try delete(by: storageURL.absoluteString)
    }
}

// MARK: - FilesProviderConfigurable

extension FilesProvider: FilesProviderConfigurable {
    func getStorageURL() throws -> URL {
        let urls = fileManager.urls(for: directory, in: domainMask)
        guard let directory = urls.first else {
            throw FilesProviderError.noDirectory
        }
        let storageURL = directory.appendingPathComponent(name)
        let isExist = fileManager.fileExists(atPath: storageURL.path)
        if !isExist {
            try fileManager.createDirectory(
                at: storageURL,
                withIntermediateDirectories: false,
                attributes: nil
            )
        }
        return storageURL
    }
}
