"
I am a world renderer that renders morphic in two steps:
- Build a scene graph of the morphic world.
- Render the scene graph into the OSWindow.
"
Class {
	#name : #FormSGWorldRenderer,
	#superclass : #OSWorldRenderer,
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #accessing }
FormSGWorldRenderer class >> isApplicableFor: aWorld [
	^ false
]

{ #category : #accessing }
FormSGWorldRenderer class >> priority [
	^ OSWorldRenderer priority + 1
]

{ #category : #initialization }
FormSGWorldRenderer >> actualScreenSize [
	^ (super actualScreenSize / self scaleFactor) ceiling max: 1@1
]

{ #category : #operations }
FormSGWorldRenderer >> buildSceneGraphForWorldState: aWorldState ofWorld: aWorld [
	| builder rootNodes scaleFactor surfaceScaleFactor |
	scaleFactor := self scaleFactor.
	surfaceScaleFactor := (self drawingSurfaceExtent / self windowExtent) asFloatPoint.
	
	builder := FormSGBuilder extent: self actualScreenSize.
	rootNodes := OrderedCollection new.
	rootNodes add: (aWorld buildFullSceneGraphWith: builder).
	aWorldState hands reverseDo: [ :each |
		rootNodes add: (each buildFullSceneGraphWith: builder)
	].
	aWorldState damageRecorder reset.
	^ builder scale: (builder containerWith: rootNodes)
		withFactorX: (scaleFactor * surfaceScaleFactor x) asFloat
		Y: (scaleFactor * surfaceScaleFactor y) asFloat
]

{ #category : #initialization }
FormSGWorldRenderer >> checkForNewScreenSize [

	osWindow ifNil: [ ^ self ].
	world worldState realWindowExtent = self actualScreenSize ifTrue: [ ^ self ].
	world worldState realWindowExtent: self actualScreenSize.

	world restoreMorphicDisplay.

]

{ #category : #initialization }
FormSGWorldRenderer >> convertWindowMouseEventPosition: aPosition [
	^ (aPosition / self scaleFactor + 0.5) floor
]

{ #category : #operations }
FormSGWorldRenderer >> deferUpdatesDuring: aBlock [
	"Nothing required here."
]

{ #category : #operations }
FormSGWorldRenderer >> displayNewSceneScene: newSceneGraph [
	| renderer |
	renderer := self osWindowRenderer.
	renderer scene rootNode: newSceneGraph.
	renderer updateAll.

]

{ #category : #operations }
FormSGWorldRenderer >> displayWorldState: aWorldState ofWorld: aWorld [
	| submorphs newSceneGraph |
	osWindow ifNil: [ ^ self ].

	"force re-layout if needed"
	submorphs := aWorld submorphs.
	submorphs do: [ :m | m fullBounds ].

	"display is already up-to-date"
	aWorldState checkIfUpdateNeeded
		ifFalse: [ ^ nil ].
		
	self isProfilingRenderingTime ifTrue: [
		self doDisplayWorldStateWhileProfiling: aWorldState ofWorld: aWorld
	] ifFalse: [
		self doDisplayWorldState: aWorldState ofWorld: aWorld
	].

]

{ #category : #operations }
FormSGWorldRenderer >> doDisplayWorldState: aWorldState ofWorld: aWorld [
	| newSceneGraph |
	newSceneGraph := self buildSceneGraphForWorldState: aWorldState ofWorld: aWorld.
	newSceneGraph ifNil: [ ^ self ].

	self displayNewSceneScene: newSceneGraph

]

{ #category : #operations }
FormSGWorldRenderer >> doDisplayWorldStateWhileProfiling: aWorldState ofWorld: aWorld [
	| sceneGraphBuildingTime builder font displayRectangle newSceneGraph measurements | 
	sceneGraphBuildingTime := [ newSceneGraph := self buildSceneGraphForWorldState: aWorldState ofWorld: aWorld ] timeToRunWithoutGC.
	newSceneGraph ifNil: [ ^ self ].

	measurements := { 'Graph building' -> sceneGraphBuildingTime }.
	previousFrameRenderingTime ifNotNil: [
		measurements := measurements , { 'Previous frame' -> previousFrameRenderingTime}.
	].

	displayRectangle := (0@0 extent: 350@40).
	builder := FormSGBuilder extent: aWorld extent.
	font := TextStyle defaultFont.
	newSceneGraph := builder containerWith: {
			newSceneGraph.
			builder rectangle: displayRectangle color: Color white
		} ,
		(measurements collectWithIndex: [:each :index |
			| line |
			line := self formatRenderingTimeMeasurement: each.
			builder string: line in: (10@(10*index) extent: 200@10) font: font color: Color black.
		]).
				
	previousFrameRenderingTime := [
		self displayNewSceneScene: newSceneGraph
	] timeToRunWithoutGC.

	self logRenderingTimeMeasurements: measurements

]

{ #category : #operations }
FormSGWorldRenderer >> drawDuring: aBlock [
	"Nothing required here."
]

{ #category : #'scale factor' }
FormSGWorldRenderer >> drawingSurfaceExtent [
	^ (osWindow isNotNil and: [ osWindow renderer isNotNil ])
		ifTrue: [ osWindow renderer pixelExtent ]
		ifFalse: [ self windowExtent ]
]

{ #category : #initialization }
FormSGWorldRenderer >> osWindowRenderer [
		
	^ osWindow renderer ifNil: [
		osWindow newGenericRenderer.
		osWindow renderer scene: FormSGOSWindowGenericRendererScene new.
		osWindow renderer
	].
	
]

{ #category : #initialization }
FormSGWorldRenderer >> scaleFactor [
	^ world scaleFactor * self windowScaleFactor
]

{ #category : #initialization }
FormSGWorldRenderer >> screenScaleFactor [
	^ 1
]

{ #category : #operations }
FormSGWorldRenderer >> updateDamage: allDamage [
	"Nothing required here."
]

{ #category : #'scale factor' }
FormSGWorldRenderer >> windowScaleFactor [
	^ osWindow ifNil: [ 1 ] ifNotNil: [ osWindow screenScaleFactor max: 1 ]
]
