import CoreData

public protocol EntityControllable {
    associatedtype Entity: CoreDataPersistable
    
    var coreDataController: CoreDataController { get }
}

// MARK: - CoreDataController Wrappers
public extension EntityControllable {
    
    func fetchObject(
        with fetchRequest: NSFetchRequest<Entity.ManagedObject>
    ) async throws -> Entity {
        try await coreDataController.fetchObject(with: fetchRequest)
    }
    
    func fetchObjects(
        with fetchRequest: NSFetchRequest<Entity.ManagedObject>
    ) async throws -> [Entity] {
        try await coreDataController.fetchObjects(with: fetchRequest)
    }
    
    func save(_ object: Entity) async throws {
        try await save([object])
    }
    
    func save(_ objects: [Entity]) async throws {
        try await coreDataController.save(objects)
    }
    
    func delete(_ object: Entity) async throws {
        try await coreDataController.delete(object)
    }
    
    func deleteAll() async throws {
        try await coreDataController.batchDelete(with: nil, entityName: Entity.entityName)
    }
    
    func getAll() async throws -> [Entity] {
        let req: NSFetchRequest<Entity.ManagedObject> = Entity.ManagedObject.fetchRequest() as! NSFetchRequest<Entity.ManagedObject>
        return try await coreDataController.fetchObjects(with: req)
    }
}
