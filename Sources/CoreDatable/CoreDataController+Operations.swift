import CoreData

// MARK: - Fetching
public extension CoreDataController {
    
    func fetchObject<T: CoreDataPersistable>(
        with fetchRequest: NSFetchRequest<T.ManagedObject>
    ) async throws -> T {
        try await viewContext.perform {
            fetchRequest.returnsObjectsAsFaults = T.returnObjectsAsFaultsOnFetch
            let items = try self.viewContext.fetch(fetchRequest)
            guard let first = items.first else {
                throw CoreDatableError.objectNotFound
            }
            guard let item = T.init(managedObject: first) else {
                // TODO: give field specific error; throw on the init
                throw CoreDatableError.failedToInitModel
            }
            retur item
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
    
    func fetchCount(
        with fetchRequest: NSFetchRequest<NSFetchRequestResult>
    ) async throws -> Int {
        try viewContext.count(for: fetchRequest)
    }
}
// MARK: - Saving
public extension CoreDataController {
    
    func save<T: CoreDataPersistable>(_ object: T) async throws {
        try await save([object])
    }
    
    func save<T: CoreDataPersistable>(_ objects: [T]) async throws {
        try await writeContext.perform {
            let _ = objects.map { $0.makeManagedObject(controller: self) }
            try self.writeContext.save()
        }
    }
    
    private func saveContext() async throws {
        try await writeContext.perform {
            try self.writeContext.save()
        }
    }
}

// MARK: - Deleting
public extension CoreDataController {
    
    func delete<T: CoreDataPersistable>(_ object: T) async throws {
        try await writeContext.perform {
            let managedObject = object.makeManagedObject(controller: self)
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

// MARK: - Creating Managed Objects
public extension CoreDataController {
    
    /// Returns entity if it exists (based on `makeGetObjectFetchRequest()`, or creates a new one
    func findOrCreateManagedObject<T: CoreDataPersistable>(
        with obj: T,
        context: NSManagedObjectContext
    ) -> T.ManagedObject {
        if let existing = fetchManagedObject(with: obj, context: context) {
            return existing
        }
        
        return T.ManagedObject(context: context)
    }
    
    private func fetchManagedObject<T: CoreDataPersistable>(
        with obj: T,
        context: NSManagedObjectContext
    ) -> T.ManagedObject? {
        let fetchRequest = obj.makeGetObjectFetchRequest()
        fetchRequest.returnsObjectsAsFaults = T.returnObjectsAsFaultsOnFetch
        return fetchManagedObject(with: fetchRequest, in: context)
    }
    
    private func fetchManagedObject<T: NSManagedObject>(
        with fetchRequest: NSFetchRequest<T>,
        in context: NSManagedObjectContext
    ) -> T? {
        fetchManagedObjects(with: fetchRequest, in: context).first
    }
    
    private func fetchManagedObjects<T: NSManagedObject>(
        with fetchRequest: NSFetchRequest<T>,
        in context: NSManagedObjectContext
    ) -> [T] {
        var objs = [T]()
        context.performAndWait {
            do {
                let items = try context.fetch(fetchRequest)
                objs = items
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        return objs
    }
}

public enum CoreDatableError: Error {
    case objectNotFound
    case failedToInitModel
}
