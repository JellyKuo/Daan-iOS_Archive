//
// HistoryScoreResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class HistoryScoreResponse: Codable {

    public enum ModelType: String, Codable { 
        case 必 = "必"
        case 選 = "選"
    }
    public var subject: String?
    public var type: ModelType?
    /** 學分 */
    public var credit: Double?
    public var score: Double?
    /** 重考 */
    public var makeup: Double?
    /** 重修 */
    public var retake: Double?
    public var qualify: Double?

    public init() {}

}
