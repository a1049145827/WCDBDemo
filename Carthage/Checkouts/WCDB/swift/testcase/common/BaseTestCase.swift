/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import XCTest
import WCDBSwift

class BaseTestCase: XCTestCase, Named {
    static let baseDirectory: URL = {
        var url = URL(fileURLWithPath: NSTemporaryDirectory())
        url.appendPathComponent(String(describing: BaseTestCase.self))
        return url
    }()

    lazy var recommendedDirectory: URL = {
        var url = BaseTestCase.baseDirectory
        url.appendPathComponent(self.className)
        return url
    }()

    lazy var recommendedPath: URL = {
        var url = recommendedDirectory
        url.appendPathComponent(String(UInt(bitPattern: self.name.hash)))
        return url
    }()

    lazy var recommendTag: Tag = recommendedPath.hashValue

    let fileManager = FileManager.default

    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false

        if fileManager.fileExists(atPath: recommendedDirectory.path) {
            XCTAssertNoThrow(try fileManager.removeItem(at: recommendedDirectory))
        }
        XCTAssertNoThrow(try fileManager.createDirectory(at: recommendedDirectory,
                                                         withIntermediateDirectories: true,
                                                         attributes: nil))
    }
}
