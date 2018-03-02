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

class ColumnTypeTests: BaseTestCase {

    func testColumnType() {
        WINQAssertEqual(ColumnType.integer32, "INTEGER")

        WINQAssertEqual(ColumnType.integer64, "INTEGER")

        WINQAssertEqual(ColumnType.float, "REAL")

        WINQAssertEqual(ColumnType.text, "TEXT")

        WINQAssertEqual(ColumnType.BLOB, "BLOB")

        WINQAssertEqual(ColumnType.null, "NULL")

        XCTAssertEqual(Int32.columnType, .integer32)

        XCTAssertEqual(Int64.columnType, .integer64)

        XCTAssertEqual(Double.columnType, .float)

        XCTAssertEqual(String.columnType, .text)

        XCTAssertEqual(Data.columnType, .BLOB)
    }
}
