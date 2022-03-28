import Foundation

public enum FilesProviderError {
    case emptyDirectory
    case emptyFile
}

// MARK: - Error

extension FilesProviderError: Error {
    public var localizedDescription: String {
        switch self {
        case .emptyDirectory:
            return "Directory is empty"
        case .emptyFile:
            return "There is no file by specified URL"
        }
    }
}
