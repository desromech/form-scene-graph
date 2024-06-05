Extension { #name : 'Text' }

{ #category : '*FormSceneGraph-MorphicP12' }
Text >> listBuildSceneGraphWith: builder atRow: aRow bounds: bounds color: color backgroundColor: backgroundColor from: aMorph [
	"Method extracted from LazyListMorph"
	| attrs useDefaultFont f itemBounds |
	
	attrs := self attributesAt: 1.
	useDefaultFont := true.
	attrs
		do: [:att | att
				forFontInStyle: aMorph font textStyle
				do: [:fon | useDefaultFont := false]].
	f := useDefaultFont
				ifTrue: [ aMorph font]
				ifFalse: [ self fontAt: 1 withStyle: aMorph font textStyle ].
	itemBounds := bounds withHeight: f height.
	itemBounds := itemBounds align: itemBounds leftCenter with: bounds leftCenter.
	"center the item if the font height is different to that of our font"
	^ builder
		string: self asString
		in: itemBounds
		font: (f emphasized: (self emphasisAt: 1))
		color: color
		underline: ((self emphasisAt: 1)
				bitAnd: 4)
				> 0
		underlineColor: color
		strikethrough: ((self emphasisAt: 1)
				bitAnd: 16)
				> 0
		strikethroughColor: color
]

{ #category : '*FormSceneGraph-MorphicP12' }
Text >> treeRenderSceneNodeWith: builder bounds: drawBounds color: drawColor font: aFont from: aMorph [

	"Method extracted from LazyListMorph"
	| attrs useDefaultFont f itemBounds |
	
	attrs := self attributesAt: 1.
	useDefaultFont := true.
	attrs
		do: [:att | att
				forFontInStyle: TextStyle default
				do: [:fon | useDefaultFont := false]].
	f := useDefaultFont
				ifTrue: [ aMorph font ]
				ifFalse: [ self fontAt: 1 withStyle: TextStyle default ].
	itemBounds := drawBounds  withHeight: f height.
	itemBounds := itemBounds align: itemBounds leftCenter with: drawBounds  leftCenter.
	"center the item if the font height is different to that of our font"
	^ builder
		string: self
		in: itemBounds
		font: (f emphasized: (self emphasisAt: 1))
		color: drawColor 
		underline: ((self emphasisAt: 1)
				bitAnd: 4)
				> 0
		underlineColor: drawColor 
		strikethrough: ((self emphasisAt: 1)
				bitAnd: 16)
				> 0
		strikethroughColor: drawColor
]
