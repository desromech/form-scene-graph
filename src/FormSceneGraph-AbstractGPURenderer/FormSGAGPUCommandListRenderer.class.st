"
I am an extent command list renderer the implements support for drawing an agpu texture directly.
"
Class {
	#name : #FormSGAGPUCommandListRenderer,
	#superclass : #FormSGGPUCommandListRenderer,
	#category : #'FormSceneGraph-AbstractGPURenderer'
}

{ #category : #visiting }
FormSGAGPUCommandListRenderer >> visitAGPUTextureNode: node [
	| sourceRectangle rectangle extent sourceExtent texcoordScale textureRectangle |
	node binding ifNil: [ ^ self ].

	rectangle := node rectangle.
	extent := rectangle extent.
	(extent x <= 0.0 or: [ extent y <= 0.0 ]) ifTrue: [ ^ self ].
		
	sourceRectangle := node validSourceRectangle.
	sourceExtent := sourceRectangle extent.
	(sourceExtent x <= 0.0 or: [ sourceExtent y <= 0.0 ]) ifTrue: [ ^ self ].
	
	texcoordScale := (1.0@1.0) / node extent.

	textureRectangle := node isRepeated
		ifTrue: [ sourceRectangle origin extent: rectangle extent / sourceExtent ]
		ifFalse: [ sourceRectangle origin*texcoordScale corner: sourceRectangle corner*texcoordScale ].
	
	node isFullyOpaque ifTrue: [ 
		commandList useFullyOpaqueBlending
	].

	commandList
		setAGPUTextureNode: node;
		beginTriangles;
		color: Color white;
		vertexPosition: (currentTransform transformPoint: rectangle bottomLeft) texcoord: textureRectangle bottomLeft;
		vertexPosition: (currentTransform transformPoint: rectangle bottomRight) texcoord: textureRectangle bottomRight;
		vertexPosition: (currentTransform transformPoint: rectangle topRight) texcoord: textureRectangle topRight;
		vertexPosition: (currentTransform transformPoint: rectangle topLeft) texcoord: textureRectangle topLeft;
		addIndices: #(
			0 1 2
			2 3 0
		);
		endSubmesh.
		
	node isFullyOpaque ifTrue: [ 
		commandList useCompositeAlphaBlending
	].

]
