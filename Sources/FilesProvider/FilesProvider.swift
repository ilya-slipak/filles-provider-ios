import Foundation

public struct FilesProvider {
    private let name: String
    private let directory: FileManager.SearchPathDirectory
    private let domainMask: FileManager.SearchPathDomainMask
    
    public init(
        name: String = "Storage",
        for directory: FileManager.SearchPathDirectory = .documentDirectory,
        in domainMask: FileManager.SearchPathDomainMask = .userDomainMask
    ) {
        self.name = name
        self.directory = directory
        self.domainMask = domainMask
    }
}

// MARK: - FileManageable

extension FilesProvider: FilesManageable {
    public var storageURL: URL? {
        let paths = FileManager.default.urls(for: directory, in: domainMask)
        let documentsDirectory = paths.first!
        let storageURL = documentsDirectory.appendingPathComponent(name)
        let isExist = fileExists(at: storageURL.path)
        if !isExist {
            do {
                try FileManager.default.createDirectory(
                    at: storageURL,
                    withIntermediateDirectories: false,
                    attributes: nil
                )
            } catch {
                debugPrint(error.localizedDescription)
                return nil
            }
        }
        return storageURL
    }
}
