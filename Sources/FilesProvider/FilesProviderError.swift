import Foundation

public enum FilesProviderError {
    case noDirectory
    case noFile
}

// MARK: - Error

extension FilesProviderError: Error {
    public var localizedDescription: String {
        switch self {
        case .noDirectory:
            return "There is no directory by specified URL"
        case .noFile:
            return "There is no file by specified URL"
        }
    }
}
