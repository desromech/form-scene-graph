"
I am a node that draws shapes with athens. My content is clipped into my bounding box.
"
Class {
	#name : #FormSGAthensNode,
	#superclass : #FormSGRectangleNode,
	#instVars : [
		'surface',
		'drawBlock',
		'surfaceSession',
		'isSurfaceValidated'
	],
	#category : #'FormSceneGraph-Core-Nodes'
}

{ #category : #visiting }
FormSGAthensNode >> accept: visitor [
	^ visitor visitAthensNode: self
]

{ #category : #accessing }
FormSGAthensNode >> drawBlock [
	^ drawBlock
]

{ #category : #accessing }
FormSGAthensNode >> drawBlock: anObject [
	drawBlock := anObject
]

{ #category : #'rendering helpers' }
FormSGAthensNode >> initialize [
	super initialize.
	isSurfaceValidated := false.
]

{ #category : #testing }
FormSGAthensNode >> isAthensNode [
	^ true
]

{ #category : #accessing }
FormSGAthensNode >> surface [
	^ surface
]

{ #category : #accessing }
FormSGAthensNode >> surface: anObject [
	surface := anObject.
	surfaceSession := Smalltalk session.
	isSurfaceValidated := false.
]

{ #category : #'rendering helpers' }
FormSGAthensNode >> validAthensCairoSurfaceWithExtent: requiredExtent [
	| logicalExtent |
	(surfaceSession == Smalltalk session and: [
	surface isNotNil and: [
	surface extent = requiredExtent]]) ifFalse: [
		surface := AthensCairoSurface extent: requiredExtent.
		isSurfaceValidated := false.
 	].

	logicalExtent := rectangle extent ceiling.
	isSurfaceValidated ifFalse: [
		[
			drawBlock cull: surface cull: (requiredExtent x / logicalExtent x) asFloat cull: (requiredExtent y / logicalExtent y) asFloat
		] on: Error do: [ :e |
		].
	
		isSurfaceValidated := true.
	].

	^ surface
]
