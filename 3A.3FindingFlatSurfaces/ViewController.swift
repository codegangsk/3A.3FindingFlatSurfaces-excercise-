//
//  ViewController.swift
//  3A.3FindingFlatSurfaces
//
//  Created by Sophie Kim on 2020/08/26.
//  Copyright © 2020 Sophie Kim. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

final class ViewController: UIViewController {

    @IBOutlet private var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.vertical, .horizontal]
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        if planeAnchor.alignment == .horizontal {
        let box = createBox(planeAnchor: planeAnchor)
        node.addChildNode(box)
        }
        
        if planeAnchor.alignment == .vertical {
        let wall = createWall(planeAnchor: planeAnchor)
        node.addChildNode(wall)
    }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        for node in node.childNodes {
                node.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            if let plane = node.geometry as? SCNPlane {
                plane.width = CGFloat(planeAnchor.extent.x)
                plane.height = CGFloat(planeAnchor.extent.z)
            }
        }
    }
}

extension ViewController {
    private func createWall(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let node = SCNNode()
        let geometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        node.geometry = geometry
        node.eulerAngles.x = -Float.pi / 2
        node.opacity = 0.8
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        
        return node
    }
    private func createBox(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let node = SCNNode()
        let geometry = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.0)
        node.geometry = geometry
        node.eulerAngles.x = -Float.pi / 2
        node.opacity = 0.8
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.green
    
    return node
    
}
}
