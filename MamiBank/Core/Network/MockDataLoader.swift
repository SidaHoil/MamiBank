//
//  MockDataLoader.swift
//  MamiBank
//
//  Created by Hoil Sida on 13/11/25.
//
import Foundation

struct MockDataLoader {
    
    static func load(_ fileName: String) -> Data {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "geojson") else {
            return Data()
        }
        return (try? Data(contentsOf: url)) ?? Data()
    }
}
