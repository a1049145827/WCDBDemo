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

class UpdateInterfaceTests: CRUDTestCase {

    func testUpdate() {
        //Give
        let object = CRUDObject()
        object.variable2 = self.name
        //When
        XCTAssertNoThrow(try database.update(table: CRUDObject.name, on: CRUDObject.Properties.variable2, with: object))
        //Then
        let results: [CRUDObject] = WCDBAssertNoThrowReturned(
            try database.getObjects(fromTable: CRUDObject.name),
            whenFailed: [CRUDObject]()
        )
        XCTAssertEqual(Array(repeating: self.name, count: preInsertedObjects.count), results.map({
            XCTAssertNotNil($0.variable2)
            return $0.variable2!
        }))
    }

    func testConditionalUpdate() {
        //Give
        let object = CRUDObject()
        object.variable2 = self.name
        //When
        XCTAssertNoThrow(try database.update(table: CRUDObject.name,
                                             on: CRUDObject.Properties.variable2,
                                             with: object,
                                             where: CRUDObject.Properties.variable1 == 1))
        //Then
        let result: CRUDObject? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: CRUDObject.name, where: CRUDObject.Properties.variable1 == 1)
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(self.name, result!.variable2)
    }

    func testOrderedUpdate() {
        //Give
        let object = CRUDObject()
        object.variable2 = self.name
        let order = [(CRUDObject.Properties.variable1).asOrder(by: .descending)]
        //When
        XCTAssertNoThrow(try database.update(table: CRUDObject.name,
                                             on: CRUDObject.Properties.variable2,
                                             with: object,
                                             orderBy: order,
                                             limit: 1))
        //Then
        let result: CRUDObject? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: CRUDObject.name, where: CRUDObject.Properties.variable1 == 2)
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(self.name, result!.variable2)
    }

    func testLimitedUpdate() {
        //Give
        let object = CRUDObject()
        object.variable2 = self.name
        //When
        XCTAssertNoThrow(try database.update(table: CRUDObject.name,
                                             on: CRUDObject.Properties.variable2,
                                             with: object,
                                             limit: 1))
        //Then
        let results: [CRUDObject] = WCDBAssertNoThrowReturned(try database.getObjects(fromTable: CRUDObject.name))
        XCTAssertEqual(results[0].variable2, self.name)
        XCTAssertEqual(results[1], preInsertedObjects[1])
    }

    func testOffsetUpdate() {
        //Give
        let object = CRUDObject()
        object.variable2 = self.name
        //When
        XCTAssertNoThrow(try database.update(table: CRUDObject.name,
                                             on: CRUDObject.Properties.variable2,
                                             with: object,
                                             limit: 1,
                                             offset: 1))
        //Then
        let results: [CRUDObject] = WCDBAssertNoThrowReturned(try database.getObjects(fromTable: CRUDObject.name))
        XCTAssertEqual(results[0], preInsertedObjects[0])
        XCTAssertEqual(results[1].variable2, self.name)
    }

    func testUpdateWithRow() {
        //Give
        let object = CRUDObject()
        object.variable2 = self.name
        //When
        XCTAssertNoThrow(
            try database.update(table: CRUDObject.name, on: CRUDObject.Properties.variable2, with: [self.name])
        )
        //Then
        let results: [CRUDObject] = WCDBAssertNoThrowReturned(
            try database.getObjects(fromTable: CRUDObject.name),
            whenFailed: [CRUDObject]()
        )
        XCTAssertEqual(Array(repeating: self.name, count: preInsertedObjects.count), results.map({
            XCTAssertNotNil($0.variable2)
            return $0.variable2!
        }))
    }

    func testConditionalUpdateWithRow() {
        //Give
        let object = CRUDObject()
        object.variable2 = self.name
        //When
        XCTAssertNoThrow(try database.update(table: CRUDObject.name,
                                             on: CRUDObject.Properties.variable2,
                                             with: [self.name],
                                             where: CRUDObject.Properties.variable1 == 1))
        //Then
        let result: CRUDObject? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: CRUDObject.name, where: CRUDObject.Properties.variable1 == 1)
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(self.name, result!.variable2)
    }

    func testOrderedUpdateWithRow() {
        //Give
        let object = CRUDObject()
        object.variable2 = self.name
        let order = [(CRUDObject.Properties.variable1).asOrder(by: .descending)]
        //When
        XCTAssertNoThrow(try database.update(table: CRUDObject.name,
                                             on: CRUDObject.Properties.variable2,
                                             with: [self.name],
                                             orderBy: order,
                                             limit: 1))
        //Then
        let result: CRUDObject? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: CRUDObject.name, where: CRUDObject.Properties.variable1 == 2)
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(self.name, result!.variable2)
    }

    func testLimitedUpdateWithRow() {
        //Give
        let object = CRUDObject()
        object.variable2 = self.name
        //When
        XCTAssertNoThrow(try database.update(table: CRUDObject.name,
                                             on: CRUDObject.Properties.variable2,
                                             with: [self.name],
                                             limit: 1))
        //Then
        let results: [CRUDObject] = WCDBAssertNoThrowReturned(try database.getObjects(fromTable: CRUDObject.name))
        XCTAssertEqual(results[0].variable2, self.name)
        XCTAssertEqual(results[1], preInsertedObjects[1])
    }

    func testOffsetUpdateWithRow() {
        //Give
        let object = CRUDObject()
        object.variable2 = self.name
        //When
        XCTAssertNoThrow(try database.update(table: CRUDObject.name,
                                             on: CRUDObject.Properties.variable2,
                                             with: [self.name],
                                             limit: 1,
                                             offset: 1))
        //Then
        let results: [CRUDObject] = WCDBAssertNoThrowReturned(try database.getObjects(fromTable: CRUDObject.name))
        XCTAssertEqual(results[0], preInsertedObjects[0])
        XCTAssertEqual(results[1].variable2, self.name)
    }

    func testTableUpdate() {
        //Give
        let object = CRUDObject()
        object.variable2 = self.name
        let table: Table<CRUDObject>? = WCDBAssertNoThrowReturned(try database.getTable(named: CRUDObject.name))
        XCTAssertNotNil(table)
        //When
        XCTAssertNoThrow(try table!.update(on: CRUDObject.Properties.variable2, with: object))
        //Then
        let results: [CRUDObject] = WCDBAssertNoThrowReturned(try table!.getObjects())
        XCTAssertEqual(results.map({
            XCTAssertNotNil($0.variable2)
            return $0.variable2!
        }), Array(repeating: self.name, count: preInsertedObjects.count))
    }

    func testTableConditionalUpdate() {
        //Give
        let object = CRUDObject()
        object.variable2 = self.name
        let table: Table<CRUDObject>? = WCDBAssertNoThrowReturned(try database.getTable(named: CRUDObject.name))
        XCTAssertNotNil(table)
        //When
        XCTAssertNoThrow(try table!.update(on: CRUDObject.Properties.variable2,
                                             with: object,
                                             where: CRUDObject.Properties.variable1 == 1))
        //Then
        let result: CRUDObject? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: CRUDObject.name, where: CRUDObject.Properties.variable1 == 1)
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(self.name, result!.variable2)
    }

    func testTableOrderedUpdate() {
        //Give
        let object = CRUDObject()
        object.variable2 = self.name
        let order = [(CRUDObject.Properties.variable1).asOrder(by: .descending)]
        let table: Table<CRUDObject>? = WCDBAssertNoThrowReturned(try database.getTable(named: CRUDObject.name))
        XCTAssertNotNil(table)
        //When
        XCTAssertNoThrow(try table!.update(on: CRUDObject.Properties.variable2,
                                             with: object,
                                             orderBy: order,
                                             limit: 1))
        //Then
        let result: CRUDObject? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: CRUDObject.name, where: CRUDObject.Properties.variable1 == 2)
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(self.name, result!.variable2)
    }

    func testTableLimitedUpdate() {
        //Give
        let object = CRUDObject()
        object.variable2 = self.name
        let table: Table<CRUDObject>? = WCDBAssertNoThrowReturned(try database.getTable(named: CRUDObject.name))
        XCTAssertNotNil(table)
        //When
        XCTAssertNoThrow(try table!.update(on: CRUDObject.Properties.variable2,
                                             with: object,
                                             limit: 1))
        //Then
        let results: [CRUDObject] = WCDBAssertNoThrowReturned(try database.getObjects(fromTable: CRUDObject.name))
        XCTAssertEqual(results[0].variable2, self.name)
        XCTAssertEqual(results[1], preInsertedObjects[1])
    }

    func testTableOffsetUpdate() {
        //Give
        let object = CRUDObject()
        object.variable2 = self.name
        let table: Table<CRUDObject>? = WCDBAssertNoThrowReturned(try database.getTable(named: CRUDObject.name))
        XCTAssertNotNil(table)
        //When
        XCTAssertNoThrow(try table!.update(on: CRUDObject.Properties.variable2,
                                             with: object,
                                             limit: 1,
                                             offset: 1))
        //Then
        let results: [CRUDObject] = WCDBAssertNoThrowReturned(try database.getObjects(fromTable: CRUDObject.name))
        XCTAssertEqual(results[0], preInsertedObjects[0])
        XCTAssertEqual(results[1].variable2, self.name)
    }

    func testTableUpdateWithRow() {
        //Give
        let object = CRUDObject()
        object.variable2 = self.name
        let table: Table<CRUDObject>? = WCDBAssertNoThrowReturned(try database.getTable(named: CRUDObject.name))
        XCTAssertNotNil(table)
        //When
        XCTAssertNoThrow(
            try table!.update(on: CRUDObject.Properties.variable2, with: [self.name])
        )
        //Then
        let results: [CRUDObject] = WCDBAssertNoThrowReturned(
            try database.getObjects(fromTable: CRUDObject.name),
            whenFailed: [CRUDObject]()
        )
        XCTAssertEqual(Array(repeating: self.name, count: preInsertedObjects.count), results.map({
            XCTAssertNotNil($0.variable2)
            return $0.variable2!
        }))
    }

    func testTableConditionalUpdateWithRow() {
        //Give
        let object = CRUDObject()
        object.variable2 = self.name
        let table: Table<CRUDObject>? = WCDBAssertNoThrowReturned(try database.getTable(named: CRUDObject.name))
        XCTAssertNotNil(table)
        //When
        XCTAssertNoThrow(try table!.update(on: CRUDObject.Properties.variable2,
                                             with: [self.name],
                                             where: CRUDObject.Properties.variable1 == 1))
        //Then
        let result: CRUDObject? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: CRUDObject.name, where: CRUDObject.Properties.variable1 == 1)
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(self.name, result!.variable2)
    }

    func testTableOrderedUpdateWithRow() {
        //Give
        let object = CRUDObject()
        object.variable2 = self.name
        let order = [(CRUDObject.Properties.variable1).asOrder(by: .descending)]
        let table: Table<CRUDObject>? = WCDBAssertNoThrowReturned(try database.getTable(named: CRUDObject.name))
        XCTAssertNotNil(table)
        //When
        XCTAssertNoThrow(try table!.update(on: CRUDObject.Properties.variable2,
                                             with: [self.name],
                                             orderBy: order,
                                             limit: 1))
        //Then
        let result: CRUDObject? = WCDBAssertNoThrowReturned(
            try database.getObject(fromTable: CRUDObject.name, where: CRUDObject.Properties.variable1 == 2)
        )
        XCTAssertNotNil(result)
        XCTAssertEqual(self.name, result!.variable2)
    }

    func testTableLimitedUpdateWithRow() {
        //Give
        let object = CRUDObject()
        object.variable2 = self.name
        let table: Table<CRUDObject>? = WCDBAssertNoThrowReturned(try database.getTable(named: CRUDObject.name))
        XCTAssertNotNil(table)
        //When
        XCTAssertNoThrow(try table!.update(on: CRUDObject.Properties.variable2,
                                             with: [self.name],
                                             limit: 1))
        //Then
        let results: [CRUDObject] = WCDBAssertNoThrowReturned(try database.getObjects(fromTable: CRUDObject.name))
        XCTAssertEqual(results[0].variable2, self.name)
        XCTAssertEqual(results[1], preInsertedObjects[1])
    }

    func testTableOffsetUpdateWithRow() {
        //Give
        let object = CRUDObject()
        object.variable2 = self.name
        let table: Table<CRUDObject>? = WCDBAssertNoThrowReturned(try database.getTable(named: CRUDObject.name))
        XCTAssertNotNil(table)
        //When
        XCTAssertNoThrow(try table!.update(on: CRUDObject.Properties.variable2,
                                             with: [self.name],
                                             limit: 1,
                                             offset: 1))
        //Then
        let results: [CRUDObject] = WCDBAssertNoThrowReturned(try database.getObjects(fromTable: CRUDObject.name))
        XCTAssertEqual(results[0], preInsertedObjects[0])
        XCTAssertEqual(results[1].variable2, self.name)
    }

}
