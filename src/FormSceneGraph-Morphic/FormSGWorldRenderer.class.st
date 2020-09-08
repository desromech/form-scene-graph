Class {
	#name : #FormSGWorldRenderer,
	#superclass : #OSWorldRenderer,
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #accessing }
FormSGWorldRenderer class >> isApplicableFor: aWorld [
	^ false
]

{ #category : #initialization }
FormSGWorldRenderer >> actualScreenSize [
	^ (super actualScreenSize / self scaleFactor) ceiling max: 1@1
]

{ #category : #operations }
FormSGWorldRenderer >> buildSceneGraphForWorldState: aWorldState ofWorld: aWorld [
	| builder rootNodes scaleFactor |
	scaleFactor := self scaleFactor.
	builder := FormSGBuilder extent: self actualScreenSize.
	rootNodes := OrderedCollection new.
	rootNodes add: (aWorld buildFullSceneGraphWith: builder).
	aWorldState hands reverseDo: [ :each |
		rootNodes add: (each buildFullSceneGraphWith: builder)
	].
	aWorldState damageRecorder reset.
	^ builder scale: (builder containerWith: rootNodes) with: scaleFactor
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
			builder solidRectangle: displayRectangle color: Color white
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

{ #category : #'as yet unclassified' }
FormSGWorldRenderer >> windowScaleFactor [
	^ osWindow ifNil: [ 1 ] ifNotNil: [ osWindow screenScaleFactor ]
]
