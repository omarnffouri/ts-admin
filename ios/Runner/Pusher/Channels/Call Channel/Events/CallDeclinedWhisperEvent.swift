//
//  CallDeclinedWhisperEvent.swift
//  Runner
//
//  Created by Hashim Khan on 26/02/2025.
//


extension CallChannel {
    
    
    func bindCallDeclinedWhisperEvent(_ callback: @escaping (CallEventDataModel) -> Void) -> String? {
        
        guard let channel = getCallChannel() else {
            return nil
        }
        
        return channel.bind(eventName: CallChannelEvents.callDeclinedWhisper.getName(), eventCallback: { event in
            do{
                guard  let data = event.property(withKey: "data") as? [String: Any] else{
                    self.printLog("return in call desclined whisper event listener because json or json data is null")
                    return
                }
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                self.printLog("got a call declined whisper event ===> \(data)")
                guard let parsedData = try JSONDecoder().decode(CallEventDataModel?.self, from: jsonData) else { return }
                self.printLog("call declined whisper event parsed successfully")
                callback(parsedData)
            }
            catch{
                self.printLog("error in call desclined whisper event listener in catch of try block ===> \(error.localizedDescription)")
            }
            
        })
    }
    
    
    func unbindCallDeclinedWhisperEvent(_ eventId: String?) {
        guard let id = eventId else { return }
        guard let channel = getCallChannel() else { return }
        channel.unbind(eventName: CallChannelEvents.callDeclinedWhisper.getName(), callbackId: id)
    }
    
}
