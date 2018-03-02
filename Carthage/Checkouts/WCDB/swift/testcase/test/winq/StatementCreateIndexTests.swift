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

class StatementCreateIndexTests: BaseTestCase {

    func testCreateIndex() {
        //Give
        let column1 = Column(named: "column1")

        let index1 = ColumnIndex(with: column1)
        let index2 = ColumnIndex(with: Column(named: "column2"), orderBy: .ascending)

        let indexName1 = "index1"
        let table1 = "table1"

        //Then
        XCTAssertEqual(StatementCreateIndex().statementType, StatementType.createIndex)

        WINQAssertEqual(
            StatementCreateIndex().create(index: indexName1).on(table: table1, indexesBy: index1, index2),
            "CREATE INDEX IF NOT EXISTS index1 ON table1(column1, column2 ASC)"
        )

        WINQAssertEqual(
            StatementCreateIndex()
                .create(index: indexName1, isUnique: true)
                .on(table: table1, indexesBy: index1, index2),
            "CREATE UNIQUE INDEX IF NOT EXISTS index1 ON table1(column1, column2 ASC)"
        )

        WINQAssertEqual(
            StatementCreateIndex()
                .create(index: indexName1, ifNotExists: false)
                .on(table: table1, indexesBy: index1, index2),
            "CREATE INDEX index1 ON table1(column1, column2 ASC)"
        )

        WINQAssertEqual(
            StatementCreateIndex()
                .create(index: indexName1)
                .on(table: table1, indexesBy: index1, index2).`where`(column1 >= 1),
            "CREATE INDEX IF NOT EXISTS index1 ON table1(column1, column2 ASC) WHERE (column1 >= 1)"
        )
    }
}
