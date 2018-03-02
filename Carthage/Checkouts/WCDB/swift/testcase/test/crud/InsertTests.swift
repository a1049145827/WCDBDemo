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

class InsertTests: CRUDTestCase {

    var insert: Insert!

    override func setUp() {
        super.setUp()

        let optionalInsert = WCDBAssertNoThrowReturned(
            try database.prepareInsert(of: CRUDObject.self, intoTable: CRUDObject.name),
            whenFailed: nil
        )
        XCTAssertNotNil(optionalInsert)
        insert = optionalInsert!
    }

    func testBase() {
        XCTAssertNotNil(insert.tag)
        XCTAssertEqual(insert.tag, database.tag)
        XCTAssertEqual(insert.path, database.path)
    }

    func testInsert() {
        //Give
        let object = CRUDObject()
        object.variable1 = preInsertedObjects.count + 1
        object.variable2 = self.name
        //When
        XCTAssertNoThrow(try insert.execute(with: object))
        //Then
        let condition = CRUDObject.Properties.variable1 == object.variable1!
        let result: CRUDObject? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: CRUDObject.name, where: condition)
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, object)
    }

    func testAutoIncrementInsert() {
        //Give
        let object = CRUDObject()
        let expectedRowID = preInsertedObjects.count + 1
        object.isAutoIncrement = true
        object.variable2 = self.name
        //When
        XCTAssertNoThrow(try insert.execute(with: object))
        //Then
        let condition = CRUDObject.Properties.variable1 == expectedRowID
        XCTAssertEqual(object.lastInsertedRowID, Int64(expectedRowID))
        let result: CRUDObject? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: CRUDObject.name, where: condition)
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.variable1, expectedRowID)
        XCTAssertEqual(result!.variable2, object.variable2)
    }

    func testInsertOrReplace() {
        //Give
        let object = CRUDObject()
        let expectedReplacedRowID = 1
        object.variable1 = expectedReplacedRowID
        object.variable2 = self.name
        let optionalInsert = WCDBAssertNoThrowReturned(
            try database.prepareInsertOrReplace(of: CRUDObject.self, intoTable: CRUDObject.name),
            whenFailed: nil
        )
        XCTAssertNotNil(optionalInsert)
        insert = optionalInsert!
        //When
        XCTAssertNoThrow(try insert.execute(with: object))
        //Then
        let condition = CRUDObject.Properties.variable1 == expectedReplacedRowID
        let result: CRUDObject? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: CRUDObject.name, where: condition)
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.variable2, self.name)
    }

    func testPartialInsert() {
        //Give
        let object = CRUDObject()
        object.variable1 = preInsertedObjects.count + 1
        object.variable2 = self.name
        let optionalInsert = WCDBAssertNoThrowReturned(
            try database.prepareInsert(on: CRUDObject.Properties.variable1, intoTable: CRUDObject.name),
            whenFailed: nil
        )
        XCTAssertNotNil(optionalInsert)
        let insert = optionalInsert!
        //When
        XCTAssertNoThrow(try insert.execute(with: object))
        //Then
        let condition = CRUDObject.Properties.variable1 == object.variable1!
        let result: CRUDObject? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: CRUDObject.name, where: condition)
        )
        XCTAssertNotNil(result)
        XCTAssertNil(result!.variable2)
    }

    func testPartialInsertOrReplace() {
        //Give
        let object = CRUDObject()
        let expectedReplacedRowID = 1
        object.variable1 = expectedReplacedRowID
        object.variable2 = self.name
        let optionalInsert = WCDBAssertNoThrowReturned(
            try database.prepareInsertOrReplace(on:
                CRUDObject.Properties.variable1,
                CRUDObject.Properties.variable2,
                                                intoTable: CRUDObject.name),
            whenFailed: nil
        )
        XCTAssertNotNil(optionalInsert)
        insert = optionalInsert!
        //When
        XCTAssertNoThrow(try insert.execute(with: object))
        //Then
        let condition = CRUDObject.Properties.variable1 == expectedReplacedRowID
        let result: CRUDObject? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: CRUDObject.name, where: condition)
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.variable2, self.name)
    }

    func testInsertEmpty() {
        XCTAssertNoThrow(try insert.execute(with: [CRUDObject]()))
    }

    func testInsertFailed() {
        XCTAssertThrowsError(try database.prepareInsert(of: CRUDObject.self, intoTable: ""))
    }

}
