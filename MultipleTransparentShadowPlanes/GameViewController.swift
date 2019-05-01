//
//  GameViewController.swift
//  ClippingPlaneTest
//
//  Created by Dennis Ippel on 02/04/2019.
//  Copyright © 2019 Dennis Ippel. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    @IBOutlet weak var scnView: SCNView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.zNear = 1
        cameraNode.camera?.zFar = 40
        cameraNode.camera?.wantsHDR = true
        
        if let lookAtNode = scene.rootNode.childNode(withName: "lookAtNode", recursively: true) {
            cameraNode.constraints = [SCNLookAtConstraint(target: lookAtNode)]
        }
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 10)

        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        scnView.scene = scene
        scnView.allowsCameraControl = true
    }
    
    @IBAction func showZDepthSingleGeometryAnswer(_ sender: UIButton) {
        guard
            let rootNode = scnView.scene?.rootNode,
            let shadowPlane1 = rootNode.childNode(withName: "shadowPlane1", recursively: true),
            let shadowPlane2 = rootNode.childNode(withName: "shadowPlane2", recursively: true)
        else {
            assertionFailure()
            return
        }
        
        // Remove the original shadow planes
        shadowPlane1.removeFromParentNode()
        shadowPlane2.removeFromParentNode()

        // Create a container for the shadow planes
        let planesNode = SCNNode()
        planesNode.addChildNode(shadowPlane1)
        planesNode.addChildNode(shadowPlane2)
        planesNode.castsShadow = false
        
        // Create a flattened clone so they're merged into on geometry
        let cloned = planesNode.flattenedClone()
        
        // Double check. Should be 0 children.
        print(cloned.childNodes.count)
        
        // Add
        rootNode.addChildNode(cloned)
        
        DispatchQueue.main.async {
            sender.isHidden = true
        }
    }
}
