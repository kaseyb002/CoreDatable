import CoreData

/// Performs reads and writes with a CoreData container
public final class CoreDataController {
    
    public init(container: NSPersistentContainer,
                viewContext: NSManagedObjectContext,
                writeContext: NSManagedObjectContext) {
        self.container = container
        self.viewContext = viewContext
        self.writeContext = writeContext
    }
    
    public let container: NSPersistentContainer
    public let viewContext: NSManagedObjectContext
    public let writeContext: NSManagedObjectContext
}
