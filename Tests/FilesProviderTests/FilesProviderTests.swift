import XCTest
@testable import FilesProvider

final class FilesProviderTests: XCTestCase {
    // MARK: - Private Properties
    
    let filesProvider: FilesManageable = FilesProvider(fileManager: MockFileManager())
    
    // MARK: - Private API
    
    private func givenSavedFile(by fileName: String) throws -> URL {
        let fileData: Data = Data()
        return try filesProvider.save(data: fileData, by: fileName)
    }
    
    // MARK: - Test Success Cases
    
    func test_saveFile_success() throws {
        let fileName: String = "TestSaveFileName.txt"
        XCTAssertNoThrow(try givenSavedFile(by: fileName))
    }
    
    func test_getFileURL_success() throws {
        let fileName: String = "TestGetFileName.txt"
        XCTAssertNoThrow(try givenSavedFile(by: fileName))
        XCTAssertNoThrow(try filesProvider.getFileURL(by: fileName))
    }
    
    func test_deleteFile_success() throws {
        let fileName: String = "TestDeleteFileName.txt"
        XCTAssertNoThrow(try givenSavedFile(by: fileName))
        XCTAssertNoThrow(try filesProvider.delete(by: fileName))
    }
    
    // MARK: - Test Error Cases
    
    func test_saveFile_error_urlAlreadyInUse() throws {
        let expectedError: FilesProviderError = .urlAlreadyInUse
        let fileName: String = "TestAlreadyInUseFileName.txt"
        let failDescription: String = "FilesProvider tries to save file by the name that already in use, but there should be an error: urlAlreadyInUse"
        XCTAssertNoThrow(try givenSavedFile(by: fileName))
        XCTAssertThrowsError(try givenSavedFile(by: fileName), failDescription) { error in
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
    }
    
    func test_getFileURL_error_noFile() throws {
        let expectedError: FilesProviderError = .noFile
        var fileName: String = "TestGetFileName.txt"
        let failDescription: String = "FilesProvider tries to retrieve a file that does not exist, but there should be an error: noFile"
        XCTAssertNoThrow(try givenSavedFile(by: fileName))
        fileName += "TestError"
        XCTAssertThrowsError(try filesProvider.getFileURL(by: fileName), failDescription) { error in
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
    }
    
    func test_deleteFile_error_noFile() throws {
        let expectedError: FilesProviderError = .noFile
        let fileName: String = "TestDeleteFileNameNoFileError.txt"
        let failDescription: String = "FilesProvider tries to delete a file that does not exist, but there should be an error: noFile"
        XCTAssertThrowsError(try filesProvider.delete(by: fileName), failDescription) { error in
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
    }
}
