"
A FormSGNodeTest is a test class for testing the behavior of FormSGNode
"
Class {
	#name : #FormSGNodeTest,
	#superclass : #TestCase,
	#category : #'FormSceneGraph-Core-Tests'
}

{ #category : #tests }
FormSGNodeTest >> testDefaultTestingMethods [
	| node |
	node := FormSGNode new.
	self deny: node isAthensNode.
	self deny: node isBorderNode.
	self deny: node isCachingSubSceneNode.
	self deny: node isClipNode.
	self deny: node isColorRectangleNode.
	self deny: node isContainerNode.
	self deny: node isGradientNode.
	self deny: node isInsetShadowNode.
	self deny: node isLinearGradientNode.
	self deny: node isNullNode.
	self deny: node isOpacityNode.
	self deny: node isOutsetShadowNode.
	self deny: node isRadialGradientNode.
	self deny: node isRectangleNode.
	self deny: node isRepeatingLinearGradientNode.
	self deny: node isRoundedClipNode.
	self deny: node isShadowNode.
	self deny: node isTextNode.
	self deny: node isTextureNode.
	self deny: node isTransformNode.
	self deny: node isTranslationNode.
]
