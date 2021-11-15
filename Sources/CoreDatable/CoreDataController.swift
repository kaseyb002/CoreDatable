import CoreData

/// Performs reads and writes with a CoreData container
public final class CoreDataController {
    
    public init(container: NSPersistentContainer,
                viewContext: NSManagedObjectContext,
                writeContext: NSManagedObjectContext,
                fetchingBackgroundContext: NSManagedObjectContext) {
        self.container = container
        self.viewContext = viewContext
        self.writeContext = writeContext
        self.fetchingBackgroundContext = fetchingBackgroundContext
    }
    
    internal let container: NSPersistentContainer
    internal let viewContext: NSManagedObjectContext
    internal let writeContext: NSManagedObjectContext
    internal let fetchingBackgroundContext: NSManagedObjectContext
}
