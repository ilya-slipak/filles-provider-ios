import Foundation

extension FileManager {
    @objc
    public func save(data: Data, to url: URL) throws {
        try data.write(to: url)
    }
}
