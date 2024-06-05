Extension { #name : 'IndentingListItemMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
IndentingListItemMorph >> buildSceneGraphNodeWith: builder [

	| tRect sRect columnScanner colorToUse columnLeft result |

	tRect := self toggleRectangle.
	sRect := bounds withLeft: tRect right + 4.

	result := self buildToggleSceneGraphNodeWith: builder in: tRect.
	colorToUse := complexContents preferredColor ifNil: [ self theme textColor ].
	icon
		ifNotNil: [ result := result , (builder 
				textureForm: icon
				at: sRect left @ ( self top + ( ( self height - icon height ) // 2 ) )).
			sRect := sRect left: sRect left + icon width + 2
			].
	( container columns isNil or: [ ( contents asString indexOf: Character tab ) = 0 ] )
		ifTrue: [ sRect := sRect top: ( sRect top + sRect bottom - self fontToUse height ) // 2.
			result := result , (contents
				treeRenderSceneNodeWith: builder
				bounds: sRect
				color: colorToUse
				font: self fontToUse
				from: self)
			]
		ifFalse: [ columnLeft := sRect left.
			columnScanner := contents asString readStream.
			container columns
				do: [ :width | 
					| columnData columnRect |

					columnRect := columnLeft @ sRect top extent: width @ sRect height.
					columnData := columnScanner upTo: Character tab.
					columnData isEmpty
						ifFalse: [ result := result , (builder
								string: columnData
								in: columnRect
								font: self fontToUse
								color: colorToUse)
							].
					columnLeft := columnRect right + 5
					]
			].
	^ result
]

{ #category : '*FormSceneGraph-MorphicP12' }
IndentingListItemMorph >> buildToggleSceneGraphNodeWith: builder in: aRectangle [

	| aForm centeringOffset |
	complexContents hasContents ifFalse: [^builder null].
	aForm := isExpanded 
		ifTrue: [container expandedFormForMorph: self]
		ifFalse: [container notExpandedFormForMorph: self].
	centeringOffset := ((aRectangle height - aForm extent y) / 2.0) truncated.
	^ builder 
		textureForm: aForm 
		at: (aRectangle topLeft translateBy: 0 @ centeringOffset).

]
