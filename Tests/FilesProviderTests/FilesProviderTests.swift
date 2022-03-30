import XCTest
@testable import FilesProvider

final class FilesProviderTests: XCTestCase {
    // MARK: - Private Properties
    
    let filesProvider: FilesManageable = FilesProvider(fileManager: MockFileManager())
    
    // MARK: - Private API
    
   private func givenSavedFile(fileName: String) throws -> URL {
        let fileData: Data = Data()
        return try filesProvider.save(data: fileData, by: fileName)
    }
    
    // MARK: - Test Methods
    
    func testSave() throws {
        let fileName: String = "TestSaveFileName.txt"
        XCTAssertNoThrow(try givenSavedFile(fileName: fileName))
    }

    func testGetFileURL() throws {
        let fileName: String = "TestGetFileName.txt"
        XCTAssertNoThrow(try givenSavedFile(fileName: fileName))
        XCTAssertNoThrow(try filesProvider.getFileURL(by: fileName))
    }
    
    func testDelete() throws {
        let fileName: String = "TestDeleteFileName.txt"
        XCTAssertNoThrow(try givenSavedFile(fileName: fileName))
        XCTAssertNoThrow(try filesProvider.delete(by: fileName))
    }
}
