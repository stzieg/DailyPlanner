//
//  AssignmentDataManager.swift
//  DailyPlanner
//
//  Created by Sam Ziegler on 3/28/22.
//  Copyright © 2022 Sam Ziegler. All rights reserved.
//

import Foundation

public class AssignmentDataManager{
    
    static fileprivate func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths.first!
        return documentsDirectory
    }
    
    //save codable objects
    static func save <A:Encodable> ( object:A, with assignmentFileName:String){
        let url = getDocumentDirectory().appendingPathComponent(assignmentFileName, isDirectory: false)
        
        let encoder = JSONEncoder()
        
        do{
            let data = try encoder.encode(object)
            
            if FileManager.default.fileExists(atPath: url.path){
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch{
            fatalError(error.localizedDescription)
        }
    }
    
    
    //load any kind of codable objects
    static func load <A:Decodable> ( assignmentFileName:String, with type:A.Type) -> A{
        let url = getDocumentDirectory().appendingPathComponent(assignmentFileName, isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: url.path)  {
            fatalError("File does not exist at path \(url.path)")
        }
        
        if let data = FileManager.default.contents(atPath: url.path){
            do{
                let model = try JSONDecoder().decode(type, from: data)
                return model
            } catch{
                debugPrint(error)
                fatalError(error.localizedDescription)
            }
        } else{
            fatalError("Data is unavailable")
        }
    }
    
    //load data from a file
    static func loadData ( assignmentFileName:String) -> Data?{
        let url = getDocumentDirectory().appendingPathComponent(assignmentFileName, isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: url.path)  {
            fatalError("File does not exist at path \(url.path)")
        }
        
        if let data = FileManager.default.contents(atPath: url.path){
            return data
        } else{
            fatalError("Data is unavailable")
        }
    }
    
    //load all files from a directory
    static func loadAll <A:Decodable> ( type:A.Type) -> [A]{
        do{
            
            //createFile()
            
            let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentDirectory().path)
            
            var modelObjects = [A]()
            
            for assignmentFileName in files{
                modelObjects.append(load(assignmentFileName: assignmentFileName, with: type))
            }
            
            return modelObjects
        } catch{
            fatalError("Could not load any files")
        }
    }
    
    //delete a file
    static func delete ( assignmentFileName:String){
        let url = getDocumentDirectory().appendingPathComponent(assignmentFileName, isDirectory: false)
        
        if FileManager.default.fileExists(atPath: url.path) {
            do{
                try FileManager.default.removeItem(at: url)
            } catch{
                fatalError(error.localizedDescription)
            }
        }
    }
}
