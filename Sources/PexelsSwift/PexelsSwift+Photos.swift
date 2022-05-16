//
//  PexelsSwift+Photos.swift
//  
//
//  Created by Lukas Pistrol on 16.05.22.
//

import Foundation

public extension PexelsSwift {

    // MARK: Get Photo

    /// Gets a single ``PSPhoto`` based on a given ID
    ///
    /// If the request fails this will return `nil`
    /// - Parameter id: The ID of the Photo
    /// - Returns: A result type of ``PhotoResult``
    func getPhoto(by id: Int) async -> PhotoResult {
        guard !apiKey.isEmpty else { return .failure(.noAPIKey) }
        let url = URL(string: API.photoByID + "/\(id)")!

        let result: Result<PSPhoto, PSError> = await fetch(url: url)
        switch result {
        case .failure(let error): return .failure(error)
        case .success(let photo): return .success(photo)
        }
    }

    /// Gets a single ``PSPhoto`` based on a given ID
    ///
    /// If the request fails this will return `nil`
    /// - Parameters:
    ///   - id: The ID of the Photo
    ///   - completion: A result type of ``PhotoResult``
    func getPhoto(by id: Int, completion: @escaping (PhotoResult) -> Void) {
        Task {
            completion(await getPhoto(by: id))
        }
    }

    // MARK: Get Curated Photos

    /// Get a list of curated ``PSPhoto``
    /// - Parameters:
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    /// - Returns: A result type of ``PhotosResult``
    func getCuratedPhotos(
        page: Int = 1,
        count results: Int = 10
    ) async -> PhotosResult {
        var components: URLComponents = .init(string: API.curatedPhotos)!
        let param: Array<URLQueryItem> = [.init(name: "page", value: "\(page)"),
                                          .init(name: "per_page", value: "\(results)")]

        components.queryItems = param
        guard let url = components.url else { return .failure(.badURL) }
        return await fetchPhotos(url: url)
    }

    /// Get a list of curated ``PSPhoto``
    /// - Parameters:
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    ///   - completion: A result type of ``PhotosResult``
    func getCuratedPhotos(
        page: Int = 1,
        count results: Int = 10,
        completion: @escaping (PhotosResult) -> Void
    ) {
        Task {
            completion(await getCuratedPhotos(page: page, count: results))
        }
    }

    // MARK: Search Photos

    /// Get a list of ``PSPhoto`` based on a search query
    /// - Parameters:
    ///   - query: The search query.
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    ///   - orientation: The orientation. Defaults to `nil`
    ///   - size: The minimum size. Defaults to `nil`
    ///   - color: The color. Defaults to `nil`
    /// - Returns: A result type of ``PhotosResult``
    func searchPhotos(
        _ query: String,
        orientation: PSOrientation? = nil,
        size: PSSize? = nil,
        color: PSColor? = nil,
        page: Int = 1,
        count results: Int = 10
    ) async -> PhotosResult {
        var components: URLComponents = .init(string: API.searchPhotos)!
        var param: Array<URLQueryItem> = [.init(name: "query", value: query),
                                          .init(name: "page", value: "\(page)"),
                                          .init(name: "per_page", value: "\(results)")]

        if let orientation = orientation {
            param.append(.init(name: "orientation", value: orientation.rawValue))
        }
        if let size = size {
            param.append(.init(name: "size", value: size.rawValue))
        }
        if let color = color {
            param.append(.init(name: "color", value: color.rawValue))
        }

        components.queryItems = param
        guard let url = components.url else { return .failure(.badURL) }
        return await fetchPhotos(url: url)
    }

    /// Get a list of ``PSPhoto`` based on a search query
    /// - Parameters:
    ///   - query: The search query.
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    ///   - orientation: The orientation. Defaults to `nil`
    ///   - size: The minimum size. Defaults to `nil`
    ///   - color: The color. Defaults to `nil`
    ///   - completion: A result type of ``PhotosResult``
    func searchPhotos(
        _ query: String,
        orientation: PSOrientation? = nil,
        size: PSSize? = nil,
        color: PSColor? = nil,
        page: Int = 1,
        count results: Int = 10,
        completion: @escaping (PhotosResult) -> Void
    ) {
        Task {
            completion(await searchPhotos(
                query, orientation: orientation, size: size, color: color, page: page, count: results
            ))
        }
    }

    // MARK: Get Photos for Category ID

    /// Get a list of ``PSPhoto`` based on a gived category ID
    /// - Parameters:
    ///   - categoryID: The category ID
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    /// - Returns: A result type of ``PhotosResult``
    func getPhotos(
        for categoryID: String,
        page: Int = 1,
        count results: Int = 10
    ) async -> PhotosResult {
        var components: URLComponents = .init(string: API.collections + "/\(categoryID)")!
        let param: Array<URLQueryItem> = [.init(name: "type", value: "photos"),
                                          .init(name: "page", value: "\(page)"),
                                          .init(name: "per_page", value: "\(results)")]

        components.queryItems = param
        guard let url = components.url else { return .failure(.badURL) }
        return await fetchPhotos(url: url)
    }

    /// Get a list of ``PSPhoto`` based on a gived category ID
    /// - Parameters:
    ///   - categoryID: The category ID
    ///   - page: The page/offset to get. Defaults to `1`
    ///   - results: The number of results a page should contain. Defaults to `10`
    ///   - completion: A result type of ``PhotosResult``
    func getPhotos(
        for categoryID: String,
        page: Int = 1,
        count results: Int = 10,
        completion: @escaping (PhotosResult) -> Void
    ) {
        Task {
            completion(await getPhotos(for: categoryID, page: page, count: results))
        }
    }

}
