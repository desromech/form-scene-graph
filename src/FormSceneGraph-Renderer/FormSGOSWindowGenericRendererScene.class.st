"
I am a wrapper on top of an scene graph node that connects with the OSWindowGenericRenderer interface.
"
Class {
	#name : #FormSGOSWindowGenericRendererScene,
	#superclass : #OSWindowGenericRendererScene,
	#instVars : [
		'rootNode',
		'renderTarget',
		'renderTargetExtent'
	],
	#category : #'FormSceneGraph-Renderer-Basic'
}

{ #category : #rendering }
FormSGOSWindowGenericRendererScene >> composeRenderTargetInto: renderer [
	| fullBounds |
	fullBounds := 0@0 extent: renderTargetExtent.
	renderer
		clippingBounds: fullBounds;
		useNoBlending;
		color: Color white;
		drawTexture: renderTarget in: fullBounds;
		present
]

{ #category : #rendering }
FormSGOSWindowGenericRendererScene >> renderAllWith: renderer [
	self withRenderer: renderer drawInMainRenderTargetWith: [
		renderer
			color: Color transparent;
			clear.
		
		rootNode ifNotNil: [ 
			FormSGOSWindowGenericRenderer render: rootNode with: renderer.
		].
	].
]

{ #category : #rendering }
FormSGOSWindowGenericRendererScene >> renderRectangle: rectangle with: renderer [
	(self validateRenderTargetFor: renderer) ifFalse: [ ^ self renderAllWith: renderer ].

	renderer withRenderTarget: renderTarget do: [
		renderer clippingBounds: rectangle origin.
		renderer
			color: Color transparent;
			useNoBlending;
			fillRectangle: rectangle.
		
		rootNode ifNotNil: [
			FormSGOSWindowGenericRenderer render: rootNode with: renderer clippingBounds: rectangle.
		].
	].

	self composeRenderTargetInto: renderer
]

{ #category : #accessing }
FormSGOSWindowGenericRendererScene >> rootNode [
	^ rootNode
]

{ #category : #accessing }
FormSGOSWindowGenericRendererScene >> rootNode: anObject [
	rootNode := anObject
]

{ #category : #rendering }
FormSGOSWindowGenericRendererScene >> validateRenderTargetFor: renderer [
	"This optimization is not working yet."
	| requiredExtent |
	requiredExtent := renderer pixelExtent.
	(renderTarget isNotNil and: [ renderTargetExtent = requiredExtent ]) ifTrue: [ ^ true ].
	
	renderTarget := renderer createRenderTargetTextureWithExtent: requiredExtent.
	renderTargetExtent := requiredExtent.
	^ renderTarget isNotNil
]

{ #category : #rendering }
FormSGOSWindowGenericRendererScene >> withRenderer: renderer drawInMainRenderTargetWith: aBlock [
	(self validateRenderTargetFor: renderer) ifTrue: [
		renderer withRenderTarget: renderTarget do: aBlock.
		self composeRenderTargetInto: renderer
	] ifFalse: [
		aBlock value.
		renderer present
	]
]
