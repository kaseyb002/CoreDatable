import CoreData

public protocol CoreDataPersistable {
    associatedtype ManagedObject: NSManagedObject
    
    init?(managedObject: ManagedObject)
    
    func makeManagedObject(controller: CoreDataController) -> ManagedObject
    func makeGetObjectPredicate() -> NSPredicate
    
    static var returnObjectsAsFaultsOnFetch: Bool { get }
}

public extension CoreDataPersistable {
    
    func makeGetObjectFetchRequest() -> NSFetchRequest<ManagedObject> {
        let fetchRequest: NSFetchRequest<ManagedObject> = ManagedObject.fetchRequest() as! NSFetchRequest<Self.ManagedObject>
        fetchRequest.predicate = makeGetObjectPredicate()
        return fetchRequest
    }
    
    var entityName: String { String(describing: ManagedObject.self) }
    
    static var entityName: String { String(describing: ManagedObject.self) }
}
