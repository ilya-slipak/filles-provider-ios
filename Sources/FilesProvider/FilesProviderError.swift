import Foundation

public enum FilesProviderError {
    case noDirectory
    case noFile
    case urlAlreadyInUse
}

// MARK: - LocalizedError

extension FilesProviderError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noDirectory:
            return "There is no directory by specified URL"
        case .noFile:
            return "There is no file by specified URL"
        case .urlAlreadyInUse:
            return "The file already exist by specified URL"
        }
    }
}
