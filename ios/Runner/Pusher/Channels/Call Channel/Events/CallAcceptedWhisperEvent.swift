//
//  CallAcceptedWhisperEvent.swift
//  Runner
//
//  Created by Hashim Khan on 25/02/2025.
//


extension CallChannel {
    
    
    func bindCallAcceptedWhisperEvent(_ callback: @escaping (CallEventDataModel) -> Void) -> String? {
        
        guard let channel = getCallChannel() else {
            return nil
        }
        
        return channel.bind(eventName: CallChannelEvents.callAcceptedWhisper.getName(), eventCallback: { event in
            do{
                guard  let data = event.property(withKey: "data") as? [String: Any] else{
                    self.printLog("return in call accepted whisper event listener because json or json data is null")
                    return
                }
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                self.printLog("got a call accepted whisper event ===> \(data)")
                guard let parsedData = try JSONDecoder().decode(CallEventDataModel?.self, from: jsonData) else { return }
                self.printLog("call accepted whisper event parsed successfully")
                callback(parsedData)
            }
            catch{
            }
            
        })
    }
    
    
    func unbindCallAcceptedWhisperEvent(_ eventId: String?) {
        guard let id = eventId else { return }
        guard let channel = getCallChannel() else { return }
        channel.unbind(eventName: CallChannelEvents.callAcceptedWhisper.getName(), callbackId: id)
    }
    
}
