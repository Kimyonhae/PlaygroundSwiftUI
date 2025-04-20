//
//  GithubSearchList.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 4/19/25.
//

import XCTest
@testable import PlaygroundSwiftUI

final class GithubSearchList: XCTestCase {
    
    func testExamplePlus() {
        let a: Int = 1
        let b: Int = 2
        XCTAssertEqual(a + b, 3)
    }
    
    func testDebugPrint() {
        let description = self.expectation(description: "GITHUB API 기다리기")
        let viewModel = GithubListViewModel()
        print("---------- DEBUG PRINT ------------")
        viewModel.fetchGithubUsers(username: "") { isSuccess in
            print("코드가 통과되었는지 확인합니다 isSuccess : \(isSuccess)")
            description.fulfill()
        }
        wait(for: [description], timeout: 5)
        print("-------- DEBUG PRINT END ----------")
        XCTAssertTrue(true)
    }
}
