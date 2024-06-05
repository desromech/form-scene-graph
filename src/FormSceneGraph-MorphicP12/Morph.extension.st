Extension { #name : 'Morph' }

{ #category : '*FormSceneGraph-MorphicP12' }
Morph >> buildCachedFullSceneGraphWith: builder [
	| invalidSceneGraph cachedSubSceneNode cachedSubSceneBounds |
	self shouldCacheSceneGraphSurface ifFalse: [ ^ self doBuildFullSceneGraphWith: builder ].
	
	invalidSceneGraph := self valueOfProperty: #invalidSceneGraph ifAbsent: [ true ]. 
	cachedSubSceneNode := self valueOfProperty: #cachedSubSceneGraph ifAbsentPut: [ builder cachingSubScene ].
	
	cachedSubSceneBounds := self fullBounds.
	
	(invalidSceneGraph or: [ cachedSubSceneNode hasValidSubSceneCreationSession not ]) ifTrue: [
		cachedSubSceneNode
			child: (self doBuildFullSceneGraphWith: builder) rectangle: cachedSubSceneBounds.
		self setProperty: #invalidSceneGraph toValue: false.
	].

	^ builder translate: cachedSubSceneNode with: cachedSubSceneBounds origin - cachedSubSceneNode rectangle origin
]

{ #category : '*FormSceneGraph-MorphicP12' }
Morph >> buildChildrenSceneGraphNodeWith: builder [
	submorphs ifEmpty: [ ^ builder null ].
	^ builder withClippingBounds: self clippingBounds when: self clipSubmorphs build: [ 
		self buildClippedChildrenSceneGraphNodeWith: builder
	].

]

{ #category : '*FormSceneGraph-MorphicP12' }
Morph >> buildClippedChildrenSceneGraphNodeListWith: builder [
	| submorphNodes |
	submorphNodes := OrderedCollection new.
	submorphs reverseDo: [ :each |
		| childNode |
		childNode := each buildFullSceneGraphWith: builder.
		childNode isNullNode ifFalse: [
			submorphNodes add: childNode
		]
	].

	^ submorphNodes
]

{ #category : '*FormSceneGraph-MorphicP12' }
Morph >> buildClippedChildrenSceneGraphNodeWith: builder [
	^ builder containerWith: (self buildClippedChildrenSceneGraphNodeListWith: builder)
]

{ #category : '*FormSceneGraph-MorphicP12' }
Morph >> buildDrawErrorSceneGraphNodeWith: builder [
	| nodes |
	nodes := OrderedCollection new.
	nodes
		add: (builder rectangle: bounds color: Color red);
		add: (builder borderRectangle: bounds color: Color yellow width: 1).
		
	self valueOfProperty: #drawError ifPresentDo: [ :error| | trace stringBounds |
		trace := String streamContents: [ :s| error signalerContext shortDebugStackOn: s].
		stringBounds := bounds insetBy: 5.
		trace linesDo: [ :aString|
			nodes add: (builder string: aString in: stringBounds font: TextStyle defaultFont color: Color black).
			stringBounds := stringBounds top: stringBounds top + (TextStyle defaultFont pixelSize * 1.2) 	]].
	^ builder containerWith: nodes asArray
]

{ #category : '*FormSceneGraph-MorphicP12' }
Morph >> buildFullSceneGraphWith: builder [ 
	self visible ifFalse: [^ builder null].
	(builder isRectangleVisible: self fullBounds) ifFalse: [ ^ builder null ].

	(self hasProperty: #errorOnDraw) ifTrue: [^ self buildDrawErrorSceneGraphNodeWith: builder ].

	^ [
		self buildCachedFullSceneGraphWith: builder
	] on: Error do: [ :err |
		self setProperty: #errorOnDraw toValue: true.
		self setProperty: #drawError toValue: err freeze.
		self buildDrawErrorSceneGraphNodeWith: builder
	]
]

{ #category : '*FormSceneGraph-MorphicP12' }
Morph >> buildKeyboardFocusIndicatorSceneGraphNodeWith: builder [
	^ self focusIndicatorMorph buildSceneGraphNodeWith: builder
]

{ #category : '*FormSceneGraph-MorphicP12' }
Morph >> buildOverlaySceneGraphNodeWith: builder [
	| result |
	result := builder null.
	self shouldDrawKeyboardFocusIndicator ifTrue: [ result := self buildKeyboardFocusIndicatorSceneGraphNodeWith: builder ].
	^ result
]

{ #category : '*FormSceneGraph-MorphicP12' }
Morph >> buildSceneGraphNodeWith: builder [
	^ builder fillRectangle: self bounds fillStyle: self fillStyle borderStyle: self borderStyle
]

{ #category : '*FormSceneGraph-MorphicP12' }
Morph >> doBuildFullSceneGraphWith: builder [
	| contentNode childrenNode overlayNode |
	contentNode := self buildSceneGraphNodeWith: builder.
	childrenNode := self buildChildrenSceneGraphNodeWith: builder.
	overlayNode := self buildOverlaySceneGraphNodeWith: builder.
	^ contentNode , childrenNode , overlayNode
]

{ #category : '*FormSceneGraph-MorphicP12' }
Morph >> invalidRect: aRectangle from: aMorph [
	| damageRect |
	aRectangle hasPositiveExtent ifFalse: [ ^self ].
	self setProperty: #invalidSceneGraph toValue: true.
	damageRect := aRectangle.
	aMorph == self ifFalse:[
		"Clip to receiver's clipping bounds if the damage came from a child"
		self clipSubmorphs 
			ifTrue:[damageRect := aRectangle intersect: self clippingBounds ifNone: [ ^ self ]]].
	owner ifNotNil: [owner invalidRect: damageRect from: self].
]

{ #category : '*FormSceneGraph-MorphicP12' }
Morph >> listBuildSceneGraphWith: builder atRow: aRow bounds: drawBounds color: drawColor backgroundColor: backgroundColor from: aMorph [
	| result |
	self bounds: drawBounds.
	result := self buildFullSceneGraphWith: builder.
	(aMorph submorphs includes: self)
		ifFalse: [ aMorph addMorph: self ].
		
	^ result
]

{ #category : '*FormSceneGraph-MorphicP12' }
Morph >> shouldCacheSceneGraphSurface [
	^ false
]

{ #category : '*FormSceneGraph-MorphicP12' }
Morph >> shouldDrawKeyboardFocusIndicator [
	^ false
]

{ #category : '*FormSceneGraph-MorphicP12' }
Morph >> treeRenderSceneNodeWith: builder bounds: drawBounds color: drawColor font: aFont from: aMorph [

	self bounds: drawBounds.
	aMorph addMorphBack: self.
 	^ builder null      
]
