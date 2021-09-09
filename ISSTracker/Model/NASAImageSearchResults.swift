//
//  NasaImage.swift
//  ISSTracker
//
//  Created by Sam McGarry on 5/21/21.
//

import Foundation

// MARK: - NASAImageSearch
struct NASAImageSearchResults: Codable {
    let collection: Collection
}

// MARK: - Collection
struct Collection: Codable {
    let href: String
    let items: [Item]
    //let links: [CollectionLink]
    let metadata: Metadata
    let version: String
}

// MARK: - Item
struct Item: Codable, Hashable, Identifiable {
    let id = UUID()

    private enum CodingKeys : String, CodingKey { case data, href, links }

    let data: [NASAdata]
    let href: String
    let links: [ItemLink]
}

// MARK: - Datum
struct NASAdata: Codable, Hashable {
    let center: String
    let dateCreated: String
    let description: String?
    let keywords: [String]?
    let mediaType: String
    //let nasaID: String
    let title: String
}

// MARK: - ItemLink
struct ItemLink: Codable, Hashable {
    let href, rel, render: String
}

// MARK: - CollectionLink
struct CollectionLink: Codable {
    let href: String
    let prompt, rel: String
}

// MARK: - Metadata
struct Metadata: Codable {
    let totalHits: Int
}
