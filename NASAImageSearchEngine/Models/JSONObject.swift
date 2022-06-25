//
//  JSONObject.swift
//  NASAImageSearchEngine
//
//  Created by Erica Gutierrez on 1/28/20.


import Foundation

struct JSONObject: Decodable {
    let collection: jsonCollection
}

struct jsonCollection: Decodable {
    let version: String
    let href: String
    let items: [MediaObject]
}

struct MediaObject: Decodable {
    let links: [Link]
    let data: [MetaData]
}

struct Link: Decodable {
    let href: String
}

struct MetaData: Decodable {
    let nasaId: String
    let title: String
    let description: String?
    let description508: String?
    let photographer: String?
    let location: String?
    
}
