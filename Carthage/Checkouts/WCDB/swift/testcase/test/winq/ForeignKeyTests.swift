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

class ForeignKeyTests: BaseTestCase {

    func generateForeignKey() -> ForeignKey {
        let column1 = Column(named: "column1")
        let column2 = Column(named: "column2")
        return ForeignKey(withForeignTable: "testForeignKeyTable", and: column1, column2)
    }

    func testForeignKey() {
        WINQAssertEqual(
            generateForeignKey().onDelete(.setNull),
            "REFERENCES testForeignKeyTable(column1, column2) ON DELETE SET NULL"
        )

        WINQAssertEqual(
            generateForeignKey().onUpdate(.setDefault),
            "REFERENCES testForeignKeyTable(column1, column2) ON UPDATE SET DEFAULT"
        )

        WINQAssertEqual(
            generateForeignKey().onDelete(.cascade),
            "REFERENCES testForeignKeyTable(column1, column2) ON DELETE CASCADE"
        )

        WINQAssertEqual(
            generateForeignKey().onUpdate(.restrict),
            "REFERENCES testForeignKeyTable(column1, column2) ON UPDATE RESTRICT"
        )

        WINQAssertEqual(
            generateForeignKey().onDelete(.noAction),
            "REFERENCES testForeignKeyTable(column1, column2) ON DELETE NO ACTION"
        )

        WINQAssertEqual(
            generateForeignKey().deferrable(.deferred),
            "REFERENCES testForeignKeyTable(column1, column2) DEFERRABLE INITIALLY DEFERRED"
        )

        WINQAssertEqual(
            generateForeignKey().notDeferrable(.immediate),
            "REFERENCES testForeignKeyTable(column1, column2) NOT DEFERRABLE INITIALLY IMMEDIATE"
        )

        WINQAssertEqual(
            generateForeignKey().match(name: "test"),
            "REFERENCES testForeignKeyTable(column1, column2) MATCH test"
        )
    }
}
