"
I am a world renderer that renders morphic in two steps:
- Build a scene graph of the morphic world.
- Render the scene graph into the OSWindow.
"
Class {
	#name : #FormSGAbstractWorldRenderer,
	#superclass : #OSWorldRenderer,
	#classVars : [
		'IsEnabled',
		'SelectedWorldRendererClass'
	],
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #testing }
FormSGAbstractWorldRenderer class >> isAbstract [
	^ self == FormSGAbstractWorldRenderer
]

{ #category : #accessing }
FormSGAbstractWorldRenderer class >> isApplicableFor: aWorld [
	self isAbstract ifTrue: [ ^ false ].
	^ self isEnabledClass and: [Smalltalk isHeadless and: [ CommandLineArguments new hasOption: 'interactive'  ]]
]

{ #category : #accessing }
FormSGAbstractWorldRenderer class >> isEnabled [
	^ IsEnabled ifNil: [ IsEnabled := false ]
]

{ #category : #accessing }
FormSGAbstractWorldRenderer class >> isEnabled: aBoolean [
	IsEnabled := aBoolean
]

{ #category : #testing }
FormSGAbstractWorldRenderer class >> isEnabledClass [
	^ self isEnabled and: [ self selectedWorldRendererClass == self ]
]

{ #category : #accessing }
FormSGAbstractWorldRenderer class >> isEnabledSettingsOn: aBuilder [
	<systemsettings>
	(aBuilder setting: #isEnabled)
		parent: #appearance;
		label: 'Enable scene graph renderer (Required for Hi-DPI)';
		description: 'This enables the new scalable scene graph rendering framework. Effects are only visible after restarting the image.';
		target: self
]

{ #category : #accessing }
FormSGAbstractWorldRenderer class >> priority [
	^ OSWorldRenderer priority + 1
]

{ #category : #testing }
FormSGAbstractWorldRenderer class >> selectedWorldRendererClass [
	^ SelectedWorldRendererClass ifNil: [ SelectedWorldRendererClass := FormAthensSGWorldRenderer ]
]

{ #category : #testing }
FormSGAbstractWorldRenderer class >> selectedWorldRendererClass: aClass [
	SelectedWorldRendererClass := aClass
]

{ #category : #accessing }
FormSGAbstractWorldRenderer class >> selectedWorldRendererClassSettingsOn: aBuilder [
	<systemsettings>
	(aBuilder pickOne: #selectedWorldRendererClass)
		parent: #appearance;
		label: 'Form Scene Graph World Renderer Class';
		description: 'This allows selecting the backend for the scene graph based UI renderer.';
		domainValues: (self allSubclasses reject: [:each | each isAbstract]);
		target: self
]

{ #category : #hooks }
FormSGAbstractWorldRenderer >> adjustSurfaceDamageRectangle: damageRectangle [
	"In some cases we may need to extend the by damage rectangle an additional pixel to overcome differences between inclusive versus exclusive definitions."
	^ damageRectangle
]

{ #category : #operations }
FormSGAbstractWorldRenderer >> buildSceneGraphForWorldState: aWorldState ofWorld: aWorld [
	| builder rootNodes scaleFactor actualScreenSize |
	scaleFactor := self scaleFactor.
	
	actualScreenSize := self actualScreenSize.
	builder := FormSGBuilder extent: actualScreenSize.
	rootNodes := OrderedCollection new.
	rootNodes add: (aWorld buildFullSceneGraphWith: builder).
	aWorldState hands reverseDo: [ :each |
		rootNodes add: (each buildFullSceneGraphWith: builder)
	].

	^ builder scale: (builder containerWith: rootNodes)
		withFactorX: scaleFactor x asFloat
		Y: scaleFactor y asFloat
]

{ #category : #initialization }
FormSGAbstractWorldRenderer >> checkForNewScreenSize [

	osWindow ifNil: [ ^ self ].
	world worldState realWindowExtent = self actualScreenSize ifTrue: [ ^ self ].
	world worldState realWindowExtent: self actualScreenSize.

	world restoreMorphicDisplay.

]

{ #category : #operations }
FormSGAbstractWorldRenderer >> deferUpdatesDuring: aBlock [
	"Nothing required here."
]

{ #category : #operations }
FormSGAbstractWorldRenderer >> displayNewSceneGraph: newSceneGraph withDamageRectangle: damageRecorder [
	self subclassResponsibility
]

{ #category : #operations }
FormSGAbstractWorldRenderer >> displayWorldState: aWorldState ofWorld: aWorld [
	| submorphs |
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
FormSGAbstractWorldRenderer >> doDisplayWorldState: aWorldState ofWorld: aWorld [
	| newSceneGraph damageRectangle |
	newSceneGraph := self buildSceneGraphForWorldState: aWorldState ofWorld: aWorld.
	newSceneGraph ifNil: [
		aWorldState damageRecorder reset.
		^ self
	].

	damageRectangle := self extractMergedDamageRectangleFromWorldState: aWorldState ofWorld: aWorld.
	damageRectangle isEmpty ifTrue: [ ^ self ].
	self displayNewSceneGraph: newSceneGraph withDamageRectangle: damageRectangle.

]

{ #category : #operations }
FormSGAbstractWorldRenderer >> doDisplayWorldStateWhileProfiling: aWorldState ofWorld: aWorld [
	| sceneGraphBuildingTime builder font displayRectangle newSceneGraph measurements damageRectangle | 
	sceneGraphBuildingTime := [ newSceneGraph := self buildSceneGraphForWorldState: aWorldState ofWorld: aWorld ] timeToRunWithoutGC.
	newSceneGraph ifNil: [
		aWorldState damageRecorder reset.
		^ self
	].

	damageRectangle := self extractMergedDamageRectangleFromWorldState: aWorldState ofWorld: aWorld.
	damageRectangle isEmpty ifTrue: [ ^ self ].

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
		self displayNewSceneGraph: newSceneGraph withDamageRectangle: damageRectangle.
	] timeToRunWithoutGC.

	self logRenderingTimeMeasurements: measurements

]

{ #category : #operations }
FormSGAbstractWorldRenderer >> drawDuring: aBlock [
	"Nothing required here."
]

{ #category : #'scale factor' }
FormSGAbstractWorldRenderer >> drawingSurfaceBounds [
	^ 0@0 extent: self drawingSurfaceExtent
]

{ #category : #'scale factor' }
FormSGAbstractWorldRenderer >> drawingSurfaceExtent [
	^ (osWindow isNotNil and: [ osWindow renderer isNotNil ])
		ifTrue: [ osWindow renderer pixelExtent ]
		ifFalse: [ self windowExtent ]
]

{ #category : #private }
FormSGAbstractWorldRenderer >> extractMergedDamageRectangleFromWorldState: aWorldState ofWorld: aWorld [
	| handsToDraw worldDamageRectangles damageRectangles result scaleFactor surfaceDamageRectangle |
	worldDamageRectangles := aWorldState damageRecorder invalidRectsFullBounds: self drawingSurfaceBounds.
	handsToDraw := aWorldState selectHandsToDrawForDamage: worldDamageRectangles.
	damageRectangles := worldDamageRectangles , (handsToDraw collect: [:each | each computeDamageRectForNextFrame ]).
	
	result := damageRectangles
		ifEmpty: [ ^ Rectangle empty ]
		ifNotEmpty: [ Rectangle merging: damageRectangles].
	aWorldState damageRecorder reset.

	scaleFactor := self scaleFactor.
	surfaceDamageRectangle := (result origin * scaleFactor) floor corner: (result corner * scaleFactor) ceiling.
	^ self adjustSurfaceDamageRectangle: surfaceDamageRectangle.
]

{ #category : #initialization }
FormSGAbstractWorldRenderer >> osWindowRenderer [
	self subclassResponsibility
]

{ #category : #operations }
FormSGAbstractWorldRenderer >> scaleFactor [
	^ self surfaceScaleFactor * self screenScaleFactor
]

{ #category : #operations }
FormSGAbstractWorldRenderer >> surfaceScaleFactor [
	^ (self drawingSurfaceExtent / self windowExtent) asFloatPoint
]

{ #category : #operations }
FormSGAbstractWorldRenderer >> updateDamage: allDamage [
	"Nothing required here."
]
