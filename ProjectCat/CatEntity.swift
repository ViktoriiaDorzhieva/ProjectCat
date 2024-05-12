//
//  CatEntity.swift
//  ProjectCat
//
//  Created by Viktoriia Dorzhieva on 5/11/24.
//

import Foundation
import RealityKit

class CatEntity: Entity, HasModel {
    required init() {
        
    }
    
    func update() {
        
    }
}

class CatComponent: Component {
    func update() {
        
    }
}


class CatSystem : System {
    // Define a query to return all entities with a MyComponent.
    private static let query = EntityQuery(where: .has(CatComponent.self))
    
    // Initializer is required. Use an empty implementation if there's no setup needed.
    required init(scene: Scene) { }
    
    // Iterate through all entities containing a MyComponent.
    func update(context: SceneUpdateContext) {
        context.scene.performQuery(Self.query).forEach { entity in
            // Make per-frame changes to each entity here.
            let myCatEntity = entity as! CatEntity
            myCatEntity.update()
        }
    }
}
