//
//  ViewController.swift
//  Temp
//
//  Created by Roland on 2018-05-03.
//  Copyright © 2018 MoozX Internet Ventures. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        basicFetch()
        populateDatabase()  // Should only be run once

    }

    private func populateDatabase() {
        let fido = createDog(with: "Fido", and: 2)
        print("fido = \(fido)")
        
        let me = createPerson(with: "Roland")
        me.dogs.append(fido)  // Add fido to my list of dogs
        print("me = \(me)")
        
        // Save my objects into Realm for persistence
        do {
            // Get a reference to Realm
            let realm = try Realm()
            try realm.write {
                // Add to the realm inside a write transaction
                realm.add(me)  // This will automatically save fido also, because it's in my list of dogs. The save is performed recursively
            }
        }
        catch {
            print("Error encountered")
        }        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func createDog(with name: String, and age: Int) -> Dog {
        let dog = Dog()
        dog.name = name
        dog.age = age
        return dog
    }
    
    private func createPerson(with name: String, and image: UIImage? = nil) -> Person {
        let person = Person()
        person.name = name
        if let image = image {
            person.picture = UIImageJPEGRepresentation(image, 1.0)
        }
        return person
    }
    
    private func basicFetch() {
        // Try to get a handle to Realm
        guard let realm = try? Realm() else {
            print("Unable to get handle for Realm")
            return
        }
//        let realm = try! Realm()  // I do not like this FORCE try because it's unsafe and could crash
        // Retrieve all objects of type Person
        let results = realm.objects(Person.self)
        
        // loop through result set
        for person in results {
            print(#line, person.name)
            print(#line, person.dogs.first?.name ?? "no dog")
            // .first here is optional because list of dogs could be empty, in which case there's no first object
            // .name here returns a String? (optional String) because if .name is nil, then there's no name associated with it
            // The operator ?? means that if the left hand side resolves to nil, then use the right hand side value, so in this case if the list of dogs were empty, then it will print "no dog"
        }
    }
}


class Dog: Object {
    @objc dynamic var name = ""  // String
    @objc dynamic var age = 0
//    @objc dynamic var owner: Person? = nil
}

class Person: Object {
    @objc dynamic var name = ""
    @objc dynamic var picture: Data? = nil // optionals supported
    let dogs = List<Dog>() // models a one to many relationship
}
