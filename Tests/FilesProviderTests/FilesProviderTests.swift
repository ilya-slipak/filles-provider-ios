import XCTest
@testable import FilesProvider

final class FilesProviderTests: XCTestCase {

    // MARK: - Private API
    
    private func saveFile(by fileName: String, filesProvider: FilesManageable) throws -> URL {
        let fileData: Data = Data()
        return try filesProvider.save(data: fileData, by: fileName)
    }
    
    // MARK: - Test Success Cases
    
    func test_saveFile_success() throws {
        let filesProvider: FilesManageable = FilesProvider(fileManager: MockFileManager())
        let fileName: String = "TestFileName.txt"
        XCTAssertNoThrow(try saveFile(by: fileName, filesProvider: filesProvider))
    }
    
    func test_getFileURL_success() throws {
        let filesProvider: FilesManageable = FilesProvider(fileManager: MockFileManager())
        let fileName: String = "TestFileName.txt"
        XCTAssertNoThrow(try saveFile(by: fileName, filesProvider: filesProvider))
        XCTAssertNoThrow(try filesProvider.getFileURL(by: fileName))
    }
    
    func test_deleteFile_success() throws {
        let filesProvider: FilesManageable = FilesProvider(fileManager: MockFileManager())
        let fileName: String = "TestFileName.txt"
        XCTAssertNoThrow(try saveFile(by: fileName, filesProvider: filesProvider))
        XCTAssertNoThrow(try filesProvider.delete(by: fileName))
    }
    
    func test_removeAll_success() {
        let filesProvider: FilesManageable = FilesProvider(fileManager: MockFileManager())
        XCTAssertNoThrow(try filesProvider.removeAll())
    }
    
    // MARK: - Test Error Cases
    
    func test_saveFile_error_urlAlreadyInUse() throws {
        let filesProvider: FilesManageable = FilesProvider(fileManager: MockFileManager())
        let expectedError: FilesProviderError = .urlAlreadyInUse
        let fileName: String = "TestFileName.txt"
        let failDescription: String = "FilesProvider tries to save file by the name that already in use, but there should be an error: urlAlreadyInUse"
        XCTAssertNoThrow(try saveFile(by: fileName, filesProvider: filesProvider))
        XCTAssertThrowsError(try saveFile(by: fileName, filesProvider: filesProvider), failDescription) { error in
            guard let error = asFilesProviderError(error) else {
                return XCTFail(error.localizedDescription)
            }
            XCTAssertEqual(error, expectedError)
        }
    }
    
    func test_getFileURL_error_noFile() throws {
        let filesProvider: FilesManageable = FilesProvider(fileManager: MockFileManager())
        let expectedError: FilesProviderError = .noFile
        var fileName: String = "TestFileName.txt"
        let failDescription: String = "FilesProvider tries to retrieve a file that does not exist, but there should be an error: noFile"
        XCTAssertNoThrow(try saveFile(by: fileName, filesProvider: filesProvider))
        fileName += "TestError"
        XCTAssertThrowsError(try filesProvider.getFileURL(by: fileName), failDescription) { error in
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
    }
    
    func test_deleteFile_error_noFile() throws {
        let filesProvider: FilesManageable = FilesProvider(fileManager: MockFileManager())
        let expectedError: FilesProviderError = .noFile
        let fileName: String = "TestFile.txt"
        let failDescription: String = "FilesProvider tries to delete a file that does not exist, but there should be an error: noFile"
        XCTAssertThrowsError(try filesProvider.delete(by: fileName), failDescription) { error in
            guard let error = asFilesProviderError(error) else {
                return XCTFail(error.localizedDescription)
            }
            XCTAssertEqual(error, expectedError)
        }
    }
}

// MARK: - Helpers

extension FilesProviderTests {
    private func asFilesProviderError(_ error: Error) -> FilesProviderError? {
        guard let error = error as? FilesProviderError else {
            return nil
        }
        return error
    }
}
