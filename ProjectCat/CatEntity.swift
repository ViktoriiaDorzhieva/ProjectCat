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
    var textureCatWalking : PhysicallyBasedMaterial.Texture? = nil
    var textureCatIdle : PhysicallyBasedMaterial.Texture? = nil
    
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
        
        guard let textureResourceCatWalking = try? TextureResource.load(named: "catWalking") else {
            return
        }
        textureCatWalking = PhysicallyBasedMaterial.Texture(textureResourceCatWalking)
        
        // init idle texture
        
            //        var simpleMaterial = SimpleMaterial(color: .red, isMetallic: false)
        var simpleMaterial = UnlitMaterial()
        simpleMaterial.color = PhysicallyBasedMaterial.BaseColor(texture: textureCatWalking)
        self.model = ModelComponent(mesh: meshResource, materials: [simpleMaterial])
        self.components[CatComponent.self] = .init()
        
        self.transform.translation.y = 0.05
        self.transform.scale = simd_make_float3(0.1, 0.1, 0.1)
        
//        let transform = Transform(scale: .one, rotation: simd_quatf(), translation: [0.5, 0, 0])
//        self.move(to: transform, relativeTo: nil, duration: 10, timingFunction: .easeInOut)
        
        }
    
    
    func update(deltaTime: TimeInterval) {
        // Put all the update behavior per frame
            switch (catState) {
            case .idle:
                idleTimer+=deltaTime
                if idleTimer>5 {
                    walk()
                    idleTimer = 0
                }
                break
                
            case .walking:
                walkTimer+=deltaTime
                if walkTimer>5 {
                    startIdle()
                    walkTimer = 0
                }
                break
            }
        }
    
        func walk() {
            catState = .walking
            //        to make it move
            var transform = Transform()
            transform.translation.x = 0.5
            
            self.move(to: transform, relativeTo: self, duration: 5.0)
            
            // here swap the texture :
            // - use the material on the entity (store it in a variable at initialization)
            // - assign the new texture to the material color
            //
        }
    
        func startIdle() {
            catState = . idle
            
            // swap the texture
            
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

///// The component that marks an entity as a billboard object which will always face the camera.
//public struct BillboardComponent: Component, Codable {
//    public init() {
//    }
//}
//
///// An ECS system that points all entities containing a billboard component at the camera.
//public struct BillboardSystem: System {
//    
//    static let query = EntityQuery(where: .has(cat.BillboardComponent.self))
//    
//    private let arkitSession = ARKitSession()
//    private let worldTrackingProvider = WorldTrackingProvider()
//    
//    public init(scene: RealityKit.Scene) {
//        setUpSession()
//    }
//    
//    func setUpSession() {
//        
//        Task {
//            do {
//                try await arkitSession.run([worldTrackingProvider])
//            } catch {
//                os_log(.info, "Error: \(error)")
//            }
//        }
//    }
//    
//    public func update(context: SceneUpdateContext) {
//        
//        let entities = context.scene.performQuery(Self.query).map({ $0 })
//        
//        guard !entities.isEmpty,
//              let pose = worldTrackingProvider.queryDeviceAnchor(atTimestamp: CACurrentMediaTime()) else { return }
//        
//        let cameraTransform = Transform(matrix: pose.originFromAnchorTransform)
//        
//        for entity in entities {
//            entity.look(at: cameraTransform.translation,
//                        from: entity.scenePosition,
//                        relativeTo: nil,
//                        forward: .positiveZ)
//        }
//    }
//}
//
