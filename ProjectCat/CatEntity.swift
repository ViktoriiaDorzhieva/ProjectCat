//
//  CatEntity.swift
//  ProjectCat
//
//  Created by Viktoriia Dorzhieva on 5/11/24.
//

import Foundation
import RealityKit

public enum CatStates {
    case idle
    case walking
//    case hiding
}

class CatEntity: Entity, HasModel {
    // my class variables
    var catState = CatStates.idle
    var walkTimer = 0
    
    required init() {
        super.init()
        var meshDescriptor = MeshDescriptor(name: "MyCatMesh")
        let meshVertices = [simd_make_float3(-1, 1, 0), simd_make_float3(-1, -1, 0), simd_make_float3(1, -1, 0),
                            simd_make_float3(-1, 1, 0), simd_make_float3(1, -1, 0), simd_make_float3(1, 1, 0)]
        meshDescriptor.positions = MeshBuffer(meshVertices)
        
        let textureCoords = [simd_make_float2(0,1), simd_make_float2(0,0), simd_make_float2(1,0), simd_make_float2(0,1), simd_make_float2(1,0), simd_make_float2(1,1)]
        
        meshDescriptor.textureCoordinates = MeshBuffer(textureCoords)
        
        let indicesArray = Array(0..<meshVertices.count)
        meshDescriptor.primitives = .triangles(indicesArray.map { UInt32($0)})
        guard let meshResource = try? MeshResource.generate(from: [meshDescriptor]) else {
            fatalError("Error creating the mesh")
//            return
        }
        
        let imageName = "catWalking"
        guard let texture = try? TextureResource.load(named: imageName) else {
            return
        }
        
            //        var simpleMaterial = SimpleMaterial(color: .red, isMetallic: false)
        var simpleMaterial = UnlitMaterial()
        simpleMaterial.color = PhysicallyBasedMaterial.BaseColor(texture: .init(texture))
        self.model = ModelComponent(mesh: meshResource, materials: [simpleMaterial])
        self.components[CatComponent.self] = .init()
        
        self.transform.translation.y = 0.05
        self.transform.scale = simd_make_float3(0.1, 0.1, 0.1)
        
//        let transform = Transform(scale: .one, rotation: simd_quatf(), translation: [0.5, 0, 0])
//        self.move(to: transform, relativeTo: nil, duration: 10, timingFunction: .easeInOut)
        
        }
    
    
    func update() {
        // Put all the update behavior per frame
        switch (catState) {
        case .idle:
            walk()
            break
        case .walking:
            startIdle()
            break
        }
        
        func walk() {
            catState = .walking
            //        to make it move
            var transform = Transform()
            transform.translation.x = 0.5
            
            self.move(to: transform, relativeTo: self, duration: 5.0)
        }
        func startIdle() {
            catState = . idle
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                walk()
            }
            
        }
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

struct BillboardSystem: System {
    
    static let query = EntityQuery(where: .has(BillboardComponent.self))
    
    init(scene: RealityKit.Scene) {}
    
    func update(context: SceneUpdateContext) {
        context.scene.performQuery(Self.query).forEach {self in
            
            guard let billboard = self.components[BillboardComponent.self] else { return }

            let headPosition = ARData.shared.headEntity.transform.translation
            let entityPosition = self.position(relativeTo: nil)
            let target = entityPosition - (headPosition - entityPosition)
            
            if let upVector = billboard.upVector {
                self.look(at: target, from: entityPosition, upVector: upVector, relativeTo: nil)
            } else {
                self.look(at: target, from: entityPosition, relativeTo: nil)
            }
        }
    }
}
    
struct BillboardComponent: Component {
    var upVector: Float3?
       
       init(upVector: Float3? = nil) {
           self.upVector = upVector
       }
}
