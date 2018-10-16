//
//  RecodingData+CoreDataProperties.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 13/10/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import Foundation
import CoreData


extension RecordingData {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecordingData> {
        return NSFetchRequest<RecordingData>(entityName: "ScribbleEntities")
    }
    
    @nonobjc public class func insertRequest(context:NSManagedObjectContext) -> RecordingData {
        return NSEntityDescription.insertNewObject(forEntityName: "ScribbleEntities", into:context ) as! RecordingData
    }
    
    @NSManaged public var url: URL?
    @NSManaged public var image: Data?
    @NSManaged public var date: Date?
    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var objectName: String?
    
}

