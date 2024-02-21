//
//  FriendInfoDataManager.swift
//  woju
//
//  Created by 정민호 on 2/21/24.
//

import Foundation
import SwiftData

final class FriendInfoDataManager {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = FriendInfoDataManager()

    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: FriendInfo.self)
        self.modelContext = modelContainer.mainContext
    }

    func appendItem(item: FriendInfo) {
        modelContext.insert(item)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func fetchItems() -> [FriendInfo] {
        do {
            return try modelContext.fetch(FetchDescriptor<FriendInfo>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func removeItem(_ item: FriendInfo) {
        modelContext.delete(item)
    }
}
