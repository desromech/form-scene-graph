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
FormSGAthensNode >> drawRedScreenOfDeathOn: targetSurface for: error [
	targetSurface drawDuring: [ :canvas |
		self drawRedScreenOfDeathOnCanvas: canvas for: error
	]
]

{ #category : #'rendering helpers' }
FormSGAthensNode >> drawRedScreenOfDeathOnCanvas: canvas for: error [
	| trace font height |
	canvas pathTransform loadIdentity.
	canvas
		setPaint: (Color red alpha: 0.7);
		setShape: (0@0 extent: surface extent);
		draw.
					
	trace := String streamContents: [ :s| error signalerContext shortDebugStackOn: s].
	font := LogicalFont familyName: 'Arial' pointSize: 20.
	canvas setFont: font.
	canvas setPaint: Color black.

	canvas pathTransform translateX: 0 Y: (font getPreciseAscent).
	height := font getPreciseHeight.
	trace linesDo: [ :line |
		canvas drawString: (line copyReplaceAll: String tab with: '    ').
		canvas pathTransform translateX: 0 Y: height.
	]

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
		] on: Error do: [ :error |
			self drawRedScreenOfDeathOn: surface for: error
		].
	
		isSurfaceValidated := true.
	].

	^ surface
]
