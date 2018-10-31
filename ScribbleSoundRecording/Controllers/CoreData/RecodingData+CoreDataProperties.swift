//
//  RecodingData+CoreDataProperties.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 17/10/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//
//

import Foundation
import CoreData


extension RecodingData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecodingData> {
        return NSFetchRequest<RecodingData>(entityName: "RecodingData")
    }
    
    @nonobjc public class func insertRequest(context:NSManagedObjectContext) -> RecodingData {
        return NSEntityDescription.insertNewObject(forEntityName: "RecodingData", into:context ) as! RecodingData
    }
    
    

    @NSManaged public var date: Date?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var objectName: String?
    @NSManaged public var url: URL?
    @NSManaged public var audioIndex: Int16
    @NSManaged public var bookmarkAudio: Bool
    @NSManaged public var audioSize: Int64
   

}
