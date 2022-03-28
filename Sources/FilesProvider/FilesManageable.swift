import Foundation

public protocol FilesManageable {
    func save(data: Data, fileName: String) throws -> URL
    func getFileURL(by name: String) throws -> URL
    func delete(at path: String) throws
    func removeAll() throws
}
