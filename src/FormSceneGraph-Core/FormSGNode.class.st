Class {
	#name : #FormSGNode,
	#superclass : #Object,
	#category : #'FormSceneGraph-Core'
}

{ #category : #copying }
FormSGNode >> , otherNode [
	otherNode isNullNode ifTrue: [ ^ self ].
	otherNode isContainerNode ifTrue: [ ^ otherNode copy children: { self } , otherNode children ].
	^ FormSGContainerNode new children: {self . otherNode}
]

{ #category : #visiting }
FormSGNode >> accept: aVisitor [
	^ self subclassResponsibility
]

{ #category : #enumerating }
FormSGNode >> allChildrenDo: aBlock [
	self childrenDo: [:each |
		each withAllChildrenDo: aBlock 
	]
]

{ #category : #converting }
FormSGNode >> asForm [
	^ self asFormWithBackgroundColor: Color transparent
]

{ #category : #converting }
FormSGNode >> asFormWithBackgroundColor: backgroundColor [
	| boundingBox form topLevelNode |
	boundingBox := self boundingBox.
	boundingBox isEmpty ifTrue: [ ^ Form extent: 0@0 depth: 32 ].
	
	form := Form extent: boundingBox extent ceiling depth: 32.
	form fillColor: backgroundColor.
	topLevelNode := self.
	boundingBox origin = (0@0) ifFalse: [
		topLevelNode := FormSGTranslationNode new
			child: topLevelNode;
			translation: boundingBox origin negated;
			yourself
	].

	FormSGCanvasRenderer render: topLevelNode on: form getCanvas.
	^ form
]

{ #category : #'display box access' }
FormSGNode >> boundingBox [
	self subclassResponsibility
]

{ #category : #accessing }
FormSGNode >> children [
	^ #()
]

{ #category : #enumerating }
FormSGNode >> childrenDo: aBlock [

]

{ #category : #inspector }
FormSGNode >> gtTreeViewIn: composite [
	<gtInspectorPresentationOrder: 0>
	composite tree 
		title: 'Rendering tree';
		display: [ :node | self ];
		children: [ :each | each children];
		format: [ :node | node asString ]
]

{ #category : #testing }
FormSGNode >> isContainerNode [
	^ false
]

{ #category : #testing }
FormSGNode >> isNullNode [
	^ false
]

{ #category : #enumerating }
FormSGNode >> withAllChildrenDo: aBlock [
	aBlock value: self.
	self allChildrenDo: aBlock.
]

{ #category : #enumerating }
FormSGNode >> withChildrenDo: aBlock [
	aBlock value: self.
	self childrenDo: aBlock
]
