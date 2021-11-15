import CoreData

// MARK: - Fetching
public extension CoreDataController {
    
    func fetchObject<T: CoreDataPersistable>(
        with fetchRequest: NSFetchRequest<T.ManagedObject>
    ) async throws -> T? {
        try await viewContext.perform {
            fetchRequest.returnsObjectsAsFaults = T.returnObjectsAsFaultsOnFetch
            let items = try self.viewContext.fetch(fetchRequest)
            guard let first = items.first else { return nil }
            return T.init(managedObject: first)
        }
    }
    
    func fetchObjects<T: CoreDataPersistable>(
        with fetchRequest: NSFetchRequest<T.ManagedObject>
    ) async throws -> [T] {
        try await viewContext.perform {
            fetchRequest.returnsObjectsAsFaults = T.returnObjectsAsFaultsOnFetch
            let items = try self.viewContext.fetch(fetchRequest)
            return items.compactMap { T.init(managedObject: $0) }
        }
    }
}
// MARK: - Saving
public extension CoreDataController {
    
    func save<T: CoreDataPersistable>(_ object: T) async throws {
        try await save([object])
    }
    
    func save<T: CoreDataPersistable>(_ objects: [T]) async throws {
        try await writeContext.perform {
            let _ = objects.map { $0.makeManagedObject() }
            try self.writeContext.save()
        }
    }
    
    private func saveContext() async throws {
        try await writeContext.perform {
            try self.writeContext.save()
        }
    }
}

// MARK: - Fetch Managed Objects
public extension CoreDataController {
    
    func fetchManagedObject<T: NSManagedObject>(
        with fetchRequest: NSFetchRequest<T>,
        in context: NSManagedObjectContext
    ) async throws -> T? {
        try await fetchManagedObjects(with: fetchRequest, in: context).first
    }
    
    func fetchManagedObjects<T: NSManagedObject>(
        with fetchRequest: NSFetchRequest<T>,
        in context: NSManagedObjectContext
    ) async throws -> [T] {
        try await context.perform {
            try context.fetch(fetchRequest)
        }
    }
}

// MARK: - Deleting
public extension CoreDataController {
    
    func delete<T: CoreDataPersistable>(_ object: T) async throws {
        try await writeContext.perform {
            let managedObject = object.makeManagedObject()
            self.writeContext.delete(managedObject)
            try self.writeContext.save()
        }
    }
    
    func batchDelete(
        with predicate: NSPredicate?,
        entityName: String
    ) async throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try await writeContext.perform {
            try self.writeContext.executeAndMergeChanges(using: batchDeleteRequest)
        }
    }
}
