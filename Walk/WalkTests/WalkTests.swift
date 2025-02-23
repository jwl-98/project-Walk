//
//  WalkTests.swift
//  WalkTests
//
//  Created by 진욱의 Macintosh on 2/23/25.
//

import Testing

struct WalkTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        
    }
    func testConcurrentGroupPerformance() {
        measure {
            let expectation = XCTestExpectation(description: "Concurrent Group")
            // Concurrent Group 코드 실행
            wait(for: [expectation], timeout: 10.0)
        }
    }
    
    
}
