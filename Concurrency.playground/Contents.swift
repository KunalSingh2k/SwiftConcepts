import UIKit
import PlaygroundSupport

////MARK: - Creating Threads
///// Simple example
///// Using GCD to perform a task on a background thread
//DispatchQueue.global(qos: .background).async {
//    /// Background thread work here
//    print("Running on background thread")
//    
//    /// Switch back to the main thread to update the UI
//    DispatchQueue.main.async {
//        /// Update UI on the main thread
//        print("Back on the main thread")
//        
//    }
//}
//
///// This line tells the Playground to continue running indefinitely
//PlaygroundPage.current.needsIndefiniteExecution = true
//
///// Using GCD to perform a task on a background thread
//DispatchQueue.global(qos: .background).async {
//    //// Background thread work here
//    print("Running on background thread")
//    
//    // Simulate a network call or heavy computation
//    sleep(2) /// Delays the thread for 2 seconds to simulate some work being done
//    
//    /// Switch back to the main thread to update the UI
//    DispatchQueue.main.async {
//        /// Update UI on the main thread
//        print("Back on the main thread")
//        
//        /// This line tells the Playground that we are done and it can stop running
//        PlaygroundPage.current.finishExecution()
//    }
//}
//
////MARK: - Deadlock
///// Simple example
//let queue1 = DispatchQueue(label: "com.example.queue1")
//let queue2 = DispatchQueue(label: "com.example.queue2")
//
//queue1.async {
//    queue2.sync {
//        /// This will never execute because queue1 is already busy with the outer async block
//    }
//}
//
//queue2.async {
//    queue1.sync {
//        /// This will never execute because queue2 is already busy with the outer async block
//    }
//}
//
///// Create two NSLock objects to demonstrate a deadlock situation
//let lock1 = NSLock()
//let lock2 = NSLock()
//
///// Thread 1
//DispatchQueue.global().async {
//    lock1.lock() /// Thread 1 acquires lock 1
//    print("Thread 1 acquired lock1")
//    sleep(1) /// Sleep to increase the chance that Thread 2 acquires lock2 before Thread 1 attempts to acquire it
//    
//    print("Thread 1 waiting for lock2")
//    lock2.lock() /// Thread 1 attempts to acquire lock 2, but it's already held by Thread 2
//    print("Thread 1 acquired lock2") /// This line will not execute because of the deadlock
//    lock2.unlock() /// These unlock calls will not be reached
//    lock1.unlock()
//}
//
///// Thread 2
//DispatchQueue.global().async {
//    lock2.lock() /// Thread 2 acquires lock 2
//    print("Thread 2 acquired lock2")
//    sleep(1) /// Sleep to increase the chance that Thread 1 acquires lock 1 before Thread 2 attempts to acquire it
//    
//    print("Thread 2 waiting for lock1")
//    lock1.lock() /// Thread 2 attempts to acquire lock1, but it's already held by Thread 1
//    print("Thread 2 acquired lock1") /// This line will not execute because of the deadlock
//    lock1.unlock() /// These unlock calls will not be reached
//    lock2.unlock()
//}
//
//
////MARK: - Race Condition
///// Shared resource that will be accessed by multiple threads
//var sharedResource = 0
//
///// Create a concurrent queue to simulate a race condition
//let resourceQueue = DispatchQueue(label: "resourceQueue", attributes: .concurrent)
//
///// First asynchronous task to increment the shared resource 1000 times
//resourceQueue.async {
//    for _ in 1...5 {
//        sharedResource += 1
//    }
//}
//
///// Second asynchronous task to increment the shared resource 1000 times
//resourceQueue.async {
//    for _ in 1...5 {
//        sharedResource += 1
//    }
//}
//
///// Schedule a task on the main queue to check the final value of the shared resource
///// After a delay, giving enough time for the above tasks to complete
//DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//    /// Print the final value of the shared resource
//    print("Final value of sharedResource is: \(sharedResource)")
//    
//    /// Stop the playground from running after we have the result
//    PlaygroundPage.current.finishExecution()
//}
//
////MARK: - Async and await
//func fetchData() async -> String {
//    try? await Task.sleep(nanoseconds: 1_000_000_000)
//    return "Data from server"
//}
//
//
//func updateUI(with data: String) {
//    print("UI updated with: \(data)")
//    PlaygroundPage.current.finishExecution()
//}
//
//Task {
//    let data = await fetchData()
//    updateUI(with: data)
//}
//
////MARK: - MultiThreading
//let operationQueue = OperationQueue()
//
//let operation1 = BlockOperation {
//    sleep(2)
//    print("Operation 1 running")
//}
//
//let operation2 = BlockOperation {
//    sleep(1)
//    print("Operation 2 running")
//}
//
///// Add both operations to the operation queue
//operationQueue.addOperation(operation1)
//operationQueue.addOperation(operation2)
//
//let completionOperation = BlockOperation {
//    print("All operations are completed")
//    PlaygroundPage.current.finishExecution()
//}
//
///// Add dependencies to the completion operation
//completionOperation.addDependency(operation1)
//completionOperation.addDependency(operation2)
//
///// Add the completion operation to the operation queue
//operationQueue.addOperation(completionOperation)
//
//
////MARK: - Using GCD with serial Queue
//let serialQueue = DispatchQueue(label: "com.example.serialQueue")
//var number = 0
//
///// First task
//serialQueue.async {
//    for _ in 1...5 {
//        number += 1
//    }
//}
//
///// Second task
//serialQueue.async {
//    for _ in 1...5 {
//        number += 1
//    }
//}
///// After a delay, giving enough time for the above tasks to complete
//DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//    print("Final value of number is: \(number)")
//    PlaygroundPage.current.finishExecution()
//}
//
////MARK: - GCD With Barriers
//let concurrentQueue = DispatchQueue(label: "com.example.concurrentQueue", attributes: .concurrent)
//
//var integer = 0
//
///// First task
//concurrentQueue.async(flags: .barrier) {
//    for _ in 1...5 {
//        integer += 1
//    }
//}
//
///// Second task
//concurrentQueue.async(flags: .barrier) {
//    for _ in 1...5 {
//        integer += 1
//    }
//}
//
///// After a delay, giving enough time for the above tasks to complete
//DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//    print("Final value of integer is: \(integer)")
//    PlaygroundPage.current.finishExecution()
//}
//
////MARK: - Sharing Data between threads
///// Create a dispatch group to synchronize group of tasks
//let dispatchGroup = DispatchGroup()
//let concurrentQueueForDispatchGroup = DispatchQueue(label: "com.example.concurrentQueueForDispatchGroup", attributes: .concurrent)
//var sharedArray: [String] = []
//
///// Protect shared resource access with a synchronization mechanism
//let arrayAccessQueue = DispatchQueue(label: "com.example.arrayAccessQueue")
//
///// First task to append in shared array
//concurrentQueue.async(group: dispatchGroup) {
//    arrayAccessQueue.sync {
//        sharedArray.append("Background Thread 1")
//    }
//}
//
///// Second task to append in shared array
//concurrentQueue.async(group: dispatchGroup) {
//    arrayAccessQueue.sync {
//        sharedArray.append("Background Thread 2")
//    }
//}
//
///// Notify block to be executed after all tasks in dispatch group are completed
//dispatchGroup.notify(queue: .main) {
//    print("Shared Array: \(sharedArray)")
//    PlaygroundPage.current.finishExecution()
//    
//    /// The use of an additional serial queue (`arrayAccessQueue`) for accessing the shared array
//    /// Ensures that the array modifications are synchronized and prevents race conditions.
//}
//
////MARK: - GCD with NSLock
//let lock = NSLock()
//var sharedNumber = 0
//
///// First task
//DispatchQueue.global().async {
//    for _ in 1...5 {
//        lock.lock() /// accquire the lock before modifying
//        sharedNumber += 1
//        lock.unlock() /// release the lock after modifying
//    }
//}
//
///// Second task
//DispatchQueue.global().async {
//    for _ in 1...5 {
//        lock.lock() /// accquire the lock before modifying
//        sharedNumber += 1
//        lock.unlock() /// release the lock after modifying
//    }
//}
//
//DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//    print("Final value of shared Number is: \(sharedNumber)")
//    PlaygroundPage.current.finishExecution()
//    
//    ///The NSLock ensures that only one thread can modify the shared resource at a time, preventing race conditions.
//    /// This means that one thread will wait for the other to release the lock before it can acquire the lock and perform its increments.
//}
//
////MARK: - Dispatch Semaphore
//let semaphore = DispatchSemaphore(value: 1)
//var sharedInteger = 0
//
///// First Task
//DispatchQueue.global().async {
//    for _ in 1...5 {
//        semaphore.wait() /// Wait for the semaphore to become available before accessing the shared Integer
//        sharedInteger += 1
//        semaphore.signal() /// Signal that the shared resource is now available for other threads
//    }
//}
//
///// Second Task
//DispatchQueue.global().async {
//    for _ in 1...5 {
//        semaphore.wait() /// Wait for the semaphore to become available before accessing the shared Integer
//        sharedInteger += 1
//        semaphore.signal() /// Signal that the shared resource is now available for other threads
//    }
//}
//
//DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//    print("Final value of sharedInteger: \(sharedInteger)")
//    PlaygroundPage.current.finishExecution()
//    /// The DispatchSemaphore ensures that only one thread can modify the shared resource at a time,
//    /// Which prevents race conditions. This means that the threads will take turns incrementing the shared resource,
//    /// Each thread waiting for the semaphore to be signaled by the other before proceeding with its increments.
//}

//MARK: - Concurreny working.
func dispatchQuestion() {
    print("A")
    DispatchQueue.global(qos: .default).async {
        print ("B" )
        DispatchQueue.main.async {
            print("C")
        }
        print("D")
        DispatchQueue.main.sync {
            print("E")
        }
        DispatchQueue.main.async {
            print("F")
            DispatchQueue.main.sync {
                print ("G")
            }
        }
        print("H")
    }
    print ("I")
}

dispatchQuestion()
