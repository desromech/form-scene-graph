"
I am a display scanner that is used for building a scene graph for text.
"
Class {
	#name : 'FormSGDisplayScanner',
	#superclass : 'DisplayScanner',
	#instVars : [
		'builder',
		'textNodes'
	],
	#category : 'FormSceneGraph-MorphicP12',
	#package : 'FormSceneGraph-MorphicP12'
}

{ #category : 'instance creation' }
FormSGDisplayScanner class >> for: paragraph with: builder [
	^ self new initWithParagraph: paragraph andBuilder: builder; yourself
]

{ #category : 'displaying' }
FormSGDisplayScanner >> displayString: string from: startIndex to: stopIndex at: aPoint [
	| rectangle underline strikethrough |
	rectangle := aPoint extent: ((font widthOfString: string from: startIndex to: stopIndex) @ font height).
	
	underline := emphasisCode allMask: 4.
	strikethrough := emphasisCode allMask: 16.
		
	textNodes add: (builder string: string from: startIndex to: stopIndex in: rectangle font: font color: foregroundColor kern: kern underline: underline underlineColor: foregroundColor strikethrough: strikethrough strikethroughColor: foregroundColor)
]

{ #category : 'displaying' }
FormSGDisplayScanner >> fillTextBackground [
	backgroundColor ifNotNil: [
		textNodes add: (builder rectangle: (line left @ lineY extent: line width @ line lineHeight) color: backgroundColor)
	]
]

{ #category : 'initialization' }
FormSGDisplayScanner >> initWithParagraph: paragraph andBuilder: theBuilder [
	self text: paragraph text textStyle: paragraph textStyle.
	builder := theBuilder.
	textNodes := OrderedCollection new.
]

{ #category : 'accessing' }
FormSGDisplayScanner >> sceneGraphNode [
	textNodes isEmpty ifTrue: [ ^ builder null ].
	textNodes size = 1 ifTrue: [ ^ textNodes first ].
	^ builder containerWith: textNodes
]

{ #category : 'accessing' }
FormSGDisplayScanner >> textNodes [
	^ textNodes
]
