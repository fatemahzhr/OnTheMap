//  APIMethods.swift
//  onTheMap_Fatima
//
//  Created by Fatimah Abdulraheem on 28/01/2019.
//

//Reference:
//the source code of some of the code in this project was used from this link: https://github.com/ATahhan/Example12/tree/TODO


import Foundation

//Main HTTP Methods:
enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

//saving links into variables:
struct C_API {
    static let s = "https://onthemap-api.udacity.com/v1/session"
    static let SN = "https://parse.udacity.com/parse/classes/StudentLocation"
}

class  APIMethods{
    //define gloabal variables to be used:
    private static var userInfo = UserInfo()
    private static var sessionId: String?

//--------------------------------------------------------------
//POST Method:
    static func postSession(username: String, password: String, completion: @escaping (String?)->Void) {
        guard let Stringurl = URL(string: C_API.s) else {
            completion("The URL is not correct!")
            return //exit the function if there is an error
        }
        var r = URLRequest(url: Stringurl)
        r.httpMethod = HTTPMethod.post.rawValue
        r.addValue("application/json", forHTTPHeaderField: "Accept")
        r.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //create the http body:
        r.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let t = session.dataTask(with: r) { data, response, error in
            var errorMsg: String?
            //check on different errors:
            if let ResponsAnswer = (response as? HTTPURLResponse)?.statusCode {
                if ResponsAnswer >= 200 && ResponsAnswer < 300 {
                    let d = data?.subdata(in: 5..<data!.count) //ignore the first 5 letters
                    if let json = try? JSONSerialization.jsonObject(with: d!, options: []),
                        let d = json as? [String:Any],
                        let Dictionary_Session = d["session"] as? [String: Any],
                        let accountDict = d["account"] as? [String: Any]  {
                        //save the key and ID:
                        self.userInfo.key = accountDict["key"] as? String 
                        self.sessionId = Dictionary_Session["id"] as? String
                    } else {
                        //check for different errors types:
                        errorMsg = "Error found: Parse response could not be done!"
                    }
                } else {
                    errorMsg = "Error found: the given email or password is not correct!"
                }
            } else {
                errorMsg = "Error found: Problem with Internet connection, please try later"
            }
            DispatchQueue.main.async {
                completion(errorMsg)
            }
        }
        t.resume() //perform the API
    }//end of POST

//--------------------------------------------------------------
    //DELETE Method:
    static func deletSession(completion: @escaping (String?)->Void){
        //Source Code for deletion's API: Udacity
        var r = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        r.httpMethod = "DELETE"
        var xc: HTTPCookie? = nil
        let c = HTTPCookieStorage.shared
        for cookie in c.cookies! {
            if cookie.name == "XSRF-TOKEN" { xc = cookie } //save te cookie to help in deletion
        }
        if let xc = xc {
            r.setValue(xc.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let t = session.dataTask(with: r) { data, response, error in
            if error != nil {
                completion ("Error Found! Deletion Method")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                _ = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                completion ("Error Found! Deletion Method")
                return
            }
            if statusCode >= 200  && statusCode < 300 {
                let range = Range(5..<data!.count) //ignore the first five characters
                let newData = data?.subdata(in: range)
                let json = try! JSONSerialization.jsonObject(with: newData!, options: []) as? [String : Any]
                //save key and account of the user:
                let Dictionary_Account = json? ["account"] as? [String : Any]
                let uniqueKey = Dictionary_Account? ["key"] as? String ?? " "
                completion (uniqueKey)
            } else {
                completion ("Error Found!")
            }
        }
        t.resume()
    }//end of deletSession
    
//--------------------------------------------------------------
class Parser {
//GET: getStudentLocations
    //get students locations to the top 100 students:
        static func getStudentLocations(limit: Int = 100, skip: Int = 0, orderBy: Parmaterss = .updatedAt, completion: @escaping (LData?)->Void) {
            guard let Stringurl = URL(string: "\(C_API.SN)?\("limit")=\(limit)&\("skip")=\(skip)&\("order")=-\(orderBy.rawValue)") else {
                completion(nil)
                return
            }
            var r = URLRequest(url: Stringurl)
            r.httpMethod = HTTPMethod.get.rawValue
            r.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            r.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            let session = URLSession.shared
            let t = session.dataTask(with: r) { data, response, error in
                //store the SLocation in an array
                var studentLocations: [SLocation] = []
                if let ResponsAnswer = (response as? HTTPURLResponse)?.statusCode {
                    if ResponsAnswer >= 200 && ResponsAnswer < 300 {
                        if let json = try? JSONSerialization.jsonObject(with: data!, options: []),
                            let d = json as? [String:Any],
                            let results = d["results"] as? [Any] {
                            for location in results {
                                //Serialzation to the obtained data:
                                let d = try! JSONSerialization.data(withJSONObject: location)
                                let studentLocation = try! JSONDecoder().decode(SLocation.self, from: d)
                                studentLocations.append(studentLocation)
                            }
                        }
                    }
                }
                //to perform synchronize in the main queue:
                DispatchQueue.main.async {
                    completion(LData(UdacityUsersL: studentLocations))
                }
            }
            t.resume()
}//End of getStudentLocations
        
//--------------------------------------------------------------
//POST: postLocation
static func postStudentLocation(_ location: SLocation, url: String, latitude: Double, longitude: Double, completion: @escaping (_ result: AnyObject?, _ error: Error?) -> Void) {
            let Stringurl = NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!
    //prepare the http body:
            let httpBody = "{\"uniqueKey\": \"\(userInfo.key!)\", \"firstName\": \"Sami\", \"lastName\": \"Al-Ali\",\"mapString\": \"\(location.mapString!)\", \"mediaURL\": \"\(location.mediaURL!)\",\"latitude\": \(location.latitude!), \"longitude\": \(location.longitude!)}"
            let r = NSMutableURLRequest(url: Stringurl as URL)
            r.httpMethod = "POST"
            r.addValue("application/json", forHTTPHeaderField: "Accept")
            r.addValue("application/json", forHTTPHeaderField: "Content-Type")
            r.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            r.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            r.httpBody = httpBody.data(using: .utf8)//.utf8 for the Unicode
            let session = URLSession.shared
            let t = session.dataTask(with: r as URLRequest) { (data, response, error) in
                guard error == nil else {
                    completion(nil, error)
                    return
                }
                if let ResponsAnswer = (response as? HTTPURLResponse)?.statusCode,
                    //check for different errors types:
                    ResponsAnswer >= 200 && ResponsAnswer <= 299 {
                    if ResponsAnswer >= 400 && ResponsAnswer <= 499 {
                        completion(nil, error)
                        return
                    }
                    if ResponsAnswer >= 500 && ResponsAnswer <= 599 {
                        completion(nil, error)
                        return
                    }
                }
                guard data != nil else {
                    completion(nil, error)
                    return
                }
            }
            t.resume()
        }//end of postLocation method
}//End of Parse Class
}//End of APIMethods CLass
