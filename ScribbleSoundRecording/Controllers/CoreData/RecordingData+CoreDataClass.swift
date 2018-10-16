//
//  RecodingData+CoreDataClass.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 13/10/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import Foundation
import CoreData

@objc(RecordingData)
public class RecordingData: NSManagedObject {
    static let share = RecordingData()
    
    func setData(urlD:URL, imageD:Data, dateD:Date, nameD:String, notesD:String, objectNameD:String){
        self.url = urlD
        self.image = imageD
        self.date = dateD
        self.name = nameD
        self.note = notesD
        self.objectName = objectNameD
        
    }
    
    func getData()->[RecordingData]{
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: RecordingData.self))
        fetchReq.resultType = .managedObjectResultType;
        // fetchReq.predicate = NSPredicate(format: "date = %@", date as CVarArg)
        var resultData = [RecordingData]()
        do{
            resultData = try CoreDataStack.sharedInstance.getContext().fetch(fetchReq) as! [RecordingData]
        } catch{
            
        }
        return resultData
    }
    
}
