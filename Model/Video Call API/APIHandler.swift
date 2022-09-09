//
//  APIHandler.swift
//  test-this better work
//
//  Created by Media Davarkhah on 5/3/1401 AP.
//

import Foundation
import HMSSDK
class APIHandler {


    struct Constants {
        static var ManagementToken: String?
        static var AccessToken: String?

    }

    fileprivate class func getRequest<ResponseType: Decodable>(url:URL, responseType: ResponseType.Type, completionHandler: @escaping (ResponseType?,Error?) -> Void) {

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completionHandler(nil,error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject =  try decoder.decode(ResponseType.self, from: data)
                completionHandler(responseObject,nil)

            } catch {
                completionHandler(nil,error)
                print("DEBUG: GET Request failed: " + error.localizedDescription)
            }
        }
        task.resume()
    }

    fileprivate class func postRequest<RequestType: Encodable, ResponseType: Decodable>(urlRequest: inout URLRequest,requestBody: RequestType ,responseType: ResponseType.Type , completionHandler: @escaping (ResponseType?,Error?) -> Void) {
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        do{
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys]

            let body = try encoder.encode(requestBody)
            urlRequest.httpBody = body

        } catch {
            completionHandler(nil,error)
            // TODO: handle the error and add an alert
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                completionHandler(nil,error)
                return
            }

            let decoder = JSONDecoder()
            do {
                let jsonResponse = try decoder.decode(ResponseType.self, from: data)
                completionHandler(jsonResponse,nil)
            } catch {

                print(error)
                completionHandler(nil,error)
                return
            }
        }
        task.resume()

    }
}
class RoomAPIHandler: APIHandler  {

    enum EndPoints {
        static let base_token_server = "https://learnalize-token-server.herokuapp.com/"
        static let base_100ms_server = "https://prod-in2.100ms.live/api/v2/"

        case getManagementToken
        case getAccessToken
        case createRoom

        var url: URL {
            return URL(string: stringValue)!
        }
        var stringValue:String {

            switch self {
            case .getManagementToken:
                return EndPoints.base_token_server + "getManagementToken"
            case .getAccessToken:
                return EndPoints.base_token_server + "getAccessToken"
            case .createRoom:
                return EndPoints.base_100ms_server + "rooms"
            }
        }
    }
    // MARK: Token server API calls

    private static func getManagementToken(completion: @escaping (TokenResponse?, Error?) -> Void) {
        getRequest(url: EndPoints.getManagementToken.url, responseType: TokenResponse.self) { response, error in
            guard let response = response, error == nil else {
                completion(nil,error)
                return
            }
            Constants.ManagementToken = response.token
            completion(response,nil)
        }

    }

    private static func getAccessToken(roomId: String, userId: String, role: String,completion: @escaping (TokenResponse?, Error?) -> Void) {
        let url = EndPoints.getAccessToken.url
        var request = URLRequest(url: url)

        // initialize body
        let body = AccessTokenRequest(room_id: roomId, user_id: userId, role: role)


        postRequest(urlRequest: &request, requestBody: body, responseType: TokenResponse.self, completionHandler: completion)

    }

    // MARK: 100ms API calls

    private static func createRoom(name: String, description: String, completion: @escaping (RoomResponse?, Error?) -> Void) {

        // initialize url
        let url = EndPoints.createRoom.url
        var request = URLRequest(url: url)
        // initialize body
        let body = RoomRequest(name: name, description: description, template: "Learnalize_videoconf_a2afcc2a-b8b6-4f17-a72b-52750a247427")

        // set additional headers
//        if Constants.ManagementToken == nil {
            // fetch management token if it's empty
            getManagementToken { response , error in
                guard let response = response, error == nil else {
                    completion(nil,error)
                    print(error?.localizedDescription)
                    return
                }

                request.setValue("Bearer \(response.token)", forHTTPHeaderField:"Authorization")
                
                Constants.ManagementToken = response.token
                print(response.token)
                // send request
                postRequest(urlRequest: &request, requestBody: body, responseType: RoomResponse.self, completionHandler: completion)

            }
//        } else {
//            request.setValue("Bearer \(Constants.ManagementToken)", forHTTPHeaderField:"Authorization")
//            // send request
//            postRequest(urlRequest: &request, requestBody: body, responseType: RoomResponse.self, completionHandler: completion)
//        }



    }

    // TODO: REPLACE COMPLETION HANDLER RETURN VALUE WITH ACTIVITY
    static func roomForHost(name: String, description: String, userId: String, completion: @escaping (RoomResponse?,TokenResponse?, Error? ) -> Void) {
        createRoom(name: name, description: description) { room, error in
            guard let room = room, error == nil else {
                completion(nil,nil,error)
                print(error?.localizedDescription)
                return
            }

            //retrieve access Token
            getAccessToken(roomId: room.id, userId: userId, role: "host") { token, error in
                guard let token = token, error == nil else {
                    completion(room,nil,error)
                    return
                }
                completion(room,token,nil)

            }

        }
    }

    static func roomForGuest(roomId: String, userId: String, completion: @escaping (TokenResponse?, Error?) -> Void) {
        getAccessToken(roomId: roomId, userId: userId, role: "guest") { token, error in
            guard let token = token, error == nil else {
                completion(nil,error)
                return
            }
            completion(token,nil)

        }
    }


   
}

