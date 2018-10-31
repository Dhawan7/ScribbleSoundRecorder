//
//  RecodingData+CoreDataClass.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 17/10/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//
//

import Foundation
import CoreData

@objc(RecodingData)
public class RecodingData: NSManagedObject {
    
    static let share = RecodingData()
    
    func setData(urlD:URL, imageD:Data, dateD:Date, nameD:String, noteD:String, objectNameD:String, recordIndex:Int16, bookmarkAudio:Bool, audioSize: Int64){
        self.url = urlD 
        self.image = imageD
        self.date = dateD
        self.name = nameD
        self.note = noteD
        self.objectName = objectNameD
        self.audioIndex = recordIndex
        self.bookmarkAudio = bookmarkAudio
        self.audioSize = audioSize
    }
    
    func getData()->[RecodingData]{
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: RecodingData.self))
        fetchReq.resultType = .managedObjectResultType;
        // fetchReq.predicate = NSPredicate(format: "date = %@", date as CVarArg)
        var resultData = [RecodingData]()
        do{
            resultData = try CoreDataStack.sharedInstance.getContext().fetch(fetchReq) as! [RecodingData]
        }catch{
            
        }
        return resultData
    }

}
