//
//  CatEntity.swift
//  ProjectCat
//
//  Created by Viktoriia Dorzhieva on 5/11/24.
//

import Foundation
import RealityKit
import ARKit
import OSLog
import simd


public enum CatStates {
    case idle
    case walking
//    case hiding
}

class CatEntity: Entity, HasModel {
    // my class variables
    var catState = CatStates.idle
    var idleTimer: Double = 0
    var walkTimer: Double = 0
    
    var baseColorIdle: UnlitMaterial.BaseColor? = nil
    var baseColorWalking: UnlitMaterial.BaseColor? = nil
    
    var simpleMaterial = UnlitMaterial()
    var randomDouble: Double = 0
    var randomX:Float = 0
    var randomZ:Float = 0
    
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
        }
        
        guard let textureResourceCatIdle = try? TextureResource.load(named: "catLaying"),
              let textureResourceCatWalking = try? TextureResource.load(named: "catLeft")
        else {
            return
        }
        
        let textureCatWalking = PhysicallyBasedMaterial.Texture(textureResourceCatWalking)
        let textureCatIdle = PhysicallyBasedMaterial.Texture(textureResourceCatIdle)
        
        self.baseColorIdle = UnlitMaterial.BaseColor(texture: textureCatIdle)
        self.baseColorWalking = UnlitMaterial.BaseColor(texture: textureCatWalking)
        
        guard let baseColorIdle = self.baseColorIdle else {
            return
        }
        self.simpleMaterial.color = baseColorIdle
        
        self.model = ModelComponent(mesh: meshResource, materials: [simpleMaterial])
        self.components[CatComponent.self] = .init()
        
        self.transform.translation.y = 0.05
        self.transform.scale = simd_make_float3(0.1, 0.1, 0.1)
        
    }
    
    
    func update(deltaTime: TimeInterval) {
        randomDouble = Double.random(in: 3..<10)
        // Put all the update behavior per frame
        switch (catState) {
        case .idle:
            idleTimer+=deltaTime
            if idleTimer>randomDouble  {
                walk()
                idleTimer = 0
            }
            break
            
        case .walking:
            walkTimer+=deltaTime
            if walkTimer>randomDouble {
                startIdle()
                walkTimer = 0
            }
            break
        }
        
        //        let scale = 0.01
        //        let offset = sin(time) * scale
        //        self.transform.translation = self.transform.translation + SIMD3<float>(0, offset, 0)
        //        }
        
        func walk() {
            randomX = Float.random(in: -2..<2)
            randomZ = Float.random(in: -2..<2)
            
            catState = .walking
            //        to make it move
            var transform = Transform()
            
            transform.translation = SIMD3<Float>(x: randomX, y: 0, z: randomZ)
            
            
            self.move(to: transform, relativeTo: self, duration: randomDouble)
            
            guard let baseColorWalking = self.baseColorWalking else {
                return
            }
            self.simpleMaterial.color = baseColorWalking
            self.model?.materials = [simpleMaterial]
            
        }
        
        func startIdle() {
            catState = . idle
            _ = SKAction.playSoundFileNamed("catPurr", waitForCompletion: false)
            guard let baseColorIdle = self.baseColorIdle else {
                return
            }
            self.simpleMaterial.color = baseColorIdle
            self.model?.materials = [simpleMaterial]
            
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
                myCatEntity.update(deltaTime: context.deltaTime)
            }
        }
    }
    
    /// The component that marks an entity as a billboard object which will always face the camera.
    //public struct BillboardComponent: Component, Codable {
    //    public init() {
    //    }
    //}
    
    ///// An ECS system that points all entities containing a billboard component at the camera.
    //public struct BillboardSystem: System {
    //
    //    static let query = EntityQuery(where: .has(BillboardComponent.self))
    //
    //
    //    public init(scene: RealityKit.Scene) {
    //
    //    }
    //
    //
    //
    //    public func update(context: SceneUpdateContext) {
    //
    //        let entities = context.scene.performQuery(Self.query).map({ $0 })
    //
    //
    //        for cat in entities {
    //            cat.look(at: cameraTransform.translation,
    //                        from: cat.scenePosition,
    //                        relativeTo: nil,
    //                        forward: .positiveZ)
    //        }
    //    }
    //}
    //
    
}
