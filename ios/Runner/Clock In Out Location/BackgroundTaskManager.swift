//
//  BackgroundFetch.swift
//  Runner
//
//  Created by TMS on 05/08/2024.
//

import Foundation
import UIKit
import BackgroundTasks

class BackgroundTaskManager{
    
    static let shared = BackgroundTaskManager()
    
    func registerTasks(){
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.transportsystemgroup.tsadmin.process", using: nil) {task in
            self.handleAppProcessing(task: task as! BGProcessingTask)
        }
    }
    
    
    func scheduleAppProcessing(){
                
        let session = ClockInOutSession.loadFromSharedPrefs()
        
        if(session == nil){
            return
        }
        
        let request = BGProcessingTaskRequest(identifier : "com.transportsystemgroup.tsadmin.process")
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false
        
        do{
            try BGTaskScheduler.shared.submit(request)
        }
        catch{
            print("Could not schedule app processing: \(error)")
        }
    }
    
    
    private func handleAppProcessing(task : BGProcessingTask){
        scheduleAppProcessing()
        
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        
        //
        // check for location service and permission
        LocationService.shared.hasLocationAlwaysPermission{
            hasPermission in
            
            //
            // if dont have permission then stop session
//            if(!hasPermission){
//                ClockInSessionStopper.stopSession(completion: { success in
//                    task.setTaskCompleted(success: true)
//                })
//                
//            }
//            else{
                task.setTaskCompleted(success: true)
//            }
        }
        
    }
    
    
}
