"
A FormSGBuilderTest is a test class for testing the behavior of FormSGBuilder
"
Class {
	#name : #FormSGBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'builder'
	],
	#category : #'FormSceneGraph-Core-Tests'
}

{ #category : #running }
FormSGBuilderTest >> setUp [
	builder := FormSGBuilder new.
]

{ #category : #tests }
FormSGBuilderTest >> testBorderRectangle [
	| rectangle node |
	rectangle := 0@0 extent: 250@250.
	node := builder borderRectangle: rectangle color: Color blue width: 2.
	self assert: node isRectangleNode.
	self assert: node isBorderNode.
	self assert: node rectangle equals: rectangle.
	self assert: node boundingBox equals: rectangle.
	self assert: node color equals: Color blue.
	self assert: node leftWidth equals: 2.
	self assert: node rightWidth equals: 2.
	self assert: node bottomWidth equals: 2.
	self assert: node topWidth equals: 2.
	self assert: node borderRectangles equals: { 
		(0@0) corner: (250@2).
		(0@248) corner: (250@250).
		(0@2) corner: (2@248).
		(248@2) corner: (250@248)
	}
]

{ #category : #tests }
FormSGBuilderTest >> testBorderRectangle2 [
	| rectangle node |
	rectangle := 0@0 extent: 250@250.
	node := builder borderRectangle: rectangle color: Color red leftWidth: 1 rightWidth: 2 bottomWidth: 3 topWidth: 4.
	self assert: node isRectangleNode.
	self assert: node isBorderNode.
	self assert: node rectangle equals: rectangle.
	self assert: node boundingBox equals: rectangle.
	self assert: node color equals: Color red.
	self assert: node leftWidth equals: 1.
	self assert: node rightWidth equals: 2.
	self assert: node bottomWidth equals: 3.
	self assert: node topWidth equals: 4.
	self assert: node borderRectangles equals: { 
		(0@0) corner: (250@3).
		(0@246) corner: (250@250).
		(0@3) corner: (1@246).
		(248@3) corner: (250@246)
	}
]

{ #category : #tests }
FormSGBuilderTest >> testBoundingBox [
	self assert: builder null boundingBox isEmpty.
	self assert: (builder rectangle: (-1 @ -2 extent: 32 @ 64) color: Color red) boundingBox equals: (-1 @ -2 extent: 32 @ 64).
	self assert: (builder containerWith: {
		builder rectangle: (-1 @ -2 extent: 32 @ 64) color: Color red.
		builder null
	}) boundingBox equals: (-1 @ -2 extent: 32 @ 64).
	self assert: (builder containerWith: {
		builder rectangle: (-1 @ -2 extent: 32 @ 64) color: Color red.
		builder rectangle: (-5 @ -2 extent: 64 @ 32) color: Color red.
	}) boundingBox equals: (-5 @ -2 extent: 64 @ 64).
]

{ #category : #tests }
FormSGBuilderTest >> testCachingSubSceneNode [
	| rectangle node clipChildNode |
	node := builder cachingSubScene.
	self assert: node isCachingSubSceneNode.
	self assert: node boundingBox isEmpty.
	self assert: node child isNullNode.
	
	rectangle := builder rectangle: (0@0 extent: 250@250) color: Color red.
	node child: rectangle.
	self assert: node boundingBox equals: (0@0 extent: 250@250).
	self assert: node child equals: rectangle.
	clipChildNode := node clipChildNode.
	self assert: node children equals: {clipChildNode}.

]

{ #category : #tests }
FormSGBuilderTest >> testClipNode [
	| node child |
	child := builder rectangle: (-50 @ -50 extent: 200@300) color: Color red.
	node := builder clip: child withRectangle: (0@5 extent: 60@50).
	self assert: node isClipNode.
	self assert: node boundingBox equals: (0@5 extent: 60@50).
	self assert: node child equals: child.
	self assert: node children equals: {child}.
]

{ #category : #tests }
FormSGBuilderTest >> testColorRectangle [
	| rectangle node |
	rectangle := 0@0 extent: 250@250.
	node := builder rectangle: rectangle color: Color blue.
	self assert: node isRectangleNode.
	self assert: node isColorRectangleNode.
	self assert: node rectangle equals: rectangle.
	self assert: node boundingBox equals: rectangle.
	self assert: node color equals: Color blue.
]

{ #category : #tests }
FormSGBuilderTest >> testContainer [
	| node children |
	children := {
		builder rectangle: (0@0 extent: 32@32) color: Color blue.
		builder rectangle: (10@10 extent: 20@40) color: Color red.
	}.
	node := builder containerWith: children.
	self assert: node children equals: children.
	self assert: node boundingBox equals: (0@0 extent: 32@50).
]

{ #category : #tests }
FormSGBuilderTest >> testHorizontalLine [
	| node |
	node := builder horizontalLineFrom: 5@0 to: 20@0 width: 2 color: Color blue.
	self assert: node isRectangleNode.
	self assert: node isColorRectangleNode.
	self assert: node rectangle origin x equals: 5.
	self assert: node rectangle corner x equals: 20.
	self assert: node color equals: Color blue.
]

{ #category : #tests }
FormSGBuilderTest >> testIdentityTransform [
	self assert: builder identityTransform isIdentity.
	self assert: builder identityTransform isTranslationOnly.
]

{ #category : #tests }
FormSGBuilderTest >> testInsetShadow [
	| rectangle node |
	rectangle := 0@0 extent: 250@250.
	node := builder insetShadow: rectangle width: 2.
	self assert: node isRectangleNode.
	self assert: node isShadowNode.
	self assert: node isInsetShadowNode.
	self assert: node rectangle equals: rectangle.
	self assert: node boundingBox equals: rectangle.
	self assert: node leftWidth equals: 2.
	self assert: node rightWidth equals: 2.
	self assert: node bottomWidth equals: 2.
	self assert: node topWidth equals: 2.
]

{ #category : #tests }
FormSGBuilderTest >> testInsetShadow2 [
	| rectangle node |
	rectangle := 0@0 extent: 250@250.
	node := builder insetShadow: rectangle leftWidth: 1 rightWidth: 2 bottomWidth: 3 topWidth: 4.
	self assert: node isRectangleNode.
	self assert: node isShadowNode.
	self assert: node isInsetShadowNode.
	self assert: node rectangle equals: rectangle.
	self assert: node boundingBox equals: rectangle.
	self assert: node leftWidth equals: 1.
	self assert: node rightWidth equals: 2.
	self assert: node bottomWidth equals: 3.
	self assert: node topWidth equals: 4.
]

{ #category : #tests }
FormSGBuilderTest >> testLinearGradientRectangle [
	| rectangle node |
	rectangle := 0@0 extent: 250@250.
	node := builder rectangle: rectangle linearGradientStart: 0@0 color: Color red end: 200@0 color: Color blue.
	self assert: node isRectangleNode.
	self assert: node isLinearGradientNode.
	self deny: node isRepeatingLinearGradientNode.
	self assert: node rectangle equals: rectangle.
	self assert: node boundingBox equals: rectangle.
	self assert: node startColor equals: Color red.
	self assert: node startPoint equals: 0@0.
	self assert: node endColor equals: Color blue.
	self assert: node endPoint equals: 200@0.
]

{ #category : #tests }
FormSGBuilderTest >> testLinearGradientRectangle2 [
	| rectangle node |
	rectangle := 0@0 extent: 250@250.
	node := builder rectangle: rectangle linearGradientStart: 0@0 color: Color transparent end: 200@0 color: Color transparent.
	self assert: node isNullNode.
]

{ #category : #tests }
FormSGBuilderTest >> testNullBorderRectangle [
	| rectangle node |
	rectangle := 0@0 extent: 250@250.
	node := builder borderRectangle: rectangle color: Color transparent width: 2.
	self assert: node isNullNode
]

{ #category : #tests }
FormSGBuilderTest >> testNullInsetShadow [
	| rectangle node |
	rectangle := 0@0 extent: 250@250.
	node := builder insetShadow: rectangle width: 0.
	self assert: node isNullNode
]

{ #category : #tests }
FormSGBuilderTest >> testNullInsetShadow2 [
	| rectangle node |
	rectangle := 0@0 extent: 250@250.
	node := builder insetShadow: rectangle leftWidth: 0 rightWidth: 0 bottomWidth: 0 topWidth: 0.
	self assert: node isNullNode
]

{ #category : #tests }
FormSGBuilderTest >> testNullNode [
	| node |
	node := builder null.
	self assert: node isNullNode.
	self assert: node boundingBox isEmpty.
]

{ #category : #tests }
FormSGBuilderTest >> testNullOutsetShadow [
	| rectangle node |
	rectangle := 0@0 extent: 250@250.
	node := builder outsetShadow: rectangle width: 0.
	self assert: node isNullNode
]

{ #category : #tests }
FormSGBuilderTest >> testNullOutsetShadow2 [
	| rectangle node |
	rectangle := 0@0 extent: 250@250.
	node := builder outsetShadow: rectangle leftWidth: 0 rightWidth: 0 bottomWidth: 0 topWidth: 0.
	self assert: node isNullNode
]

{ #category : #tests }
FormSGBuilderTest >> testOpacityNode [
	| node child |
	child := builder rectangle: (5@5 extent: 32@32) color: Color red.
	node := builder node: child withOpacityFactor: 0.75.
	self assert: node isChildAttributeNode.
	self assert: node isOpacityNode.
	self assert: node opacityFactor equals: 0.75.
	self assert: node boundingBox equals: (5@5 extent: 32@32).
	self assert: node child equals: child.
	self assert: node children equals: {child}.

]

{ #category : #tests }
FormSGBuilderTest >> testOpacityNode2 [
	| node child |
	child := builder rectangle: (5@5 extent: 32@32) color: Color red.
	node := builder node: child withOpacityFactor: 0.
	self assert: node isNullNode.

]

{ #category : #tests }
FormSGBuilderTest >> testOutsetShadow [
	| rectangle node |
	rectangle := 0@0 extent: 250@250.
	node := builder outsetShadow: rectangle width: 2.
	self assert: node isRectangleNode.
	self assert: node isShadowNode.
	self assert: node isOutsetShadowNode.
	self assert: node rectangle equals: rectangle.
	self assert: node boundingBox equals: rectangle.
	self assert: node leftWidth equals: 2.
	self assert: node rightWidth equals: 2.
	self assert: node bottomWidth equals: 2.
	self assert: node topWidth equals: 2.
]

{ #category : #tests }
FormSGBuilderTest >> testOutsetShadow2 [
	| rectangle node |
	rectangle := 0@0 extent: 250@250.
	node := builder outsetShadow: rectangle leftWidth: 1 rightWidth: 2 bottomWidth: 3 topWidth: 4.
	self assert: node isRectangleNode.
	self assert: node isShadowNode.
	self assert: node isOutsetShadowNode.
	self assert: node rectangle equals: rectangle.
	self assert: node boundingBox equals: rectangle.
	self assert: node leftWidth equals: 1.
	self assert: node rightWidth equals: 2.
	self assert: node bottomWidth equals: 3.
	self assert: node topWidth equals: 4.
]

{ #category : #tests }
FormSGBuilderTest >> testRadiantGradientRectangle [
	| rectangle node |
	rectangle := 0@0 extent: 250@250.
	node := builder rectangle: rectangle radialGradientCenter: 125@125
		innerRadius: 50 color: Color red clipRadius: 40
		outerRadius: 100 color: Color blue clipRadius: 110.
	self assert: node isRectangleNode.
	self assert: node isRadialGradientNode.
	self assert: node rectangle equals: rectangle.
	self assert: node boundingBox equals: rectangle.
	self assert: node center equals: 125@125.
	self assert: node innerRadius equals: 50.
	self assert: node startColor equals: Color red.
	self assert: node clipInnerRadius equals: 40.

	self assert: node outerRadius equals: 100.
	self assert: node startColor equals: Color red.
	self assert: node clipOuterRadius equals: 110.


]

{ #category : #tests }
FormSGBuilderTest >> testRadiantGradientRectangle2 [
	| rectangle node |
	rectangle := 0@0 extent: 250@250.
	node := builder rectangle: rectangle radialGradientCenter: 125@125
		innerRadius: 50 color: Color transparent clipRadius: 40
		outerRadius: 100 color: Color transparent clipRadius: 110.
	self assert: node isNullNode.
]

{ #category : #tests }
FormSGBuilderTest >> testRectangleDrawWithAthens [
	| rectangle node drawBlock |
	rectangle := 0@0 extent: 250@250.
	drawBlock := [ :surface | ].
	node := builder rectangle: rectangle drawWithAthens: drawBlock.
	self assert: node isRectangleNode.
	self assert: node isAthensNode.
	self assert: node rectangle equals: rectangle.
	self assert: node surface isNil.
	self assert: node drawBlock equals: drawBlock.
]

{ #category : #tests }
FormSGBuilderTest >> testRectangleSurfaceDrawWithAthens [
	| rectangle node drawBlock surface |
	rectangle := 0@0 extent: 250@250.
	surface := AthensCairoSurface extent: 32@32.
	drawBlock := [ :drawSurface | ].
	node := builder rectangle: rectangle surface: surface drawWithAthens: drawBlock.
	self assert: node isRectangleNode.
	self assert: node isAthensNode.
	self assert: node rectangle equals: rectangle.
	self assert: node surface equals: surface.
	self assert: node drawBlock equals: drawBlock.
]

{ #category : #tests }
FormSGBuilderTest >> testRepeatingLinearGradientRectangle [
	| rectangle node |
	rectangle := 0@0 extent: 250@250.
	node := builder rectangle: rectangle repeatingLinearGradientStart: 0@0 color: Color red end: 200@0 color: Color blue.
	self assert: node isRectangleNode.
	self assert: node isLinearGradientNode.
	self assert: node isRepeatingLinearGradientNode.
	self assert: node rectangle equals: rectangle.
	self assert: node boundingBox equals: rectangle.
	self assert: node startColor equals: Color red.
	self assert: node startPoint equals: 0@0.
	self assert: node endColor equals: Color blue.
	self assert: node endPoint equals: 200@0.
]

{ #category : #tests }
FormSGBuilderTest >> testRepeatingLinearGradientRectangle2 [
	| rectangle node |
	rectangle := 0@0 extent: 250@250.
	node := builder rectangle: rectangle repeatingLinearGradientStart: 0@0 color: Color transparent end: 200@0 color: Color transparent.
	self assert: node isNullNode.
]

{ #category : #tests }
FormSGBuilderTest >> testRotateDegreesNode [
	| node child |
	child := builder rectangle: (5@5 extent: 32@32) color: Color red.
	node := builder rotate: child withDegrees: 90.
	self assert: node isChildAttributeNode.
	self assert: node isTransformNode.
	self assert: node transform equals: (FormSGAffineTransform rotationInDegrees: 90).
	self assert: node boundingBox closeTo: (-37@5 corner: -5@37).
	self assert: node child equals: child.
	self assert: node children equals: {child}.

]

{ #category : #tests }
FormSGBuilderTest >> testRotateRadiansNode [
	| node child |
	child := builder rectangle: (5@5 extent: 32@32) color: Color red.
	node := builder rotate: child withRadians: Float halfPi.
	self assert: node isChildAttributeNode.
	self assert: node isTransformNode.
	self assert: node transform equals: (FormSGAffineTransform rotationInRadians: Float halfPi).
	self assert: node boundingBox closeTo: (-37@5 corner: -5@37).
	self assert: node child equals: child.
	self assert: node children equals: {child}.

]

{ #category : #tests }
FormSGBuilderTest >> testRoundedClipNode [
	| node child |
	child := builder rectangle: (-50 @ -50 extent: 200@300) color: Color red.
	node := builder clip: child withRectangle: (0@5 extent: 60@50) roundBorderRadius: 2.
	self assert: node isClipNode.
	self assert: node isRoundedClipNode.
	self assert: node boundingBox equals: (0@5 extent: 60@50).
	self assert: node borderRadius equals: 2.
	self assert: node child equals: child.
	self assert: node children equals: {child}.
]

{ #category : #tests }
FormSGBuilderTest >> testRoundedClipNode2 [
	| node child |
	child := builder rectangle: (-50 @ -50 extent: 200@300) color: Color red.
	node := builder clip: child withRectangle: (0@5 extent: 60@50) roundBorderRadius: 0.
	self assert: node isClipNode.
	self deny: node isRoundedClipNode.
	self assert: node boundingBox equals: (0@5 extent: 60@50).
	self assert: node child equals: child.
	self assert: node children equals: {child}.
]

{ #category : #tests }
FormSGBuilderTest >> testScaleNode [
	| node child |
	child := builder rectangle: (5@5 extent: 32@32) color: Color red.
	node := builder scale: child with: 2.
	self assert: node isChildAttributeNode.
	self assert: node isTransformNode.
	self assert: node transform equals: (FormSGAffineTransform scale: 2).
	self assert: node boundingBox equals: (10@10 extent: 64@64).
	self assert: node child equals: child.
	self assert: node children equals: {child}.

]

{ #category : #tests }
FormSGBuilderTest >> testScaleXYNode [
	| node child |
	child := builder rectangle: (5@5 extent: 32@32) color: Color red.
	node := builder scale: child withFactorX: 2 Y: 3.
	self assert: node isChildAttributeNode.
	self assert: node isTransformNode.
	self assert: node transform equals: (FormSGAffineTransform scaleX: 2 Y: 3).
	self assert: node boundingBox equals: (10@15 extent: 64@96).
	self assert: node child equals: child.
	self assert: node children equals: {child}.

]

{ #category : #tests }
FormSGBuilderTest >> testText [
	| rectangle node form |
	rectangle := 0@0 extent: 250@250.
	form := Form extent: 1@1 depth: 32.
	node := builder string: 'Hello World' from: 2 to: 4 in: rectangle font: 42 color: Color red kern: 5 underline: true underlineColor: Color green strikethrough: true strikethroughColor: Color blue.
	self assert: node isRectangleNode.
	self assert: node isTextNode.
	self assert: node rectangle equals: rectangle.
	self assert: node boundingBox equals: rectangle.
	self assert: node string equals: 'Hello World'.
	self assert: node firstIndex equals: 2.
	self assert: node lastIndex equals: 4.
	self assert: node font equals: 42.
	self assert: node color equals: Color red.
	self assert: node kern equals: 5.
	self assert: node underline.
	self assert: node underlineColor equals: Color green.
	self assert: node strikethrough.
	self assert: node strikethroughColor equals: Color blue.
]

{ #category : #tests }
FormSGBuilderTest >> testTextureRectangle [
	| rectangle node form |
	rectangle := 0@0 extent: 250@250.
	form := Form extent: 1@1 depth: 32.
	node := builder texturedRectangle: rectangle form: form.
	self assert: node isRectangleNode.
	self assert: node isTextureNode.
	self assert: node rectangle equals: rectangle.
	self assert: node form equals: form.
	self deny: node isFullyOpaque.
	self deny: node isRepeated.
]

{ #category : #tests }
FormSGBuilderTest >> testTextureRectangleOpaque [
	| rectangle node form |
	rectangle := 0@0 extent: 250@250.
	form := Form extent: 1@1 depth: 32.
	node := builder texturedRectangle: rectangle form: form opaque: true.
	self assert: node isRectangleNode.
	self assert: node isTextureNode.
	self assert: node rectangle equals: rectangle.
	self assert: node form equals: form.
	self assert: node isFullyOpaque.
	self deny: node isRepeated.
]

{ #category : #tests }
FormSGBuilderTest >> testTransformNode [
	| node child |
	child := builder rectangle: (5@5 extent: 32@32) color: Color red.
	node := builder transform: child with: builder identityTransform.
	self assert: node isChildAttributeNode.
	self assert: node isTransformNode.
	self assert: node transform equals: builder identityTransform.
	self assert: node child equals: child.
	self assert: node children equals: {child}.

]

{ #category : #tests }
FormSGBuilderTest >> testTranslationNode [
	| node child |
	child := builder rectangle: (5@5 extent: 32@32) color: Color red.
	node := builder translate: child with: 4@5.
	self assert: node isChildAttributeNode.
	self assert: node isTranslationNode.
	self assert: node translation equals: 4@5.
	self assert: node boundingBox equals: (9@10 extent: 32@32).
	self assert: node child equals: child.
	self assert: node children equals: {child}.

]

{ #category : #tests }
FormSGBuilderTest >> testTranslationTransform [
	| transform |
	transform := builder transformWithTranslation: 4@5.
	self deny: transform isIdentity.
	self assert: transform isTranslationOnly.

]

{ #category : #tests }
FormSGBuilderTest >> testVerticalLine [
	| node |
	node := builder verticalLineFrom: 0@5 to: 0@20 width: 2 color: Color blue.
	self assert: node isRectangleNode.
	self assert: node isColorRectangleNode.
	self assert: node rectangle origin y equals: 5.
	self assert: node rectangle corner y equals: 20.
	self assert: node color equals: Color blue.
]

{ #category : #tests }
FormSGBuilderTest >> testWithTranslationBuild [
	| node child |
	builder extent: 20@50.
	self assert: builder clippingBounds equals: (0@0 extent: 20@50).
	child := builder rectangle: (5@5 extent: 32@32) color: Color red.
	node := builder withTranslation: 4@5 build: [
		self assert: builder clippingBounds equals: (-4 @ -5 extent: 20@50).
		child
	].
	self assert: node isTranslationNode.
	self assert: node translation equals: 4@5.
	self assert: node boundingBox equals: (9@10 extent: 32@32).
	self assert: node child equals: child.

]

{ #category : #tests }
FormSGBuilderTest >> testWithTranslationTransformBuild [
	| node child |
	builder extent: 20@50.
	self assert: builder clippingBounds equals: (0@0 extent: 20@50).
	child := builder rectangle: (5@5 extent: 32@32) color: Color red.
	node := builder withTransform: (builder transformWithTranslation: 4@5) build: [
		self assert: builder clippingBounds equals: (-4 @ -5 extent: 20@50).
		child
	].
	self assert: node isTranslationNode.
	self assert: node translation equals: 4@5.
	self assert: node boundingBox equals: (9@10 extent: 32@32).
	self assert: node child equals: child.

]
