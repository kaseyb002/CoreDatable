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
    
    internal let container: NSPersistentContainer
    internal let viewContext: NSManagedObjectContext
    internal let writeContext: NSManagedObjectContext
}
