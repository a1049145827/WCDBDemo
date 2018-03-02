//
//  SampleORM.swift
//  WCDBDemo
//
//  Created by Bruce on 2018/3/1.
//  Copyright © 2018年 snailvr. All rights reserved.
//

import Foundation
import WCDBSwift

class SampleORM: TableCodable,Codable {
    // Your own properties
    
    var id: Int?
    
    // 注：定义属性的同时进行赋值操作会导致WCDBSwift无法映射字段名而引发崩溃（当前版本 WCDBSwift v1.0.6.1，安装方式Carthage）
    // 例如 let variable1: Int? = 0
    let variable1: Int?
    var variable2: String? // Optional if it would be nil in some WCDB selection
    var variable3: Double? // Optional if it would be nil in some WCDB selection
    let unbound: Date? = nil
    
    init() {
        variable1 = 8
    }

    enum CodingKeys: String, CodingTableKey {
        typealias Root = SampleORM

        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        // List the properties which should be bound to table
        case id
        case variable1 //= "card_id"
        case variable2 //= "name"
        case variable3 //= "create_time"
        
        //Column constraints for primary key, unique, not null, default value and so on. It is optional.
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .id: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: true),
//                .variable2: ColumnConstraintBinding(isPrimary: false, orderBy: nil, isAutoIncrement: false, onConflict: nil, isNotNull: true, isUnique: true, defaultTo: "defaultDescription")
            ]
        }

        // Index bindings. It is optional.
        //static var indexBindings: [IndexBinding.Subfix: IndexBinding]? {
        //    return [
        //        "_index": IndexBinding(indexesBy: CodingKeys.variable2)
        //    ]
        //}

        // Table constraints for multi-primary, multi-unique and so on. It is optional.
        //static var tableConstraintBindings: [TableConstraintBinding.Name: TableConstraintBinding]? {
        //    return [
        //        "MultiPrimaryConstraint": MultiPrimaryBinding(indexesBy: variable2.asIndex(orderBy: .descending), variable3.primaryKeyPart2)
        //    ]
        //}

        // Virtual table binding for FTS and so on. It is optional.
        //static var virtualTableBinding: VirtualTableBinding? {
        //    return VirtualTableBinding(with: .fts3, and: ModuleArgument(with: .WCDB))
        //}
    }

    // Properties below are needed only the primary key is auto-incremental
    var isAutoIncrement: Bool = false
    var lastInsertedRowID: Int64 = 0
}


struct DatabaseManager {
    
    static let shared = DatabaseManager()
    let database: Database
    
    private init() {
        
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/wcdb.db"
//        let databasePath = NSHomeDirectory().appending("/Intermediate/Directories/Will/Be/Created/sample.db")
        print("databasePath is: \(dbPath)")
        
        database = Database(withPath: dbPath)
        
//        let password = "password".data(using: .ascii)
//
//        // 设置加密接口应在其他所有调用之前进行，否则会因无法解密而出错
//        database.setCipher(key: password)
        
        // 以下代码等效于 SQL：CREATE TABLE IF NOT EXISTS sampleTable(identifier INTEGER, description TEXT)
        do {
            
            try database.create(table: "sampleTable", of: SampleORM.self)
        } catch {
            print("table create failed error message: \(error)")
        }
    }
    
    func insertData() -> Void {
        // Prepare data
        let object = SampleORM()
        object.variable2 = "sample_insert"
        object.variable3 = Date().timeIntervalSince1970
        
        // Insert
        do {
            
            try database.insert(objects: object, intoTable: "sampleTable")
        } catch {
            print("table create failed error message: \(error)")
        }
    }
    
    func deleteData() -> Void {
        do {
            
//            try database.delete(fromTable: "sampleTable")
            
            // 删除 sampleTable 中所有 variable1 大于 1 的行的数据
            try database.delete(fromTable: "sampleTable",
                                where: SampleORM.Properties.id < 3)
        } catch {
            print("table create failed error message: \(error)")
        }
    }
    
    func updateData() -> Void {
        
        // Prepare data
        let object = SampleORM()
        object.variable2 = "sample_update"
        // Update
        do {
            
            try database.update(table: "sampleTable",
                                on: SampleORM.Properties.variable2,
                                with: object,
                                where: SampleORM.Properties.variable3 > 0)
            
        } catch {
            print("table create failed error message: \(error)")
        }
    }
    
    func getData() -> [SampleORM]? {
        
        var objects: [SampleORM]? = nil
        do {
            
//            objects = try database.getObjects(fromTable: "sampleTable")
            
            objects = try database.getObjects(fromTable: "sampleTable", where: SampleORM.Properties.variable3 > 1)

        } catch {
            print("table create failed error message: \(error)")
        }
        
        print(objects?.count ?? 0)
        let _ = objects?.filter {
            print($0.variable1 ?? 0)
            guard let _ = $0.variable3 else {
                return false
            }
            return $0.variable3! > 0
        }
        
        return objects
    }
    
    
}
