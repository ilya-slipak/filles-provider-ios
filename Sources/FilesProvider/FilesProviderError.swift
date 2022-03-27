import Foundation

public enum FilesProviderError {
    case emptyStorage
    case emptyFile
}

// MARK: - Error

extension FilesProviderError: Error {
    public var localizedDescription: String {
        switch self {
        case .emptyStorage:
            return "Storage doesn't exist"
        case .emptyFile:
            return "There is no file by specified URL"
        }
    }
}
