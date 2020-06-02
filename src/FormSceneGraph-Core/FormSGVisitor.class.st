Class {
	#name : #FormSGVisitor,
	#superclass : #Object,
	#category : #'FormSceneGraph-Core'
}

{ #category : #visiting }
FormSGVisitor >> visitAthensNode: node [
	^ self visitRectangleNode: node
]

{ #category : #visiting }
FormSGVisitor >> visitBorderNode: node [
	^ self visitRectangleNode: node
]

{ #category : #visiting }
FormSGVisitor >> visitChildAttributeNode: node [
	^ self subclassResponsibility
]

{ #category : #visiting }
FormSGVisitor >> visitClipNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
FormSGVisitor >> visitColorNode: node [
	^ self visitRectangleNode: node
]

{ #category : #visiting }
FormSGVisitor >> visitContainerNode: node [
	^ self subclassResponsibility
]

{ #category : #visiting }
FormSGVisitor >> visitInsetShadowNode: node [
	^ self visitRectangleNode: node
]

{ #category : #visiting }
FormSGVisitor >> visitLinearGradientNode: node [
	^ self visitRectangleNode: node
]

{ #category : #visiting }
FormSGVisitor >> visitNode: node [
	^ node accept: self
]

{ #category : #visiting }
FormSGVisitor >> visitNodes: nodes [
	nodes do: [ :each | self visitNode: each ]
]

{ #category : #visiting }
FormSGVisitor >> visitNodesAndCollect: nodes [
	^ nodes collect: [ :each | self visitNode: each ]
]

{ #category : #visiting }
FormSGVisitor >> visitNullNode: node [
	^ self subclassResponsibility
]

{ #category : #visiting }
FormSGVisitor >> visitOpacityNode: node [
	^ self visitChildAttributeNode: node
]

{ #category : #visiting }
FormSGVisitor >> visitOutsetShadowNode: node [
	^ self visitRectangleNode: node
]

{ #category : #visiting }
FormSGVisitor >> visitRectangleNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
FormSGVisitor >> visitRepeatingGradientNode: node [
	^ self visitRectangleNode: node
]

{ #category : #visiting }
FormSGVisitor >> visitRoundedClipNode: node [
	^ self visitClipNode: node
]

{ #category : #visiting }
FormSGVisitor >> visitTextNode: node [
	^ self visitRectangleNode: node
]

{ #category : #visiting }
FormSGVisitor >> visitTextureNode: node [
	^ self visitRectangleNode: node
]

{ #category : #visiting }
FormSGVisitor >> visitTransformNode: node [
	^ self visitChildAttributeNode: node
]

{ #category : #visiting }
FormSGVisitor >> visitTranslationNode: node [
	^ self visitChildAttributeNode: node
]
