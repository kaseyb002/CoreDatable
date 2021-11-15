import CoreData

public protocol EntityControllable {
    associatedtype Entity: CoreDataPersistable
    
    var coreDataController: CoreDataController { get }
}

public extension EntityControllable {
    
    
    
    func deleteAll() async throws {
        try await coreDataController.batchDelete(with: nil, entityName: Entity.entityName)
    }
    
    func getAll() async throws -> [Entity] {
        let req: NSFetchRequest<Entity.ManagedObject> = Entity.ManagedObject.fetchRequest() as! NSFetchRequest<Entity.ManagedObject>
        return try await coreDataController.fetchObjects(with: req)
    }
}
