//
//  AppDelegate.swift
//  StatTracker
//
//  Created by Kent Brady on 5/11/20.
//  Copyright © 2020 Kent Brady. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	static var instance: AppDelegate!
	
	static var context: NSManagedObjectContext {
		instance.persistentContainer.viewContext
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		//TODO: Only perform in test code
		
//		do {
//			Uncomment to do a dry run and print the CK records it'll make
//			try persistentContainer.initializeCloudKitSchema(options: [.dryRun, .printSchema])
//			Uncomment to initialize your schema
//			try persistentContainer.initializeCloudKitSchema()
//		} catch {
//			print("Unable to initialize CloudKit schema: \(error.localizedDescription)")
//		}
		
		// Override point for customization after application launch.
		AppDelegate.instance = self
		
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		self.saveContext()
	}
	
	// MARK: - Core Data stack

	lazy var persistentContainer: NSPersistentCloudKitContainer = {
	    /*
	     The persistent container for the application. This implementation
	     creates and returns a container, having loaded the store for the
	     application to it. This property is optional since there are legitimate
	     error conditions that could cause the creation of the store to fail.
	    */
	    let container = NSPersistentCloudKitContainer(name: "BoxScore")
		
		
		var storePath: URL
        do {
			
//			let url = try FileManager.default.url(for: .documentDirectory,
//												in: .userDomainMask,
//												appropriateFor: nil,
//			create: true).appendingPathComponent("CloudStore.store")
//
//			try FileManager.default.removeItem(at: url)
			storePath = try FileManager.default.url(for: .documentDirectory,
													in: .userDomainMask,
                                                    appropriateFor: nil,
				create: true).appendingPathComponent("CloudStore.store")
        } catch {
            fatalError("Unable to get path to Application Support directory")
        }
		
		let cloudDescription = NSPersistentStoreDescription(url: storePath)
		
		let options = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.BoxScore")
		cloudDescription.cloudKitContainerOptions = options
		
		container.persistentStoreDescriptions = [
			cloudDescription
		]
		
	    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
	        if let error = error as NSError? {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	             
	            /*
	             Typical reasons for an error here include:
	             * The parent directory does not exist, cannot be created, or disallows writing.
	             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
	             * The device is out of space.
	             * The store could not be migrated to the current model version.
	             Check the error message to determine what the actual problem was.
	             */
	            fatalError("Unresolved error \(error), \(error.userInfo)")
	        }
	    })
		
	    return container
	}()

	// MARK: - Core Data Saving support

	func saveContext () {
	    let context = persistentContainer.viewContext
		context.mergePolicy = NSOverwriteMergePolicy
		
	    if context.hasChanges {
	        do {
	            try context.save()
	        } catch {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	            let nserror = error as NSError
	            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
	        }
	    }
	}


}

