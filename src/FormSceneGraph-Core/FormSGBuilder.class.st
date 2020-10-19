"
I am an scene graph builder. I am utility that provides a convenient API for creating 2D scene graph nodes.
I conveneniently also provide support for keeping track of transformations and clipping bounds with the objective of avoiding building nodes that are complete obscured such as the scrolled out text in a transcript.
"
Class {
	#name : #FormSGBuilder,
	#superclass : #Object,
	#instVars : [
		'clippingBounds'
	],
	#category : #'FormSceneGraph-Core-Builder'
}

{ #category : #geometry }
FormSGBuilder class >> extent: anExtent [
	^ self new extent: anExtent; yourself
]

{ #category : #'node building' }
FormSGBuilder >> borderRectangle: rectangle color: color leftWidth: leftWidth rightWidth: rightWidth bottomWidth: bottomWidth topWidth: topWidth [
	color isTransparent ifTrue: [ ^ self null ].
	(leftWidth = 0 and: [ rightWidth = 0 and:
	[bottomWidth = 0 and: [topWidth = 0]]]) ifTrue: [ ^ self null ].

	^ FormSGBorderNode new
		rectangle: rectangle;
		color: color;
		leftWidth: leftWidth;
		rightWidth: rightWidth;
		bottomWidth: bottomWidth;
		topWidth: topWidth;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> borderRectangle: rectangle color: color width: width [
	(color isTransparent or: [ width = 0 ]) ifTrue: [ ^ self null ].
	^ FormSGBorderNode new
		rectangle: rectangle;
		color: color;
		width: width;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> cachingSubScene [
	^ FormSGCachingSubSceneNode new
]

{ #category : #'node building' }
FormSGBuilder >> clip: node withRectangle: rectangle [
	^ FormSGClipNode new
		child: node;
		rectangle: rectangle;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> clip: node withRectangle: rectangle roundBorderRadius: radius [
	radius <= 0 ifTrue: [ ^ self clip: node withRectangle: rectangle ].
	^ FormSGRoundedClipNode new
		child: node;
		rectangle: rectangle;
		borderRadius: radius;
		yourself
]

{ #category : #'building context' }
FormSGBuilder >> clippingBounds [
	^ clippingBounds
]

{ #category : #'node building' }
FormSGBuilder >> containerWith: nodes [
	^ FormSGContainerNode new
		children: nodes;
		yourself
]

{ #category : #'building context' }
FormSGBuilder >> extent: anExtent [
	clippingBounds := 0@0 extent: anExtent.
]

{ #category : #'node building' }
FormSGBuilder >> horizontalLineFrom: startPoint to: endPoint width: lineWidth color: color [
	^ self rectangle: (startPoint corner: endPoint + (0@lineWidth)) color: color
]

{ #category : #'node building' }
FormSGBuilder >> identityTransform [
	^ FormSGAffineTransform identity
]

{ #category : #initialization }
FormSGBuilder >> initialize [
	super initialize.
	clippingBounds := Rectangle fullSpace.
]

{ #category : #'node building' }
FormSGBuilder >> insetShadow: rectangle leftWidth: leftWidth rightWidth: rightWidth bottomWidth: bottomWidth topWidth: topWidth [
	(leftWidth = 0 and: [ rightWidth = 0 and:
	[bottomWidth = 0 and: [topWidth = 0]]]) ifTrue: [ ^ self null ].
	^ FormSGInsetShadowNode new
		rectangle: rectangle;
		leftWidth: leftWidth;
		rightWidth: rightWidth;
		bottomWidth: bottomWidth;
		topWidth: topWidth;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> insetShadow: rectangle width: width [
	width = 0 ifTrue: [ ^ self null ].
	^ FormSGInsetShadowNode new
		rectangle: rectangle;
		width: width;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> lineFrom: startPoint to: endPoint width: lineWidth color: color [
	(lineWidth closeTo: 0) ifTrue: [ ^ self null ].
	color isTransparent ifTrue: [ ^ self null ].
	(startPoint y closeTo: endPoint y) ifTrue: [
		^ self horizontalLineFrom: startPoint to: endPoint width: lineWidth color: color.
	].
	(startPoint x closeTo: endPoint x) ifTrue: [
		^ self verticalLineFrom: startPoint to: endPoint width: lineWidth color: color.
	].

]

{ #category : #'node building' }
FormSGBuilder >> node: child withOpacityFactor: opacityFactor [
	opacityFactor <= 0 ifTrue: [ ^ self null ].
	^ FormSGOpacityNode new
		opacityFactor: opacityFactor;
		child: child;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> null [
	^ FormSGNullNode uniqueInstance
]

{ #category : #'node building' }
FormSGBuilder >> outsetShadow: rectangle leftWidth: leftWidth rightWidth: rightWidth bottomWidth: bottomWidth topWidth: topWidth [
	(leftWidth = 0 and: [ rightWidth = 0 and:
	[bottomWidth = 0 and: [topWidth = 0]]]) ifTrue: [ ^ self null ].
	^ FormSGOutsetShadowNode new
		rectangle: rectangle;
		leftWidth: leftWidth;
		rightWidth: rightWidth;
		bottomWidth: bottomWidth;
		topWidth: topWidth;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> outsetShadow: rectangle width: width [
	width = 0 ifTrue: [ ^ self null ].
	^ FormSGOutsetShadowNode new
		rectangle: rectangle;
		width: width;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> rectangle: rectangle color: color [
	color isTransparent ifTrue: [ ^ self null ].
	^ FormSGColorRectangleNode new
		rectangle: rectangle;
		color: color;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> rectangle: rectangle drawWithAthens: drawBlock [
	^ self rectangle: rectangle surface: nil drawWithAthens: drawBlock
]

{ #category : #'node building' }
FormSGBuilder >> rectangle: rectangle linearGradientStart: startPoint color: startColor end: endPoint color: endColor [
	(startColor isTransparent and: [ endColor isTransparent ]) ifTrue: [ ^ self null ].
	^ FormSGLinearGradientNode new
		rectangle: rectangle;
		startPoint: startPoint;
		startColor: startColor;
		endPoint: endPoint;
		endColor: endColor;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> rectangle: rectangle radialGradientCenter: center
	innerRadius: innerRadius color: startColor clipRadius: clipInnerRadius
	outerRadius: outerRadius color: endColor clipRadius: clipOuterRadius [
	(startColor isTransparent and: [ endColor isTransparent ]) ifTrue: [ ^ self null ].
	^ FormSGRadialGradientNode new
		rectangle: rectangle;
		center: center;
		innerRadius: innerRadius;
		clipInnerRadius: clipInnerRadius;
		startColor: startColor;
		outerRadius: outerRadius;
		endColor: endColor;
		clipOuterRadius: clipOuterRadius;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> rectangle: rectangle repeatingLinearGradientStart: startPoint color: startColor end: endPoint color: endColor [
	(startColor isTransparent and: [ endColor isTransparent ]) ifTrue: [ ^ self null ].
	^ FormSGRepeatingLinearGradientNode new
		rectangle: rectangle;
		startPoint: startPoint;
		startColor: startColor;
		endPoint: endPoint;
		endColor: endColor;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> rectangle: rectangle surface: surface drawWithAthens: drawBlock [
	^ FormSGAthensNode new
		rectangle: rectangle;
		surface: surface;
		drawBlock: drawBlock;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> rotate: child withDegrees: angle [
	(angle closeTo: 0) ifTrue: [ ^ child ].
	^ self transform: child with: (FormSGAffineTransform rotationInDegrees: angle)
]

{ #category : #'node building' }
FormSGBuilder >> rotate: child withRadians: angle [
	(angle closeTo: 0) ifTrue: [ ^ child ].
	^ self transform: child with: (FormSGAffineTransform rotationInRadians: angle)
]

{ #category : #'node building' }
FormSGBuilder >> scale: child with: scaleFactor [
	(scaleFactor closeTo: 1) ifTrue: [ ^ child ].
	^ self transform: child with: (FormSGAffineTransform scale: scaleFactor)
]

{ #category : #'node building' }
FormSGBuilder >> scale: child withFactorX: scaleFactorX Y: scaleFactorY [
	((scaleFactorX closeTo: 1) and: [ scaleFactorY closeTo: 1 ]) ifTrue: [ ^ child ].
	^ self transform: child with: (FormSGAffineTransform scaleX: scaleFactorX Y: scaleFactorY)
]

{ #category : #'node building' }
FormSGBuilder >> string: string from: firstIndex to: lastIndex in: rectangle font: font color: color kern: kern [ 
	^ self string: string from: firstIndex to: lastIndex in: rectangle font: font color: color kern: kern underline: false underlineColor: nil strikethrough: false strikethroughColor: nil
]

{ #category : #'node building' }
FormSGBuilder >> string: string from: firstIndex to: lastIndex in: rectangle font: font color: color kern: kern underline: underline underlineColor: underlineColor strikethrough: strikethrough strikethroughColor: strikethroughColor [
	^ FormSGTextNode new
		rectangle: rectangle;
		string: string;
		firstIndex: firstIndex;
		lastIndex: lastIndex;
		font: font;
		kern: kern;
		color: color;
		underline: underline;
		underlineColor: underlineColor;
		strikethrough: strikethrough;
		strikethroughColor: strikethroughColor;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> string: string from: firstIndex to: lastIndex in: rectangle font: font color: color underline: underline underlineColor: underlineColor strikethrough: strikethrough strikethroughColor: strikethroughColor [
	^ self string: string from: firstIndex to: lastIndex in: rectangle font: font color: color kern: 0 underline: underline underlineColor: underlineColor strikethrough: strikethrough strikethroughColor: strikethroughColor
]

{ #category : #'node building' }
FormSGBuilder >> string: string in: boundsRect font: fontOrNil color: c [
	^ self string: string in: boundsRect font: fontOrNil color: c underline: false underlineColor: nil strikethrough: false strikethroughColor: nil
]

{ #category : #'node building' }
FormSGBuilder >> string: string in: boundsRect font: fontOrNil color: c underline: underline underlineColor: underlineColor strikethrough: strikethrough strikethroughColor: strikethroughColor [
	^ self string: string from: 1 to: string size in: boundsRect font: fontOrNil color: c underline: underline underlineColor: underlineColor strikethrough: strikethrough strikethroughColor: strikethroughColor
]

{ #category : #'node building' }
FormSGBuilder >> textureForm: form at: position [
	^ self texturedRectangle: (position extent: form extent) form: form
]

{ #category : #'node building' }
FormSGBuilder >> texturedRectangle: rectangle form: form [
	^ self texturedRectangle: rectangle form: form opaque: false
]

{ #category : #'node building' }
FormSGBuilder >> texturedRectangle: rectangle form: form opaque: fullyOpaque [
	^ FormSGTextureNode new
		rectangle: rectangle;
		form: form;
		isFullyOpaque: fullyOpaque;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> transform: child with: transform [
	^ FormSGTransformNode new
		transform: transform;
		child: child;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> transformWithTranslation: translation [
	^ FormSGAffineTransform translation: translation
]

{ #category : #'node building' }
FormSGBuilder >> translate: child with: translation [
	^ FormSGTranslationNode new
		translation: translation;
		child: child;
		yourself
]

{ #category : #'node building' }
FormSGBuilder >> verticalLineFrom: startPoint to: endPoint width: lineWidth color: color [
	^ self rectangle: (startPoint corner: endPoint + (lineWidth@0)) color: color
]

{ #category : #'building context' }
FormSGBuilder >> withClippingBounds: additionalClippingBound build: aBlock [
	| newClippingBounds oldClippingBounds result |
	newClippingBounds := clippingBounds intersect: additionalClippingBound ifNone: [ ^ self null ].
	oldClippingBounds := clippingBounds.
	clippingBounds := newClippingBounds.

	result := aBlock ensure: [ clippingBounds := oldClippingBounds ].
	result isNullNode ifTrue: [ ^ result ].
	^ self clip: result withRectangle: additionalClippingBound
]

{ #category : #'building context' }
FormSGBuilder >> withClippingBounds: additionalClippingBound when: clippingEnable build: aBlock [
	clippingEnable ifFalse: [ ^ aBlock value ].
	^ self withClippingBounds: additionalClippingBound build: aBlock
]

{ #category : #'building context' }
FormSGBuilder >> withTransform: transform build: aBlock [
	| child oldClippingBounds |
	transform isTranslationOnly ifTrue: [ ^ self withTranslation: transform translation build: aBlock ].
	oldClippingBounds := clippingBounds.
	clippingBounds := transform inverseTransformRectangle: clippingBounds.
	child := aBlock ensure: [ clippingBounds := oldClippingBounds ].

	child := aBlock value.
	^ child isNullNode
		ifTrue: [ child ]
		ifFalse: [ self transform: child with: transform ].
]

{ #category : #'building context' }
FormSGBuilder >> withTranslation: translation build: aBlock [
	| child oldClippingBounds |
	oldClippingBounds := clippingBounds.
	clippingBounds := clippingBounds translateBy: translation negated.
	child := aBlock ensure: [ clippingBounds := oldClippingBounds ].
	^ child isNullNode
		ifTrue: [ child ]
		ifFalse: [ self translate: child with: translation ].
]
