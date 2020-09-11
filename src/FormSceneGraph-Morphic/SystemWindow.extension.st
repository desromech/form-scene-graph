Extension { #name : #SystemWindow }

{ #category : #'*FormSceneGraph-Morphic' }
SystemWindow >> doBuildFullSceneGraphWith: builder [
	| invalidSceneGraph renderTargetNode |
	invalidSceneGraph := self valueOfProperty: #invalidSceneGraph ifAbsent: [ true ]. 
	renderTargetNode := self valueOfProperty: #cachedSubSceneGraph ifAbsentPut: [ builder cachingSubScene ].
	
	invalidSceneGraph ifFalse: [
		^ builder translate: renderTargetNode with: bounds origin - renderTargetNode rectangle origin
	].

	renderTargetNode
		child: (super doBuildFullSceneGraphWith: builder) rectangle: bounds.

	self setProperty: #invalidSceneGraph toValue: false.
	^ renderTargetNode
]

{ #category : #'*FormSceneGraph-Morphic' }
SystemWindow >> invalidRect: damageRect from: aMorph [
	self setProperty: #invalidSceneGraph toValue: true.
	super invalidRect: damageRect from: aMorph.
]
