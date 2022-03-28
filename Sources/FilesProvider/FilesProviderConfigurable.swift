import Foundation

protocol FilesProviderConfigurable {
    func getStorageURL() throws -> URL
}
