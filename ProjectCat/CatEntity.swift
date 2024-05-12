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
        super.init()
        var meshDescriptor = MeshDescriptor(name: "MyCatMesh")
        let meshVertices = [simd_make_float3(-1, 1, 0), simd_make_float3(-1, -1, 0), simd_make_float3(1, -1, 0),
                            simd_make_float3(-1, 1, 0), simd_make_float3(1, -1, 0), simd_make_float3(1, 1, 0)]
        meshDescriptor.positions = MeshBuffer(meshVertices)
        let indicesArray = Array(0..<meshVertices.count)
        meshDescriptor.primitives = .triangles(indicesArray.map { UInt32($0)})
        guard let meshResource = try? MeshResource.generate(from: [meshDescriptor]) else {
            fatalError("Error creating the mesh")
        }
        var simpleMaterial = SimpleMaterial(color: .red, isMetallic: false)
        self.model = ModelComponent(mesh: meshResource, materials: [simpleMaterial])
        self.components[CatComponent.self] = .init()
    }
    
    func update() {
        // Put all the update behavior per frame
    }
}

class CatComponent: Component {
    init() {
        CatSystem.registerSystem()
    }
    
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
            guard let myCatEntity = entity as? CatEntity else {
                fatalError("couldn't cast entity as CatEntity")
            }
            myCatEntity.update()
        }
    }
}
