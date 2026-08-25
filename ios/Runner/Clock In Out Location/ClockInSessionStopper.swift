//
//  ClockInSessionStopper.swift
//  Runner
//
//  Created by TMS on 05/08/2024.
//

import Foundation



import Foundation

class ClockInSessionStopper{
    
    
    
    static func stopSession(completion : @escaping (Bool) -> Void){

        do{
            let myDetails = MyDetails.loadFromSharedPrefs()
            let session = ClockInOutSession.loadFromSharedPrefs()
            if(myDetails == nil || session == nil){
                completion(true)
                return
            }
            
            //Create url
            guard let url = URL(string: myDetails!.serverUrl! + "admin/clock-in-out") else {
                completion(true)
                return
            }
            
            //Create request
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue( "Bearer \(myDetails!.token!)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            

            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                ClockInOutSession.clearSession()
                completion(true)
            }
            task.resume()
        }
        catch(_){
            completion(true)
        }
    }


}
