import CoreData

public protocol EntityControllable {
    associatedtype Entity: CoreDataPersistable
    
    var coreDataController: CoreDataController { get }
}

public extension EntityControllable {
    
    func fetchManagedObject(
        with obj: Entity,
        context: NSManagedObjectContext
    ) async throws -> Entity.ManagedObject? {
        let fetchRequest = obj.makeGetObjectFetchRequest()
        fetchRequest.returnsObjectsAsFaults = Entity.returnObjectsAsFaultsOnFetch
        return try await coreDataController.fetchManagedObject(with: fetchRequest, in: context)
    }
    
    func findOrCreateManagedObject(
        with obj: Entity,
        context: NSManagedObjectContext
    ) async throws -> Entity.ManagedObject {
        if let existing = try? await fetchManagedObject(with: obj, context: context) {
            return existing
        }
        
        return Entity.ManagedObject(context: context)
    }
    
    func deleteAll() async throws {
        try await coreDataController.batchDelete(with: nil, entityName: Entity.entityName)
    }
    
    func getAll() async throws -> [Entity] {
        let req: NSFetchRequest<Entity.ManagedObject> = Entity.ManagedObject.fetchRequest() as! NSFetchRequest<Entity.ManagedObject>
        return try await coreDataController.fetchObjects(with: req)
    }
}
